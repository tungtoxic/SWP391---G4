/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.Random;
import utility.EmailUtil;

@WebServlet("/resendOtp")
public class ResendOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");
        HttpSession session = req.getSession();
        User tempUser = (User) session.getAttribute("tempUser");
        String authType = (String) session.getAttribute("authType");

        if (tempUser == null || authType == null) {
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Phiên làm việc đã hết hạn.\"}");
            return;
        }

        // 🔹 Tạo lại mã OTP
        int otpValue = 100000 + new Random().nextInt(900000);
        session.setAttribute("otp", String.valueOf(otpValue));
        session.setAttribute("otpTime", System.currentTimeMillis());

        String subject = "register".equals(authType) ? "Mã đăng ký" : "Mã đăng nhập";
        String body = "Xin chào " + tempUser.getFullName()
                + ",<br><br>Mã " + ("register".equals(authType) ? "đăng ký" : "đăng nhập")
                + " của bạn là: <b>" + otpValue + "</b><br>Mã có hiệu lực trong 5 phút.";

        EmailUtil.sendEmail(tempUser.getEmail(), subject, body);
        System.out.println("✅ Gửi lại OTP " + authType + ": " + otpValue);

        resp.getWriter().write("{\"status\":\"success\",\"message\":\"Mã OTP mới đã được gửi đến email của bạn!\"}");
    }
}
