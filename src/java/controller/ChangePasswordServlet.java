package controller;

import dao.UserDao;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import utility.PasswordUtils;
@WebServlet("/ChangePassword")
public class ChangePasswordServlet extends HttpServlet {

    private UserDao userDao; // khai báo

    @Override
    public void init() throws ServletException {
        userDao = new UserDao(); // khởi tạo
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
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
            if (PasswordUtils.verifyPassword(oldPassword, user.getPasswordHash())) {
                String newHash = PasswordUtils.hashPassword(newPassword);
                userDao.updatePassword(user.getId(), newHash); // ✅ bây giờ chạy được
                request.setAttribute("message", "Đổi mật khẩu thành công!");
            } else {
                request.setAttribute("error", "Mật khẩu cũ không đúng!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại.");
        }
        request.getRequestDispatcher("changePassword.jsp").forward(request, response);
    }
}
