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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDao userDAO = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String fullName = req.getParameter("fullName");
        String role = req.getParameter("role");
        String email = req.getParameter("email");
        String phoneNumber = req.getParameter("phoneNumber");

        String error = null;

        try {
            if (userDAO.checkEmailExists(email)) {
                error = "Email đã tồn tại!";
            }

            if (error == null) {
<<<<<<< HEAD
                int roleId = userDAO.getRoleIdByName(roleName);
=======
                User user = new User();
                user.setFullName(fullName);
                user.setEmail(email);
                user.setPhoneNumber(phoneNumber);
                if (role.equalsIgnoreCase("Agent")) {
                    user.setRoleId(1);
                } else if (role.equalsIgnoreCase("Manager")) {
                    user.setRoleId(2);
                }
>>>>>>> thanhhe180566

                // Agent
                user.setStatus("Pending"); // Pending
                user.setIsFirstLogin(true);

                boolean success = userDAO.registerUser(user);
                if (success) {
                    req.setAttribute("message", "Đăng ký thành công! Vui lòng chờ manager duyệt.");
                } else {
<<<<<<< HEAD
                    User user = new User();
                    user.setUsername(username);
                    user.setPasswordHash(password);
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
                    } catch (Exception e) {
                        error = "Không gửi được OTP: " + e.getMessage();
                        e.printStackTrace();
                    }

                    if (error == null) {
                        req.getRequestDispatcher("verify.jsp").forward(req, resp);
                        return;
                    }
=======
                    error = "Lỗi khi lưu vào DB!";
>>>>>>> thanhhe180566
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            error = "Lỗi hệ thống: " + e.getMessage();
        }

        if (error != null) {
            req.setAttribute("error", error);
        }
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }
}
