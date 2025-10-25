/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ContractDao;
import dao.ProductDao;
import dao.CustomerDao;
import entity.Contract;
import entity.Product;
import entity.Customer;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/ContractManagementServlet")
public class ContractManagementServlet extends HttpServlet {

    private ContractDao contractDao;
    private CustomerDao customerDao;
    private ProductDao productDao;

    @Override
    public void init() {
        contractDao = new ContractDao();
        customerDao = new CustomerDao();
        productDao = new ProductDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        try {
            switch (action) {
                case "list":
                    listContracts(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("renew".equalsIgnoreCase(action)) {
                int contractId = Integer.parseInt(request.getParameter("contractId")); 
                int renewYears = Integer.parseInt(request.getParameter("renewYears"));
                ContractDao dao = new ContractDao();
                dao.renewContract(contractId, renewYears);
                response.sendRedirect(request.getContextPath() + "/ContractManagementServlet?action=list");
            } else {
                updateContract(request, response, action);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void updateContract(HttpServletRequest request, HttpServletResponse response, String action)
            throws Exception {
        int contractId = Integer.parseInt(request.getParameter("contractId"));
        if (action.equalsIgnoreCase("approve")) {
            contractDao.updateStatus(contractId, "Active");
        } else if (action.equalsIgnoreCase("renew")) {
            contractDao.updateStatus(contractId, "Active");
        } else if (action.equalsIgnoreCase("cancel")) {
            contractDao.updateStatus(contractId, "Cancelled");
        }

        response.sendRedirect(request.getContextPath() + "/ContractManagementServlet?action=list");
    }

    private void listContracts(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Contract> contractList = contractDao.getAllContracts();
        List<Customer> customerList = customerDao.getAllCustomers();
        List<Product> productList = productDao.getAllProducts();
        request.setAttribute("contractList", contractList);
        request.setAttribute("customerList", customerList);
        request.setAttribute("productList", productList);
        request.getRequestDispatcher("/contractmanagement.jsp").forward(request, response);
    }

}
