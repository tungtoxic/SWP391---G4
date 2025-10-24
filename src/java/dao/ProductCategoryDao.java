package dao;

import java.sql.*;
import java.util.*;
import entity.ProductCategory;
import utility.DBConnector;

public class ProductCategoryDao {

    public List<ProductCategory> getAllCategories() throws Exception {
        List<ProductCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM Product_Categories";

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ProductCategory c = new ProductCategory();
                c.setCategoryId(rs.getInt("category_id"));
                c.setCategoryName(rs.getString("category_name"));
                c.setDescription(rs.getString("description"));
                list.add(c);
            }
        }
        return list;
    }
    public ProductCategory getCategoryByName(String categoryName) throws Exception {
        String sql = "SELECT * FROM Product_Categories WHERE category_name LIKE ?";
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + categoryName + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProductCategory category = new ProductCategory();
                    category.setCategoryId(rs.getInt("category_id"));
                    category.setCategoryName(rs.getString("category_name"));
                    category.setDescription(rs.getString("description"));
                    return category;
                }
            }
        }
        return null;
    }
}