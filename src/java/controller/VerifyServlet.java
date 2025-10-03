/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDao;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/VerifyServlet")
public class VerifyServlet extends HttpServlet {

    private UserDao userDAO = new UserDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String inputOtp = request.getParameter("otp");
        HttpSession session = request.getSession();

        String otp = (String) session.getAttribute("otp");
        Long otpTime = (Long) session.getAttribute("otpTime");
        User tempUser = (User) session.getAttribute("tempUser");
        String authType = (String) session.getAttribute("authType");

        String error = null;

        if (otp != null && otpTime != null && otp.equals(inputOtp)
                && (System.currentTimeMillis() - otpTime) < 5 * 60 * 1000) {

            try {
                if ("register".equals(authType)) {
                    // ✅ Trường hợp đăng ký: lưu user mới
                    boolean inserted = userDAO.insertUser(tempUser);
                    if (inserted) {
                        session.removeAttribute("otp");
                        session.removeAttribute("otpTime");
                        session.removeAttribute("tempUser");
                        session.removeAttribute("authType");

                        session.setAttribute("user", tempUser);
                        response.sendRedirect("home.jsp"); // về trang home
                        return;
                    } else {
                        error = "Không thể lưu user. Vui lòng thử lại.";
                    }

                } else if ("login".equals(authType)) {
                    // ✅ Trường hợp login: không insert, chỉ login
                    session.removeAttribute("otp");
                    session.removeAttribute("otpTime");
                    session.removeAttribute("authType");

                    session.setAttribute("user", tempUser);
                    response.sendRedirect("profile.jsp"); // về trang profile
                    return;

                } else {
                    error = "Không xác định được loại xác thực!";
                }

            } catch (Exception e) {
                e.printStackTrace();
                error = "Lỗi hệ thống: " + e.getMessage();
            }

        } else {
            error = "OTP không hợp lệ hoặc đã hết hạn.";
        }

        // Nếu có lỗi → quay lại verify.jsp
        request.setAttribute("error", error);
        request.getRequestDispatcher("verify.jsp").forward(request, response);
    }
}


