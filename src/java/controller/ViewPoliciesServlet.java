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
import java.util.List;

/**
 * VÁ LỖI "Ô ĐỎ": Servlet "chỉ đọc" cho Agent/Manager xem Chính sách.
 */
// Map tới cả 2 vai trò
@WebServlet(name = "ViewPoliciesServlet", urlPatterns = {"/agent/policies", "/manager/policies"})
public class ViewPoliciesServlet extends HttpServlet {

    private CommissionPolicyDao policyDao;
    private static final int ROLE_AGENT = 1;
    private static final int ROLE_MANAGER = 2;

    @Override
    public void init() {
        policyDao = new CommissionPolicyDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // Bảo mật: Phải là Agent hoặc Manager
        if (currentUser == null || (currentUser.getRoleId() != ROLE_AGENT && currentUser.getRoleId() != ROLE_MANAGER)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<CommissionPolicy> policyList = policyDao.getAllPolicies();
            
            request.setAttribute("policyList", policyList);
            request.setAttribute("currentUser", currentUser);
            
            // Đặt "activePage" cho sidebar
            request.setAttribute("activePage", "policies"); 

            request.getRequestDispatcher("/view_policies.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}