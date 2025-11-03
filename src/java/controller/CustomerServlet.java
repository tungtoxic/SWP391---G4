package controller;

import dao.CustomerDao;
import entity.Customer;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/agent/customers"})
public class CustomerServlet extends HttpServlet {

    private CustomerDao customerDao;
    private static final int ROLE_AGENT = 1;

    @Override
    public void init() {
        customerDao = new CustomerDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null || currentUser.getRoleId() != ROLE_AGENT) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
    if (action == null) {
        action = "list";
    }

    try {
        switch (action) {
            case "showAddForm":
                showAddForm(request, response);
                break;
            case "showEditForm":
                showEditForm(request, response, currentUser);
                break;
            case "delete":
                deleteCustomer(request, response, currentUser);
                break;
                
            // THÊM CASE NÀY VÀO
            case "updateType": 
                updateCustomerType(request, response, currentUser);
                break;
                
            default:
                listCustomers(request, response, currentUser);
                break;
        }
    } catch (Exception e) {
        throw new ServletException(e);
    }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null || currentUser.getRoleId() != ROLE_AGENT) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        try {
            switch (action) {
                case "add":
                    insertCustomer(request, response, currentUser);
                    break;
                case "update":
                    updateCustomer(request, response, currentUser);
                    break;
                case "updateType": 
                    updateCustomerType(request, response, currentUser);
                    break;
                default:
                    listCustomers(request, response, currentUser);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // ========== CÁC PHƯƠNG THỨC XỬ LÝ LOGIC ==========

    private void listCustomers(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws SQLException, ServletException, IOException {
        int agentId = currentUser.getUserId();
        List<Customer> customerList = customerDao.getAllCustomersByAgentId(agentId);
        request.setAttribute("customerList", customerList);
        request.getRequestDispatcher("/customerManagerment.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/addCustomer.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Customer existingCustomer = customerDao.getCustomerById(id);
        
        // Đảm bảo agent chỉ sửa được khách hàng của mình
        if (existingCustomer != null && existingCustomer.getCreatedBy() == currentUser.getUserId()) {
            request.setAttribute("customer", existingCustomer);
            request.getRequestDispatcher("/editCustomer.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/agent/customers?message=AuthError");
        }
    }

    private void insertCustomer(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws SQLException, IOException {
        String fullName = request.getParameter("fullName");
        Date dateOfBirth = Date.valueOf(request.getParameter("dateOfBirth"));
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        Customer newCustomer = new Customer();
        newCustomer.setFullName(fullName);
        newCustomer.setDateOfBirth(dateOfBirth);
        newCustomer.setPhoneNumber(phone);
        newCustomer.setEmail(email);
        newCustomer.setAddress(address);
        newCustomer.setCreatedBy(currentUser.getUserId()); // Gán agent tạo là user đang đăng nhập
        newCustomer.setCustomerType("Lead");

        customerDao.insertCustomer(newCustomer);
        response.sendRedirect(request.getContextPath() + "/agent/customers?message=AddSuccess");
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("customerId"));
        String fullName = request.getParameter("fullName");
        Date dateOfBirth = Date.valueOf(request.getParameter("dateOfBirth"));
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        Customer customer = new Customer();
        customer.setCustomerId(id);
        customer.setFullName(fullName);
        customer.setDateOfBirth(dateOfBirth);
        customer.setPhoneNumber(phone);
        customer.setEmail(email);
        customer.setAddress(address);
        customer.setCreatedBy(currentUser.getUserId()); // Dù không update nhưng cần để kiểm tra quyền

        // Tương tự showEditForm, cần kiểm tra quyền trước khi update
        Customer existingCustomer = customerDao.getCustomerById(id);
        if (existingCustomer != null && existingCustomer.getCreatedBy() == currentUser.getUserId()) {
            customerDao.updateCustomer(customer);
            response.sendRedirect(request.getContextPath() + "/agent/customers?message=UpdateSuccess");
        } else {
            response.sendRedirect(request.getContextPath() + "/agent/customers?message=AuthError");
        }
    }

    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        Customer existingCustomer = customerDao.getCustomerById(id);
        if (existingCustomer != null && existingCustomer.getCreatedBy() == currentUser.getUserId()) {
            customerDao.deleteCustomer(id);
            response.sendRedirect(request.getContextPath() + "/agent/customers?message=DeleteSuccess");
        } else {
            response.sendRedirect(request.getContextPath() + "/agent/customers?message=AuthError");
        }
    }
    private void updateCustomerType(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String type = request.getParameter("type");

            // Validate type để tránh injection linh tinh
            if (type != null && (type.equals("Lead") || type.equals("Client"))) {
                boolean success = customerDao.updateCustomerType(id, type, currentUser.getUserId());
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/agent/customers?message=TypeUpdateSuccess");
                } else {
                    // Thất bại (có thể do cố update khách của agent khác)
                    response.sendRedirect(request.getContextPath() + "/agent/customers?message=AuthError");
                }
            } else {
                // Type không hợp lệ
                response.sendRedirect(request.getContextPath() + "/agent/customers?message=Error");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/agent/customers?message=Error");
        }
    }
}