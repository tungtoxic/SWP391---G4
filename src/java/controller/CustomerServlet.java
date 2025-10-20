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
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/agent/customer-management"})
public class CustomerServlet extends HttpServlet {

    private CustomerDao customerDao;
    private static final int AGENT_ROLE_ID = 3; 

    @Override
    public void init() throws ServletException {
        this.customerDao = new CustomerDao();
        System.out.println("--- CustomerServlet Initialized ---");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. KIỂM TRA PHÂN QUYỀN VÀ LẤY AGENT ID
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // KHÔNG BẮT BUỘC LỌC ROLE TẠI ĐÂY NẾU MUỐN TEST LẤY FULL DANH SÁCH KHÔNG LỖI
        if (currentUser == null) {
             // Tạm thời bỏ qua Role check, chỉ kiểm tra Session để lấy ID Agent sau
        } else if (currentUser.getRoleId() != AGENT_ROLE_ID) {
            // response.sendRedirect(request.getContextPath() + "/access-denied.jsp"); 
            // return; // Bỏ check role nghiêm ngặt để tiện test
        }
        
        // GIẢ ĐỊNH ID AGENT ĐANG ĐĂNG NHẬP, NHƯNG KHÔNG DÙNG NÓ (VÌ BẠN MUỐN LẤY FULL LIST)
        // int agentId = (currentUser != null) ? currentUser.getUserId() : -1; 

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    // Gọi hàm listCustomers mà không truyền Agent ID
                    listCustomers(request, response);
                    break;
                // [CRUD LOGIC SẼ ĐƯỢC THÊM TẠI ĐÂY SAU]
                default:
                    listCustomers(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace(System.err);
            request.setAttribute("errorMessage", "Lỗi xử lý yêu cầu.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        // Lấy full danh sách khách hàng (như bạn yêu cầu)
        List<Customer> customerList = customerDao.getAllCustomers();
        
        // DEBUG LOG
        System.out.println("--- CUSTOMER MANAGEMENT DEBUG START ---");
        System.out.println("Customers loaded (Total): " + (customerList != null ? customerList.size() : "null"));
        
        if (customerList != null) {
            for (Customer c : customerList) {
                System.out.println("Customer ID: " + c.getCustomerId() + ", Name: " + c.getFullName());
            }
        }
        System.out.println("--- CUSTOMER MANAGEMENT DEBUG END ---");
        
        request.setAttribute("customerList", customerList);
        
        // Đảm bảo đường dẫn JSP là chính xác
        request.getRequestDispatcher("/customerManagerment.jsp").forward(request, response);
    }
}