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

    // 🟢 Lấy tất cả khách hàng
// CustomerDao.java

public List<Customer> getAllCustomers() throws SQLException { // <--- THÊM throws SQLException
    List<Customer> list = new ArrayList<>();
    String sql = "SELECT * FROM Customers ORDER BY customer_id DESC";
    
    try (Connection conn = DBConnector.makeConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            // ... (Ánh xạ DTO giữ nguyên) ...
            Customer c = new Customer();
            c.setCustomerId(rs.getInt("customer_id"));
            c.setFullName(rs.getString("full_name"));
            c.setDateOfBirth(rs.getDate("date_of_birth"));
            c.setPhoneNumber(rs.getString("phone_number"));
            c.setEmail(rs.getString("email"));
            c.setAddress(rs.getString("address"));
            c.setCreatedBy(rs.getInt("created_by"));
            c.setCreatedAt(rs.getTimestamp("created_at"));
            c.setUpdatedAt(rs.getTimestamp("updated_at"));
            list.add(c);
        }
    } 
    // KHÔNG BẮT CATCH Ở ĐÂY NỮA, mà ném lên Servlet
    return list;
}

    // 🟢 Lấy khách hàng theo ID
    public Customer getCustomerById(int id) {
        String sql = "SELECT * FROM Customers WHERE customer_id = ?";
        try (Connection conn = DBConnector.makeConnection();PreparedStatement ps = conn.prepareStatement(sql)) {
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
                    c.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 🟢 Thêm khách hàng mới
    public boolean insertCustomer(Customer c) {
        String sql = "INSERT INTO Customers(full_name, date_of_birth, phone_number, email, address, created_by) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection();PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getFullName());
            ps.setDate(2, c.getDateOfBirth());
            ps.setString(3, c.getPhoneNumber());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getAddress());
            ps.setInt(6, c.getCreatedBy());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🟢 Cập nhật thông tin khách hàng
    public boolean updateCustomer(Customer c) {
        String sql = "UPDATE Customers SET full_name=?, date_of_birth=?, phone_number=?, email=?, address=? "
                   + "WHERE customer_id=?";
        try (Connection conn = DBConnector.makeConnection();PreparedStatement ps = conn.prepareStatement(sql)) {
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

    // 🟢 Xóa khách hàng
    public boolean deleteCustomer(int id) {
        String sql = "DELETE FROM Customers WHERE customer_id=?";
        try (Connection conn = DBConnector.makeConnection();PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // CustomerDao.java

// 🟢 Lấy danh sách khách hàng theo ID Agent tạo ra
public List<Customer> getAllCustomersByAgentId(int agentId) {
    List<Customer> list = new ArrayList<>();
    // Thêm điều kiện lọc WHERE created_by = ?
    String sql = "SELECT * FROM Customers WHERE created_by = ? ORDER BY customer_id DESC";
    
    // Lưu ý: Đã thay đổi catch (Exception e) thành try/catch bên trong để quản lý tài nguyên
    try (Connection conn = DBConnector.makeConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, agentId); // Set ID của Agent
        
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
                c.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(c);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

// Giữ nguyên các hàm khác (getCustomerById, insertCustomer, updateCustomer, deleteCustomer)
}

