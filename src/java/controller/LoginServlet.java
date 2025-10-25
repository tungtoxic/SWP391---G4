/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDao;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    // --- THAY ĐỔI 1: ĐỊNH NGHĨA HẰNG SỐ CHO VAI TRÒ ---
    // Giúp code dễ đọc và dễ bảo trì hơn
    private static final int ROLE_AGENT = 1;
    private static final int ROLE_MANAGER = 2;
    private static final int ROLE_ADMIN = 3;

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

        User user = userDAO.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            try {
                boolean activated = userDAO.activateUserById(user.getUserId());
            } catch (SQLException e) {
                e.printStackTrace();
            }

            switch (user.getRoleId()) {
                case ROLE_AGENT:
                    response.sendRedirect(request.getContextPath() + "/agent/dashboard");
                    break;
                case ROLE_MANAGER:
                    response.sendRedirect("ManagerDashboard.jsp");
                    break;
                case ROLE_ADMIN:
                    response.sendRedirect("AdminDashboard.jsp");
                    break;
                default:
                    response.sendRedirect("home.jsp");
                    break;
            }
        } else {
            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

}
