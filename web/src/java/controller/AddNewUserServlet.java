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
import java.security.SecureRandom;
import utility.EmailUtil;
import utility.PasswordUtils;

/**
 *
 * @author hoang
 */
@WebServlet(name="AddNewUserServlet", urlPatterns={"/addUser"})
public class AddNewUserServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet AddNewUserServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddNewUserServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
//        processRequest(request, response);
 request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                handleAddUser(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/usermanagement.jsp");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // Tạo password ngẫu nhiên
    private String generateRandomPassword(int length) {
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(PASSWORD_CHARS.charAt(random.nextInt(PASSWORD_CHARS.length())));
        }
        return sb.toString();
    }

    private void handleAddUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String username = request.getParameter("username").trim();
        String fullName = request.getParameter("fullName").trim();
        String email = request.getParameter("email").trim();
        String phone = request.getParameter("phoneNumber").trim();
        int roleId = Integer.parseInt(request.getParameter("role_id"));
        String status = request.getParameter("status");

        // Kiểm tra trùng username, email, phone
        if (userDao.isUsernameExists(username)) {
            request.setAttribute("error", "Username đã tồn tại.");
            request.getRequestDispatcher("/addUser.jsp").forward(request, response);
            return;
        }

        if (userDao.checkEmailExists(email)) {
            request.setAttribute("error", "Email đã tồn tại.");
            request.getRequestDispatcher("/addUser.jsp").forward(request, response);
            return;
        }

        if (userDao.isPhoneExists(phone)) {
            request.setAttribute("error", "Số điện thoại đã tồn tại.");
            request.getRequestDispatcher("/addUser.jsp").forward(request, response);
            return;
        }

        // Tạo password ngẫu nhiên 8 ký tự
        String password = generateRandomPassword(8);

        
       // Hash mật khẩu trước khi lưu
        String hashedPassword = PasswordUtils.hashPassword(password);
        // Tạo đối tượng user
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPasswordHash(hashedPassword); // lưu hash vào DB
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPhoneNumber(phone);
        newUser.setRoleId(roleId);
        newUser.setStatus(status);


        boolean inserted = userDao.insertUser(newUser);

        if (inserted) {
            // Gửi mail với password
            String subject = "Thông tin tài khoản của bạn";
            String content = "<p>Chào " + fullName + ",</p>"
                    + "<p>Tài khoản của bạn đã được tạo thành công.</p>"
                    + "<p><b>Username:</b> " + username + "<br>"
                    + "<b>Password:</b> " + password + "</p>"
                    + "<p>Vui lòng đổi mật khẩu sau khi đăng nhập lần đầu.</p>";
            EmailUtil.sendEmail(email, subject, content);

            response.sendRedirect(request.getContextPath() + "/usermanagement.jsp");
        } else {
            request.setAttribute("error", "Thêm user thất bại.");
            request.getRequestDispatcher("/addUser.jsp").forward(request, response);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
