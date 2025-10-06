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

        List<Contract> contracts = dao.getAllContracts();

        // Gán dữ liệu sang JSP
        request.setAttribute("contracts", contracts);

        // Forward sang contractDetails.jsp
        RequestDispatcher rd = request.getRequestDispatcher("contractDetail.jsp");
        rd.forward(request, response);
    }
}
