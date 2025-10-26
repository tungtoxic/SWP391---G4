/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.TaskDao;
import entity.Task;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
/**
 *
 * @author Nguyễn Tùng
 */


// Servlet này sẽ xử lý tất cả các hành động liên quan đến Tasks
@WebServlet(name = "TaskServlet", urlPatterns = {"/tasks"})
public class TaskServlet extends HttpServlet {

    private TaskDao taskDao;
    private static final int ROLE_AGENT = 1;
    private static final int ROLE_MANAGER = 2;
    private static final int ROLE_ADMIN = 3;

    @Override
    public void init() {
        taskDao = new TaskDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(getDashboardUrl(currentUser, request));
            return;
        }

        try {
            int userId = currentUser.getUserId();
            
            // === SỬA LỖI 1: ĐỔI TÊN CÁC CASE ĐỂ KHỚP VỚI JSP ===
            switch (action) {
                case "addPersonalTask": // Sửa từ "add"
                    handleAddTask(request, userId);
                    break;
                case "completeTask": // Sửa từ "complete"
                    handleCompleteTask(request, userId);
                    break;
                case "deleteTask": // Sửa từ "delete"
                    handleDeleteTask(request, userId);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        String source = request.getParameter("source");

        // Nếu 'source' là 'manager', quay về Manager Dashboard
        if ("manager".equals(source)) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard");
        } else {
            // Mặc định (hoặc source="agent"), quay về Agent Dashboard
            response.sendRedirect(request.getContextPath() + "/agent/dashboard");
        }
    }

    /**
     * Xử lý thêm To-do mới
     */
    private void handleAddTask(HttpServletRequest request, int userId) {
        String title = request.getParameter("taskTitle");
        if (title != null && !title.trim().isEmpty()) {
            Task newTask = new Task();
            newTask.setUserId(userId);
            newTask.setTitle(title.trim());
            newTask.setCompleted(false);
            taskDao.insertTask(newTask);
        }
    }

    /**
     * Xử lý cập nhật trạng thái hoàn thành
     */
    private void handleCompleteTask(HttpServletRequest request, int userId) {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            
            // === SỬA LỖI 2: LOGIC CHECKBOX ===
            // Khi checkbox được tick, request.getParameter("isCompleted") sẽ là "on".
            // Khi nó không được tick, request.getParameter("isCompleted") sẽ là null.
            boolean isCompleted = "on".equals(request.getParameter("isCompleted"));
            
            taskDao.updateTaskStatus(taskId, userId, isCompleted);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    /**
     * Xử lý xóa Task
     */
    private void handleDeleteTask(HttpServletRequest request, int userId) {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            taskDao.deleteTask(taskId, userId);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    /**
     * Phương thức trợ giúp để lấy đúng URL Dashboard dựa trên vai trò
     */
    private String getDashboardUrl(User user, HttpServletRequest request) {
        String contextPath = request.getContextPath();
        switch (user.getRoleId()) {
            case ROLE_AGENT:
                return contextPath + "/agent/dashboard";
            case ROLE_MANAGER:
                return contextPath + "/ManagerDashboard.jsp"; // Sửa lại URL của Manager Dashboard nếu cần
            case ROLE_ADMIN:
                return contextPath + "/AdminDashboard.jsp"; // Sửa lại URL của Admin Dashboard nếu cần
            default:
                return contextPath + "/login.jsp";
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    }
}