package controller;

import dao.UserDao;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
// import java.sql.SQLException; // (Không (Not) "cần" (needed))
// import java.util.Random; // (KHÔNG (NO) "OTP")
import java.util.regex.Pattern;
import utility.*; // (Cần (Need) "PasswordUtils" VÀ "VerifyRecaptcha")

/**
 * ĐÃ "VÁ" (PATCHED) (Phiên bản "Lai" (Hybrid))
 * (Đã GỠ BỎ (REMOVED) "OTP" (Xác thực 2 bước))
 * (ĐÃ GIỮ LẠI (KEPT) "Captcha" (Xác thực))
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDao userDAO = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // 1. Lấy (Get) "Dữ liệu" (Data) (GIỮ LẠI (KEPT) "Captcha" (Xác thực))
        String username = req.getParameter("username");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String phoneNumber = req.getParameter("phoneNumber");
        String roleName = req.getParameter("role");
        String gRecaptchaResponse = req.getParameter("g-recaptcha-response"); // (GIỮ LẠI (KEPT))

        String error = null;

        try {
            // 2. "Validate" (Xác thực) (GIỮ LẠI (KEPT) "Captcha" (Xác thực))
            boolean captchaValid = VerifyRecaptcha.verify(gRecaptchaResponse);
            if (!captchaValid) {
                error = "Captcha không hợp lệ.";
            } else if (username == null || username.trim().length() < 3) {
                error = "Username phải >= 3 ký tự";
            } else if (userDAO.checkUsernameExists(username)) { //
                error = "Username đã tồn tại";
            } else if (fullName == null || fullName.trim().length() < 3) {
                error = "Full name phải >= 3 ký tự";
            } else if (!Pattern.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$", email)) {
                error = "Email không hợp lệ";
            } else if (userDAO.checkEmailExists(email)) { //
                error = "Email đã tồn tại";
            } else if (password == null || password.length() < 6) {
                error = "Mật khẩu phải >= 6 ký tự";
            } else if (!password.equals(confirmPassword)) {
                error = "Mật khẩu nhập lại không khớp";
            } else if (!Pattern.matches("^\\d{9,11}$", phoneNumber)) {
                error = "Số điện thoại phải 9-11 chữ số";
            } else if (userDAO.isPhoneExists(phoneNumber)){ // (Bổ sung (Added) "check" (kiểm tra) "trùng" (duplicate) SĐT)
                 error = "Số điện thoại đã tồn tại";
            }

            // 3. "Xử lý" (Process) (Nếu (If) "vượt qua" (passed) "validate" (xác thực))
            if (error == null) {
                String hashedPassword = PasswordUtils.hashPassword(password);
                int roleId = userDAO.getRoleIdByName(roleName); //

                if (roleId == -1 || roleId == 3) { // (GỠ BỎ (REMOVED) "Admin" (Quản trị viên))
                    error = "Vai trò không hợp lệ (Chỉ (Only) Agent/Manager)!";
                } else {
                    User user = new User();
                    user.setUsername(username);
                    user.setPasswordHash(hashedPassword);
                    user.setFullName(fullName);
                    user.setEmail(email);
                    user.setPhoneNumber(phoneNumber);
                    user.setRoleId(roleId);
                    user.setStatus("Active"); 
                    user.setIsFirstLogin(true); 
                    
                    // (GỠ BỎ (REMOVED) "Toàn bộ" (Entire) "Block" (Khối) "Sinh OTP" (Generate OTP))
                    // (GỠ BỎ (REMOVED) "Toàn bộ" (Entire) "Block" (Khối) "Gửi Email" (Send Email))
                    // (GỠ BỎ (REMOVED) "forward" (Chuyển tiếp) "đến" (to) "verify.jsp")

                    // === "VÁ" (PATCH): "CHÈN" (INSERT) "TRỰC TIẾP" (DIRECTLY) ===
                    boolean success = userDAO.insertUser(user); //

                    if (success) {
                        HttpSession session = req.getSession();
                        session.setAttribute("registerMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
                        resp.sendRedirect(req.getContextPath() + "/login.jsp");
                        return; // (DỪNG (STOP))
                    } else {
                        error = "Lỗi CSDL (Database Error): Không thể (Could not) 'tạo' (create) User.";
                    }
                    // ===================================
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            error = "Lỗi hệ thống: " + e.getMessage();
        }

        // 4. "Fallback" (Phương án dự phòng)
        req.setAttribute("error", error);
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }
}