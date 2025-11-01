package dao;

import entity.AgentPerformanceDTO;
import entity.*;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import utility.DBConnector;
import utility.PasswordUtils;

public class UserDao {

    // ===== GIỮ NGUYÊN TỪ CODE CỦA BẠN =====
    /**
     * Kiểm tra thông tin đăng nhập.
     * @param username Tên đăng nhập
     * @param password Mật khẩu (chưa hash)
     * @return Đối tượng User nếu hợp lệ và Active, null nếu không.
     */
    public User login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username = ? AND status = 'Active'";
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");

                    // So sánh hash SHA-256
                    if (PasswordUtils.verifyPassword(password, storedHash)) {
                        User user = new User();
                        user.setUserId(rs.getInt("user_id"));
                        user.setUsername(rs.getString("username"));
                        user.setFullName(rs.getString("full_name"));
                        user.setEmail(rs.getString("email"));
                        user.setPhoneNumber(rs.getString("phone_number"));
                        user.setPasswordHash(storedHash);
                        user.setStatus(rs.getString("status"));
                        user.setRoleId(rs.getInt("role_id"));
                        user.setIsFirstLogin(rs.getBoolean("is_first_login"));
                        return user;
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        String checkSql = "SELECT password_hash FROM Users WHERE user_id = ?";
        String updateSql = "UPDATE Users SET password_hash = ?, is_first_login = false WHERE user_id = ?";

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement psCheck = conn.prepareStatement(checkSql)) {

            psCheck.setInt(1, userId);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next()) {
                    String currentHash = rs.getString("password_hash");
                    String oldHash = PasswordUtils.hashPassword(oldPassword);

                    // Kiểm tra mật khẩu cũ
                    if (!currentHash.equals(oldHash)) {
                        System.out.println("Mật khẩu cũ không đúng.");
                        return false;
                    }
                } else {
                    return false; // không tìm thấy user
                }
            }

            // Hash mật khẩu mới và cập nhật
            String newHash = PasswordUtils.hashPassword(newPassword);
            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                psUpdate.setString(1, newHash);
                psUpdate.setInt(2, userId);
                return psUpdate.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra email đã tồn tại chưa (dùng rs.next()).
     */
    public boolean checkEmailExists(String email) {
        String sql = "SELECT user_id FROM Users WHERE email = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu có kết quả
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra username đã tồn tại chưa (dùng rs.next()).
     */
    public boolean checkUsernameExists(String username) {
        String sql = "SELECT user_id FROM Users WHERE username = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra username đã tồn tại chưa (dùng COUNT(*)).
     */
    public boolean isUsernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE username = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Kiểm tra số điện thoại đã tồn tại chưa (dùng COUNT(*)).
     */
    public boolean isPhoneExists(String phoneNumber) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE phone_number = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phoneNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    /**
     * Thêm một user mới vào DB (phiên bản đầy đủ thông tin ban đầu).
     */
    public boolean insertUser(User user) throws SQLException {
        // Cần thêm is_first_login vào câu SQL nếu cột này tồn tại và quan trọng
        String sql = "INSERT INTO users (username, password_hash, full_name, email, phone_number, role_id, status, is_first_login) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection(); 
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash()); // Dùng getPasswordHash()
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhoneNumber());
            ps.setInt(6, user.getRoleId());
            ps.setString(7, user.getStatus());
            ps.setBoolean(8, user.getIsFirstLogin()); // Thêm is_first_login
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lấy role_id dựa vào role_name.
     */
    public int getRoleIdByName(String roleName) throws SQLException {
        String sql = "SELECT role_id FROM Roles WHERE role_name = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roleName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("role_id");
                }
            }
        }
        return -1; // Role không tồn tại
    }

    /**
     * Lấy danh sách tất cả Users, có thể lọc theo role_id. Bao gồm cả role_name.
     * @param roleIdFilter ID của role cần lọc (String), hoặc null/rỗng để lấy tất cả.
     */
    public List<User> getAllUsers(String roleIdFilter) throws SQLException {
        List<User> userList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT u.*, r.role_name FROM Users u JOIN Roles r ON u.role_id = r.role_id");
        List<Object> params = new ArrayList<>();

        if (roleIdFilter != null && !roleIdFilter.isEmpty()) {
            try {
                 int roleId = Integer.parseInt(roleIdFilter);
                 sql.append(" WHERE u.role_id = ?");
                 params.add(roleId);
            } catch (NumberFormatException e) {
                 System.err.println("Lỗi: roleIdFilter không hợp lệ: " + roleIdFilter);
                 // Có thể chọn trả về danh sách rỗng hoặc bỏ qua bộ lọc
            }
        }
        sql.append(" ORDER BY u.user_id ASC");

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = mapRowToUser(rs); // Dùng hàm map riêng cho gọn
                    userList.add(user);
                }
            }
        } catch (SQLException e) {
             System.err.println("Lỗi khi lấy danh sách users với filter: " + roleIdFilter);
             e.printStackTrace();
             // Ném lại lỗi hoặc trả về danh sách rỗng tùy logic mong muốn
             throw e;
        }
        return userList;
    }

    /**
     * Lấy role_name dựa vào role_id.
     */
    public String getRoleNameById(int roleId) throws SQLException {
        String sql = "SELECT role_name FROM Roles WHERE role_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("role_name");
                }
            }
        }
        return "Unknown";
    }

    /**
     * Lấy thông tin chi tiết User theo ID, bao gồm role_name.
     */
    public User getUserById(int id) throws SQLException {
        String sql = "SELECT u.*, r.role_name FROM Users u JOIN Roles r ON u.role_id = r.role_id WHERE u.user_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs); // Dùng hàm map
                }
            }
        } catch (SQLException e) {
             System.err.println("Lỗi khi lấy user theo ID: " + id);
             e.printStackTrace();
             throw e;
        }
        return null;
    }

    /**
     * Lấy danh sách Users theo role_id cụ thể.
     */
    public List<User> getUsersByRoleId(int roleId) throws SQLException {
        List<User> users = new ArrayList<>();
        // Dùng text block cho SQL rõ ràng hơn
        String sql = """
            SELECT u.*, r.role_name
            FROM Users u
            JOIN Roles r ON u.role_id = r.role_id
            WHERE u.role_id = ?
            ORDER BY u.user_id ASC
        """;
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapRowToUser(rs)); // Dùng hàm map
                }
            }
        } catch (SQLException e) {
             System.err.println("Lỗi khi lấy user theo Role ID: " + roleId);
             e.printStackTrace();
             throw e;
        }
        return users;
    }

    /**
     * Cập nhật toàn bộ thông tin User (dùng cho Admin).
     */
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE Users SET username=?, password_hash=?, full_name=?, email=?, phone_number=?, role_id=?, status=?, is_first_login=? WHERE user_id=?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhoneNumber());
            ps.setInt(6, user.getRoleId());
            ps.setString(7, user.getStatus());
            ps.setBoolean(8, user.getIsFirstLogin()); // Thêm is_first_login
            ps.setInt(9, user.getUserId());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Kích hoạt tài khoản User.
     */
    public boolean activateUserById(int id) throws SQLException {
        String sql = "UPDATE Users SET status = 'Active' WHERE user_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Vô hiệu hóa tài khoản User.
     */
    public boolean deactivateUserById(int id) throws SQLException {
        String sql = "UPDATE Users SET status = 'Inactive' WHERE user_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Đếm số hợp đồng của một Agent.
     */
    public int getContractCountByAgent(int agentId) {
        String sql = "SELECT COUNT(*) FROM Contracts WHERE agent_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, agentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy tổng hoa hồng (tất cả trạng thái) của một Agent.
     */
    public double getTotalCommissionByAgent(int agentId) {
        // Nên dùng BigDecimal để tính tiền
        String sql = "SELECT IFNULL(SUM(amount), 0.00) FROM Commissions WHERE agent_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, agentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1); // Cẩn thận với độ chính xác của double
                    // return rs.getBigDecimal(1); // Nếu trả về BigDecimal
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Tạo mật khẩu tạm ngẫu nhiên.
     */
    public static String generateTempPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"; // Bỏ ký tự đặc biệt cho dễ gõ
        StringBuilder sb = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }

    /**
     * Tạo User mới (thường dùng cho Admin tạo tài khoản).
     * Đã bao gồm is_first_login.
     */
    public boolean createUser(User user) throws SQLException {
        // Giống hệt insertUser, có thể gộp lại hoặc bỏ 1 trong 2 nếu logic y hệt
         String sql = "INSERT INTO Users (username, password_hash, full_name, email, phone_number, role_id, status, is_first_login) "
                 + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash()); // Sửa: Dùng getPasswordHash()
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhoneNumber());
            ps.setInt(6, user.getRoleId());
            ps.setString(7, user.getStatus());
            ps.setBoolean(8, user.getIsFirstLogin());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Xóa User theo ID.
     */
    public boolean deleteUser(int userId) throws SQLException {
    String deleteCommissionsSQL = "DELETE FROM Commissions WHERE agent_id = ?";
    String deleteContractsSQL = "DELETE FROM Contracts WHERE agent_id = ?";
    String deleteManagerAgentSQL = "DELETE FROM Manager_Agent WHERE agent_id = ? OR manager_id = ?";
    String deleteUserSQL = "DELETE FROM Users WHERE user_id = ?";

    try (Connection conn = DBConnector.makeConnection()) {
        conn.setAutoCommit(false);

        try (
            PreparedStatement ps1 = conn.prepareStatement(deleteCommissionsSQL);
            PreparedStatement ps2 = conn.prepareStatement(deleteContractsSQL);
            PreparedStatement ps3 = conn.prepareStatement(deleteManagerAgentSQL);
            PreparedStatement ps4 = conn.prepareStatement(deleteUserSQL)
        ) {
            // Xóa các quan hệ khóa ngoại trước
            ps1.setInt(1, userId);
            ps1.executeUpdate();

            ps2.setInt(1, userId);
            ps2.executeUpdate();

            ps3.setInt(1, userId);
            ps3.setInt(2, userId);
            ps3.executeUpdate();

            // Cuối cùng xóa user
            ps4.setInt(1, userId);
            int rows = ps4.executeUpdate();

            conn.commit();
            return rows > 0;
        } catch (SQLException e) {
            conn.rollback();
            System.err.println("Lỗi khi xóa user ID: " + userId + ". Đã rollback.");
            e.printStackTrace();
            return false;
        }
    }
}


    /**
     * Cập nhật mật khẩu (đã hash) cho User.
     */
    public boolean updatePassword(int userId, String newPasswordHash) {
        // Nên thêm điều kiện is_first_login = false sau khi đổi pass lần đầu
        String sql = "UPDATE Users SET password_hash = ?, is_first_login = false WHERE user_id = ?";
        try (Connection con = DBConnector.makeConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Đăng ký User mới (thường dùng cho chức năng tự đăng ký nếu có).
     * User sẽ ở trạng thái Pending hoặc Inactive chờ duyệt.
     */
    public boolean registerUser(User user) throws SQLException {
        // Khác insertUser/createUser: không cần username/password ban đầu, status là Pending/Inactive
        String sql = "INSERT INTO Users (full_name, email, phone_number, role_id, status, is_first_login) "
                 + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setInt(4, user.getRoleId());
            ps.setString(5, user.getStatus()); // Ví dụ: "Pending" hoặc "Inactive"
            ps.setBoolean(6, user.getIsFirstLogin()); // Thường là true
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lấy hiệu suất của các Agent trong team của Manager.
     */
    public List<AgentPerformanceDTO> getTeamPerformance(int managerId) {
        List<AgentPerformanceDTO> teamPerformance = new ArrayList<>();
        String sql = """
            SELECT
                u.user_id,
                u.full_name,
                IFNULL(SUM(CASE WHEN c.status = 'Active' THEN c.premium_amount ELSE 0 END), 0) AS total_premium,
                COUNT(CASE WHEN c.status = 'Active' THEN c.contract_id ELSE NULL END) AS contracts_count,
                IFNULL(t.target_amount, 0.00) AS target_amount 
            FROM Users u
            JOIN Manager_Agent ma ON u.user_id = ma.agent_id
            LEFT JOIN Contracts c ON u.user_id = c.agent_id
            LEFT JOIN Agent_Targets t ON u.user_id = t.agent_id
                                    AND t.target_month = MONTH(CURDATE())
                                    AND t.target_year = YEAR(CURDATE())
            WHERE ma.manager_id = ? AND u.role_id = 1
            GROUP BY u.user_id, u.full_name, t.target_amount
            ORDER BY total_premium DESC;
        """; // Sửa lại SUM và COUNT chỉ tính HĐ 'Active'

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AgentPerformanceDTO dto = new AgentPerformanceDTO(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getDouble("total_premium"), // Cẩn thận với double
                            rs.getInt("contracts_count")
                    );
                    dto.setTargetAmount(rs.getDouble("target_amount"));
                    teamPerformance.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return teamPerformance;
    }

    public List<AgentPerformanceDTO> getAllAgentsPerformance() {
        List<AgentPerformanceDTO> allAgents = new ArrayList<>();
        int agentRoleId = 1; // Giả định role_id của Agent là 1

        String sql = """
            SELECT
                u.user_id,
                u.full_name,
                IFNULL(SUM(CASE WHEN c.status = 'Active' THEN c.premium_amount ELSE 0 END), 0) AS total_premium,
                COUNT(CASE WHEN c.status = 'Active' THEN c.contract_id ELSE NULL END) AS contracts_count
            FROM Users u
            LEFT JOIN Contracts c ON u.user_id = c.agent_id
            WHERE u.role_id = ?
            GROUP BY u.user_id, u.full_name
            ORDER BY total_premium DESC;
        """; // Sửa lại SUM và COUNT chỉ tính HĐ 'Active'

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, agentRoleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AgentPerformanceDTO dto = new AgentPerformanceDTO(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getDouble("total_premium"),
                            rs.getInt("contracts_count")
                    );
                    allAgents.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return allAgents;
    }
    /**
     * Thêm mới hoặc cập nhật Target cho Agent theo tháng/năm.
     * Sử dụng cú pháp INSERT ... ON DUPLICATE KEY UPDATE.
     * @param agentId ID của Agent
     * @param targetAmount Số tiền target
     * @param month Tháng (1-12)
     * @param year Năm (ví dụ: 2025)
     * @return true nếu thực thi thành công, false nếu thất bại.
     */
    public boolean setAgentTarget(int agentId, BigDecimal targetAmount, int month, int year) {
        // Cú pháp này sẽ tự động UPDATE nếu đã tồn tại bản ghi (agent_id, target_month, target_year)
        // hoặc INSERT mới nếu chưa có.
        String sql = """
            INSERT INTO Agent_Targets (agent_id, target_amount, target_month, target_year)
            VALUES (?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
                target_amount = VALUES(target_amount);
        """;
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, agentId);
            ps.setBigDecimal(2, targetAmount);
            ps.setInt(3, month);
            ps.setInt(4, year);
            
            return ps.executeUpdate() > 0; // Trả về true nếu (1) insert thành công hoặc (2) update thành công
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi set target cho agent ID: " + agentId);
            e.printStackTrace();
            return false;
        }
    }

    public List<AgentPerformanceDTO> getAgentLeaderboard() {
        return getAllAgentsPerformance();
    }

    public List<AgentPerformanceDTO> getManagerLeaderboard() {
        List<AgentPerformanceDTO> leaderboard = new ArrayList<>();
        String sql = """
            SELECT
                m.user_id,
                m.full_name,
                IFNULL(SUM(CASE WHEN c.status = 'Active' THEN c.premium_amount ELSE 0 END), 0) AS total_team_premium
            FROM Users m
            LEFT JOIN Manager_Agent ma ON m.user_id = ma.manager_id
            LEFT JOIN Contracts c ON ma.agent_id = c.agent_id
            WHERE m.role_id = 2
            GROUP BY m.user_id, m.full_name
            ORDER BY total_team_premium DESC;
        """; // Sửa lại SUM chỉ tính HĐ 'Active'

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                leaderboard.add(new AgentPerformanceDTO(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getDouble("total_team_premium"),
                        0 // contracts_count không liên quan ở đây
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return leaderboard;
    }

    public List<User> getAgentsByManagerId(int managerId) {
        List<User> agentList = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name " + // Lấy thêm role_name
                     "FROM Users u " +
                     "JOIN Manager_Agent ma ON u.user_id = ma.agent_id " +
                     "JOIN Roles r ON u.role_id = r.role_id " + // Join thêm Roles
                     "WHERE ma.manager_id = ? AND u.role_id = 1";

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    agentList.add(mapRowToUser(rs)); // Dùng hàm map
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách Agent theo Manager ID: " + managerId);
            e.printStackTrace();
        }
        return agentList;
    }


<<<<<<< HEAD
    
    /**
     * Lấy danh sách Users theo Status cụ thể.
     */
=======
>>>>>>> VuTT
    public List<User> getUsersByStatus(String status) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name FROM Users u "
                   + "JOIN Roles r ON u.role_id = r.role_id "
                   + "WHERE u.status = ? ORDER BY u.user_id ASC";
        try (Connection con = DBConnector.makeConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            try(ResultSet rs = ps.executeQuery()){
                while (rs.next()) {
                    list.add(mapRowToUser(rs)); // Dùng hàm map
                }
            }
        } catch (SQLException e) {
             System.err.println("Lỗi khi lấy user theo Status: " + status);
             e.printStackTrace();
             throw e;
        }
        return list;
    }

    public boolean updateAgent(User user) throws SQLException {
        // Chỉ cập nhật full_name, email, phone_number
        String sql = "UPDATE users SET full_name=?, email=?, phone_number=? WHERE user_id =? AND role_id = 1"; // Thêm AND role_id = 1
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setInt(4, user.getUserId());
            return ps.executeUpdate() > 0;
        }
    }

    private User mapRowToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhoneNumber(rs.getString("phone_number"));
        // Lấy password hash cẩn thận, chỉ khi thực sự cần (ví dụ: đổi mật khẩu)
        // user.setPasswordHash(rs.getString("password_hash"));
        user.setRoleId(rs.getInt("role_id"));
        user.setStatus(rs.getString("status"));
        // Lấy is_first_login nếu có trong câu SELECT
        try {
             user.setIsFirstLogin(rs.getBoolean("is_first_login"));
        } catch (SQLException e) { /* Bỏ qua nếu cột không có */ }
        // Lấy createdAt/updatedAt nếu có trong câu SELECT
        try {
             user.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException e) {
            /* Bỏ qua */ }
        try {
            user.setUpdatedAt(rs.getTimestamp("updated_at"));
        } catch (SQLException e) {
            /* Bỏ qua */ }
        // Lấy role_name nếu có trong câu SELECT (thường là có khi JOIN)
        try {
            user.setRoleName(rs.getString("role_name"));
        } catch (SQLException e) {
            /* Bỏ qua nếu câu SELECT không có */ }
        return user;
    }
    
    
    public List<User> getAllUsers() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

<<<<<<< HEAD
    /**
     * Kiểm tra xem một Agent có thuộc quyền quản lý của một Manager hay không.
     *
     * @param agentId ID của Agent cần kiểm tra
     * @param managerId ID của Manager
     * @return true nếu Agent thuộc Manager, false nếu không hoặc có lỗi.
     */
    public boolean isAgentManagedBy(int agentId, int managerId) {
        String sql = "SELECT COUNT(*) FROM Manager_Agent WHERE manager_id = ? AND agent_id = ?";

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, managerId);
            ps.setInt(2, agentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0; // Trả về true nếu có 1 bản ghi (có tồn tại)
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra isAgentManagedBy: " + e.getMessage());
            e.printStackTrace();
        }
        return false; // Trả về false nếu có lỗi hoặc không tìm thấy
    }
    /**
 * Đặt/Cập nhật một mức Target chung cho TẤT CẢ Agent
 * thuộc quyền quản lý của một Manager cho tháng/năm cụ thể.
 * @param managerId ID của Manager
 * @param targetAmount Số tiền target chung
 * @param month Tháng (1-12)
 * @param year Năm (ví dụ: 2025)
 * @return true nếu thực thi thành công, false nếu thất bại.
 */
public boolean setTeamTarget(int managerId, BigDecimal targetAmount, int month, int year) {
    // SQL này dùng INSERT ... SELECT ... ON DUPLICATE KEY UPDATE
    // 1. SELECT: Tìm tất cả agent_id thuộc managerId
    // 2. INSERT: Thêm (agent_id, targetAmount, month, year) cho mỗi agent tìm được
    // 3. ON DUPLICATE KEY UPDATE: Nếu đã có target cho agent đó, nó sẽ tự động UPDATE
    String sql = """
        INSERT INTO Agent_Targets (agent_id, target_amount, target_month, target_year)
        (
            SELECT 
                agent_id, 
                ? AS target_amount, 
                ? AS target_month, 
                ? AS target_year 
            FROM 
                Manager_Agent 
            WHERE 
                manager_id = ?
        )
        ON DUPLICATE KEY UPDATE
            target_amount = VALUES(target_amount);
    """;
    
    try (Connection conn = DBConnector.makeConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setBigDecimal(1, targetAmount); // Giá trị cho target_amount
        ps.setInt(2, month);            // Giá trị cho target_month
        ps.setInt(3, year);             // Giá trị cho target_year
        ps.setInt(4, managerId);        // ID của Manager để lọc agent
        
        return ps.executeUpdate() > 0; // Trả về true nếu có dòng được thêm/cập nhật
        
    } catch (SQLException e) {
        System.err.println("Lỗi khi set Team Target cho manager ID: " + managerId);
        e.printStackTrace();
        return false;
    }
}
}
=======
}
>>>>>>> VuTT
