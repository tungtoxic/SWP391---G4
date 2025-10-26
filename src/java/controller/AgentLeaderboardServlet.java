/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.UserDao;
import entity.AgentPerformanceDTO;
import java.io.IOException;
import java.io.PrintWriter;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Nguyễn Tùng
 */
@WebServlet(name = "AgentLeaderboardServlet", urlPatterns = {"/agents/leaderboard"})
public class AgentLeaderboardServlet extends HttpServlet {

    private UserDao userDao;

    @Override
    public void init() {
        userDao = new UserDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
   
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) { // Chỉ cần kiểm tra currentUser
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        try {
            // Gọi phương thức DAO để lấy danh sách xếp hạng Agent
            List<AgentPerformanceDTO> agentLeaderboard = userDao.getAgentLeaderboard();
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("activePage", "leaderboard");
            // Đặt danh sách vào request
            request.setAttribute("agentLeaderboard", agentLeaderboard);

            // Chuyển tiếp đến file JSP có tên cụ thể
            request.getRequestDispatcher("/agent_leaderboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving agent leaderboard data", e);
        }
    }
}