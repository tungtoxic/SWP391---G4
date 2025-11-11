/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.CommissionPolicyDao;
import entity.CommissionPolicy;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date; // Dùng java.sql.Date để dễ dàng parse từ "yyyy-MM-dd"
import java.util.List;

/**
 *
 * @author Nguyễn Tùng
 */

/**
 * Servlet MỚI: Quản lý CRUD cho Commission Policies (nghiệp vụ của Manager).
 */
@WebServlet(name = "CommissionPolicyServlet", urlPatterns = {"/manager/policiesss"})
public class CommissionPolicyServlet extends HttpServlet {

    private CommissionPolicyDao policyDao;
    private static final int ROLE_MANAGER = 2; // Giả định vai trò Manager

    @Override
    public void init() {
        policyDao = new CommissionPolicyDao();
    }

    // =========================================================================
    // GET: XỬ LÝ VIỆC HIỂN THỊ CÁC TRANG (List, Add Form, Edit Form)
    // =========================================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Bảo mật: Kiểm tra quyền truy cập
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null || currentUser.getRoleId() != ROLE_MANAGER) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Set các thuộc tính chung cho layout
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("activePage", "policies"); // Sẽ dùng để tô sáng sidebar

        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Mặc định là hiển thị danh sách
        }

        try {
            switch (action) {
                case "showAddForm":
                    showAddForm(request, response);
                    break;
                case "showEditForm":
                    showEditForm(request, response);
                    break;
                default: // "list"
                    listPolicies(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // =========================================================================
    // POST: XỬ LÝ VIỆC THÊM MỚI (add) HOẶC CẬP NHẬT (update)
    // =========================================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8"); // Đảm bảo tiếng Việt

        // Bảo mật: Kiểm tra quyền truy cập
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null || currentUser.getRoleId() != ROLE_MANAGER) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    insertPolicy(request, response);
                    break;
                case "update":
                    updatePolicy(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/manager/policies");
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // =========================================================================
    // CÁC HÀM XỬ LÝ (HELPER METHODS)
    // =========================================================================
    
    private void listPolicies(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CommissionPolicy> policyList = policyDao.getAllPolicies();
        request.setAttribute("policyList", policyList);
        request.getRequestDispatcher("/policy-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chỉ cần forward đến form, không cần dữ liệu
        request.getRequestDispatcher("/policy-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            CommissionPolicy policy = policyDao.getPolicyById(id);
            
            if (policy != null) {
                request.setAttribute("policy", policy); // Gửi đối tượng policy sang form
                request.getRequestDispatcher("/policy-form.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/manager/policies?message=notFound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/policies?message=error");
        }
    }

    private void insertPolicy(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            // Lấy dữ liệu từ form
            String policyName = request.getParameter("policyName");
            BigDecimal rate = new BigDecimal(request.getParameter("rate"));
            
            // Input type="date" trả về "yyyy-MM-dd", Date.valueOf() sẽ parse
            Date effectiveFrom = Date.valueOf(request.getParameter("effectiveFrom"));

            // Tạo đối tượng Entity
            CommissionPolicy policy = new CommissionPolicy();
            policy.setPolicyName(policyName);
            policy.setRate(rate);
            policy.setEffectiveFrom(effectiveFrom); // Entity của bạn dùng java.util.Date, và java.sql.Date là con của nó.

            // Gọi DAO
            policyDao.insertPolicy(policy);
            
            response.sendRedirect(request.getContextPath() + "/manager/policies?message=addSuccess");

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Lỗi định dạng Tỷ lệ. Vui lòng nhập số.");
            request.getRequestDispatcher("/policy-form.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Lỗi định dạng Ngày hiệu lực. Vui lòng chọn ngày.");
            request.getRequestDispatcher("/policy-form.jsp").forward(request, response);
        }
    }

    private void updatePolicy(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            // Lấy dữ liệu từ form (bao gồm cả ID)
            int policyId = Integer.parseInt(request.getParameter("policyId"));
            String policyName = request.getParameter("policyName");
            BigDecimal rate = new BigDecimal(request.getParameter("rate"));
            Date effectiveFrom = Date.valueOf(request.getParameter("effectiveFrom"));

            // Tạo đối tượng Entity
            CommissionPolicy policy = new CommissionPolicy();
            policy.setPolicyId(policyId);
            policy.setPolicyName(policyName);
            policy.setRate(rate);
            policy.setEffectiveFrom(effectiveFrom);

            // Gọi DAO
            policyDao.updatePolicy(policy);
            
            response.sendRedirect(request.getContextPath() + "/manager/policies?message=updateSuccess");

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Lỗi định dạng Tỷ lệ hoặc ID.");
            request.getRequestDispatcher("/policy-form.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Lỗi định dạng Ngày hiệu lực.");
            request.getRequestDispatcher("/policy-form.jsp").forward(request, response);
        }
    }
}