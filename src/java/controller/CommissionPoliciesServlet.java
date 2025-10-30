/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CommissionPolicyDao;
import dao.ProductDao;
import entity.CommissionPolicy;
import entity.Product;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Helios 16
 */
@WebServlet(name = "CommissionPoliciesServlet", urlPatterns = {"/CommissionPoliciesServlet"})
public class CommissionPoliciesServlet extends HttpServlet {

    private static final int ROLE_AGENT = 1; // Giả định Agent role là 1
    private static final int ROLE_MANAGER = 2;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CommissionPoliciesServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CommissionPoliciesServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            listCommissionPolicies(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void listCommissionPolicies(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        try {
            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
            if (currentUser == null) { // Chỉ cần kiểm tra currentUser
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            ProductDao productDao = new ProductDao();
            CommissionPolicyDao policyDao = new CommissionPolicyDao();

            List<Product> productList = productDao.getAllProducts();
            Map<Integer, List<CommissionPolicy>> productPolicies = new HashMap<>();

            for (Product product : productList) {
                List<CommissionPolicy> policies = policyDao.getPoliciesByProductId(product.getProductId());
                productPolicies.put(product.getProductId(), policies);
            }

            request.setAttribute("productList", productList);
            request.setAttribute("productPolicies", productPolicies);
            request.setAttribute("currentUser", currentUser);
            if (currentUser.getRoleId() == ROLE_AGENT) {
                request.setAttribute("activePage", "leaderboard");
            } else if (currentUser.getRoleId() == ROLE_MANAGER) {
                request.setAttribute("activePage", "agentLeaderboard");
            }
            request.getRequestDispatcher("/commissionPolicies.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải dữ liệu chính sách hoa hồng.");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
