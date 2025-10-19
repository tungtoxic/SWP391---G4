/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

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
/**
 *
 * @author Nguyễn Tùng
 */
@WebServlet(name = "CommissionReportServlet", urlPatterns = {"/agent/commission-report"})
public class CommissionReportServlet extends HttpServlet {
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

        if (currentUser == null || currentUser.getRoleId() != AGENT_ROLE_ID) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int agentId = currentUser.getUserId();
            
            // Lấy tham số bộ lọc từ request
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            // Gọi DAO để lấy dữ liệu báo cáo
            List<CommissionReportDTO> reportList = commissionDao.getCommissionReportByAgentId(agentId, startDate, endDate);
            
            // Tính tổng hoa hồng
            double totalCommission = reportList.stream()
                                               .mapToDouble(CommissionReportDTO::getCommissionAmount)
                                               .sum();

            // Đặt thuộc tính vào request
            request.setAttribute("reportList", reportList);
            request.setAttribute("totalCommission", totalCommission);
            // Gửi lại giá trị bộ lọc để hiển thị trên form
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);

            // Chuyển tiếp đến trang JSP
            request.getRequestDispatcher("/commission_report.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}
