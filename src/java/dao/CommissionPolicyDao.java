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
import java.util.ArrayList;
import java.util.List;
import utility.DBConnector;

/**
 *
 * @author Nguyễn Tùng
 */
public class CommissionPolicyDao {

    /**
     * Lấy chính sách hoa hồng đang có hiệu lực tại thời điểm hiện tại. Logic:
     * Lấy chính sách có ngày hiệu lực (effective_from) gần nhất nhưng không ở
     * trong tương lai.
     *
     * @return một đối tượng CommissionPolicy, hoặc null nếu không tìm thấy.
     */
    public CommissionPolicy getCurrentPolicy() {
        String sql = "SELECT * FROM Commission_Policies WHERE effective_from <= CURDATE() ORDER BY effective_from DESC LIMIT 1";

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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

    public List<CommissionPolicy> getAllPolicies() {
        List<CommissionPolicy> list = new ArrayList<>();
        String sql = "SELECT * FROM Commission_Policies ORDER BY effective_from DESC";

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CommissionPolicy p = new CommissionPolicy();
                p.setPolicyId(rs.getInt("policy_id"));
                p.setPolicyName(rs.getString("policy_name"));
                p.setRate(rs.getBigDecimal("rate"));
                p.setRateType(rs.getString("rate_type"));
                p.setEffectiveFrom(rs.getDate("effective_from"));
                p.setEffectiveTo(rs.getDate("effective_to"));
                p.setStatus(rs.getString("status"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🟢 Lấy các chính sách đang hiệu lực
    public List<CommissionPolicy> getActivePolicies() {
        List<CommissionPolicy> list = new ArrayList<>();
        String sql = """
            SELECT * FROM Commission_Policies
            WHERE status = 'Active'
              AND effective_from <= CURDATE()
              AND (effective_to IS NULL OR effective_to >= CURDATE())
            ORDER BY effective_from DESC
        """;

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CommissionPolicy p = new CommissionPolicy();
                p.setPolicyId(rs.getInt("policy_id"));
                p.setPolicyName(rs.getString("policy_name"));
                p.setRate(rs.getBigDecimal("rate"));
                p.setRateType(rs.getString("rate_type"));
                p.setEffectiveFrom(rs.getDate("effective_from"));
                p.setEffectiveTo(rs.getDate("effective_to"));
                p.setStatus(rs.getString("status"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    
    public List<CommissionPolicy> getPoliciesByProductId(int productId) throws Exception {
        List<CommissionPolicy> list = new ArrayList<>();

        String sql = """
            SELECT DISTINCT cp.policy_id, cp.policy_name, cp.rate, cp.rate_type,
                            cp.effective_from, cp.effective_to, cp.status
            FROM Commission_Policies cp
            JOIN Commissions c ON cp.policy_id = c.policy_id
            JOIN Contracts ct ON c.contract_id = ct.contract_id
            JOIN Products p ON ct.product_id = p.product_id
            WHERE p.product_id = ?
            ORDER BY cp.effective_from DESC
        """;

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CommissionPolicy policy = new CommissionPolicy();
                    policy.setPolicyId(rs.getInt("policy_id"));
                    policy.setPolicyName(rs.getString("policy_name"));
                    policy.setRate(rs.getBigDecimal("rate"));
                    policy.setRateType(rs.getString("rate_type"));
                    policy.setEffectiveFrom(rs.getDate("effective_from"));
                    policy.setEffectiveTo(rs.getDate("effective_to"));
                    policy.setStatus(rs.getString("status"));
                    list.add(policy);
                }
            }
        }
        return list;
    }

}
