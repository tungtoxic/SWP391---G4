/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

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
        try {
            Connection conn = DBConnector.makeConnection();
            if (conn != null) {
                String sql = "SELECT * FROM Users WHERE username = ? AND password_hash = ? AND status ='active'";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, password);
                ResultSet rs = ps.executeQuery();
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
<<<<<<< HEAD
=======

>>>>>>> thanhhe180566
        } catch (Exception e) {

        }
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
   
    //lấy toàn bộ user 
    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name FROM Users u JOIN Roles r ON u.role_id = r.role_id";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setRoleId(rs.getInt("role_id"));
                user.setStatus(rs.getString("status"));
                user.setRoleName(rs.getString("role_name")); // ✅ lấy role name từ join
                list.add(user);
            }
        }
        return list;
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

<<<<<<< HEAD
=======

>>>>>>> thanhhe180566
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

<<<<<<< HEAD
=======

>>>>>>> thanhhe180566
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
<<<<<<< HEAD
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

    public List<MonthlySaleDTO> getAgentMonthlySales(int agentId) {
        List<MonthlySaleDTO> salesData = new ArrayList<>();
        String sql = """
        SELECT 
            DATE_FORMAT(start_date, '%Y-%m') AS month_year, 
            IFNULL(SUM(premium_amount), 0) AS total_premium
        FROM Contracts
        WHERE agent_id = ? 
          AND start_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
        GROUP BY month_year
        ORDER BY month_year ASC
    """;

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, agentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String monthYear = rs.getString("month_year");
                    double totalPremium = rs.getDouble("total_premium");

                    // Chuyển đổi định dạng tháng/năm (ví dụ: 2025-05 -> T5/25)
                    String displayMonth = "T" + monthYear.substring(5) + "/" + monthYear.substring(2, 4);

                    salesData.add(new MonthlySaleDTO(displayMonth, totalPremium));
                }
            }
        } catch (SQLException e) {
            // Ghi lại lỗi SQL, không nên để trống catch block
            System.err.print("Wrong when get Number Sale by Agent");
            e.printStackTrace();
        }
        return salesData;
    }

    // Bổ sung vào class UserDao.java
    /**
     * Lấy tổng Premium (doanh thu) cá nhân trong tháng hiện tại
     * (Month-To-Date).
     *
     * @param agentId ID của Agent.
     * @return Tổng Premium tháng này.
     */
    public double getMonthlyPremiumByAgent(int agentId) {
        String sql = """
        SELECT IFNULL(SUM(premium_amount), 0)
        FROM Contracts
        WHERE agent_id = ? 
          AND MONTH(start_date) = MONTH(CURDATE()) 
          AND YEAR(start_date) = YEAR(CURDATE())
          AND status = 'Active' /* Chỉ tính HĐ Active/Đã được duyệt */
    """;
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, agentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            System.err.print("Wrong when get month by agent");
            e.printStackTrace();
        }
        return 0;
    }

    public int getActiveClientCountByAgent(int agentId) {
        String sql = """
        SELECT COUNT(DISTINCT customer_id)
        FROM Contracts
        WHERE agent_id = ? 
          AND status = 'Active'
    """;
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, agentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.print("Wrong when get Active Client");
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getLeadsCountByAgent(int agentId) {
    String sql = "SELECT COUNT(*) FROM Customers WHERE created_by = ? AND customer_type = 'Lead'";
    
    try (Connection conn = DBConnector.makeConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
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
=======
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
>>>>>>> thanhhe180566


    public List<String> getRenewalAlerts(int agentId) {
        List<String> alerts = new ArrayList<>();
        String sql = """
        SELECT 
            c.contract_id, 
            cust.full_name AS customer_name,
            c.end_date
        FROM Contracts c
        JOIN Customers cust ON c.customer_id = cust.customer_id
        WHERE c.agent_id = ? 
          AND c.status = 'Active'
          AND c.end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 90 DAY)
        ORDER BY c.end_date ASC
        LIMIT 5 /* Giới hạn 5 cảnh báo hiển thị trên Dashboard */
    """;

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, agentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String alertString = "Hợp đồng #" + rs.getInt("contract_id")
                            + " (" + rs.getString("customer_name") + ")"
                            + " - Hạn: " + rs.getDate("end_date").toString();
                    alerts.add(alertString);
                }
            }
        } catch (SQLException e) {
            System.err.print("Wrong when get alerts");
            e.printStackTrace();
        }
        return alerts;
    }
}
