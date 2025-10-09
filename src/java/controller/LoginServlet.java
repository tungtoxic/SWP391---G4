/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.*;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Random;
import utility.*;
import utility.PasswordUtils;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserDao userDAO;

    @Override
    public void init() {
        userDAO = new UserDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        try {
            User user = userDAO.login(username);

            if (user != null && PasswordUtils.verifyPassword(password, user.getPasswordHash())) {
                // ✅ Sinh OTP
                int otpValue = 100000 + new Random().nextInt(900000);

                HttpSession session = request.getSession();
                session.setAttribute("tempUser", user);
                session.setAttribute("otp", String.valueOf(otpValue));
                session.setAttribute("otpTime", System.currentTimeMillis());
                session.setAttribute("authType", "login"); // 👈 Quan trọng!

                // ✅ Gửi mail
                EmailUtil.sendEmail(
                        user.getEmail(),
                        "Mã OTP đăng nhập",
                        "<h3>Xin chào " + user.getFullName() + ",</h3>"
                        + "<p>Mã OTP đăng nhập của bạn là: <b>" + otpValue + "</b></p>"
                        + "<p>OTP có hiệu lực trong 5 phút.</p>"
                );

                // Chuyển đến verify.jsp
                request.getRequestDispatcher("verify.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Sai username hoặc password!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException("Login failed", e);
        }
    }
}
