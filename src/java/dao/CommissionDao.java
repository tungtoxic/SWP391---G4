package dao;

import entity.CommissionPolicy; // <-- THÊM MỚI
import entity.CommissionReportDTO;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utility.DBConnector;

public class CommissionDao {

    /**
     * SỬA ĐỔI: Chuyển sang dùng BigDecimal
     */
    public List<CommissionReportDTO> getCommissionReportByAgentId(int agentId, String startDateStr, String endDateStr) {
        List<CommissionReportDTO> reportList = new ArrayList<>();
        List<Object> params = new ArrayList<>();

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

        if (startDateStr != null && !startDateStr.isEmpty()) {
            sql.append(" AND com.created_at >= ?");
            params.add(startDateStr);
        }
        if (endDateStr != null && !endDateStr.isEmpty()) {
            sql.append(" AND com.created_at <= ?");
            params.add(endDateStr + " 23:59:59");
        }
        
        sql.append(" ORDER BY com.created_at DESC");

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reportList.add(new CommissionReportDTO(
                        rs.getInt("contract_id"),
                        rs.getString("customer_name"),
                        rs.getString("product_name"),
                        rs.getBigDecimal("premium_amount"), // <-- SỬA
                        rs.getBigDecimal("commission_amount"), // <-- SỬA
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
    
    /**
     * VIẾT LẠI: Hàm "Tự động 100%" (Nghiệp vụ Tầng 1).
     * Hàm này sẽ tự lấy Policy, tự tính toán, và tự INSERT.
     * Servlet chỉ cần gọi hàm này.
     */
    public boolean createCommissionForContract(int contractId, int agentId, BigDecimal premiumAmount) {
        
        // Bước 1: Lấy chính sách hiện hành
        CommissionPolicyDao policyDao = new CommissionPolicyDao();
        CommissionPolicy currentPolicy = policyDao.getCurrentPolicy();
        
        // Nếu không có chính sách nào, không thể tạo hoa hồng
        if (currentPolicy == null) {
            System.err.println("Lỗi nghiệp vụ: Không tìm thấy Commission Policy nào đang hiệu lực. Không thể tạo hoa hồng.");
            return false;
        }

        // Bước 2: Tự động tính toán
        BigDecimal rate = currentPolicy.getRate().divide(new BigDecimal("100")); // Chuyển 5.00 thành 0.05
        BigDecimal amount = premiumAmount.multiply(rate);
        int policyId = currentPolicy.getPolicyId(); // Lấy ID động (không "fix cứng" 1)

        // Bước 3: INSERT vào CSDL
        String sql = "INSERT INTO Commissions (contract_id, agent_id, policy_id, amount, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, contractId);
            ps.setInt(2, agentId);
            ps.setInt(3, policyId); // <-- Động
            ps.setBigDecimal(4, amount); // <-- Động
            ps.setString(5, "Pending"); // Hoa hồng mới luôn ở trạng thái Pending

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * GIỮ NGUYÊN: Hàm này đã "sạch"
     */
    public BigDecimal getPendingCommissionTotal(int agentId) {
        String sql = "SELECT IFNULL(SUM(amount), 0) FROM Commissions WHERE agent_id = ? AND status = 'Pending'";
        BigDecimal total = BigDecimal.ZERO;

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, agentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getBigDecimal(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }
}