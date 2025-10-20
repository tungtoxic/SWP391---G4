package controller;

import dao.CommissionDao;
import entity.CommissionReportDTO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CommissionReportServlet", urlPatterns = {"/agent/commission-report"})
public class CommissionReportServlet extends HttpServlet {

    // Giả sử role_id của Agent là 1
    private static final int AGENT_ROLE_ID = 1; 
    private CommissionDao commissionDao;

    @Override
    public void init() {
        this.commissionDao = new CommissionDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("\n--- [BẮT ĐẦU YÊU CẦU MỚI TỚI COMMISSION REPORT SERVLET] ---");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // === LOG DEBUG 1: KIỂM TRA SESSION VÀ USER ===
        if (currentUser == null) {
            System.out.println("!!! DEBUG 1: Lỗi - Session không tồn tại hoặc không có attribute 'user'. Đang chuyển hướng đến trang đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        System.out.println("--- DEBUG 1: OK - Lấy thành công user từ session.");
        System.out.println("    -> User Full Name: " + currentUser.getFullName());
        System.out.println("    -> User ID: " + currentUser.getUserId());
        System.out.println("    -> User Role ID: " + currentUser.getRoleId());


        // === LOG DEBUG 2: KIỂM TRA QUYỀN TRUY CẬP ===
        if (currentUser.getRoleId() != AGENT_ROLE_ID) {
            System.out.println("!!! DEBUG 2: Lỗi - User không phải là Agent. Đang chặn truy cập.");
            // Bạn có thể chuyển hướng đến trang lỗi "access denied"
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to access this page.");
            return;
        }
        System.out.println("--- DEBUG 2: OK - User có quyền Agent.");

        try {
            int agentId = currentUser.getUserId();
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            // === LOG DEBUG 3: KIỂM TRA THAM SỐ TRƯỚC KHI GỌI DAO ===
            System.out.println("--- DEBUG 3: Chuẩn bị gọi DAO với các tham số:");
            System.out.println("    -> agentId: " + agentId);
            System.out.println("    -> startDate: " + startDate);
            System.out.println("    -> endDate: " + endDate);

            List<CommissionReportDTO> reportList = commissionDao.getCommissionReportByAgentId(agentId, startDate, endDate);

            // === LOG DEBUG 4: KIỂM TRA KẾT QUẢ TRẢ VỀ TỪ DAO ===
            System.out.println("--- DEBUG 4: DAO đã thực thi xong. Số bản ghi trả về: " + reportList.size());

            // Tính tổng hoa hồng
            double totalCommission = reportList.stream()
                                               .mapToDouble(CommissionReportDTO::getCommissionAmount)
                                               .sum();
            
            System.out.println("--- DEBUG 5: Tính tổng hoa hồng thành công: " + totalCommission);

            // Đặt thuộc tính vào request
            request.setAttribute("reportList", reportList);
            request.setAttribute("totalCommission", totalCommission);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);

            // Chuyển tiếp đến trang JSP
            System.out.println("--- DEBUG 6: Chuẩn bị chuyển tiếp dữ liệu đến commission_report.jsp");
            request.getRequestDispatcher("/commission_report.jsp").forward(request, response);
            System.out.println("--- [KẾT THÚC YÊU CẦU] ---");

        } catch (Exception e) {
            System.out.println("!!! DEBUG X: ĐÃ XẢY RA LỖI NGOẠI LỆ TRONG SERVLET !!!");
            e.printStackTrace(); // In chi tiết lỗi ra console
            // Chuyển đến trang lỗi chung
            request.setAttribute("errorMessage", "Đã có lỗi hệ thống xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}