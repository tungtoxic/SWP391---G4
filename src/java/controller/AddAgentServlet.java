/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;


import dao.AgentDAO;
import entity.Agent;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/addAgent")
public class AddAgentServlet extends HttpServlet {

    private AgentDAO agentDAO;

    @Override
    public void init() throws ServletException {
        agentDAO = new AgentDAO();
    }

    // Hiển thị form + danh sách agent
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Agent> agents = agentDAO.getAllAgents();
        req.setAttribute("agents", agents);

        req.getRequestDispatcher("addAgent.jsp").forward(req, resp);
    }

    // Xử lý thêm agent
@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    req.setCharacterEncoding("UTF-8");

    String username = req.getParameter("username");
    String password = req.getParameter("password");
    String fullName = req.getParameter("full_name");
    String email = req.getParameter("email");
    String phone = req.getParameter("phone_number");

    AgentDAO dao = new AgentDAO();
    boolean success = dao.addAgent(username, password, fullName, email, phone);

    if (success) {
        // Dùng redirect để tránh bị submit lại khi F5
        resp.sendRedirect("addAgent?message=success");
    } else {
        req.setAttribute("message", "❌ Thêm Agent thất bại!");
        req.getRequestDispatcher("addAgent.jsp").forward(req, resp);
    }
}
}