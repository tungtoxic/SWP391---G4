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
import java.util.List;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/agent/customer-management"})
public class CustomerServlet extends HttpServlet {

    private CustomerDao customerDao;
    private static final int AGENT_ROLE_ID = 3; // Giả định Role ID của Agent là 3

    @Override
    public void init() throws ServletException {
        this.customerDao = new CustomerDao();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. KIỂM TRA PHÂN QUYỀN VÀ LẤY AGENT ID
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || currentUser.getRoleId() != AGENT_ROLE_ID) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int agentId = currentUser.getUserId();

        // 2. XỬ LÝ ACTION (Hiển thị danh sách là action mặc định)
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listCustomers(request, response, agentId);
                    break;
                // case "add": // Xử lý Add Form (sẽ làm sau)
                // case "edit": // Xử lý Edit Form (sẽ làm sau)
                // case "delete": // Xử lý Delete (sẽ làm sau)
                default:
                    listCustomers(request, response, agentId);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi CSDL hoặc hệ thống.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response, int agentId)
            throws ServletException, IOException {
        
        List<Customer> customerList = customerDao.getAllCustomersByAgentId(agentId);
        
        request.setAttribute("customerList", customerList);
        // Chuyển tiếp đến View JSP
        request.getRequestDispatcher("/customerManagerment.jsp").forward(request, response);
    }
}