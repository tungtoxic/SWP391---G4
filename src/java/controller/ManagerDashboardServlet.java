/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.ContractDao;
import dao.UserDao;
import entity.AgentPerformanceDTO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 *
 * @author Nguyễn Tùng
 */
@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/manager/dashboard"})
public class ManagerDashboardServlet extends HttpServlet {

    private ContractDao contractDao;
    private UserDao userDao;
    private static final int ROLE_MANAGER = 2;

    @Override
    public void init() {
        contractDao = new ContractDao();
        userDao = new UserDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null || currentUser.getRoleId() != ROLE_MANAGER) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int managerId = currentUser.getUserId();

            // 1. Lấy dữ liệu cho các KPI Cards (Dùng hàm DAO mới)
            BigDecimal teamPremiumThisMonth = contractDao.getTeamPremiumThisMonth(managerId);
            int expiringContractsCount = contractDao.countExpiringContractsByManagerId(managerId);
            int pendingContractsCount = contractDao.countPendingContractsByManagerId(managerId); // Thêm KPI này
            // Tận dụng hàm đã có trong UserDao (hoặc có thể tạo hàm count riêng nếu muốn)
            List<AgentPerformanceDTO> teamPerformance = userDao.getTeamPerformance(managerId);
            
            // Tính toán KPI Conversion Rate (Ví dụ, cần thêm hàm DAO)
            // Tạm thời để fix cứng hoặc tính toán đơn giản nếu có
            // int totalLeads = ...; // Cần hàm DAO đếm leads của team
            // int newContracts = ...; // Cần hàm DAO đếm HĐ mới của team
            // double conversionRate = (totalLeads > 0) ? ((double) newContracts / totalLeads) * 100 : 0.0;
            
            // 2. Lấy dữ liệu cho Bảng Agent Performance Matrix
            // (Đã lấy ở trên: teamPerformance)

            // 3. Lấy dữ liệu cho Widget Team Leaderboard (Lấy top 5)
            List<AgentPerformanceDTO> managerLeaderboard = userDao.getManagerLeaderboard();
            if (managerLeaderboard.size() > 5) {
                managerLeaderboard = managerLeaderboard.subList(0, 5); // Chỉ lấy 5 người đầu
            }

            // 4. (Tương lai) Lấy dữ liệu cho Biểu đồ Product Distribution
            // Map<String, Double> productDistribution = ... // Cần hàm DAO
            
            
            // 5. Gửi dữ liệu sang JSP
            request.setAttribute("currentUser", currentUser); // Gửi currentUser
            request.setAttribute("activePage", "dashboard"); // Đặt activePage

            // Gửi dữ liệu KPI Cards
            request.setAttribute("teamPremiumThisMonth", teamPremiumThisMonth);
            request.setAttribute("expiringContractsCount", expiringContractsCount);
            request.setAttribute("pendingContractsCount", pendingContractsCount); // Gửi số HĐ chờ duyệt
            // request.setAttribute("teamConversionRate", conversionRate); // Gửi khi đã có
            // request.setAttribute("teamNewContracts", newContracts); // Gửi khi đã có
            // request.setAttribute("teamTotalLeads", totalLeads); // Gửi khi đã có

            // Gửi dữ liệu Bảng và Widget
            request.setAttribute("teamPerformanceList", teamPerformance); // Dùng cho bảng Matrix
            request.setAttribute("leaderboardWidgetList", managerLeaderboard); // Dùng cho widget Leaderboard

            // Gửi dữ liệu Biểu đồ
            // request.setAttribute("productLabels", ...); // Gửi khi đã có
            // request.setAttribute("productData", ...); // Gửi khi đã có

            // Forward
            request.getRequestDispatcher("/ManagerDashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi tải Manager Dashboard", e);
        }
    }
}