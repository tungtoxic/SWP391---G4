package controller;

import dao.*;
import dao.ProductCategoryDao;
import entity.Product;
import entity.ProductCategory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductManagementServlet", urlPatterns = {"/ProductServlet"})
public class ProductManagementServlet extends HttpServlet {

    private ProductDao productDao;
    private ProductCategoryDao categoryDao;

    @Override
    public void init() {
        productDao = new ProductDao();
        categoryDao = new ProductCategoryDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // ======================= GET Actions =======================
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Product> productList = productDao.getAllProducts();
        List<ProductCategory> categoryList = categoryDao.getAllCategories();
        request.setAttribute("productList", productList);
        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("/productmanagement.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<ProductCategory> categories = categoryDao.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/addProduct.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productDao.getProductById(id);
        List<ProductCategory> categories = categoryDao.getAllCategories();

        // Đảm bảo có dữ liệu
        if (product == null) {
            request.setAttribute("error", "Không tìm thấy sản phẩm có ID: " + id);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("product", product);
        request.setAttribute("categories", categories); // 👈 thêm dòng này

        request.getRequestDispatcher("/editProduct.jsp").forward(request, response);
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        productDao.deleteProduct(id);
        response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
    }

    // ======================= POST Actions =======================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    insertProduct(request, response);
                    break;
                case "edit":
                    updateProduct(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // ======================= POST Handlers =======================
    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String name = request.getParameter("product_name").trim();
        String description = request.getParameter("description").trim();
        double price = Double.parseDouble(request.getParameter("base_price"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));

        Product p = new Product();
        p.setProductName(name);
        p.setDescription(description);
        p.setBasePrice(price);
        p.setCategoryId(categoryId);

        boolean success = productDao.insertProduct(p);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
        } else {
            request.setAttribute("error", "Không thể thêm sản phẩm.");
            request.getRequestDispatcher("/addProduct.jsp").forward(request, response);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int id = Integer.parseInt(request.getParameter("product_id"));
        String name = request.getParameter("product_name").trim();
        String description = request.getParameter("description").trim();
        double price = Double.parseDouble(request.getParameter("base_price"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));

        Product p = new Product();
        p.setProductId(id);
        p.setProductName(name);
        p.setDescription(description);
        p.setBasePrice(price);
        p.setCategoryId(categoryId);

        boolean success = productDao.updateProduct(p);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/ProductServlet?action=list");
        } else {
            request.setAttribute("error", "Không thể cập nhật sản phẩm.");
            request.getRequestDispatcher("/editProduct.jsp").forward(request, response);
        }
    }
}
