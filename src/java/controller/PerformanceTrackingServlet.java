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
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "PerformanceTrackingServlet", urlPatterns = {"/manager/performance-tracking"})
public class PerformanceTrackingServlet extends HttpServlet {

    private UserDao userDao;
    private static final int MANAGER_ROLE_ID = 2; 
    private static final Logger LOGGER = Logger.getLogger(PerformanceTrackingServlet.class.getName());

    @Override
    public void init() throws ServletException {
        // Khởi tạo DAO trong init()
        this.userDao = new UserDao();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. KIỂM TRA PHÂN QUYỀN
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleId() != MANAGER_ROLE_ID) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int managerId = currentUser.getUserId();
        
        try {
            // 2. LẤY DỮ LIỆU HIỆU SUẤT ĐỘI NHÓM
            List<AgentPerformanceDTO> teamPerformance = userDao.getTeamPerformance(managerId);
            
            LOGGER.log(Level.INFO, "Loaded {0} agents for Manager ID {1}", new Object[]{teamPerformance.size(), managerId});

            // 3. GỬI DỮ LIỆU SANG VIEW
            request.setAttribute("teamPerformanceList", teamPerformance);
            
            // 4. CHUYỂN TIẾP ĐẾN VIEW 
            
            request.getRequestDispatcher("/agentPerformance.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error", e);
            request.setAttribute("errorMessage", "Lỗi không xác định.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}