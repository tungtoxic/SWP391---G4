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
import java.math.BigDecimal; // <<< THÊM IMPORT NÀY
import java.time.LocalDate; // <<< THÊM IMPORT NÀY
import java.util.ArrayList;
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
            String filter = request.getParameter("filter");
            List<AgentPerformanceDTO> teamPerformanceAll = userDao.getTeamPerformance(managerId);
            List<AgentPerformanceDTO> filteredList;
            if ("completed".equals(filter)) {
                filteredList = new ArrayList<>();
                for (AgentPerformanceDTO agent : teamPerformanceAll) {
                    // So sánh premium với targetAmount động của agent
                    if (agent.getTargetAmount() > 0 && agent.getTotalPremium() >= agent.getTargetAmount()) {
                        filteredList.add(agent);
                    }
                }
                request.setAttribute("currentFilter", "completed"); // Gửi tên filter đang chọn
            
            } else if ("below".equals(filter)) {
                filteredList = new ArrayList<>();
                for (AgentPerformanceDTO agent : teamPerformanceAll) {
                     // So sánh premium với targetAmount động của agent
                    if (agent.getTargetAmount() == 0 || agent.getTotalPremium() < agent.getTargetAmount()) {
                        filteredList.add(agent);
                    }
                }
                 request.setAttribute("currentFilter", "below");
            
            } else {
                filteredList = teamPerformanceAll; // Mặc định là hiển thị tất cả
                 request.setAttribute("currentFilter", "all");
            }
            // ===========================================

            // 3. Gửi dữ liệu layout sang JSP
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("activePage", "performance"); // Tên định danh cho trang này

            // 4. Gửi dữ liệu của trang sang JSP
            request.setAttribute("teamPerformanceList", filteredList); // Gửi danh sách ĐÃ LỌC
            
            // Gửi tháng/năm hiện tại để hiển thị trên form (cho Bước 5)
            LocalDate today = LocalDate.now();
            request.setAttribute("currentTargetMonth", today.getMonthValue());
            request.setAttribute("currentTargetYear", today.getYear());

            request.getRequestDispatcher("/agentPerformance.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading performance data.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null || currentUser.getRoleId() != ROLE_MANAGER) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("setTarget".equals(action)) {
            try {
                // Lấy dữ liệu từ form submit (sẽ tạo ở Bước 5)
                int agentId = Integer.parseInt(request.getParameter("agentId"));
                BigDecimal targetAmount = new BigDecimal(request.getParameter("targetAmount"));
                int targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
                int targetYear = Integer.parseInt(request.getParameter("targetYear"));

                // (Thêm kiểm tra bảo mật: agentId này có thuộc quyền quản lý của currentUser không)
                if (userDao.isAgentManagedBy(agentId, currentUser.getUserId())) {
                     // Gọi DAO để set target
                    boolean success = userDao.setAgentTarget(agentId, targetAmount, targetMonth, targetYear);
                    if (success) {
                        // Set message thành công
                        session.setAttribute("message", "Target updated successfully!");
                    } else {
                         session.setAttribute("message", "Error: Could not update target.");
                    }
                } else {
                     session.setAttribute("message", "Error: You do not have permission for this agent.");
                }

            } catch (NumberFormatException e) {
                e.printStackTrace();
                session.setAttribute("message", "Error: Invalid number format for target.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("message", "Error: " + e.getMessage());
            }
        }
        
        // Quay lại trang performance (doGet sẽ chạy lại và lấy dữ liệu mới)
        response.sendRedirect(request.getContextPath() + "/manager/performance");
    }
}