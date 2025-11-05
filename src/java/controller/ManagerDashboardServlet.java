/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.ContractDao;
import dao.UserDao;
import dao.CustomerDao;   
import dao.TaskDao;
import entity.Task;
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
import java.util.Map;

/**
 *
 * @author Nguyễn Tùng
 */
@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/manager/dashboard"})
public class ManagerDashboardServlet extends HttpServlet {

    private ContractDao contractDao;
    private UserDao userDao;
    private CustomerDao customerDao; 
    private TaskDao taskDao;
    private static final int ROLE_MANAGER = 2;

    @Override
    public void init() {
        contractDao = new ContractDao();
        userDao = new UserDao();
        customerDao = new CustomerDao(); 
        taskDao = new TaskDao();
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
            int pendingContractsCount = contractDao.countPendingContractsByManagerId(managerId); 
            
            // ==========================================================
            // "VÁ" MỤC TIÊU 3: KPI CARD 4 (Conversion Rate)
            // ==========================================================
            Map<String, Integer> stageCounts = customerDao.countTeamCustomersByStage(managerId);
            int leads = stageCounts.getOrDefault("Lead", 0);
            int potentials = stageCounts.getOrDefault("Potential", 0);
            int clients = stageCounts.getOrDefault("Client", 0);
            int loyals = stageCounts.getOrDefault("Loyal", 0);
            
            int teamTotalLeads = leads + potentials; // (Lead + Potential)
            int teamTotalClients = clients + loyals; // (Client + Loyal)
            double teamConversionRate = 0.0;
            if (teamTotalLeads + teamTotalClients > 0) {
                teamConversionRate = ((double) teamTotalClients / (teamTotalLeads + teamTotalClients)) * 100;
            }
            // ==========================================================

            // 2. Lấy dữ liệu cho Bảng Agent Performance Matrix
            List<AgentPerformanceDTO> teamPerformance = userDao.getTeamPerformance(managerId);
            
            // 3. Lấy dữ liệu cho Widget Team Leaderboard (Lấy top 5)
            List<AgentPerformanceDTO> managerLeaderboard = userDao.getManagerLeaderboard();
            if (managerLeaderboard.size() > 5) {
                managerLeaderboard = managerLeaderboard.subList(0, 5); 
            }
            
            // ==========================================================
            // "VÁ" MỤC TIÊU 1: WIDGET (Personal To-Do List)
            // ==========================================================
            List<Task> personalTasks = taskDao.getPersonalTasks(managerId);
            // ==========================================================
            
            // 5. Gửi dữ liệu sang JSP
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("activePage", "dashboard"); 

            // Gửi dữ liệu KPI Cards
            request.setAttribute("teamPremiumThisMonth", teamPremiumThisMonth);
            request.setAttribute("expiringContractsCount", expiringContractsCount);
            request.setAttribute("pendingContractsCount", pendingContractsCount);
            request.setAttribute("teamConversionRate", teamConversionRate); // <-- "Sạch"
            request.setAttribute("teamTotalClients", teamTotalClients); // <-- "Sạch"
            request.setAttribute("teamTotalLeads", teamTotalLeads); // <-- "Sạch"

            // Gửi dữ liệu Bảng và Widget
            request.setAttribute("teamPerformanceList", teamPerformance); 
            request.setAttribute("leaderboardWidgetList", managerLeaderboard); 
            request.setAttribute("personalTasks", personalTasks); // <-- "Sạch"

            // (Mục tiêu 2: Biểu đồ sẽ để sau)
            
            // Forward
            request.getRequestDispatcher("/ManagerDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi tải Manager Dashboard", e);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null || currentUser.getRoleId() != ROLE_MANAGER) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String source = request.getParameter("source"); // "manager"
        
        try {
            switch (action) {
                case "addPersonalTask":
                    String taskTitle = request.getParameter("taskTitle");
                    Task newTask = new Task();
                    newTask.setUserId(currentUser.getUserId());
                    newTask.setTitle(taskTitle);
                    newTask.setCompleted(false);
                    // (customerId và dueDate là NULL)
                    taskDao.insertTask(newTask);
                    break;
                    
                case "completeTask":
                    int taskIdToComplete = Integer.parseInt(request.getParameter("taskId"));
                    boolean isCompleted = "on".equals(request.getParameter("isCompleted"));
                    taskDao.updateTaskStatus(taskIdToComplete, currentUser.getUserId(), isCompleted);
                    break;
                    
                case "deleteTask":
                    int taskIdToDelete = Integer.parseInt(request.getParameter("taskId"));
                    taskDao.deleteTask(taskIdToDelete, currentUser.getUserId());
                    break;
            }
            
            // "Vá" (Patch) thành công: Chuyển hướng "an toàn" (safely)
            response.sendRedirect(request.getContextPath() + "/manager/dashboard");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi xử lý POST request ở ManagerDashboard", e);
        }
    }
}