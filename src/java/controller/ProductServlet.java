/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.ProductDao;
import entity.Product;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
/**
 *
 * @author Nguyễn Tùng
 */
@WebServlet(name = "ProductServlet", urlPatterns = {"/products"})
public class ProductServlet extends HttpServlet {

    private ProductDao productDao;
    private static final int ROLE_AGENT = 1;
    private static final int ROLE_MANAGER = 2;

    @Override
    public void init() {
        productDao = new ProductDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // Kiểm tra bảo mật: Phải là Agent hoặc Manager
        if (currentUser == null || (currentUser.getRoleId() != ROLE_AGENT && currentUser.getRoleId() != ROLE_MANAGER)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // 1. Lấy dữ liệu
            List<Product> productList = productDao.getAllProducts();

            // 2. Gửi dữ liệu qua View
            request.setAttribute("productList", productList);
            request.setAttribute("currentUser", currentUser);
            
            // 3. Đặt activePage cho sidebar (dựa trên vai trò)
            if(currentUser.getRoleId() == ROLE_AGENT) {
                request.setAttribute("activePage", "products");
            } else if (currentUser.getRoleId() == ROLE_MANAGER) {
                request.setAttribute("activePage", "products");
            }

            // 4. Forward
            request.getRequestDispatcher("/product_list.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    
}