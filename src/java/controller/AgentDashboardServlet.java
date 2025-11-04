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
    private InteractionDao interactionDao;

    @Override
    public void init() {
        userDao = new UserDao();
        contractDao = new ContractDao();
        customerDao = new CustomerDao();
        commissionDao = new CommissionDao();
        taskDao = new TaskDao();
        interactionDao = new InteractionDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null || currentUser.getRoleId() != ROLE_AGENT) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // SỬA: Set activePage trong Servlet (an toàn hơn)
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("activePage", "dashboard");

        try {
            int agentId = currentUser.getUserId();

            // 4. Lấy tất cả dữ liệu từ các DAO
            
            // --- KPIs ---
            BigDecimal pendingCommission = commissionDao.getPendingCommissionTotal(agentId);
            
            // === SỬA LỖI (FIX LỖI CỦA BẠN) ===
            // GỌI HÀM MỚI (chỉ 1 lần)
            Map<String, Integer> stageCounts = customerDao.countCustomersByStage(agentId);

            // TÍNH TOÁN CHO 4 KPI CARDS (Dựa trên 4 Giai đoạn)
            // (Lấy giá trị, mặc định là 0 nếu không có)
            int leads = stageCounts.getOrDefault("Lead", 0);
            int potentials = stageCounts.getOrDefault("Potential", 0);
            int clients = stageCounts.getOrDefault("Client", 0);
            int loyals = stageCounts.getOrDefault("Loyal", 0);

            // Gán biến cho JSP (cho 4 KPI Cards)
            int leadCount = leads + potentials; // Card "Active Leads" = Lead + Potential
            int clientCount = clients + loyals; // Card "Active Clients" = Client + Loyal
            // (Biến conversionRate sẽ tự động tính đúng trong JSP)
            // ===================================
            
            // --- Renewal Alerts ---
            List<ContractDTO> expiringContracts = contractDao.getExpiringContracts(agentId);

            // --- Follow-ups & To-do List ---
            List<Interaction> followUps = interactionDao.getTodaysFollowUps(agentId);
            List<Task> personalTasks = taskDao.getPersonalTasks(agentId);

            // --- Chart Data (Sales Performance) ---
            Map<String, Double> salesData = contractDao.getMonthlySalesData(agentId);
            List<String> salesChartLabels = new ArrayList<>(salesData.keySet());
            List<Double> salesChartValues = new ArrayList<>(salesData.values());
            
            // --- Leaderboard Widget (Lấy Top 5) ---
            List<AgentPerformanceDTO> topAgents = userDao.getAgentLeaderboard();
            if (topAgents.size() > 5) {
                topAgents = topAgents.subList(0, 5);
            }

            // 5. Đặt tất cả dữ liệu vào request
            request.setAttribute("pendingCommission", pendingCommission);
            request.setAttribute("leadCount", leadCount);     // (Đã tính lại)
            request.setAttribute("clientCount", clientCount);   // (Đã tính lại)
            
            // THÊM MỚI: Gửi 4 con số "thô" cho Donut Chart
            request.setAttribute("leads", leads);
            request.setAttribute("potentials", potentials);
            request.setAttribute("clients", clients); // "clients" này là stage "Client"
            request.setAttribute("loyals", loyals);
            
            request.setAttribute("expiringContracts", expiringContracts);
            request.setAttribute("followUps", followUps);
            request.setAttribute("personalTasks", personalTasks);
            request.setAttribute("salesChartLabels", salesChartLabels);
            request.setAttribute("salesChartValues", salesChartValues);
            request.setAttribute("topAgents", topAgents);

            // 6. Chuyển tiếp đến trang JSP
            request.getRequestDispatcher("/AgentDashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading dashboard data", e);
        }
    }
}