package controller;

import dao.ContractDAO;
import entity.Contract;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/contracts")
public class ContractDetailsServlet extends HttpServlet {
    private final ContractDAO dao = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Contract> contracts = dao.getAllContracts();
        req.setAttribute("contracts", contracts);
        req.getRequestDispatcher("contractDetails.jsp").forward(req, resp);
    }
}
