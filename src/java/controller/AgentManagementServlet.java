/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import entity.User;
import dao.UserDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;
import utility.EmailUtil;

@WebServlet(name = "AgentManagementServlet", urlPatterns = {"/AgentManagementServlet"})
public class AgentManagementServlet extends HttpServlet {

    private UserDao userDAO = new UserDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        try {
            if ("activate".equals(action)) {
                activateAgent(request, response);
            } else if ("deactivate".equals(action)) {
                deactivateAgent(request, response);
            } else if ("delete".equals(action)) {
                deleteAgent(request, response);
            } else if ("edit".equals(action)) {
                showEditForm(request, response);
            } else {
                listAgents(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("agentmanagement.jsp").forward(request, response);
        }
    }

    private void listAgents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String statusFilter = request.getParameter("status"); 
        List<User> agentList = userDAO.getUsersByRoleId(1); 
        if (statusFilter != null) {
            agentList = agentList.stream()
                    .filter(u -> u.getStatus().equals(statusFilter))
                    .collect(Collectors.toList());
        }
        request.setAttribute("agentList", agentList);
        request.setAttribute("status", statusFilter);
        request.getRequestDispatcher("agentmanagement.jsp").forward(request, response);
    }

    private void activateAgent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.activateUserById(id); 
        response.sendRedirect("AgentManagementServlet?message=Agent activated successfully!");
    }

    private void deactivateAgent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.deactivateUserById(id); 
        response.sendRedirect("AgentManagementServlet?message=Agent deactivated successfully!");
    }

    private void deleteAgent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.deleteUser(id); 
        response.sendRedirect("AgentManagementServlet?message=Agent delete successfully!");
    }

    private void createAgent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {

        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNumber");

        String tempPassword = UserDao.generateTempPassword(8); 
        User newAgent = new User();
        newAgent.setUsername(username);
        newAgent.setPasswordHash(tempPassword); 
        newAgent.setFullName(fullName);
        newAgent.setEmail(email);
        newAgent.setPhoneNumber(phone);
        newAgent.setStatus("Active");
        newAgent.setRoleId(1); 
        newAgent.setIsFirstLogin(true);
        if (userDAO.checkUsernameExists(username)) {
            request.setAttribute("message", "Username already exists!");
            request.getRequestDispatcher("createAgent.jsp").forward(request, response);
            return;
        }

        if (userDAO.checkEmailExists(email)) {
            request.setAttribute("message", "Email already exists!");
            request.getRequestDispatcher("createAgent.jsp").forward(request, response);
            return;
        }

        boolean success = userDAO.createUser(newAgent);
        if (success) {

            // Gửi email
            
            response.sendRedirect("AgentManagementServlet?message=Agent created & email sent!");
        } else {
            response.sendRedirect("AgentManagementServlet?message=Error creating agent!");
        }
    }

    private void updateAgent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {

        int id = Integer.parseInt(request.getParameter("id"));
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phoneNumber");

        User agent = userDAO.getUserById(id);
        agent.setFullName(fullName);
        agent.setEmail(email);
        agent.setPhoneNumber(phone);

        boolean success = userDAO.updateAgent(agent);
        if (success) {
            response.sendRedirect("AgentManagementServlet?message=Agent updated successfully!");
        } else {
            request.setAttribute("message", "Error updating agent!");
            request.setAttribute("agent", agent);
            request.getRequestDispatcher("editAgent.jsp").forward(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        User existingAgent = userDAO.getUserById(id);
        request.setAttribute("agent", existingAgent);
        request.getRequestDispatcher("editAgent.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("approve".equals(action)) {
                approveAgent(request, response);
                return; 

            } else if ("create".equals(action)) {
                createAgent(request, response);
                return;

            } else if ("edit".equals(action)) {
                updateAgent(request, response);
                return;
            }

  
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("agentmanagement.jsp").forward(request, response);
        }

        response.sendRedirect("AgentManagementServlet");
    }

    private void approveAgent(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User agent = userDAO.getUserById(id);
        agent.setUsername(username);
        agent.setPasswordHash(password); 
        agent.setStatus("Active");

        boolean success = userDAO.updateUser(agent); 
        if (success) {
            EmailUtil.sendEmail(agent.getEmail(),
                    "Thông tin tài khoản",
                    "Xin chào " + agent.getFullName()
                    + ",\nTài khoản của bạn đã được kích hoạt.\n"
                    + "Username: " + username + "\nPassword: " + password);
            response.sendRedirect("AgentManagementServlet?message=Agent approved!");
        } else {
            response.sendRedirect("AgentManagementServlet?message=Error approving agent!");
        }
    }
}
