/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDao;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/VerifyServlet")
public class VerifyServlet extends HttpServlet {

    private final UserDao userDAO = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String inputOtp = req.getParameter("otp");
        String otp = (String) session.getAttribute("otp");
        Long otpTime = (Long) session.getAttribute("otpTime");
        User tempUser = (User) session.getAttribute("tempUser");
        String authType = (String) session.getAttribute("authType");

        if (otp == null || otpTime == null || tempUser == null || authType == null) {
            req.setAttribute("error", "Phiên làm việc đã hết hạn, vui lòng đăng nhập lại.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

    
        long diff = System.currentTimeMillis() - otpTime;
        if (otp.equals(inputOtp) && diff <= 5 * 60 * 1000) {
            if ("register".equals(authType)) {
                try {
                    boolean inserted = userDAO.insertUser(tempUser);
                    if (inserted) {
                        cleanup(session);
                        session.setAttribute("user", tempUser);
                        resp.sendRedirect("home.jsp");
                        return;
                    } else {
                        req.setAttribute("error", "Không thể lưu tài khoản, vui lòng thử lại.");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                }
            } else if ("login".equals(authType)) {
                cleanup(session);
                session.setAttribute("user", tempUser);

                int roleId = tempUser.getRoleId();
                switch (roleId) {
                    case 1:
                        resp.sendRedirect("AgentDashboard.jsp");
                        break;
                    case 2:
                        resp.sendRedirect("ManagementDashboard.jsp");
                        break;
                    case 3:
                        resp.sendRedirect("AdminDashboard.jsp");
                        break;

                    default:
                        resp.sendRedirect("profile.jsp");
                }
                return;
            }
        } else {
            req.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn.");
        }

        req.getRequestDispatcher("verify.jsp").forward(req, resp);
    }

    private void cleanup(HttpSession session) {
        session.removeAttribute("otp");
        session.removeAttribute("otpTime");
        session.removeAttribute("authType");
        session.removeAttribute("tempUser");
    }
}

