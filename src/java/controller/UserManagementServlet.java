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
import java.io.IOException;
import java.io.PrintWriter;

/**
 *
 * @author hoang
 */
@WebServlet(name = "AdminManagementServlet", urlPatterns = {"/admin/management"})
public class UserManagementServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminManagementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminManagementServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private UserDao userDao;
    private static final String PASSWORD_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%!";

    @Override
    public void init() {
        userDao = new UserDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    int id = Integer.parseInt(idStr);
                    userDao.deleteUser(id);
                }
                response.sendRedirect(request.getContextPath() + "/usermanagement.jsp");

            } else if ("edit".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isEmpty()) {
                    int id = Integer.parseInt(idStr);
                    User user = userDao.getUserById(id);
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/editUser.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/usermanagement.jsp");
                }

            } else {
                // default redirect nếu action khác
                response.sendRedirect(request.getContextPath() + "/usermanagement.jsp");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        processRequest(request, response);

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
          if ("edit".equals(action)) {
                handleUpdateUser(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/usermanagement.jsp");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    
    private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int userId = Integer.parseInt(request.getParameter("userId"));
        String username = request.getParameter("username").trim();
        String fullName = request.getParameter("fullName").trim();
        String email = request.getParameter("email").trim();
        String phone = request.getParameter("phoneNumber").trim();
        int roleId = Integer.parseInt(request.getParameter("role_id"));
        String status = request.getParameter("status");

        User user = userDao.getUserById(userId);
        if (user == null) {
            request.setAttribute("error", "Người dùng không tồn tại.");
            request.getRequestDispatcher("/editUser.jsp").forward(request, response);
            return;
        }

        // Kiểm tra trùng email, phone (ngoại trừ user hiện tại)
        if (!user.getEmail().equals(email) && userDao.checkEmailExists(email)) {
            request.setAttribute("error", "Email đã tồn tại.");
            request.getRequestDispatcher("/editUser.jsp").forward(request, response);
            return;
        }

        if (!user.getPhoneNumber().equals(phone) && userDao.isPhoneExists(phone)) {
            request.setAttribute("error", "Số điện thoại đã tồn tại.");
            request.getRequestDispatcher("/editUser.jsp").forward(request, response);
            return;
        }

        user.setUsername(username);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNumber(phone);
        user.setRoleId(roleId);
        user.setStatus(status);

        boolean updated = userDao.updateUser(user);
        if (updated) {
            response.sendRedirect(request.getContextPath() + "/usermanagement.jsp");
        } else {
            request.setAttribute("error", "Cập nhật thất bại.");
            request.getRequestDispatcher("/editUser.jsp").forward(request, response);
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
