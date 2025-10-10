package controller;

import dao.UserDao;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ChangePassword")
public class ChangePasswordServlet extends HttpServlet {

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới không trùng khớp!");
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }

        try {
            if (oldPassword.equals(user.getPasswordHash())) {
                boolean ok = userDao.updatePassword(user.getUserId(), newPassword);
                if (ok) {
                    // cập nhật session user
                    user.setPasswordHash(newPassword);
                    session.setAttribute("user", user);

                    // lưu message vào session để hiển thị ở profile sau redirect
                    session.setAttribute("successMsg", "Đổi mật khẩu thành công!");

                    // redirect về profile (home.jsp)
                    response.sendRedirect("home.jsp");
                    return;
                } else {
                    request.setAttribute("error", "Không thể cập nhật mật khẩu vào DB.");
                }
            } else {
                request.setAttribute("error", "Mật khẩu cũ không đúng!");
            }
        } catch (Exception e) {
            e.printStackTrace(); // in stacktrace lên console/tomcat logs
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage()); // tạm hiện lỗi chi tiết cho debug
        }
        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
    }
}
