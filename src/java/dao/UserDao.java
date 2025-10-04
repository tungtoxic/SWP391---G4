/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import utility.*;
import utility.DBConnector;
import entity.User;
import java.sql.*;

/**
 *
 * @author Helios 16
 */
public class UserDao {
    // Hàm login check DB

    public User login(String username) throws SQLException {
        String sql = "SELECT * FROM Users WHERE username = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
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
                    return user;
                }
            }
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
            return ps.executeUpdate() > 0;   // ✅ phải kiểm tra số dòng insert
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
}
