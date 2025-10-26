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
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Nguyễn Tùng
 */
@WebServlet(name = "AgentLeaderboardServlet", urlPatterns = {"/agents/leaderboard"})
public class AgentLeaderboardServlet extends HttpServlet {

    private UserDao userDao;
    private static final int ROLE_AGENT = 1; // Giả định Agent role là 1
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

        if (currentUser == null) { // Chỉ cần kiểm tra currentUser
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        try {
            /// 1. Lấy danh sách đã sắp xếp từ DAO
            List<AgentPerformanceDTO> leaderboardList = userDao.getAgentLeaderboard();

            // ===== BẮT ĐẦU LOGIC MỚI (TÍNH TOÁN %) =====
            
            // 2. Tính tổng doanh thu toàn bộ Agent
            double grandTotalRevenue = 0.0;
            for (AgentPerformanceDTO agent : leaderboardList) {
                grandTotalRevenue += agent.getTotalPremium();
            }

            // 3. Tính % cho từng Agent và set vào DTO
            if (grandTotalRevenue > 0) { // Tránh chia cho 0
                for (AgentPerformanceDTO agent : leaderboardList) {
                    double percentage = (agent.getTotalPremium() / grandTotalRevenue) * 100;
                    agent.setRevenuePercentage(percentage); // Set % vào DTO
                }
            }
            // ===== KẾT THÚC LOGIC MỚI =====


            // 4. Tách Top 3 và phần còn lại
            // (Thêm các biến rỗng để tránh lỗi NullPointerException trên JSP)
            AgentPerformanceDTO top1Agent = null;
            AgentPerformanceDTO top2Agent = null;
            AgentPerformanceDTO top3Agent = null;
            List<AgentPerformanceDTO> remainingAgents = new ArrayList<>();

            if (leaderboardList.size() >= 1) {
                top1Agent = leaderboardList.get(0);
            }
            if (leaderboardList.size() >= 2) {
                top2Agent = leaderboardList.get(1);
            }
            if (leaderboardList.size() >= 3) {
                top3Agent = leaderboardList.get(2);
                // Lấy danh sách từ hạng 4 trở đi
                if (leaderboardList.size() > 3) {
                    remainingAgents = leaderboardList.subList(3, leaderboardList.size());
                }
            } else if (leaderboardList.size() == 2) {
                // Trường hợp chỉ có 2 agent, không có hạng 3
                // remainingAgents vẫn là list rỗng
            }
            // (Trường hợp chỉ có 1 agent, top2, top3, remaining đều rỗng)

            // 5. Gửi TẤT CẢ dữ liệu sang JSP
            request.setAttribute("currentUser", currentUser);
            
            // Đặt activePage dựa trên vai trò
            if (currentUser.getRoleId() == ROLE_AGENT) {
                 request.setAttribute("activePage", "leaderboard");
            } else if (currentUser.getRoleId() == ROLE_MANAGER) {
                 // Đặt tên này để khớp với sidebar của Manager
                 request.setAttribute("activePage", "agentLeaderboard"); 
            }
            
            request.setAttribute("agentLeaderboard", leaderboardList); // Gửi cả danh sách đầy đủ (dự phòng)
            
            // Gửi Top 3
            request.setAttribute("top1Agent", top1Agent);
            request.setAttribute("top2Agent", top2Agent);
            request.setAttribute("top3Agent", top3Agent);
            
            // Gửi phần còn lại
            request.setAttribute("remainingAgents", remainingAgents);
            
            // Gửi tổng doanh thu (nếu JSP cần hiển thị)
            request.setAttribute("grandTotalRevenue", grandTotalRevenue);


            // 6. Chuyển tiếp đến file JSP 
            request.getRequestDispatcher("/agent_leaderboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error retrieving agent leaderboard data", e);
        }
    }
}