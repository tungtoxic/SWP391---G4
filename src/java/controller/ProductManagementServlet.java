package controller;

import dao.*;
import entity.InsuranceProductDetails;
import entity.Product;
import entity.ProductCategory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProductManagementServlet", urlPatterns = {"/ProductServlet"})
public class ProductManagementServlet extends HttpServlet {

    private ProductDao productDao;

    @Override
    public void init() {
        productDao = new ProductDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "addCategory":
                    addCategory(request, response);
                    break;
                case "addProduct":
                    addProduct(request, response);
                    break;
                case "addChosenCategory":
                    addChosenCategory(request, response);
                    break;
                case "edit":
                    editProduct(request, response);
                    break;
                case "update":
                    updateProduct(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Product> productList = productDao.getAllProducts();
        List<ProductCategory> categoryList = productDao.getAllCategories();

        Map<Integer, InsuranceProductDetails> detailMap = new HashMap<>();
        for (Product p : productList) {
            InsuranceProductDetails detail = productDao.getInsuranceProductDetailsByProductId(p.getProductId());
            if (detail != null) {
                detailMap.put(p.getProductId(), detail);
            }
        }

        request.setAttribute("productList", productList);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("detailMap", detailMap);
        request.getRequestDispatcher("/productmanagement.jsp").forward(request, response);
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<ProductCategory> categories = productDao.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/addCategoryProduct.jsp").forward(request, response);
    }

    private void addChosenCategory(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String categoryType = request.getParameter("category");
        request.setAttribute("selectedCategory", categoryType);
        request.getRequestDispatcher("/addProduct.jsp").forward(request, response);
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String name = request.getParameter("product_name");
        double price = Double.parseDouble(request.getParameter("base_price"));
        String categoryType = request.getParameter("category");
        int durationYears = Integer.parseInt(request.getParameter("duration_years"));
        int categoryId = 0;

        InsuranceProductDetails d = new InsuranceProductDetails();
        d.setProductType(categoryType);
        d.setDurationYears(durationYears);

        String beneficiaries = null, maturityBenefit = null, vehicleType = null, coverageType = null;
        Double vehicleValue = null;
        Double coverageAmount = null;
        Double maturityAmount = null, hospitalizationLimit = null, surgeryLimit = null, maternityLimit = null;
        Integer waitingPeriod = null, minAge = null, maxAge = null;

        coverageAmount = Double.parseDouble(request.getParameter("coverage_amount"));

        switch (categoryType.toLowerCase()) {
            case "life":
                categoryId = 1;
                beneficiaries = request.getParameter("beneficiaries");
                maturityBenefit = request.getParameter("maturity_benefit");
                maturityAmount = Double.parseDouble(request.getParameter("maturity_amount"));
                break;
            case "health":
                categoryId = 2;
                hospitalizationLimit = Double.parseDouble(request.getParameter("hospital_limit"));
                surgeryLimit = Double.parseDouble(request.getParameter("surgery_limit"));
                maternityLimit = Double.parseDouble(request.getParameter("maternity_limit"));
                waitingPeriod = Integer.parseInt(request.getParameter("waiting_period"));
                minAge = Integer.parseInt(request.getParameter("min_age"));
                maxAge = Integer.parseInt(request.getParameter("max_age"));
                break;
            case "car":
                categoryId = 3;
                vehicleType = request.getParameter("vehicle_type");
                vehicleValue = Double.parseDouble(request.getParameter("vehicle_value"));
                coverageType = request.getParameter("coverage_type");
                break;
        }

        Product p = new Product();
        p.setProductName(name);
        p.setBasePrice(price);
        p.setCategoryId(categoryId);

        d.setCategoryId(categoryId);
        d.setCoverageAmount(coverageAmount);
        if ("life".equalsIgnoreCase(categoryType)) {
            d.setBeneficiaries(beneficiaries);
            d.setMaturityBenefit(maturityBenefit);
            d.setMaturityAmount(maturityAmount);
        } else if ("health".equalsIgnoreCase(categoryType)) {
            d.setHospitalizationLimit(hospitalizationLimit);
            d.setSurgeryLimit(surgeryLimit);
            d.setMaternityLimit(maternityLimit);
            d.setMinAge(minAge);
            d.setMaxAge(maxAge);
            d.setWaitingPeriod(waitingPeriod);
        } else if ("car".equalsIgnoreCase(categoryType)) {
            d.setVehicleType(vehicleType);
            d.setVehicleValue(vehicleValue);
            d.setCoverageType(coverageType);
        }

        boolean success = productDao.insertProduct(p, d);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
        } else {
            request.setAttribute("error", "❌ Không thể thêm sản phẩm.");
            request.getRequestDispatcher("/addProduct.jsp").forward(request, response);
        }
    }


    private void editProduct(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productDao.getProductById(id);
        InsuranceProductDetails details = productDao.getInsuranceDetailsByProductId(id);
        List<ProductCategory> categories = productDao.getAllCategories();

        if (product == null) {
            request.setAttribute("error", "Không tìm thấy sản phẩm có ID: " + id);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("product", product);
        request.setAttribute("details", details);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/editproduct.jsp").forward(request, response);
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
    try {
        int productId = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("product_name");
        double price = Double.parseDouble(request.getParameter("base_price"));
        String categoryType = request.getParameter("category");
        int durationYears = Integer.parseInt(request.getParameter("duration_years"));
        int categoryId = 0;

        InsuranceProductDetails d = new InsuranceProductDetails();
        d.setProductType(categoryType);
        d.setDurationYears(durationYears);

        String beneficiaries = null, maturityBenefit = null, vehicleType = null, coverageType = null;
        Double vehicleValue = null;
        Double coverageAmount = null;
        Double maturityAmount = null, hospitalizationLimit = null, surgeryLimit = null, maternityLimit = null;
        Integer waitingPeriod = null, minAge = null, maxAge = null;

        coverageAmount = Double.parseDouble(request.getParameter("coverage_amount"));

        switch (categoryType.toLowerCase()) {
            case "life":
                categoryId = 1;
                beneficiaries = request.getParameter("beneficiaries");
                maturityBenefit = request.getParameter("maturity_benefit");
                maturityAmount = Double.parseDouble(request.getParameter("maturity_amount"));
                break;
            case "health":
                categoryId = 2;
                hospitalizationLimit = Double.parseDouble(request.getParameter("hospital_limit"));
                surgeryLimit = Double.parseDouble(request.getParameter("surgery_limit"));
                maternityLimit = Double.parseDouble(request.getParameter("maternity_limit"));
                waitingPeriod = Integer.parseInt(request.getParameter("waiting_period"));
                minAge = Integer.parseInt(request.getParameter("min_age"));
                maxAge = Integer.parseInt(request.getParameter("max_age"));
                break;
            case "car":
                categoryId = 3;
                vehicleType = request.getParameter("vehicle_type");
                vehicleValue = Double.parseDouble(request.getParameter("vehicle_value"));
                coverageType = request.getParameter("coverage_type");
                break;
        }


        Product p = new Product();
        p.setProductId(productId);
        p.setProductName(name);
        p.setBasePrice(price);
        p.setCategoryId(categoryId);
        d.setProductId(productId);
        d.setCategoryId(categoryId);
        d.setCoverageAmount(coverageAmount);

        if ("life".equalsIgnoreCase(categoryType)) {
            d.setBeneficiaries(beneficiaries);
            d.setMaturityBenefit(maturityBenefit);
            d.setMaturityAmount(maturityAmount);
        } else if ("health".equalsIgnoreCase(categoryType)) {
            d.setHospitalizationLimit(hospitalizationLimit);
            d.setSurgeryLimit(surgeryLimit);
            d.setMaternityLimit(maternityLimit);
            d.setMinAge(minAge);
            d.setMaxAge(maxAge);
            d.setWaitingPeriod(waitingPeriod);
        } else if ("car".equalsIgnoreCase(categoryType)) {
            d.setVehicleType(vehicleType);
            d.setVehicleValue(vehicleValue);
            d.setCoverageType(coverageType);
        }

        boolean success = productDao.updateProduct(p, d);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
        } else {
            request.setAttribute("error", "❌ Không thể cập nhật sản phẩm.");
            request.getRequestDispatcher("/editproduct.jsp").forward(request, response);
        }

    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("error", "❌ Lỗi khi cập nhật sản phẩm: " + e.getMessage());
        request.getRequestDispatcher("/editproduct.jsp").forward(request, response);
    }
}


    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        productDao.deleteProduct(id);
        response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
    }
}
