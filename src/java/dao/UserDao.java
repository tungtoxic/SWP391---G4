package dao;

import entity.AgentPerformanceDTO;
import entity.*;
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
        String hashed = PasswordUtils.hashPassword(password);
        // Cần kiểm tra status = 'Active' trong SQL
        String sql = "SELECT * FROM Users WHERE username = ? AND password_hash = ? AND status ='Active'";
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, hashed); // Giả định password chưa hash khi truyền vào

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setPasswordHash(rs.getString("password_hash")); // Lấy hash từ DB
                    user.setStatus(rs.getString("status"));
                    user.setRoleId(rs.getInt("role_id"));
                    // Lấy thêm is_first_login nếu cần cho logic đổi pass lần đầu
                    try {
                         user.setIsFirstLogin(rs.getBoolean("is_first_login"));
                    } catch (SQLException e) {
                        // Bỏ qua nếu cột không tồn tại hoặc có lỗi
                        System.err.println("Warning: Could not read is_first_login for user " + username);
                    }
                    return user;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đăng nhập cho user: " + username);
            e.printStackTrace();
        }
        return null;
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
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        // Lưu ý: Cần xử lý các ràng buộc khóa ngoại (ví dụ: xóa agent khỏi Manager_Agent?)
        // Hoặc chỉ nên deactivate thay vì xóa cứng?
        String sql = "DELETE FROM Users WHERE user_id=?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e){
            System.err.println("Lỗi khi xóa user ID: " + userId + ". Có thể do ràng buộc khóa ngoại.");
            e.printStackTrace();
            throw e; // Ném lại lỗi để báo hiệu xóa thất bại
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
                COUNT(CASE WHEN c.status = 'Active' THEN c.contract_id ELSE NULL END) AS contracts_count
            FROM Users u
            JOIN Manager_Agent ma ON u.user_id = ma.agent_id
            LEFT JOIN Contracts c ON u.user_id = c.agent_id
            WHERE ma.manager_id = ? AND u.role_id = 1
            GROUP BY u.user_id, u.full_name
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
                    teamPerformance.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return teamPerformance;
    }

    /**
     * Lấy hiệu suất của TẤT CẢ Agent.
     */
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
     * Lấy danh sách xếp hạng Agent (giống getAllAgentsPerformance).
     */
    public List<AgentPerformanceDTO> getAgentLeaderboard() {
        // Thực chất là gọi lại hàm getAllAgentsPerformance vì logic giống hệt
        return getAllAgentsPerformance();
    }

    /**
     * Lấy danh sách xếp hạng Manager dựa trên tổng doanh thu team.
     */
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

    /**
     * Lấy danh sách Agents theo Manager ID (dùng cho kiểm tra quyền).
     */
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


    // ===== BỔ SUNG TỪ CODE VU TT (Cần thiết cho Admin?) =====
    /**
     * Lấy danh sách Users theo Status cụ thể.
     */
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


    // ===== BỔ SUNG TỪ CODE THANH HE (Hữu ích cho sửa thông tin Agent) =====
    /**
     * Cập nhật thông tin cơ bản của Agent (không bao gồm username, pass, role, status).
     */
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


    // ===== HÀM MAP RIÊNG (Tránh lặp code) =====
    /**
     * Ánh xạ một dòng ResultSet sang đối tượng User.
     * Bao gồm cả role_name.
     */
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
        } catch (SQLException e) { /* Bỏ qua */ }
         try {
             user.setUpdatedAt(rs.getTimestamp("updated_at"));
        } catch (SQLException e) { /* Bỏ qua */ }
        // Lấy role_name nếu có trong câu SELECT (thường là có khi JOIN)
        try {
            user.setRoleName(rs.getString("role_name"));
        } catch (SQLException e) { /* Bỏ qua nếu câu SELECT không có */ }
        return user;
    }

}