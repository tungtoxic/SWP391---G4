/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDao;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Random;
import java.util.regex.Pattern;
import utility.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDao userDAO = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String phoneNumber = req.getParameter("phoneNumber");
        String roleName = req.getParameter("role");
        String gRecaptchaResponse = req.getParameter("g-recaptcha-response");

        String error = null;

        try {
            // ✅ Validate dữ liệu
            boolean captchaValid = VerifyRecaptcha.verify(gRecaptchaResponse);
            if (!captchaValid) {
                error = "Captcha không hợp lệ.";
            } else if (username == null || username.trim().length() < 3) {
                error = "Username phải >= 3 ký tự";
            } else if (userDAO.checkUsernameExists(username)) {
                error = "Username đã tồn tại";
            } else if (fullName == null || fullName.trim().length() < 3) {
                error = "Full name phải >= 3 ký tự";
            } else if (!Pattern.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$", email)) {
                error = "Email không hợp lệ";
            } else if (userDAO.checkEmailExists(email)) {
                error = "Email đã tồn tại";
            } else if (password == null || password.length() < 6) {
                error = "Mật khẩu phải >= 6 ký tự";
            } else if (!password.equals(confirmPassword)) {
                error = "Mật khẩu nhập lại không khớp";
            } else if (!Pattern.matches("^\\d{9,11}$", phoneNumber)) {
                error = "Số điện thoại phải 9-11 chữ số";
            }

            if (error == null) {
                String hashedPassword = PasswordUtils.hashPassword(password);
                int roleId = userDAO.getRoleIdByName(roleName);

                if (roleId == -1) {
                    error = "Vai trò không hợp lệ!";
                } else {
                    User user = new User();
                    user.setUsername(username);
                    user.setPasswordHash(hashedPassword);
                    user.setFullName(fullName);
                    user.setEmail(email);
                    user.setPhoneNumber(phoneNumber);
                    user.setRoleId(roleId);
                    user.setStatus("Active");

                    // ✅ Sinh OTP
                    int otpValue = 100000 + new Random().nextInt(900000);

                    HttpSession session = req.getSession();
                    session.setAttribute("tempUser", user);
                    session.setAttribute("otp", String.valueOf(otpValue));
                    session.setAttribute("otpTime", System.currentTimeMillis());
                    session.setAttribute("authType", "register");

                    // ✅ Gửi OTP qua email
                    try {
                        EmailUtil.sendEmail(
                                user.getEmail(),
                                "Mã đăng ký",   // 👈 đổi tiêu đề
                                "Xin chào " + user.getFullName()
                                        + ",\n\nMã đăng ký của bạn là: " + otpValue
                                        + "\nMã có hiệu lực trong 5 phút."
                        );
                        System.out.printf("otp"+ otpValue);
                    } catch (Exception e) {
                        error = "Không gửi được OTP: " + e.getMessage();
                        e.printStackTrace();
                    }

                    if (error == null) {
                        req.getRequestDispatcher("verify.jsp").forward(req, resp);
                        return;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            error = "Lỗi hệ thống: " + e.getMessage();
        }

        req.setAttribute("error", error);
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }
}
