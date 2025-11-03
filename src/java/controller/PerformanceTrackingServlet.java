package controller;

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
import java.util.List;

@WebServlet(name = "PerformanceTrackingServlet", urlPatterns = {"/manager/performance"})
public class PerformanceTrackingServlet extends HttpServlet {

    private UserDao userDao;
    private static final int ROLE_MANAGER = 2;

    @Override
    public void init() {
        this.userDao = new UserDao();
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
            
            // Gọi DAO để lấy dữ liệu
            List<AgentPerformanceDTO> teamPerformance = userDao.getTeamPerformance(managerId);

            // Gửi dữ liệu sang JSP
            request.setAttribute("teamPerformanceList", teamPerformance);
            
            request.getRequestDispatcher("/agentPerformance.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Chuyển đến trang lỗi chung
            request.setAttribute("errorMessage", "Error loading performance data.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}