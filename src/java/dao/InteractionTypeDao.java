/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import entity.InteractionType;
import utility.DBConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InteractionTypeDao {

    /**
     * Lấy TẤT CẢ các loại tương tác (để hiển thị trong dropdown).
     */
    public List<InteractionType> getAllInteractionTypes() {
        List<InteractionType> list = new ArrayList<>();
        String sql = "SELECT * FROM interaction_types ORDER BY type_name ASC";
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                InteractionType type = new InteractionType();
                type.setTypeId(rs.getInt("type_id"));
                type.setTypeName(rs.getString("type_name"));
                type.setIconClass(rs.getString("icon_class"));
                list.add(type);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}