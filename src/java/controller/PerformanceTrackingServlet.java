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
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * ĐÃ "VÁ" (PATCHED) (Lần 3 - "CHỐT")
 * * Logic "Baseline Target" (Mục tiêu Cơ sở) đã được "chuyển" (moved)
 * * vào DAO (Data Access).
 * * Controller (Bộ não) này "quay lại" (reverts) logic "đơn giản" (simple) (chỉ "chặn" (block) Target < Sales).
 */
@WebServlet(name = "PerformanceTrackingServlet", urlPatterns = {"/manager/performance"})
public class PerformanceTrackingServlet extends HttpServlet {

    private UserDao userDao;
    private static final int ROLE_MANAGER = 2;

    @Override
    public void init() {
        this.userDao = new UserDao();
    }

    /**
     * HÀM NÀY GIỮ NGUYÊN (Unchanged)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // (Code doGet của bạn là "HOÀN HẢO" (PERFECT) -> Giữ nguyên)
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
                    // (Sửa (Fix) logic "Completed" (Hoàn thành) -> dùng "Baseline")
                    if (agent.getBaselineTarget() > 0 && agent.getTotalPremium() >= agent.getBaselineTarget()) {
                        filteredList.add(agent);
                    }
                }
                request.setAttribute("currentFilter", "completed");
            } else if ("below".equals(filter)) {
                filteredList = new ArrayList<>();
                for (AgentPerformanceDTO agent : teamPerformanceAll) {
                    // (Sửa (Fix) logic "Below" (Dưới) -> dùng "Baseline")
                    if (agent.getBaselineTarget() == 0 || agent.getTotalPremium() < agent.getBaselineTarget()) {
                        filteredList.add(agent);
                    }
                }
                request.setAttribute("currentFilter", "below");
            } else {
                filteredList = teamPerformanceAll;
                request.setAttribute("currentFilter", "all");
            }
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("activePage", "performance");
            request.setAttribute("teamPerformanceList", filteredList);
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

    /**
     * HÀM NÀY ĐÃ ĐƯỢC "VÁ" (PATCHED) (Logic "Đơn giản" (Simple))
     */
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

        // === 2. "VÁ" (PATCH) LOGIC "setTarget" (CÁ NHÂN) ===
        if ("setTarget".equals(action)) {
            try {
                int agentId = Integer.parseInt(request.getParameter("agentId"));
                BigDecimal newTargetAmount = new BigDecimal(request.getParameter("targetAmount")); // Target MỚI
                int targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
                int targetYear = Integer.parseInt(request.getParameter("targetYear"));

                // (A) Kiểm tra Bảo mật (Security Check)
                if (userDao.isAgentManagedBy(agentId, currentUser.getUserId())) {
                    
                    // (B) Lấy (Fetch) Doanh số (Premium) HIỆN TẠI
                    // (Logic "chặn" (block) Target < Sales (Doanh số) VẪN QUAN TRỌNG)
                    List<AgentPerformanceDTO> teamData = userDao.getTeamPerformance(currentUser.getUserId());
                    BigDecimal currentPremium = BigDecimal.ZERO;
                    for (AgentPerformanceDTO agent : teamData) {
                        if (agent.getAgentId() == agentId) {
                            currentPremium = BigDecimal.valueOf(agent.getTotalPremium());
                            break;
                        }
                    }

                    // (C) "CHỐT CHẶN" (CHECKPOINT) (Chỉ "chặn" (block) nếu Target MỚI < Doanh số HIỆN TẠI)
                    if (newTargetAmount.compareTo(currentPremium) >= 0) {
                        // CHO PHÉP (ALLOW)
                        boolean success = userDao.setAgentTarget(agentId, newTargetAmount, targetMonth, targetYear);
                        if (success) {
                            session.setAttribute("message", "Target updated successfully!");
                        } else {
                            session.setAttribute("message", "Error: Could not update target.");
                        }
                    } else {
                        // "CHẶN" (BLOCK)
                        session.setAttribute("message", "Error: Cannot set Target (" + newTargetAmount + ") lower than current sales (" + currentPremium + ").");
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

        // === 3. "VÁ" (PATCH) LOGIC "setTeamTarget" (CẢ TEAM) ===
        // (Quay lại (Revert) logic "đơn giản" (simple) của bạn, vì DAO (Bước 3) đã "xử lý" (handled) logic)
        } else if ("setTeamTarget".equals(action)) {
            try {
                BigDecimal targetAmount = new BigDecimal(request.getParameter("teamTargetAmount"));
                int targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
                int targetYear = Integer.parseInt(request.getParameter("targetYear"));

                // (Chúng ta KHÔNG (DO NOT) cần "chặn" (block) Target < Sales ở đây, 
                // vì nó "quá" (too) "phức tạp" (complex) (1 Agent "pass", 1 Agent "fail"))
                // (Chỉ gọi (Call) DAO "mới" (new) (ở Bước 3))
                
                boolean success = userDao.setTeamTarget(currentUser.getUserId(), targetAmount, targetMonth, targetYear);
                
                if (success) {
                    session.setAttribute("message", "Đã cập nhật Target chung cho cả team thành công! (Target 'Cơ sở' (Baseline) được giữ nguyên.)");
                } else {
                    session.setAttribute("message", "Error: Không thể cập nhật Target cho team.");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                session.setAttribute("message", "Error: Định dạng số tiền Target không hợp lệ.");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("message", "Error: " + e.getMessage());
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/manager/performance");
    }
}