package dao;

import utility.DBConnector;
import entity.Product;
import java.sql.*;
import java.util.*;

public class ProductDao {

    // ================== Lấy tất cả sản phẩm ==================
    public List<Product> getAllProducts() throws Exception {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products";

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setDescription(rs.getString("description"));
                p.setBasePrice(rs.getDouble("base_price"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(p);
            }
        }
        return list;
    }

    // ================== Lấy sản phẩm theo ID ==================
    public Product getProductById(int id) {
        Product product = null;
        String sql = "SELECT * FROM Products WHERE product_id = ?";

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setProductName(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setBasePrice(rs.getDouble("base_price"));
                product.setCategoryId(rs.getInt("category_id"));
                product.setCreatedAt(rs.getTimestamp("created_at"));
                product.setUpdatedAt(rs.getTimestamp("updated_at"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return product;
    }

    // ================== Thêm sản phẩm mới ==================
    public boolean insertProduct(Product p) throws Exception {
        String sql = """
            INSERT INTO Products (product_name, description, base_price, category_id, created_at)
            VALUES (?, ?, ?, ?, NOW())
        """;

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getProductName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getBasePrice());
            ps.setInt(4, p.getCategoryId());
            return ps.executeUpdate() > 0;
        }
    }

    // ================== Cập nhật sản phẩm ==================
    public boolean updateProduct(Product p) throws Exception {
        String sql = """
            UPDATE Products
            SET product_name = ?, description = ?, base_price = ?, category_id = ?, updated_at = NOW()
            WHERE product_id = ?
        """;

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getProductName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getBasePrice());
            ps.setInt(4, p.getCategoryId());
            ps.setInt(5, p.getProductId());
            return ps.executeUpdate() > 0;
        }
    }

    // ================== Xóa sản phẩm ==================
    public boolean deleteProduct(int id) throws Exception {
        String sql = "DELETE FROM Products WHERE product_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ================== Lấy theo danh mục ==================
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE category_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setDescription(rs.getString("description"));
                p.setBasePrice(rs.getDouble("base_price"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🧩 Thêm hàm main để test nhanh
    public static void main(String[] args) {
        ProductDao dao = new ProductDao();
        int testId = 4; // 👉 ID bạn muốn test trong database

        Product p = dao.getProductById(testId);

        if (p != null) {
            System.out.println("✅ Tìm thấy sản phẩm:");
            System.out.println("ID: " + p.getProductId());
            System.out.println("Tên: " + p.getProductName());
            System.out.println("Giá: " + p.getBasePrice());
            System.out.println("Mô tả: " + p.getDescription());
            System.out.println("Danh mục: " + p.getCategoryId());
        } else {
            System.out.println("❌ Không tìm thấy sản phẩm với ID = " + testId);
        }
    }
}
