package controller;
import dao.UserDao;
import dao.ContractDao;
import dao.CommissionDao;
import dao.CommissionPolicyDao;
import entity.ContractDTO;
import entity.User;
import entity.CommissionPolicy;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "ManagerContractServlet", urlPatterns = {"/manager/contracts"})
public class ManagerContractServlet extends HttpServlet {

    private ContractDao contractDao;
    private UserDao userDao;
    private CommissionDao commissionDao;
    private CommissionPolicyDao policyDao;
    private static final int ROLE_MANAGER = 2;

    @Override
    public void init() {
        contractDao = new ContractDao();
        commissionDao = new CommissionDao();
        policyDao = new CommissionPolicyDao();
        userDao = new UserDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Luôn kiểm tra quyền truy cập ở đầu mỗi phương thức
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null || currentUser.getRoleId() != ROLE_MANAGER) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.setAttribute("currentUser", currentUser);
        String action = request.getParameter("action");
        if (action == null) {
            action = "listAll";
        }

        try {
            switch (action) {
                // Thêm các action GET khác của Manager ở đây nếu cần
                case "listPending": // <-- Phải gọi rõ action=listPending mới vào đây
                    listPendingContracts(request, response, currentUser);
                    break;
                case "viewDetail": // <-- THÊM CASE NÀY -->
                    viewContractDetail(request, response, currentUser);
                    break;
                case "listAll": // <-- ADD THIS CASE
                default:
                    listAllContracts(request, response, currentUser);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error processing GET request in ManagerContractServlet",e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (currentUser == null || currentUser.getRoleId() != ROLE_MANAGER) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.setAttribute("currentUser", currentUser);
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        try {
            switch(action) {
                case "approve":
                    approveContract(request, response);
                    break;
                case "reject": // Ví dụ thêm action từ chối
                    rejectContract(request, response);
                    break;
                // Thêm các action POST khác ở đây
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    /**
     * Hiển thị danh sách các hợp đồng đang chờ duyệt.
     */
    private void listPendingContracts(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws Exception {
        int managerId = currentUser.getUserId();
        List<ContractDTO> pendingList = contractDao.getPendingContractsByManagerId(managerId);
        request.setAttribute("pendingList", pendingList);
        request.getRequestDispatcher("/manager_approval.jsp").forward(request, response);
    }

    /**
     * Xử lý logic khi Manager duyệt một hợp đồng.
     */
    private void approveContract(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        int contractId = Integer.parseInt(request.getParameter("contractId"));
        
        // Bước 1: Cập nhật trạng thái hợp đồng thành "Active"
        boolean updateSuccess = contractDao.updateContractStatus(contractId, "Active");
        
        // Bước 2: Tự động tạo hoa hồng nếu cập nhật thành công
        if (updateSuccess) {
            ContractDTO contract = contractDao.getContractById(contractId);
            CommissionPolicy currentPolicy = policyDao.getCurrentPolicy();

            if (contract != null && currentPolicy != null) {
                // Tính hoa hồng dựa trên tỷ lệ động từ CSDL
                BigDecimal premium = contract.getPremiumAmount();
                BigDecimal rate = currentPolicy.getRate().divide(new BigDecimal("100")); // Chuyển 5.00 thành 0.05
                BigDecimal commissionAmount = premium.multiply(rate);
                
                commissionDao.createCommissionForContract(contract, commissionAmount.doubleValue());
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/manager/contracts?message=approveSuccess");
    }
    
    /**
     * Xử lý logic khi Manager từ chối một hợp đồng.
     */
    private void rejectContract(HttpServletRequest request, HttpServletResponse response)
        throws Exception {
        int contractId = Integer.parseInt(request.getParameter("contractId"));
        // Đơn giản là cập nhật trạng thái, Agent sẽ phải tạo lại
        contractDao.updateContractStatus(contractId, "Cancelled");
        response.sendRedirect(request.getContextPath() + "/manager/contracts?message=rejectSuccess");
    }
    private void listAllContracts(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {
        int managerId = currentUser.getUserId();
        List<ContractDTO> allContractsList = contractDao.getAllContractsByManagerId(managerId);
        request.setAttribute("contractList", allContractsList); // Use the same generic name
        request.setAttribute("viewTitle", "All Managed Contracts"); // Different title
        request.setAttribute("isPendingView", false); // Flag for the JSP
        request.getRequestDispatcher("/manager_contract_list.jsp").forward(request, response); // Forward to the NEW JSP
    }
    private void viewContractDetail(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws Exception {
        int contractId = -1;
        try {
             contractId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
             // Xử lý ID không hợp lệ - chuyển hướng hoặc báo lỗi
             response.sendRedirect(request.getContextPath() + "/manager/contracts?message=invalidId");
             return;
        }

        ContractDTO contract = contractDao.getContractById(contractId);

        // Kiểm tra bảo mật: Đảm bảo hợp đồng tồn tại VÀ agent tạo hợp đồng đó thuộc quản lý của manager này
        if (contract == null || !isAgentManagedBy(contract.getAgentId(), currentUser.getUserId())) {
            // Chuyển hướng với thông báo lỗi nếu không tìm thấy hoặc không có quyền
             response.sendRedirect(request.getContextPath() + "/manager/contracts?message=AuthError");
             return;
        }

        // Đặt attribute cho trang chi tiết
        request.setAttribute("contractDetail", contract);
        // Đặt activePage là "detail" hoặc giữ nguyên trang list ("all"/"pending")? Tạm dùng "detail".
        request.setAttribute("activePage", "detail");
        // currentUser đã được set ở doGet

        // Forward đến trang JSP chi tiết mới
        request.getRequestDispatcher("/manager_contract_detail.jsp").forward(request, response);
    }
    private boolean isAgentManagedBy(int agentId, int managerId) {
        // Nếu bạn chưa có UserDao hoặc phương thức đó, bạn cần truy vấn trực tiếp bảng Manager_Agent
        // Tạm giả định UserDao có phương thức này:
        List<User> managedAgents = userDao.getAgentsByManagerId(managerId); // Bạn cần tạo phương thức này trong UserDao
        if (managedAgents == null) return false; // Xử lý lỗi nếu DAO trả về null
        for (User agent : managedAgents) {
            if (agent.getUserId() == agentId) {
                return true;
            }
        }
        return false;
    }
}