package controller;

import dao.ContractDao;
import entity.Contract;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/contracts")
public class ContractServlet extends HttpServlet {
    private final ContractDao dao = new ContractDao();

   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String agent = request.getParameter("agent");
    String status = request.getParameter("status");
    String keyword = request.getParameter("search");

    ContractDao dao = new ContractDao();
    List<Contract> contracts = dao.getContractsFiltered(agent, status, keyword);

    // Summary
    int totalContracts = dao.countContracts();
    double totalPremium = dao.sumPremium();

    request.setAttribute("contracts", contracts);
    request.setAttribute("totalContracts", totalContracts);
    request.setAttribute("totalPremium", totalPremium);

    RequestDispatcher rd = request.getRequestDispatcher("contractDetail.jsp");
    rd.forward(request, response);
}

}
