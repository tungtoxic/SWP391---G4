/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import entity.CustomerStage;
import utility.DBConnector;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyễn Tùng
 */

public class CustomerStageDao {

    /**
     * Lấy TẤT CẢ các Giai đoạn Khách hàng (Lead, Potential...)
     * để hiển thị trong dropdown.
     */
    public List<CustomerStage> getAllStages() {
        List<CustomerStage> list = new ArrayList<>();
        String sql = "SELECT * FROM Customer_Stages ORDER BY stage_order ASC";
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                CustomerStage stage = new CustomerStage();
                stage.setStageId(rs.getInt("stage_id"));
                stage.setStageName(rs.getString("stage_name"));
                stage.setStageOrder(rs.getInt("stage_order"));
                list.add(stage);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}