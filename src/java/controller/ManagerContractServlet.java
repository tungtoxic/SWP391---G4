package controller;

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
    private CommissionDao commissionDao;
    private CommissionPolicyDao policyDao;
    private static final int ROLE_MANAGER = 2;

    @Override
    public void init() {
        contractDao = new ContractDao();
        commissionDao = new CommissionDao();
        policyDao = new CommissionPolicyDao();
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

        String action = request.getParameter("action");
        if (action == null) {
            action = "listPending";
        }

        try {
            switch (action) {
                // Thêm các action GET khác của Manager ở đây nếu cần
                default:
                    listPendingContracts(request, response, currentUser);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
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
}