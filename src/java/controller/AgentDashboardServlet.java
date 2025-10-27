/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;


import dao.*;
import entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
/**
 *
 * @author Nguyễn Tùng
 */
@WebServlet(name = "AgentDashboardServlet", urlPatterns = {"/agent/dashboard"})
public class AgentDashboardServlet extends HttpServlet {

    private static final int ROLE_AGENT = 1;
    private UserDao userDao;
    private ContractDao contractDao;
    private CustomerDao customerDao;
    private CommissionDao commissionDao;
    private TaskDao taskDao;

    @Override
    public void init() {
        // 2. Khởi tạo tất cả các DAO cần thiết
        userDao = new UserDao();
        contractDao = new ContractDao();
        customerDao = new CustomerDao();
        commissionDao = new CommissionDao();
        taskDao = new TaskDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 3. Kiểm tra quyền truy cập
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null || currentUser.getRoleId() != ROLE_AGENT) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int agentId = currentUser.getUserId();

            // 4. Lấy tất cả dữ liệu từ các DAO
            
            // --- KPIs ---
            BigDecimal pendingCommission = commissionDao.getPendingCommissionTotal(agentId);
            int leadCount = customerDao.countLeadsByAgent(agentId);
            int clientCount = customerDao.countClientsByAgent(agentId);
            
            // --- Renewal Alerts ---
            List<ContractDTO> expiringContracts = contractDao.getExpiringContracts(agentId);
            
            // --- Follow-ups & To-do List ---
            List<Task> followUps = taskDao.getTodaysFollowUps(agentId);
            List<Task> personalTasks = taskDao.getPersonalTasks(agentId); // Cho widget "To-do List" mới
            
            // --- Chart Data (Sales Performance) ---
            Map<String, Double> salesData = contractDao.getMonthlySalesData(agentId);
            // Chuyển đổi Map sang 2 List để Chart.js có thể đọc
            List<String> salesChartLabels = new ArrayList<>(salesData.keySet());
            List<Double> salesChartValues = new ArrayList<>(salesData.values());
            
            // --- Leaderboard Widget (Lấy Top 5) ---
            List<AgentPerformanceDTO> topAgents = userDao.getAgentLeaderboard();
            if (topAgents.size() > 5) {
                topAgents = topAgents.subList(0, 5);
            }

            // 5. Đặt tất cả dữ liệu vào request
            request.setAttribute("pendingCommission", pendingCommission);
            request.setAttribute("leadCount", leadCount);
            request.setAttribute("clientCount", clientCount);
            request.setAttribute("expiringContracts", expiringContracts);
            request.setAttribute("followUps", followUps);
            request.setAttribute("personalTasks", personalTasks);
            request.setAttribute("salesChartLabels", salesChartLabels); // Gửi labels cho biểu đồ
            request.setAttribute("salesChartValues", salesChartValues); // Gửi data cho biểu đồ
            request.setAttribute("topAgents", topAgents);

            // 6. Chuyển tiếp đến trang JSP
            request.getRequestDispatcher("/AgentDashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading dashboard data", e);
        }
    }
}