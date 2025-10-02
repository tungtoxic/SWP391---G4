/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.*;
import entity.Agent;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewAgents")
public class ViewAgentsServlet extends HttpServlet {

    private AgentDAO agentDAO;

    @Override
    public void init() throws ServletException {
        agentDAO = new AgentDAO(); // tạo DAO khi servlet khởi chạy
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        agentDAO = new AgentDAO();
        try {
            // gọi DAO để lấy danh sách agents
            List<Agent> agents = agentDAO.getAllAgents();

            // gửi dữ liệu qua JSP
            request.setAttribute("agents", agents);
            request.getRequestDispatcher("viewAgents.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Lỗi khi lấy danh sách agents", e);
        }
    }
   


    public static void main(String[] args) {
        AgentDAO dao = new AgentDAO();
        try {
            List<Agent> agents = dao.getAllAgents();
            if (agents.isEmpty()) {
                System.out.println("⚠ Không có agent nào trong database.");
            } else {
                System.out.println("Danh sách Agents:");
                for (Agent a : agents) {
                    System.out.println(
                        a.getUserId() + " | " +
                        a.getUsername() + " | " +
                        a.getFullName() + " | " +
                        a.getEmail() + " | " +
                        a.getPhoneNumber() + " | " +
                        a.getStatus()
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
