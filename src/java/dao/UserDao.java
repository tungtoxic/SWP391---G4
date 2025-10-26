/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import entity.AgentPerformanceDTO; 
import entity.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import utility.DBConnector;

/**
 *
 * @author Helios 16
 */
public class UserDao {
    // Hàm login check DB
public User login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username = ? AND password_hash = ? AND status ='active'";
        // Sử dụng try-with-resources để đảm bảo kết nối luôn được đóng
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setStatus(rs.getString("status"));
                    user.setRoleId(rs.getInt("role_id"));
                    return user;
                }
            }
        } catch (SQLException e) {
            // SỬA LỖI TẠI ĐÂY: In ra lỗi để biết nguyên nhân khi có sự cố
            e.printStackTrace();
        }
        // Trả về null nếu không tìm thấy user hoặc có lỗi
        return null;
    
    }

    public boolean checkEmailExists(String email) {
        String sql = "SELECT user_id FROM Users WHERE email = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // nếu có bản ghi => true
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra username đã tồn tại chưa
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

    //check username exist
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
//kiem tra phone_number

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

    public boolean insertUser(User user) throws SQLException {
        String sql = "INSERT INTO users (username, password_hash, full_name, email, phone_number, role_id, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhoneNumber());
            ps.setInt(6, user.getRoleId());
            ps.setString(7, user.getStatus());
            return ps.executeUpdate() > 0;
            // ✅ phải kiểm tra số dòng insert
        }
    }

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
        return -1; // Không tìm thấy role
    }
   
// Thêm/Sửa phương thức này trong file dao/UserDao.java

public List<User> getAllUsers(String roleIdFilter) throws SQLException {
    List<User> userList = new ArrayList<>();
    
    StringBuilder sql = new StringBuilder("SELECT u.*, r.role_name FROM Users u JOIN Roles r ON u.role_id = r.role_id");
    List<Object> params = new ArrayList<>();

    // Thêm điều kiện lọc nếu có
    if (roleIdFilter != null && !roleIdFilter.isEmpty()) {
        sql.append(" WHERE u.role_id = ?");
        params.add(Integer.parseInt(roleIdFilter));
    }
    sql.append(" ORDER BY u.user_id ASC");

    try (Connection conn = DBConnector.makeConnection();
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        // Set các tham số
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setRoleId(rs.getInt("role_id"));
                user.setStatus(rs.getString("status"));
                user.setRoleName(rs.getString("role_name"));
                userList.add(user);
            }
        }
    }
    return userList;
}
    //lấy rolename theo role_id
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
        return "Unknown"; // Nếu không có role
    }

    // Lấy user theo id
    public User getUserById(int id) throws SQLException {
        String sql = "SELECT u.*, r.role_name FROM Users u JOIN Roles r ON u.role_id = r.role_id WHERE u.user_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setStatus(rs.getString("status"));
                    // Nếu entity User có field roleName
                    try {
                        user.setRoleName(rs.getString("role_name"));
                    } catch (Exception e) {
                        // nếu chưa thêm roleName thì bỏ qua
                    }
                    return user;
                }
            }
        }
        return null;
    }

    public List<User> getUsersByRoleId(int roleId) throws SQLException {
        List<User> users = new ArrayList<>();
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
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setStatus(rs.getString("status"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    users.add(user);
                }
            }
        }
        return users;
    }

    //update thông tin cua user 
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE Users SET username=?,password_hash=?, full_name=?, email=?, phone_number=?, role_id=?, status=? WHERE user_id=?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhoneNumber());
            ps.setInt(6, user.getRoleId());
            ps.setString(7, user.getStatus());
            ps.setInt(8, user.getUserId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean activateUserById(int id) throws SQLException {
        String sql = "UPDATE Users SET status = 'Active' WHERE user_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deactivateUserById(int id) throws SQLException {
        String sql = "UPDATE Users SET status = 'Inactive' WHERE user_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

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

    public double getTotalCommissionByAgent(int agentId) {
        String sql = "SELECT IFNULL(SUM(amount), 0) FROM Commissions WHERE agent_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, agentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static String generateTempPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%";
        StringBuilder sb = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }

    public boolean createUser(User user) throws SQLException {
        String sql = "INSERT INTO Users (username, password_hash, full_name, email, phone_number, role_id, status, is_first_login) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword()); // hoặc hash nếu muốn
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhoneNumber());
            ps.setInt(6, user.getRoleId());
            ps.setString(7, user.getStatus());
            ps.setBoolean(8, user.getIsFirstLogin());

            int rows = ps.executeUpdate();
            return rows > 0; // true nếu insert thành công
        }
    }

    //xóa user bangid
    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM Users WHERE user_id=?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }
    // update password

    public boolean updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE Users SET password_hash = ? WHERE user_id = ?";
        try (Connection con = DBConnector.makeConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace(); // xem log server để biết chi tiết lỗi
            return false;
        }
    }

    public boolean registerUser(User user) throws SQLException {
        String sql = "INSERT INTO Users (full_name, email, phone_number, role_id, status, is_first_login) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setInt(4, user.getRoleId());
            ps.setString(5, user.getStatus()); // Inactive
            ps.setBoolean(6, user.getIsFirstLogin());

            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }
    // Bổ sung vào class UserDao.java (Nếu chưa có)

    public List<AgentPerformanceDTO> getTeamPerformance(int managerId) {
        List<AgentPerformanceDTO> teamPerformance = new ArrayList<>();
        String sql = """
        SELECT 
            u.user_id, 
            u.full_name,
            IFNULL(SUM(c.premium_amount), 0) AS total_premium,
            COUNT(c.contract_id) AS contracts_count
        FROM Users u
        JOIN Manager_Agent ma ON u.user_id = ma.agent_id
        LEFT JOIN Contracts c ON u.user_id = c.agent_id AND c.status = 'Active'
        WHERE ma.manager_id = ? 
        GROUP BY u.user_id, u.full_name
        ORDER BY total_premium DESC;
    """;

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, managerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AgentPerformanceDTO dto = new AgentPerformanceDTO(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getDouble("total_premium"),
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
    
    public List<AgentPerformanceDTO> getAllAgentsPerformance() {
    List<AgentPerformanceDTO> allAgents = new ArrayList<>();
    // Giả sử role_id của Agent là 1 (dựa trên AgentManagementServlet của bạn)
    int agentRoleId = 1; 

    String sql = """
    SELECT 
        u.user_id, 
        u.full_name,
        IFNULL(SUM(c.premium_amount), 0) AS total_premium,
        COUNT(c.contract_id) AS contracts_count
    FROM Users u
    LEFT JOIN Contracts c ON u.user_id = c.agent_id AND c.status = 'Active'
    WHERE u.role_id = ? 
    GROUP BY u.user_id, u.full_name
    ORDER BY total_premium DESC;
    """;

    try (Connection conn = DBConnector.makeConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, agentRoleId); // Lọc theo role_id của Agent
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
        e.printStackTrace(); // Luôn in ra lỗi để dễ debug
    }
    return allAgents;
}
    /**
     * Lấy danh sách xếp hạng tất cả các Agent dựa trên tổng doanh thu từ hợp
     * đồng Active.
     *
     * @return Một danh sách AgentPerformanceDTO đã được sắp xếp.
     */
    public List<AgentPerformanceDTO> getAgentLeaderboard() {
        List<AgentPerformanceDTO> leaderboard = new ArrayList<>();
        // ROLE_AGENT = 1
        String sql = "SELECT "
                + "    u.user_id, "
                + "    u.full_name, "
                + "    IFNULL(SUM(c.premium_amount), 0) AS total_premium, "
                + "    COUNT(c.contract_id) AS contracts_count "
                + "FROM "
                + "    Users u "
                + "LEFT JOIN "
                + "    Contracts c ON u.user_id = c.agent_id AND c.status = 'Active' "
                + "WHERE "
                + "    u.role_id = 1 "
                + // Chỉ lấy những user là Agent
                "GROUP BY "
                + "    u.user_id, u.full_name "
                + "ORDER BY "
                + "    total_premium DESC, contracts_count DESC"; // Xếp hạng theo doanh thu, nếu bằng nhau thì xếp theo số HĐ

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int agentId = rs.getInt("user_id");
                String agentName = rs.getString("full_name");
                double totalPremium = rs.getDouble("total_premium");
                int contractsCount = rs.getInt("contracts_count");

                leaderboard.add(new AgentPerformanceDTO(agentId, agentName, totalPremium, contractsCount));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return leaderboard;
    }
    /**
 * Lấy danh sách xếp hạng tất cả các Manager dựa trên tổng doanh thu
 * của các Agent trong team họ quản lý.
 * @return Một danh sách AgentPerformanceDTO đã được sắp xếp (dùng lại DTO này cho đơn giản).
 */
    public List<AgentPerformanceDTO> getManagerLeaderboard() {
        List<AgentPerformanceDTO> leaderboard = new ArrayList<>();
        // ROLE_MANAGER = 2
        String sql = "SELECT "
                + "    m.user_id, "
                + "    m.full_name, "
                + "    IFNULL(SUM(c.premium_amount), 0) AS total_team_premium "
                + "FROM "
                + "    Users m "
                + // Bắt đầu từ bảng Users với vai trò Manager
                "LEFT JOIN "
                + "    Manager_Agent ma ON m.user_id = ma.manager_id "
                + // Tìm các agent họ quản lý
                "LEFT JOIN "
                + "    Contracts c ON ma.agent_id = c.agent_id AND c.status = 'Active' "
                + // Tìm hợp đồng active của các agent đó
                "WHERE "
                + "    m.role_id = 2 "
                + // Chỉ lấy những user là Manager
                "GROUP BY "
                + "    m.user_id, m.full_name "
                + "ORDER BY "
                + "    total_team_premium DESC";

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int managerId = rs.getInt("user_id");
                String managerName = rs.getString("full_name");
                double totalTeamPremium = rs.getDouble("total_team_premium");

                // Chúng ta có thể tái sử dụng AgentPerformanceDTO ở đây
                // agentId sẽ là managerId, agentName là managerName, totalPremium là totalTeamPremium
                // contractsCount có thể tạm để là 0 vì không cần thiết trong BXH này
                leaderboard.add(new AgentPerformanceDTO(managerId, managerName, totalTeamPremium, 0));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return leaderboard;
    }
    /**
     * Lấy danh sách các User là Agent được quản lý bởi một Manager cụ thể.
     * @param managerId ID của Manager.
     * @return Danh sách các đối tượng User (Agent), hoặc danh sách rỗng nếu không có Agent nào hoặc có lỗi.
     */
    public List<User> getAgentsByManagerId(int managerId) {
        List<User> agentList = new ArrayList<>();
        // JOIN bảng Users (u) với Manager_Agent (ma) để tìm agent theo manager_id
        // Chỉ lấy những user có role_id = 1 (Agent) để đảm bảo tính chính xác
        String sql = "SELECT u.user_id, u.username, u.full_name, u.email, u.phone_number, u.status, u.role_id " +
                     "FROM Users u " +
                     "JOIN Manager_Agent ma ON u.user_id = ma.agent_id " +
                     "WHERE ma.manager_id = ? AND u.role_id = 1"; // Lọc theo manager_id và role_id = 1 (Agent)

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, managerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User agent = new User();
                    agent.setUserId(rs.getInt("user_id"));
                    agent.setUsername(rs.getString("username")); // Lấy username
                    agent.setFullName(rs.getString("full_name"));
                    agent.setEmail(rs.getString("email"));         // Lấy email
                    agent.setPhoneNumber(rs.getString("phone_number")); // Lấy SĐT
                    agent.setStatus(rs.getString("status"));       // Lấy status
                    agent.setRoleId(rs.getInt("role_id"));       // Lấy role_id (luôn là 1)
                    // Không lấy password_hash vì không cần thiết

                    agentList.add(agent);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách Agent theo Manager ID: " + managerId);
            e.printStackTrace(); // In lỗi ra để debug
        }
        return agentList;
    }
        public boolean updateAgent(User user) throws SQLException {
        String sql = "UPDATE users SET full_name=?, email=?, phone_number=? WHERE user_id =?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setInt(4, user.getUserId());
            return ps.executeUpdate() > 0;
        }
    }
}