/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.ContractDao;
import dao.UserDao;
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
    private TaskDao taskDao;
    private static final int ROLE_MANAGER = 2;

    @Override
    public void init() {
        contractDao = new ContractDao();
        userDao = new UserDao();
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