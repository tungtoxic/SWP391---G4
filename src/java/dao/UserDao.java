/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import entity.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
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
                String sql = "SELECT * FROM Users WHERE username = ? AND password_hash = ?";
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
                    user.setRoleId(rs.getInt("role_id"));
                    user.setStatus(rs.getString("status"));
                    return user;

                }
            }
        }catch (Exception e) {
            
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

    public boolean activateUserByEmail(String email) throws SQLException {
        String sql = "UPDATE Users SET status = 'Active' WHERE email = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeUpdate() > 0;
        }
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

    //update thông tin cua user 
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE Users SET username=?, full_name=?, email=?, phone_number=?, role_id=?, status=? WHERE user_id=?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhoneNumber());
            ps.setInt(5, user.getRoleId());
            ps.setString(6, user.getStatus());
            ps.setInt(7, user.getUserId());
            return ps.executeUpdate() > 0;
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

}
