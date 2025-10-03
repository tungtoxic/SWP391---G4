/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import entity.User;
import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.Random;
import utility.EmailUtil;
import utility.PasswordUtils;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UserDao userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDao();
    }

    // GET -> hiển thị form login
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    // POST -> xử lý login
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
                session.setAttribute("authType", "login"); // 👈 xác định đây là đăng nhập

                // ✅ Gửi OTP qua email
                try {
                    EmailUtil.sendEmail(
                            user.getEmail(),
                            "Mã OTP đăng nhập",
                            "Xin chào " + user.getFullName()
                            + ",\n\nMã OTP đăng nhập của bạn là: " + otpValue
                            + "\nOTP có hiệu lực trong 5 phút."
                    );
                } catch (Exception e) {
                    request.setAttribute("error", "Không gửi được OTP: " + e.getMessage());
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                // Sang verify.jsp
                request.getRequestDispatcher("verify.jsp").forward(request, response);

            } else {
                request.setAttribute("error", "Sai username hoặc password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException("Login failed", e);
        }
    }
}
