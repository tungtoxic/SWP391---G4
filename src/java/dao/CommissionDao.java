/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import entity.CommissionReportDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utility.DBConnector;
/**
 *
 * @author Nguyễn Tùng
 */
public class CommissionDao {

    public List<CommissionReportDTO> getCommissionReportByAgentId(int agentId, String startDateStr, String endDateStr) {
        List<CommissionReportDTO> reportList = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        // Câu SQL gốc
        StringBuilder sql = new StringBuilder("""
            SELECT 
                co.contract_id,
                cust.full_name AS customer_name,
                p.product_name,
                co.premium_amount,
                com.amount AS commission_amount,
                com.status,
                com.created_at AS commission_date
            FROM Commissions com
            JOIN Contracts co ON com.contract_id = co.contract_id
            JOIN Customers cust ON co.customer_id = cust.customer_id 
            JOIN Products p ON co.product_id = p.product_id
            WHERE com.agent_id = ?
        """);
        
        params.add(agentId);

        // Thêm điều kiện lọc theo ngày nếu có
        if (startDateStr != null && !startDateStr.isEmpty()) {
            sql.append(" AND com.created_at >= ?");
            params.add(startDateStr);
        }
        if (endDateStr != null && !endDateStr.isEmpty()) {
            // Thêm giờ phút giây để bao gồm cả ngày kết thúc
            sql.append(" AND com.created_at <= ?");
            params.add(endDateStr + " 23:59:59");
        }
        
        sql.append(" ORDER BY com.created_at DESC");

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            // Set các tham số cho PreparedStatement
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reportList.add(new CommissionReportDTO(
                        rs.getInt("contract_id"),
                        rs.getString("customer_name"),
                        rs.getString("product_name"),
                        rs.getDouble("premium_amount"),
                        rs.getDouble("commission_amount"),
                        rs.getString("status"),
                        rs.getTimestamp("commission_date")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reportList;
    }
}