package controller;

import dao.UserDao;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Servlet "Hoàn thiện" (Finishing) (Luồng 1 & 2)
 * Chịu trách nhiệm (Handles) Xem (View) và Cập nhật (Update) Profile
 * (Áp dụng cho TẤT CẢ (ALL) vai trò: Agent, Manager, Admin)
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    private UserDao userDao;

    @Override
    public void init() {
        this.userDao = new UserDao(); // (Khởi tạo DAO)
    }

    /**
     * LUỒNG 1: HIỂN THỊ (VIEW) PROFILE
     * (Khi User nhấn (click) "Profile" trên Navbar)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // 1. "Chốt chặn" (Checkpoint) Bảo mật (Security)
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // 2. Lấy (Fetch) data "MỚI NHẤT" (freshest) từ CSDL (Database)
            // (Đề phòng (In case) data (dữ liệu) trong "session" (phiên) bị "cũ" (stale))
            User userFromDb = userDao.getUserById(currentUser.getUserId());

            // 3. Gửi (Send) data (dữ liệu) "MỚI" (fresh) sang JSP
            request.setAttribute("profileUser", userFromDb);
            
            // 4. "Vẽ" (Render) Giao diện (UI)
            request.getRequestDispatcher("/profile.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading profile data.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * LUỒNG 2: CẬP NHẬT (UPDATE) PROFILE
     * (Khi User nhấn (click) "Save Changes" (Lưu Thay đổi) trong form)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // 1. "Chốt chặn" (Checkpoint) Bảo mật (Security)
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // 2. Lấy (Get) các tham số (parameters) "mới" (new) từ Form
            String newFullName = request.getParameter("fullName");
            String newEmail = request.getParameter("email");
            String newPhone = request.getParameter("phoneNumber");

            // 3. Lấy (Fetch) "toàn bộ" (full) object User "hiện tại" (current) từ CSDL (Database)
            User userToUpdate = userDao.getUserById(currentUser.getUserId());

            // 4. "Chốt chặn" (Checkpoint) "Trùng lặp" (Duplicate) (Logic quan trọng nhất)
            
            // (A) Kiểm tra (Check) Email (CHỈ (ONLY) nếu Email "bị thay đổi" (is changed))
            if (!newEmail.equalsIgnoreCase(userToUpdate.getEmail()) && userDao.checkEmailExists(newEmail)) {
                // LỖI (ERROR): Email "mới" (new) này đã "tồn tại" (exists) (bị "chiếm" (taken) bởi User "khác" (other))
                session.setAttribute("profileMessage", "Error: Email '" + newEmail + "' already exists.");
                response.sendRedirect(request.getContextPath() + "/profile"); // (Tải lại (Reload) trang)
                return; // (Dừng (STOP))
            }
            
            // (B) Kiểm tra (Check) SĐT (Phone) (CHỈ (ONLY) nếu SĐT "bị thay đổi" (is changed))
            if (!newPhone.equals(userToUpdate.getPhoneNumber()) && userDao.isPhoneExists(newPhone)) {
                // LỖI (ERROR): SĐT "mới" (new) này đã "tồn tại" (exists)
                session.setAttribute("profileMessage", "Error: Phone number '" + newPhone + "' already exists.");
                response.sendRedirect(request.getContextPath() + "/profile"); // (Tải lại (Reload) trang)
                return; // (Dừng (STOP))
            }

            // 5. "Vá" (Patch) Object (Nếu (If) "vượt qua" (passed) "chốt chặn" (checkpoint))
            userToUpdate.setFullName(newFullName);
            userToUpdate.setEmail(newEmail);
            userToUpdate.setPhoneNumber(newPhone);
            
            // 6. "Lưu" (Save) (Dùng hàm `updateUser` (an toàn) vì nó "ghi đè" (overwrites) "toàn bộ" (full) object)
            boolean success = userDao.updateUser(userToUpdate);

            if (success) {
                // 7. (QUAN TRỌNG) "Đồng bộ" (Sync) "Session" (Phiên)
                // (Cập nhật (Update) data "mới" (new) vào "session" (phiên) 
                //  để "Tên" (Name) trên Navbar "thay đổi" (change) "ngay lập tức" (immediately))
                session.setAttribute("user", userToUpdate); 
                session.setAttribute("profileMessage", "Success: Profile updated successfully!");
            } else {
                session.setAttribute("profileMessage", "Error: Could not update profile in database.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("profileMessage", "Error: " + e.getMessage());
        }
        
        // 8. Tải lại (Redirect) trang "Profile" (để "thấy" (see) "thông báo" (message))
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}