package dao;

import entity.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import utility.DBConnector;

/**
 * PHIÊN BẢN ĐÃ TÁI CẤU TRÚC HOÀN CHỈNH (FIX LỖI stage_name)
 */
public class CustomerDao {

    /**
     * SỬA LỖI: Đã THÊM JOIN với Customer_Stages
     */
    public List<Customer> getAllCustomersByAgentId(int agentId) {
        List<Customer> list = new ArrayList<>();
        // SỬA: Thêm JOIN, bỏ customer_type, thêm stage_id và stage_name
        String sql = "SELECT c.*, s.stage_name " + // <-- SỬA
                     "FROM Customers c " +
                     "JOIN Customer_Stages s ON c.stage_id = s.stage_id " + // <-- SỬA
                     "WHERE c.created_by = ? AND c.status = 'Active' " + 
                     "ORDER BY c.customer_id DESC";
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, agentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Customer c = new Customer();
                    c.setCustomerId(rs.getInt("customer_id"));
                    c.setFullName(rs.getString("full_name"));
                    c.setDateOfBirth(rs.getDate("date_of_birth"));
                    c.setPhoneNumber(rs.getString("phone_number"));
                    c.setEmail(rs.getString("email"));
                    c.setAddress(rs.getString("address"));
                    c.setCreatedBy(rs.getInt("created_by"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setStageId(rs.getInt("stage_id"));
                    c.setStageName(rs.getString("stage_name")); // <-- Dòng 34 (giờ đã an toàn)
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * SỬA LỖI: Đã THÊM JOIN với Customer_Stages
     */
    public Customer getCustomerById(int id) {
        String sql = "SELECT c.*, s.stage_name " +
                     "FROM Customers c " +
                     "JOIN Customer_Stages s ON c.stage_id = s.stage_id " +
                     "WHERE c.customer_id = ?";
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer c = new Customer();
                    c.setCustomerId(rs.getInt("customer_id"));
                    c.setFullName(rs.getString("full_name"));
                    c.setDateOfBirth(rs.getDate("date_of_birth"));
                    c.setPhoneNumber(rs.getString("phone_number"));
                    c.setEmail(rs.getString("email"));
                    c.setAddress(rs.getString("address"));
                    c.setCreatedBy(rs.getInt("created_by"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setStageId(rs.getInt("stage_id"));
                    c.setStageName(rs.getString("stage_name"));
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * SỬA LỖI: Dùng stage_id = 1 (Lead) thay vì customer_type
     */
    public boolean insertCustomer(Customer c) {
        // SỬA: Bỏ customer_type, thêm stage_id
        String sql = "INSERT INTO Customers(full_name, date_of_birth, phone_number, email, address, created_by, stage_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, c.getFullName());
            ps.setDate(2, c.getDateOfBirth());
            ps.setString(3, c.getPhoneNumber());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getAddress());
            ps.setInt(6, c.getCreatedBy());
            ps.setInt(7, 1); // Mặc định stage_id = 1 (Lead)
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // updateCustomer (Giữ nguyên)
    public boolean updateCustomer(Customer c) {
        String sql = "UPDATE Customers SET full_name=?, date_of_birth=?, phone_number=?, email=?, address=? WHERE customer_id=?";
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, c.getFullName());
            ps.setDate(2, c.getDateOfBirth());
            ps.setString(3, c.getPhoneNumber());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getAddress());
            ps.setInt(6, c.getCustomerId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * SỬA LỖI: Dùng Soft Delete (CSDL của bạn có cột 'status')
     */
    public boolean deleteCustomer(int id) {
        // CSDL của bạn có cột status ENUM('Active', 'Inactive'), chúng ta nên dùng nó.
        String sql = "UPDATE Customers SET status = 'Inactive' WHERE customer_id = ?"; 
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- CÁC HÀM "SẠCH" MÀ BẠN ĐÃ THÊM (GIỮ NGUYÊN) ---

    public boolean updateCustomerStage(int customerId, int stageId, int agentId) {
        String sql = "UPDATE Customers SET stage_id = ? WHERE customer_id = ? AND created_by = ?";
        try (Connection conn = DBConnector.makeConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stageId);
            ps.setInt(2, customerId);
            ps.setInt(3, agentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Map<String, Integer> countCustomersByStage(int agentId) {
        Map<String, Integer> stageCounts = new HashMap<>();
        // Sắp xếp theo stage_order để giữ thứ tự (Lead, Potential, Client...)
        String sql = "SELECT s.stage_name, COUNT(c.customer_id) as count " +
                     "FROM Customers c " +
                     "JOIN Customer_Stages s ON c.stage_id = s.stage_id " +
                     "WHERE c.created_by = ? AND c.status = 'Active' " +
                     "GROUP BY s.stage_id, s.stage_name, s.stage_order " +
                     "ORDER BY s.stage_order"; 

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, agentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    stageCounts.put(rs.getString("stage_name"), rs.getInt("count"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stageCounts;
    }
}