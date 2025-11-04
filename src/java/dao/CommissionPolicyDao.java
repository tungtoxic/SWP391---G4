package dao;

import entity.CommissionPolicy;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utility.DBConnector;

/**
 * NÂNG CẤP: Đã thêm các hàm CRUD (Thêm/Sửa/Xem) cho Manager.
 */
public class CommissionPolicyDao {

    // -----------------------------------------------------------------
    // HÀM GỐC (GIỮ NGUYÊN - RẤT TỐT)
    // -----------------------------------------------------------------
    
    /**
     * Lấy chính sách hoa hồng đang có hiệu lực tại thời điểm hiện tại.
     * (Dùng cho logic "Tự động hóa" của ManagerContractServlet)
     */
    public CommissionPolicy getCurrentPolicy() {
        String sql = "SELECT * FROM Commission_Policies WHERE effective_from <= CURDATE() ORDER BY effective_from DESC LIMIT 1";
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return mapResultSetToPolicy(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // Trả về null nếu không có chính sách nào hợp lệ
    }

    // -----------------------------------------------------------------
    // CÁC HÀM CRUD MỚI (CHO MANAGER)
    // -----------------------------------------------------------------
    
    /**
     * HÀM MỚI: Lấy TẤT CẢ chính sách (để hiển thị danh sách cho Manager).
     */
    public List<CommissionPolicy> getAllPolicies() {
        List<CommissionPolicy> list = new ArrayList<>();
        // Sắp xếp theo ngày hiệu lực, mới nhất lên đầu
        String sql = "SELECT * FROM Commission_Policies ORDER BY effective_from DESC";
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSetToPolicy(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * HÀM MỚI: Lấy một chính sách theo ID (dùng cho form Edit).
     */
    public CommissionPolicy getPolicyById(int policyId) {
        String sql = "SELECT * FROM Commission_Policies WHERE policy_id = ?";
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, policyId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPolicy(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * HÀM MỚI: Thêm một chính sách mới vào CSDL.
     */
    public boolean insertPolicy(CommissionPolicy policy) {
        String sql = "INSERT INTO Commission_Policies (policy_name, rate, effective_from) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, policy.getPolicyName());
            ps.setBigDecimal(2, policy.getRate());
            // Chuyển đổi java.util.Date (từ Entity) sang java.sql.Date (cho CSDL)
            ps.setDate(3, new java.sql.Date(policy.getEffectiveFrom().getTime()));
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * HÀM MỚI: Cập nhật một chính sách đã có.
     */
    public boolean updatePolicy(CommissionPolicy policy) {
        String sql = "UPDATE Commission_Policies SET policy_name = ?, rate = ?, effective_from = ? WHERE policy_id = ?";
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, policy.getPolicyName());
            ps.setBigDecimal(2, policy.getRate());
            ps.setDate(3, new java.sql.Date(policy.getEffectiveFrom().getTime()));
            ps.setInt(4, policy.getPolicyId());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // HÀM HỖ TRỢ: Giúp map ResultSet sang Entity (Tránh lặp code)
    private CommissionPolicy mapResultSetToPolicy(ResultSet rs) throws SQLException {
        CommissionPolicy policy = new CommissionPolicy();
        policy.setPolicyId(rs.getInt("policy_id"));
        policy.setPolicyName(rs.getString("policy_name"));
        policy.setRate(rs.getBigDecimal("rate"));
        policy.setEffectiveFrom(rs.getDate("effective_from")); // java.sql.Date là con của java.util.Date
        return policy;
    }
}