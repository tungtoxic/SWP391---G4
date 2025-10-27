/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dao;

import entity.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import utility.DBConnector;

public class CustomerDao {

    // ========== READ: LẤY DANH SÁCH KHÁCH HÀNG THEO AGENT ==========
    public List<Customer> getAllCustomersByAgentId(int agentId) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM Customers WHERE created_by = ? AND status = 'Active' ORDER BY customer_id DESC";
        
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
                    c.setCustomerType(rs.getString("customer_type"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    // ========== READ: LẤY MỘT KHÁCH HÀNG THEO ID ==========
    public Customer getCustomerById(int id) {
        String sql = "SELECT * FROM Customers WHERE customer_id = ?";
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
                    c.setCustomerType(rs.getString("customer_type"));
                    c.setCreatedAt(rs.getTimestamp("created_at")); 
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    // ========== CREATE: THÊM KHÁCH HÀNG MỚI ==========
    public boolean insertCustomer(Customer c) {
        String sql = "INSERT INTO Customers(full_name, date_of_birth, phone_number, email, address, created_by, customer_type) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getFullName());
            ps.setDate(2, c.getDateOfBirth());
            ps.setString(3, c.getPhoneNumber());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getAddress());
            ps.setInt(6, c.getCreatedBy());
            ps.setString(7, c.getCustomerType());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    // ========== UPDATE: CẬP NHẬT THÔNG TIN KHÁCH HÀNG ==========
    public boolean updateCustomer(Customer c) {
        // Lưu ý: Không cho phép cập nhật created_by
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


    // ========== DELETE: XÓA KHÁCH HÀNG ==========
public boolean deleteCustomer(int id) {
    // String sql = "DELETE FROM Customers WHERE customer_id = ?"; // <-- Dòng cũ
    String sql = "UPDATE Customers SET status = 'Inactive' WHERE customer_id = ?"; // <-- Dòng MỚI
    try (Connection conn = DBConnector.makeConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, id);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
    // Thêm 2 phương thức này vào file dao/CustomerDao.java

/**
 * Đếm số lượng khách hàng tiềm năng (Leads) của một Agent.
 */
public int countLeadsByAgent(int agentId) {
    String sql = "SELECT COUNT(*) FROM Customers WHERE created_by = ? AND customer_type = 'Lead'";
    try (Connection conn = DBConnector.makeConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, agentId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
    }

    /**
     * Đếm số lượng khách hàng đã chốt (Clients) của một Agent.
     */
    public int countClientsByAgent(int agentId) {
        String sql = "SELECT COUNT(*) FROM Customers WHERE created_by = ? AND customer_type = 'Client'";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, agentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;

    }

    public boolean updateCustomerType(int customerId, String customerType, int agentId) {
        String sql = "UPDATE Customers SET customer_type = ? WHERE customer_id = ? AND created_by = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customerType);
            ps.setInt(2, customerId);
            ps.setInt(3, agentId); // Đảm bảo agent chỉ update được khách của mình
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
