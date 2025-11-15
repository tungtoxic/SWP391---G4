package dao;

import entity.AgentPerformanceDTO;
import entity.*;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import utility.DBConnector;

public class UserDao {
    // ... (Hàm login()... giữ nguyên)
    public User login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username = ? AND password_hash = ? AND status ='Active'";
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
                    try {
                        user.setIsFirstLogin(rs.getBoolean("is_first_login"));
                    } catch (SQLException e) {
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

    // ... (Hàm checkEmailExists()... giữ nguyên)
    public boolean checkEmailExists(String email) {
        String sql = "SELECT user_id FROM Users WHERE email = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ... (Hàm checkUsernameExists()... giữ nguyên)
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

    // ... (Hàm isUsernameExists()... giữ nguyên)
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
    
    // ... (Hàm isPhoneExists()... giữ nguyên)
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

    // ... (Hàm insertUser()... giữ nguyên)
    public boolean insertUser(User user) throws SQLException {
        String sql = "INSERT INTO users (username, password_hash, full_name, email, phone_number, role_id, status, is_first_login) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhoneNumber());
            ps.setInt(6, user.getRoleId());
            ps.setString(7, user.getStatus());
            ps.setBoolean(8, user.getIsFirstLogin());
            return ps.executeUpdate() > 0;
        }
    }

    // ... (Hàm getRoleIdByName()... giữ nguyên)
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
        return -1; 
    }
    
    // ... (Hàm getAllUsers()... giữ nguyên)
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
                    User user = mapRowToUser(rs); 
                    userList.add(user);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách users với filter: " + roleIdFilter);
            e.printStackTrace();
            throw e;
        }
        return userList;
    }

    // ... (Hàm getRoleNameById()... giữ nguyên)
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

    // ... (Hàm getUserById()... giữ nguyên)
    public User getUserById(int id) throws SQLException {
        String sql = "SELECT u.*, r.role_name FROM Users u JOIN Roles r ON u.role_id = r.role_id WHERE u.user_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy user theo ID: " + id);
            e.printStackTrace();
            throw e;
        }
        return null;
    }
    
    // ... (Hàm getUsersByRoleId()... giữ nguyên)
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
                    users.add(mapRowToUser(rs)); 
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy user theo Role ID: " + roleId);
            e.printStackTrace();
            throw e;
        }
        return users;
    }

    // ... (Hàm updateUser()... giữ nguyên)
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
            ps.setBoolean(8, user.getIsFirstLogin());
            ps.setInt(9, user.getUserId());
            return ps.executeUpdate() > 0;
        }
    }
    
    // ... (Hàm activateUserById()... giữ nguyên)
    public boolean activateUserById(int id) throws SQLException {
        String sql = "UPDATE Users SET status = 'Active' WHERE user_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ... (Hàm deactivateUserById()... giữ nguyên)
    public boolean deactivateUserById(int id) throws SQLException {
        String sql = "UPDATE Users SET status = 'Inactive' WHERE user_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ... (Hàm getContractCountByAgent()... giữ nguyên)
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

    // ... (Hàm getTotalCommissionByAgent()... giữ nguyên)
    public double getTotalCommissionByAgent(int agentId) {
        String sql = "SELECT IFNULL(SUM(amount), 0.00) FROM Commissions WHERE agent_id = ?";
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
        return 0.0;
    }

    // ... (Hàm generateTempPassword()... giữ nguyên)
    public static String generateTempPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"; 
        StringBuilder sb = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
    
    // ... (Hàm createUser()... giữ nguyên)
    public boolean createUser(User user) throws SQLException {
        String sql = "INSERT INTO Users (username, password_hash, full_name, email, phone_number, role_id, status, is_first_login) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash()); 
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhoneNumber());
            ps.setInt(6, user.getRoleId());
            ps.setString(7, user.getStatus());
            ps.setBoolean(8, user.getIsFirstLogin());
            return ps.executeUpdate() > 0;
        }
    }
    
    // ... (Hàm deleteUser()... giữ nguyên)
    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM Users WHERE user_id=?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa user ID: " + userId + ". Có thể do ràng buộc khóa ngoại.");
            e.printStackTrace();
            throw e; 
        }
    }
    
    // ... (Hàm updatePassword()... giữ nguyên)
    public boolean updatePassword(int userId, String newPasswordHash) {
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

    // ... (Hàm registerUser()... giữ nguyên)
    public boolean registerUser(User user) throws SQLException {
        String sql = "INSERT INTO Users (full_name, email, phone_number, role_id, status, is_first_login) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setInt(4, user.getRoleId());
            ps.setString(5, user.getStatus());
            ps.setBoolean(6, user.getIsFirstLogin());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lấy hiệu suất của các Agent trong team của Manager.
     * === ĐÃ "VÁ" (PATCHED) LỖI SQL (GROUP BY) ===
     */
    public List<AgentPerformanceDTO> getTeamPerformance(int managerId) {
        List<AgentPerformanceDTO> teamPerformance = new ArrayList<>();
        
        // === BƯỚC "VÁ" (PATCH) SQL ===
        // (1) Dùng MAX(t.target_amount) để "tổng hợp" (aggregate) Target
        // (2) XÓA (REMOVE) "t.target_amount" khỏi "GROUP BY"
        // (3) Sửa COUNT (đếm) sang COUNT(DISTINCT ...) để tránh đếm trùng HĐ
        String sql = """
            SELECT
                u.user_id,
                u.full_name,
                IFNULL(SUM(CASE WHEN c.status = 'Active' THEN c.premium_amount ELSE 0 END), 0) AS total_premium,
                COUNT(DISTINCT CASE WHEN c.status = 'Active' THEN c.contract_id ELSE NULL END) AS contracts_count,
                IFNULL(MAX(t.target_amount), 0.00) AS target_amount 
            FROM Users u
            JOIN Manager_Agent ma ON u.user_id = ma.agent_id
            LEFT JOIN Contracts c ON u.user_id = c.agent_id
            LEFT JOIN Agent_Targets t ON u.user_id = t.agent_id
                        AND t.target_month = MONTH(CURDATE())
                        AND t.target_year = YEAR(CURDATE())
            WHERE ma.manager_id = ? AND u.role_id = 1
            GROUP BY u.user_id, u.full_name
            ORDER BY total_premium DESC;
        """; 
        // ============================

        try (Connection conn = DBConnector.makeConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, managerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // (1) Tạo DTO (Code cũ của bạn - đã TỐT)
                    AgentPerformanceDTO dto = new AgentPerformanceDTO(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getDouble("total_premium"), 
                            rs.getInt("contracts_count")
                    );
                    
                    // (2) Set Target (Code cũ của bạn - đã TỐT)
                    double targetAmount = rs.getDouble("target_amount");
                    dto.setTargetAmount(targetAmount);
                    
                    // (3) Tính % Vượt (Over-Achievement) (Code cũ của bạn - đã TỐT)
                    double overAchievementRate = 0.0;
                    if (targetAmount > 0 && dto.getTotalPremium() > targetAmount) {
                        overAchievementRate = ((dto.getTotalPremium() - targetAmount) / targetAmount) * 100;
                    }
                    dto.setOverAchievementRate(overAchievementRate); 
                    
                    // (4) Thêm (Add) DTO vào List
                    teamPerformance.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return teamPerformance;
    }

    // ... (Hàm getAllAgentsPerformance()... giữ nguyên)
    // (Chúng ta cũng "vá" (patch) SQL ở đây cho "đồng bộ" (consistent))
    public List<AgentPerformanceDTO> getAllAgentsPerformance() {
        List<AgentPerformanceDTO> allAgents = new ArrayList<>();
        int agentRoleId = 1; 
        String sql = """
            SELECT
                u.user_id,
                u.full_name,
                IFNULL(SUM(CASE WHEN c.status = 'Active' THEN c.premium_amount ELSE 0 END), 0) AS total_premium,
                COUNT(DISTINCT CASE WHEN c.status = 'Active' THEN c.contract_id ELSE NULL END) AS contracts_count
            FROM Users u
            LEFT JOIN Contracts c ON u.user_id = c.agent_id
            WHERE u.role_id = ?
            GROUP BY u.user_id, u.full_name
            ORDER BY total_premium DESC;
        """; 
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
    
    // ... (Hàm setAgentTarget()... giữ nguyên)
    public boolean setAgentTarget(int agentId, BigDecimal targetAmount, int month, int year) {
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
            
            return ps.executeUpdate() > 0; 
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi set target cho agent ID: " + agentId);
            e.printStackTrace();
            return false;
        }
    }

    // ... (Hàm getAgentLeaderboard()... giữ nguyên)
    public List<AgentPerformanceDTO> getAgentLeaderboard() {
        return getAllAgentsPerformance();
    }
    
    // ... (Hàm getManagerLeaderboard()... giữ nguyên)
    // (Chúng ta cũng "vá" (patch) SQL ở đây cho "đồng bộ" (consistent))
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
        """; 
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                leaderboard.add(new AgentPerformanceDTO(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getDouble("total_team_premium"),
                        0 
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return leaderboard;
    }

    // ... (Hàm getAgentsByManagerId()... giữ nguyên)
    public List<User> getAgentsByManagerId(int managerId) {
        List<User> agentList = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name " + 
                     "FROM Users u " +
                     "JOIN Manager_Agent ma ON u.user_id = ma.agent_id " +
                     "JOIN Roles r ON u.role_id = r.role_id " + 
                     "WHERE ma.manager_id = ? AND u.role_id = 1";
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    agentList.add(mapRowToUser(rs)); 
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách Agent theo Manager ID: " + managerId);
            e.printStackTrace();
        }
        return agentList;
    }

    // ... (Hàm getUsersByStatus()... giữ nguyên)
    public List<User> getUsersByStatus(String status) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id "
                + "WHERE u.status = ? ORDER BY u.user_id ASC";
        try (Connection con = DBConnector.makeConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToUser(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy user theo Status: " + status);
            e.printStackTrace();
            throw e;
        }
        return list;
    }

    // ... (Hàm updateAgent()... giữ nguyên)
    public boolean updateAgent(User user) throws SQLException {
        String sql = "UPDATE users SET full_name=?, email=?, phone_number=? WHERE user_id =? AND role_id = 1"; 
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setInt(4, user.getUserId());
            return ps.executeUpdate() > 0;
        }
    }
    
    // ... (Hàm mapRowToUser()... giữ nguyên)
    private User mapRowToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setRoleId(rs.getInt("role_id"));
        user.setStatus(rs.getString("status"));
        try {
            user.setIsFirstLogin(rs.getBoolean("is_first_login"));
        } catch (SQLException e) { /* Bỏ qua */ }
        try {
            user.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException e) { /* Bỏ qua */ }
        try {
            user.setUpdatedAt(rs.getTimestamp("updated_at"));
        } catch (SQLException e) { /* Bỏ qua */ }
        try {
            user.setRoleName(rs.getString("role_name"));
        } catch (SQLException e) { /* Bỏ qua */ }
        return user;
    }

    // ... (Hàm isAgentManagedBy()... giữ nguyên)
    public boolean isAgentManagedBy(int agentId, int managerId) {
        String sql = "SELECT COUNT(*) FROM Manager_Agent WHERE manager_id = ? AND agent_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ps.setInt(2, agentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi kiểm tra isAgentManagedBy: " + e.getMessage());
            e.printStackTrace();
        }
        return false; 
    }
    
    // ... (Hàm setTeamTarget()... giữ nguyên)
    public boolean setTeamTarget(int managerId, BigDecimal targetAmount, int month, int year) {
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
            
            ps.setBigDecimal(1, targetAmount); 
            ps.setInt(2, month);
            ps.setInt(3, year);
            ps.setInt(4, managerId);
            
            return ps.executeUpdate() > 0; 
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi set Team Target cho manager ID: " + managerId);
            e.printStackTrace();
            return false;
        }
    }
}