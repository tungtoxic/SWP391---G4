/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import entity.Product;
import utility.DBConnector;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/*
 * @author Nguyễn Tùng
 */

public class ProductDao {

    /**
     * Lấy TẤT CẢ sản phẩm đang có trong CSDL.
     */
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        // Đã BỎ QUA category, chỉ lấy từ bảng Products
        String sql = "SELECT * FROM Products ORDER BY product_name ASC"; 
        
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setDescription(rs.getString("description"));
                p.setBasePrice(rs.getBigDecimal("base_price")); // Dùng getBigDecimal
                p.setCategoryId(rs.getInt("category_id"));
                p.setDurationMonths(rs.getInt("duration_months"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy 1 sản phẩm bằng ID.
     * (Vẫn cần cho luồng "Chi tiết Hợp đồng" và "Tạo Commission")
     */
    public Product getProductById(int id) {
        String sql = "SELECT * FROM Products WHERE product_id = ?";
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setDescription(rs.getString("description"));
                    p.setBasePrice(rs.getBigDecimal("base_price"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setDurationMonths(rs.getInt("duration_months"));
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}