/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import entity.*;
import utility.DBConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;  
/**
 *
 * @author Nguyễn Tùng
 */
public class InteractionDao {
    /**
     * Thêm một tương tác mới vào CSDL.
     */
    public boolean addInteraction(Interaction interaction) {
        // Đã SỬA: Thêm "interaction_type_id"
        String sql = "INSERT INTO customer_interactions (customer_id, agent_id, interaction_type_id, notes, interaction_date) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, interaction.getCustomerId());
            ps.setInt(2, interaction.getAgentId());
            ps.setInt(3, interaction.getInteractionTypeId()); // <-- ĐÃ SỬA
            ps.setString(4, interaction.getNotes());
            ps.setTimestamp(5, interaction.getInteractionDate()); 

            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy tất cả lịch sử tương tác của MỘT khách hàng, sắp xếp mới nhất lên đầu.
     * SỬA ĐỔI: Dùng JOIN để lấy tên và icon của loại tương tác.
     */
    public List<Interaction> getInteractionsByCustomerId(int customerId) {
        List<Interaction> list = new ArrayList<>();
        // ĐÃ SỬA: Dùng JOIN 2 bảng
        String sql = "SELECT i.*, it.type_name, it.icon_class " +
                     "FROM customer_interactions i " +
                     "JOIN interaction_types it ON i.interaction_type_id = it.type_id " +
                     "WHERE i.customer_id = ? " +
                     "ORDER BY i.interaction_date DESC";
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, customerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Interaction interaction = new Interaction();
                    interaction.setInteractionId(rs.getInt("interaction_id"));
                    interaction.setCustomerId(rs.getInt("customer_id"));
                    interaction.setAgentId(rs.getInt("agent_id"));
                    interaction.setInteractionTypeId(rs.getInt("interaction_type_id")); // <-- ID
                    interaction.setNotes(rs.getString("notes"));
                    interaction.setInteractionDate(rs.getTimestamp("interaction_date"));
                    interaction.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    // Thêm dữ liệu JOIN vào các trường transient
                    interaction.setInteractionTypeName(rs.getString("type_name")); // <-- Tên
                    interaction.setInteractionTypeIcon(rs.getString("icon_class")); // <-- Icon
                    
                    list.add(interaction);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    /**
     * HÀM MỚI (THEO LOGIC "SẠCH" CỦA BẠN):
     * Lấy tất cả các "Tương tác" (Interactions) được lên lịch
     * cho HÔM NAY (CURDATE()) và JOIN với tên khách hàng.
     * Đây chính là "Today's Follow-ups".
     */
    public List<Interaction> getTodaysFollowUps(int agentId) {
        List<Interaction> list = new ArrayList<>();
        
        // SQL "SẠCH": Đọc từ customer_interactions, không phải Tasks
        String sql = "SELECT i.*, c.full_name as customer_name, it.type_name, it.icon_class " +
                     "FROM customer_interactions i " +
                     "JOIN Customers c ON i.customer_id = c.customer_id " +
                     "JOIN interaction_types it ON i.interaction_type_id = it.type_id " +
                     "WHERE i.agent_id = ? " +
                     "AND DATE(i.interaction_date) = CURDATE() " + // Chỉ lấy hẹn HÔM NAY
                     "ORDER BY i.interaction_date ASC"; // Sắp xếp theo giờ hẹn

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, agentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Interaction interaction = new Interaction();
                    interaction.setInteractionId(rs.getInt("interaction_id"));
                    interaction.setCustomerId(rs.getInt("customer_id"));
                    interaction.setAgentId(rs.getInt("agent_id"));
                    interaction.setInteractionTypeId(rs.getInt("interaction_type_id"));
                    interaction.setNotes(rs.getString("notes"));
                    interaction.setInteractionDate(rs.getTimestamp("interaction_date"));
                    interaction.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    // Thêm dữ liệu JOIN
                    interaction.setCustomerName(rs.getString("customer_name")); // <-- Tên KH
                    interaction.setInteractionTypeName(rs.getString("type_name")); // <-- Tên Tương tác
                    interaction.setInteractionTypeIcon(rs.getString("icon_class")); // <-- Icon
                    
                    list.add(interaction);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

