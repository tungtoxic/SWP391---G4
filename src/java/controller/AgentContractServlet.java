package controller;

import dao.ContractDao;
import dao.CustomerDao;
import dao.ProductDao;
import entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AgentContractServlet", urlPatterns = {"/agent/contracts"})
public class AgentContractServlet extends HttpServlet {

    private ContractDao contractDao;
    private CustomerDao customerDao;
    private ProductDao productDao;
    private static final int ROLE_AGENT = 1;

    @Override
    public void init() {
        contractDao = new ContractDao();
        customerDao = new CustomerDao();
        productDao = new ProductDao();
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

        // ===== SỬA LỖI: Gửi currentUser sang JSP =====
        request.setAttribute("currentUser", currentUser);
        // ============================================

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "showAddForm":
                    showAddForm(request, response, currentUser);
                    break;
                case "showEditForm": // THÊM MỚI
                    showEditForm(request, response, currentUser);
                    break;
                case "delete": // THÊM MỚI
                    deleteContract(request, response, currentUser);
                    break;

                default:
                    listContracts(request, response, currentUser);
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
        
        // ===== SỬA LỖI: Gửi currentUser sang JSP (cho trường hợp update lỗi) =====
        request.setAttribute("currentUser", currentUser);
        // ===================================================================

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    insertContract(request, response, currentUser);
                    break;
                case "update":
                    updateContract(request, response, currentUser);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/agent/contracts");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }

    }

    private void listContracts(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {
        List<ContractDTO> contractList = contractDao.getContractsByAgentId(currentUser.getUserId());
        request.setAttribute("contractList", contractList);
        request.getRequestDispatcher("/agent_contract_list.jsp").forward(request, response);
    }

    // MỚI: Hiển thị form thêm mới
    private void showAddForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {
        // Lấy danh sách khách hàng của agent và danh sách sản phẩm để hiển thị trong form
        List<Customer> customerList = customerDao.getAllCustomersByAgentId(currentUser.getUserId());
        List<Product> productList = productDao.getAllProducts(); // Giả định ProductDao có phương thức này

        request.setAttribute("customerList", customerList);
        request.setAttribute("productList", productList);
        // (Không cần set currentUser nữa vì đã làm ở doGet)
        request.getRequestDispatcher("/agent_add_contract.jsp").forward(request, response);
    }

    // MỚI: Xử lý logic thêm mới
private void insertContract(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {

        // 1. Lấy 3 input "sạch" từ Agent
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        int productId = Integer.parseInt(request.getParameter("productId"));
        Date startDate = Date.valueOf(request.getParameter("startDate")); // java.sql.Date

        // 2. Lấy "Cái khuôn" (Product) để lấy "luật"
        Product product = productDao.getProductById(productId);

        // 3. Xử lý lỗi nếu không tìm thấy "khuôn"
        if (product == null) {
            // Nếu "khuôn" không tồn tại, quay lại form với thông báo lỗi
            request.setAttribute("errorMessage", "Lỗi: Sản phẩm không tồn tại.");
            showAddForm(request, response, currentUser); // Tải lại form
            return;
        }

        // 4. TỰ ĐỘNG HÓA (Automation) - Áp dụng "luật" từ "khuôn"
        BigDecimal premiumAmount = product.getBasePrice(); // <-- Tự động lấy giá
        int durationMonths = product.getDurationMonths(); // <-- Tự động lấy thời hạn

        // Tính toán ngày kết thúc (endDate)
        LocalDate localEndDate = startDate.toLocalDate().plusMonths(durationMonths);
        Date endDate = Date.valueOf(localEndDate); // Chuyển về java.sql.Date

        // 5. Tạo "Cái bánh" (Contract) đã được "chuẩn hóa"
        Contract newContract = new Contract();
        newContract.setCustomerId(customerId);
        newContract.setProductId(productId);
        newContract.setStartDate(startDate);
        newContract.setAgentId(currentUser.getUserId());
        newContract.setStatus("Pending"); // Hợp đồng mới luôn là Pending

        // 6. Set 2 trường TỰ ĐỘNG TÍNH TOÁN
        newContract.setPremiumAmount(premiumAmount);
        newContract.setEndDate(endDate);

        // 7. Lưu vào CSDL
        contractDao.insertContract(newContract);
        response.sendRedirect(request.getContextPath() + "/agent/contracts?message=AddSuccess");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        ContractDTO existingContract = contractDao.getContractById(id);

        // Bảo mật: Đảm bảo agent chỉ sửa hợp đồng của mình và hợp đồng đó phải là Pending
        if (existingContract != null && existingContract.getAgentId() == currentUser.getUserId() && "Pending".equals(existingContract.getStatus())) {
            List<Customer> customerList = customerDao.getAllCustomersByAgentId(currentUser.getUserId());
            List<Product> productList = productDao.getAllProducts();

            request.setAttribute("contract", existingContract);
            request.setAttribute("customerList", customerList);
            request.setAttribute("productList", productList);
            // (Không cần set currentUser nữa vì đã làm ở doGet)
            request.getRequestDispatcher("/agent_edit_contract.jsp").forward(request, response);
        } else {
            // Nếu không đủ quyền, đá về trang danh sách
            response.sendRedirect(request.getContextPath() + "/agent/contracts?message=AuthError");
        }
    }

    private void updateContract(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {

        int contractId = Integer.parseInt(request.getParameter("contractId"));

        // Bảo mật: Kiểm tra quyền sở hữu TRƯỚC KHI làm bất cứ điều gì
        ContractDTO existingContract = contractDao.getContractById(contractId);
        if (existingContract == null || existingContract.getAgentId() != currentUser.getUserId() || !"Pending".equals(existingContract.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/agent/contracts?message=AuthError");
            return;
        }

        // 1. Lấy 3 input "sạch" từ Agent
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        int productId = Integer.parseInt(request.getParameter("productId"));
        Date startDate = Date.valueOf(request.getParameter("startDate"));

        // 2. Lấy "Cái khuôn" (Product) để lấy "luật"
        Product product = productDao.getProductById(productId);

        // 3. Xử lý lỗi nếu không tìm thấy "khuôn"
        if (product == null) {
            request.setAttribute("error", "Lỗi: Sản phẩm không tồn tại.");
            showEditForm(request, response, currentUser); // Tải lại form edit
            return;
        }

        // 4. TỰ ĐỘNG HÓA (Automation) - Áp dụng "luật" từ "khuôn"
        BigDecimal premiumAmount = product.getBasePrice(); // <-- Tự động lấy giá
        int durationMonths = product.getDurationMonths(); // <-- Tự động lấy thời hạn
        
        // Tính toán ngày kết thúc (endDate)
        LocalDate localEndDate = startDate.toLocalDate().plusMonths(durationMonths);
        Date endDate = Date.valueOf(localEndDate); // Chuyển về java.sql.Date

        // 5. Tạo "Cái bánh" (Contract) đã được "chuẩn hóa"
        Contract contractToUpdate = new Contract();
        contractToUpdate.setContractId(contractId); // ID của HĐ cũ
        contractToUpdate.setCustomerId(customerId);
        contractToUpdate.setProductId(productId);
        contractToUpdate.setStartDate(startDate);
        contractToUpdate.setAgentId(currentUser.getUserId());
        contractToUpdate.setStatus("Pending"); // Vẫn là Pending

        // 6. Set 2 trường TỰ ĐỘNG TÍNH TOÁN
        contractToUpdate.setPremiumAmount(premiumAmount);
        contractToUpdate.setEndDate(endDate);

        // 7. Cập nhật CSDL
        boolean success = contractDao.updateContract(contractToUpdate);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/agent/contracts?message=UpdateSuccess");
        } else {
            // Nếu lỗi, setAttribute lỗi và forward lại
            request.setAttribute("error", "Cập nhật thất bại, vui lòng thử lại.");
            showEditForm(request, response, currentUser);
        }
    }

    private void deleteContract(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));

        // Bảo mật: Kiểm tra quyền sở hữu trước khi xóa
        ContractDTO existingContract = contractDao.getContractById(id);
        if (existingContract != null && existingContract.getAgentId() == currentUser.getUserId() && "Pending".equals(existingContract.getStatus())) {
            contractDao.deleteContract(id);
            response.sendRedirect(request.getContextPath() + "/agent/contracts?message=DeleteSuccess");
        } else {
            response.sendRedirect(request.getContextPath() + "/agent/contracts?message=AuthError");
        }
    }
}