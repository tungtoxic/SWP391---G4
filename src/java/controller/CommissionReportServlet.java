package controller;

import dao.CommissionDao;
import entity.CommissionReportDTO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CommissionReportServlet", urlPatterns = {"/agent/commission-report"})
public class CommissionReportServlet extends HttpServlet {

    // Giả sử role_id của Agent là 1
    private static final int AGENT_ROLE_ID = 1; 
    private CommissionDao commissionDao;

    @Override
    public void init() {
        this.commissionDao = new CommissionDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (currentUser.getRoleId() != AGENT_ROLE_ID) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to access this page.");
            return;
        }
        try {
            int agentId = currentUser.getUserId();
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            List<CommissionReportDTO> reportList = commissionDao.getCommissionReportByAgentId(agentId, startDate, endDate);
        // Tính tổng hoa hồng
            double totalCommission = reportList.stream()
                                               .mapToDouble(CommissionReportDTO::getCommissionAmount)
                                               .sum();
            
            // Đặt thuộc tính vào request
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("activePage", "commission");
            request.setAttribute("reportList", reportList);
            request.setAttribute("totalCommission", totalCommission);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.getRequestDispatcher("/commission_report.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace(); // In chi tiết lỗi ra console
            // Chuyển đến trang lỗi chung
            request.setAttribute("errorMessage", "Đã có lỗi hệ thống xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}