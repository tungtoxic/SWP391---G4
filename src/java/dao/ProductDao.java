package dao;

import entity.InsuranceProductDetails;
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

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setProductName(rs.getString("product_name"));
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

    // ================== Thêm sản phẩm (có chi tiết bảo hiểm) ==================
    public boolean insertProduct(Product product, InsuranceProductDetails details) throws SQLException {
        String insertProductSQL = "INSERT INTO Products (product_name, base_price, category_id) VALUES (?, ?, ?)";
        String insertDetailSQL = "INSERT INTO Insurance_Product_Details ("
                + "product_id, category_id, product_type, coverage_amount, duration_years, "
                + "beneficiaries, maturity_benefit, maturity_amount, "
                + "hospitalization_limit, surgery_limit, maternity_limit, min_age, max_age, waiting_period, "
                + "vehicle_type, vehicle_value, coverage_type) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnector.makeConnection();
            conn.setAutoCommit(false);

            // 1️⃣ Insert sản phẩm chính
            PreparedStatement psProduct = conn.prepareStatement(insertProductSQL, Statement.RETURN_GENERATED_KEYS);
            psProduct.setString(1, product.getProductName());
            psProduct.setDouble(2, product.getBasePrice());
            psProduct.setInt(3, product.getCategoryId());
            psProduct.executeUpdate();

            // Lấy product_id tự sinh
            ResultSet rs = psProduct.getGeneratedKeys();
            int productId = 0;
            if (rs.next()) {
                productId = rs.getInt(1);
            }

            // 2️⃣ Insert chi tiết bảo hiểm
            PreparedStatement psDetail = conn.prepareStatement(insertDetailSQL);
            psDetail.setInt(1, productId);
            psDetail.setInt(2, details.getCategoryId());
            psDetail.setString(3, details.getProductType());
            psDetail.setDouble(4, details.getCoverageAmount());
            psDetail.setObject(5, details.getDurationYears(), java.sql.Types.INTEGER);
            psDetail.setString(6, details.getBeneficiaries());
            psDetail.setString(7, details.getMaturityBenefit());
            psDetail.setObject(8, details.getMaturityAmount(), java.sql.Types.DECIMAL);
            psDetail.setObject(9, details.getHospitalizationLimit(), java.sql.Types.DECIMAL);
            psDetail.setObject(10, details.getSurgeryLimit(), java.sql.Types.DECIMAL);
            psDetail.setObject(11, details.getMaternityLimit(), java.sql.Types.DECIMAL);
            psDetail.setObject(12, details.getMinAge(), java.sql.Types.INTEGER);
            psDetail.setObject(13, details.getMaxAge(), java.sql.Types.INTEGER);
            psDetail.setObject(14, details.getWaitingPeriod(), java.sql.Types.INTEGER);
            psDetail.setString(15, details.getVehicleType());
            psDetail.setObject(16, details.getVehicleValue(), java.sql.Types.DECIMAL);
            psDetail.setString(17, details.getCoverageType());
            psDetail.executeUpdate();

            conn.commit();
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }

    // ================== Cập nhật sản phẩm ==================
    public boolean updateProduct(Product product, InsuranceProductDetails details) throws SQLException {
        String updateProductSQL = "UPDATE Products SET product_name=?, base_price=?, category_id=? WHERE product_id=?";
        String updateDetailSQL = "UPDATE Insurance_Product_Details SET "
                + "category_id=?, product_type=?, coverage_amount=?, duration_years=?, "
                + "beneficiaries=?, maturity_benefit=?, maturity_amount=?, "
                + "hospitalization_limit=?, surgery_limit=?, maternity_limit=?, "
                + "min_age=?, max_age=?, waiting_period=?, vehicle_type=?, vehicle_value=?, coverage_type=? "
                + "WHERE product_id=?";

        Connection conn = null;
        try {
            conn = DBConnector.makeConnection();
            conn.setAutoCommit(false);

            PreparedStatement ps1 = conn.prepareStatement(updateProductSQL);
            ps1.setString(1, product.getProductName());
            ps1.setDouble(2, product.getBasePrice());
            ps1.setInt(3, product.getCategoryId());
            ps1.setInt(4, product.getProductId());
            ps1.executeUpdate();

            PreparedStatement ps2 = conn.prepareStatement(updateDetailSQL);
            ps2.setInt(1, details.getCategoryId());
            ps2.setString(2, details.getProductType());
            ps2.setDouble(3, details.getCoverageAmount());
            ps2.setObject(4, details.getDurationYears(), java.sql.Types.INTEGER);
            ps2.setString(5, details.getBeneficiaries());
            ps2.setString(6, details.getMaturityBenefit());
            ps2.setObject(7, details.getMaturityAmount(), java.sql.Types.DECIMAL);
            ps2.setObject(8, details.getHospitalizationLimit(), java.sql.Types.DECIMAL);
            ps2.setObject(9, details.getSurgeryLimit(), java.sql.Types.DECIMAL);
            ps2.setObject(10, details.getMaternityLimit(), java.sql.Types.DECIMAL);
            ps2.setObject(11, details.getMinAge(), java.sql.Types.INTEGER);
            ps2.setObject(12, details.getMaxAge(), java.sql.Types.INTEGER);
            ps2.setObject(13, details.getWaitingPeriod(), java.sql.Types.INTEGER);
            ps2.setString(14, details.getVehicleType());
            ps2.setObject(15, details.getVehicleValue(), java.sql.Types.DECIMAL);
            ps2.setString(16, details.getCoverageType());
            ps2.setInt(17, product.getProductId());
            ps2.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }

    // ================== Xóa sản phẩm ==================
    public boolean deleteProduct(int id) throws Exception {
        try (Connection conn = DBConnector.makeConnection()) {
            conn.setAutoCommit(false);

            // Xóa chi tiết trước
            try (PreparedStatement ps1 = conn.prepareStatement("DELETE FROM insurance_product_details WHERE product_id = ?")) {
                ps1.setInt(1, id);
                ps1.executeUpdate();
            }

            // Sau đó xóa sản phẩm
            try (PreparedStatement ps2 = conn.prepareStatement("DELETE FROM products WHERE product_id = ?")) {
                ps2.setInt(1, id);
                boolean deleted = ps2.executeUpdate() > 0;
                conn.commit();
                return deleted;
            }
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

    // ================== Lấy chi tiết bảo hiểm ==================
    public InsuranceProductDetails getInsuranceProductDetailsByProductId(int productId) throws SQLException {
        String sql = "SELECT * FROM insurance_product_details WHERE product_id = ?";
        InsuranceProductDetails d = null;

        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                d = new InsuranceProductDetails();
                d.setProductId(rs.getInt("product_id"));
                d.setCategoryId(rs.getInt("category_id"));
                d.setProductType(rs.getString("product_type"));
                d.setCoverageAmount(rs.getDouble("coverage_amount"));
                d.setDurationYears(rs.getInt("duration_years"));
                d.setBeneficiaries(rs.getString("beneficiaries"));
                d.setMaturityBenefit(rs.getString("maturity_benefit"));
                d.setMaturityAmount(rs.getDouble("maturity_amount"));
                d.setHospitalizationLimit(rs.getDouble("hospitalization_limit"));
                d.setSurgeryLimit(rs.getDouble("surgery_limit"));
                d.setMaternityLimit(rs.getDouble("maternity_limit"));
                d.setWaitingPeriod(rs.getInt("waiting_period"));
                d.setMaxAge(rs.getInt("max_age"));
                d.setMinAge(rs.getInt("min_age"));
                d.setVehicleType(rs.getString("vehicle_type"));
                d.setVehicleValue(rs.getDouble("vehicle_value"));
                d.setCoverageType(rs.getString("coverage_type"));
                d.setCreatedAt(rs.getTimestamp("created_at"));
                d.setUpdatedAt(rs.getTimestamp("updated_at"));
            }
        }
        return d;
    }

    public InsuranceProductDetails getInsuranceDetailsByProductId(int productId) {
        String sql = "SELECT * FROM insurance_product_details WHERE product_id = ?";
        try (Connection conn = DBConnector.makeConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    InsuranceProductDetails d = new InsuranceProductDetails();

                    d.setProductId(rs.getInt("product_id"));
                    d.setCategoryId(rs.getInt("category_id"));
                    d.setDurationYears(rs.getInt("duration_years"));
                    d.setCoverageAmount(rs.getDouble("coverage_amount"));
                    d.setBeneficiaries(rs.getString("beneficiaries"));
                    d.setMaturityBenefit(rs.getString("maturity_benefit"));
                    d.setMaturityAmount(rs.getDouble("maturity_amount"));
                    d.setHospitalizationLimit(rs.getDouble("hospitalization_limit"));
                    d.setSurgeryLimit(rs.getDouble("surgery_limit"));
                    d.setMaternityLimit(rs.getDouble("maternity_limit"));
                    d.setMinAge(rs.getInt("min_age"));
                    d.setMaxAge(rs.getInt("max_age"));
                    d.setWaitingPeriod(rs.getInt("waiting_period"));
                    d.setVehicleType(rs.getString("vehicle_type"));
                    d.setVehicleValue(rs.getDouble("vehicle_value"));
                    d.setCoverageType(rs.getString("coverage_type"));

                    return d;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ================== TEST MAIN ==================
    public static void main(String[] args) {
        try {
            ProductDao dao = new ProductDao();
            System.out.println("✅ Số lượng sản phẩm: " + dao.getAllProducts().size());
            Product p = dao.getProductById(1);
            if (p != null) {
                System.out.println("🧩 Tên sản phẩm: " + p.getProductName());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
