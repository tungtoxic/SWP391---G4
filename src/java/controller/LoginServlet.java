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

        User user = userDAO.login(username, password);
        HttpSession session = request.getSession();
        if (user != null) {
            session.setAttribute("user", user);
            int roleId = user.getRoleId();
            switch (roleId) {
                case 1:
                    response.sendRedirect("AgentDashboard.jsp");
                    break;
                case 2:
                    response.sendRedirect("ManagerDashboard.jsp");
                    break;
                case 3:
                    response.sendRedirect("AdminDashboard.jsp");
                    break;

                default:
                    response.sendRedirect("profile.jsp");
            }
        } else {
            request.setAttribute("error", "Sai username hoặc password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }

    }
}
