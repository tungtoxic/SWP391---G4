package controller;

import entity.User;
import dao.UserDao; // nếu bạn có UserDAO
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNumber");

        currentUser.setFullName(fullName);
        currentUser.setEmail(email);
        currentUser.setPhoneNumber(phone);

        boolean updateSuccess = false;

        try {
            UserDao userDAO = new UserDao();
            updateSuccess = userDAO.updateUser(currentUser);
        } catch (Exception e) {
            e.printStackTrace();
        }

        session.setAttribute("user", currentUser);

        if (updateSuccess) {
            request.setAttribute("message", "Profile updated successfully!");
        } else {
            request.setAttribute("message", "Update failed. Please try again.");
        }

        RequestDispatcher rd = request.getRequestDispatcher("profile.jsp");
        rd.forward(request, response);
    }
}