/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.UserDao;
import entity.AgentPerformanceDTO;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "ManagerLeaderboardServlet", urlPatterns = {"/managers/leaderboard"})
public class ManagerLeaderboardServlet extends HttpServlet {

    private UserDao userDao;
    private static final int ROLE_MANAGER = 2;

    @Override
    public void init() {
        userDao = new UserDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // Chỉ Manager hoặc Admin mới có quyền xem trang này
        if (currentUser == null || (currentUser.getRoleId() != ROLE_MANAGER && currentUser.getRoleId() != 3)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Gọi phương thức DAO để lấy danh sách xếp hạng Manager
            List<AgentPerformanceDTO> managerLeaderboard = userDao.getManagerLeaderboard();

            // Đặt danh sách vào request
            request.setAttribute("managerLeaderboard", managerLeaderboard);
                             request.setAttribute("activePage", "leaderboard");

            // Chuyển tiếp đến trang JSP
            request.getRequestDispatcher("/manager_leaderboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving manager leaderboard data", e);
        }
    }
}
