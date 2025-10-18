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

@WebServlet(name = "PerformanceTrackingServlet", urlPatterns = {"/manager/performance-tracking"})
public class PerformanceTrackingServlet extends HttpServlet {

    private UserDao userDao;
    private static final int MANAGER_ROLE_ID = 2; 

    @Override
    public void init() throws ServletException {
        // Khởi tạo DAO trong init()
        this.userDao = new UserDao();
        System.out.println("--- PERFORMANCE TRACKING SERVLET INITIALIZED ---");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. KIỂM TRA PHÂN QUYỀN
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleId() != MANAGER_ROLE_ID) {
            System.err.println("!!! SECURITY ALERT: Access denied for non-Manager user.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int managerId = currentUser.getUserId();
        
        // LOG XÁC NHẬN ĐẦU VÀO
        System.err.println("--- START DEBUG ---");
        System.err.println("ACCESS GRANTED: Manager " + currentUser.getFullName() + " (ID: " + managerId + ") is processing request.");
        
        try {
            // 2. GỌI DAO VÀ LẤY DỮ LIỆU HIỆU SUẤT ĐỘI NHÓM
            List<AgentPerformanceDTO> teamPerformance = userDao.getTeamPerformance(managerId);
            
            // LOG KẾT QUẢ ĐẦU RA TỪ DAO
            System.err.println("DATABASE RESULT: Loaded " + teamPerformance.size() + " agents for Manager ID " + managerId + ".");
            
            // LOG CHI TIẾT CÁC AGENT ĐƯỢC TẢI
            if (teamPerformance.isEmpty()) {
                System.err.println("TEAM LIST EMPTY. Check Manager_Agent table or Active Contracts.");
            } else {
                for (AgentPerformanceDTO dto : teamPerformance) {
                    System.err.println(
                        "-> Agent ID: " + dto.getAgentId() + 
                        ", Name: " + dto.getAgentName() + 
                        ", Premium: " + dto.getTotalPremium() + 
                        ", Contracts: " + dto.getContractsCount()
                    );
                }
            }

            // 3. GỬI DỮ LIỆU SANG VIEW
            request.setAttribute("teamPerformanceList", teamPerformance);
            
            // 4. CHUYỂN TIẾP ĐẾN VIEW 
            response.setContentType("text/html;charset=UTF-8");
            request.getRequestDispatcher("/agentperformance.jsp").forward(request, response);
            
        }catch (Exception e) {
            // Xử lý lỗi không xác định
            System.err.println("!!! UNEXPECTED ERROR !!!");
            e.printStackTrace(System.err);
            request.setAttribute("errorMessage", "Lỗi hệ thống không xác định.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
        // Xử lý lỗi SQL
        // In stack trace ra standard error
        
    }
}