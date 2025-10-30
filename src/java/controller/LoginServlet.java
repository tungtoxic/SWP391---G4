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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

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

            switch (user.getRoleId()) {
                case ROLE_AGENT:
                    response.sendRedirect(request.getContextPath() + "/agent/dashboard");
                    break;
                case ROLE_MANAGER:
                    response.sendRedirect("manager/dashboard");
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