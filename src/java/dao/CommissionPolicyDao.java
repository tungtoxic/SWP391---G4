/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import entity.CommissionPolicy;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utility.DBConnector;


/**
 *
 * @author Nguyễn Tùng
 */


public class CommissionPolicyDao {

    /**
     * Lấy chính sách hoa hồng đang có hiệu lực tại thời điểm hiện tại.
     * Logic: Lấy chính sách có ngày hiệu lực (effective_from) gần nhất 
     * nhưng không ở trong tương lai.
     * @return một đối tượng CommissionPolicy, hoặc null nếu không tìm thấy.
     */
    public CommissionPolicy getCurrentPolicy() {
        String sql = "SELECT * FROM Commission_Policies WHERE effective_from <= CURDATE() ORDER BY effective_from DESC LIMIT 1";
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                CommissionPolicy policy = new CommissionPolicy();
                policy.setPolicyId(rs.getInt("policy_id"));
                policy.setPolicyName(rs.getString("policy_name"));
                policy.setRate(rs.getBigDecimal("rate")); // Lấy tỷ lệ từ CSDL
                policy.setEffectiveFrom(rs.getDate("effective_from"));
                return policy;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Trả về null nếu không có chính sách nào hợp lệ
    }
}