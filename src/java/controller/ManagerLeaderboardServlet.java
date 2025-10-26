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
import java.util.ArrayList;
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

        // Chỉ Manager mới được xem trang này
        if (currentUser == null || currentUser.getRoleId() != ROLE_MANAGER) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // 1. Lấy danh sách xếp hạng Manager đã sắp xếp từ DAO
            List<AgentPerformanceDTO> leaderboardList = userDao.getManagerLeaderboard();

            // 2. Tính tổng doanh thu toàn bộ các Team
            double grandTotalRevenue = 0.0;
            for (AgentPerformanceDTO manager : leaderboardList) {
                grandTotalRevenue += manager.getTotalPremium();
            }

            // 3. Tính % cho từng Manager và set vào DTO
            if (grandTotalRevenue > 0) { // Tránh chia cho 0
                for (AgentPerformanceDTO manager : leaderboardList) {
                    double percentage = (manager.getTotalPremium() / grandTotalRevenue) * 100;
                    // Tận dụng trường revenuePercentage (nếu đã thêm) hoặc trường khác
                    manager.setRevenuePercentage(percentage); 
                }
            }

            // 4. Tách Top 3 và phần còn lại
            AgentPerformanceDTO top1Manager = null;
            AgentPerformanceDTO top2Manager = null;
            AgentPerformanceDTO top3Manager = null;
            List<AgentPerformanceDTO> remainingManagers = new ArrayList<>();

            if (leaderboardList.size() >= 1) {
                top1Manager = leaderboardList.get(0);
            }
            if (leaderboardList.size() >= 2) {
                top2Manager = leaderboardList.get(1);
            }
            if (leaderboardList.size() >= 3) {
                top3Manager = leaderboardList.get(2);
                if (leaderboardList.size() > 3) {
                    remainingManagers = leaderboardList.subList(3, leaderboardList.size());
                }
            } else if (leaderboardList.size() == 2) {
                // Chỉ có 2 manager, remaining rỗng
            }
            
            // 5. Gửi dữ liệu sang JSP
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("activePage", "leaderboard"); // Đặt tên định danh

            // Gửi Top 3
            request.setAttribute("top1Manager", top1Manager);
            request.setAttribute("top2Manager", top2Manager);
            request.setAttribute("top3Manager", top3Manager);
            
            // Gửi phần còn lại
            request.setAttribute("remainingManagers", remainingManagers);

            // 6. Chuyển tiếp đến file JSP
            request.getRequestDispatcher("/manager_leaderboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi tải Manager Leaderboard", e);
        }
    }
}
