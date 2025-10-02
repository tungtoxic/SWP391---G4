/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Helios 16
 */
import entity.Agent;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AgentDAO extends DBConnector {   // DBUtils là class tiện ích mở kết nối DB

    // Thêm agent mới
    public boolean addAgent(String username, String password, String fullName,
                         String email, String phoneNumber) {
        String sql = "INSERT INTO Users (username, password_hash, full_name, email, phone_number, role_id, status) "
                   + "VALUES (?, ?, ?, ?, ?, 3, 'Active')";

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);  // ⚠ TODO: Nên mã hoá trước khi lưu
            ps.setString(3, fullName);
            ps.setString(4, email);
            ps.setString(5, phoneNumber);

            int rows = ps.executeUpdate();
            return rows > 0; // trả về true nếu thêm thành công
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Hàm lấy tất cả Agents
    public List<Agent> getAllAgents() {
        List<Agent> list = new ArrayList<>();
        String sql = "SELECT user_id, username, full_name, email, phone_number, status " +
                     "FROM Users WHERE role_id = 3";

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Agent agent = new Agent();
                agent.setUserId(rs.getInt("user_id"));
                agent.setUsername(rs.getString("username"));
                agent.setFullName(rs.getString("full_name"));
                agent.setEmail(rs.getString("email"));
                agent.setPhoneNumber(rs.getString("phone_number"));
                agent.setStatus(rs.getString("status"));
                list.add(agent);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    
}
