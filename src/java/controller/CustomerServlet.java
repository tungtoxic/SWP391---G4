package controller;

import dao.ContractDao;
import dao.CustomerDao;
import dao.InteractionDao; // THÊM MỚI
import dao.InteractionTypeDao; // THÊM MỚI
import entity.Contract;
import entity.Customer;
import entity.Interaction; // THÊM MỚI
import entity.InteractionType; // THÊM MỚI
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
import java.sql.Timestamp; // THÊM MỚI
import java.util.List; // THÊM MỚI

@WebServlet(name = "CustomerServlet", urlPatterns = {"/agent/customers"})
public class CustomerServlet extends HttpServlet {

    private CustomerDao customerDao;
    private InteractionDao interactionDao; // THÊM MỚI
    private InteractionTypeDao interactionTypeDao; // THÊM MỚI
    private ContractDao contractDao;

    private static final int ROLE_AGENT = 1;

    @Override
    public void init() {
        customerDao = new CustomerDao();
        interactionDao = new InteractionDao(); // THÊM MỚI
        interactionTypeDao = new InteractionTypeDao(); // THÊM MỚI
        contractDao = new ContractDao();
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
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("activePage", "customers");
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
                
                // THÊM MỚI: Case để xem trang Chi tiết CRM
                case "viewDetail": 
                    viewCustomerDetail(request, response, currentUser);
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
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("activePage", "customers");
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "add":
                    insertCustomer(request, response, currentUser);
                    break;
                case "update":
                    updateCustomer(request, response, currentUser);
                    break;
                
                // THÊM MỚI: Case để xử lý form "Thêm Tương tác"
                case "addInteraction":
                    addInteraction(request, response, currentUser);
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

    // ========== CÁC PHƯƠNG THỨC XỬ LÝ LOGIC (Giữ nguyên) ==========

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
        newCustomer.setCreatedBy(currentUser.getUserId());
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
        customer.setCreatedBy(currentUser.getUserId()); 

        Customer existingCustomer = customerDao.getCustomerById(id);
        if (existingCustomer != null && existingCustomer.getCreatedBy() == currentUser.getUserId()) {
            customerDao.updateCustomer(customer);
            // THAY ĐỔI: Chuyển hướng về trang chi tiết (nếu bạn muốn) hoặc trang list
            response.sendRedirect(request.getContextPath() + "/agent/customers?action=viewDetail&id=" + id + "&message=UpdateSuccess");
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

            if (type != null && (type.equals("Lead") || type.equals("Client"))) {
                boolean success = customerDao.updateCustomerType(id, type, currentUser.getUserId());
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/agent/customers?message=TypeUpdateSuccess");
                } else {
                    response.sendRedirect(request.getContextPath() + "/agent/customers?message=AuthError");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/agent/customers?message=Error");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/agent/customers?message=Error");
        }
    }
    
    // ========== CÁC PHƯƠNG THỨC CRM MỚI (THÊM MỚI) ==========

    /**
     * THÊM MỚI: Hiển thị trang chi tiết khách hàng (CRM View).
     */
private void viewCustomerDetail(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Customer customer = customerDao.getCustomerById(id);

            // Kiểm tra quyền sở hữu
            if (customer != null && customer.getCreatedBy() == currentUser.getUserId()) {
                // 1. Lấy thông tin chi tiết khách hàng (đã có)
                request.setAttribute("customer", customer);
                
                // 2. Lấy Lịch sử Tương tác (Interaction Log) (đã có)
                List<Interaction> interactionList = interactionDao.getInteractionsByCustomerId(id);
                request.setAttribute("interactionList", interactionList);
                
                // 3. Lấy Danh sách các Loại Tương tác (đã có)
                List<InteractionType> typeList = interactionTypeDao.getAllInteractionTypes();
                request.setAttribute("typeList", typeList);
                
                // 4. THÊM MỚI: Lấy danh sách Hợp đồng của khách hàng này
                List<Contract> contractList = contractDao.getContractsByCustomerId(id);
                request.setAttribute("contractList", contractList); // <-- THÊM DÒNG NÀY
                
                // Forward đến trang JSP
                request.getRequestDispatcher("/customer_detail.jsp").forward(request, response);
                
            } else {
                // Không có quyền
                response.sendRedirect(request.getContextPath() + "/agent/customers?message=AuthError");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/agent/customers?message=Error");
        }
    }
    
    /**
     * THÊM MỚI: Xử lý việc thêm một tương tác mới.
     */
    private void addInteraction(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws SQLException, IOException {
        try {
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            int typeId = Integer.parseInt(request.getParameter("interactionType"));
            String notes = request.getParameter("notes");
            String dateTimeString = request.getParameter("interactionDate"); // "2025-11-03T14:30"
            
            // Chuyển đổi chuỗi "datetime-local" sang java.sql.Timestamp
            // Định dạng "YYYY-MM-DDTHH:mm" -> "YYYY-MM-DD HH:mm:00"
            Timestamp interactionDate = Timestamp.valueOf(dateTimeString.replace("T", " ") + ":00");

            // Kiểm tra quyền sở hữu (Bảo mật: Agent không thể thêm note cho khách của người khác)
            Customer customer = customerDao.getCustomerById(customerId);
            if (customer != null && customer.getCreatedBy() == currentUser.getUserId()) {
                
                // Tạo đối tượng Interaction
                Interaction interaction = new Interaction();
                interaction.setCustomerId(customerId);
                interaction.setAgentId(currentUser.getUserId());
                interaction.setInteractionTypeId(typeId);
                interaction.setNotes(notes);
                interaction.setInteractionDate(interactionDate);

                // Lưu vào CSDL
                interactionDao.addInteraction(interaction);
                
                // Điều hướng về trang chi tiết với thông báo thành công
                response.sendRedirect(request.getContextPath() + "/agent/customers?action=viewDetail&id=" + customerId + "&message=AddInteractionSuccess");
            } else {
                // Không có quyền
                response.sendRedirect(request.getContextPath() + "/agent/customers?message=AuthError");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/agent/customers?message=Error");
        }
    }
}