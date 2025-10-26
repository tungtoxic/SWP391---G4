<%-- 
    Document   : manager_contract_detail
    Created on : Oct 25, 2025, 1:29:52 PM
    Author     : Nguyễn Tùng
--%>
<%-- manager_contract_detail.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.*, java.text.*, java.util.Date" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser"); // Lấy user
    ContractDTO contract = (ContractDTO) request.getAttribute("contractDetail"); // Lấy chi tiết HĐ
    Customer customerDetail = (Customer) request.getAttribute("customerDetail");
    // Xác định activePage cho sidebar (có thể là "all", "pending", hoặc "detail")
    // Tạm để là "detail", bạn có thể truyền giá trị từ trang list qua nếu muốn highlight đúng mục
    String activePage = "detail";

    // Formatters
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

    // Xử lý trường hợp contract bị null (Servlet nên chặn trường hợp này)
    if (contract == null) {
        response.sendRedirect(ctx + "/manager/contracts?message=notFound");
        return;
    }
    if (customerDetail == null) {
        customerDetail = new Customer();
        customerDetail.setFullName(contract.getCustomerName() + " (Details not found)"); // Ghi chú tạm
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết Hợp đồng #<%= contract.getContractId() %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
    <style>
        .detail-label { font-weight: bold; color: #555; margin-bottom: 0.2rem; }
        .detail-value { margin-bottom: 1rem; font-size: 1.05rem; }
        .status-badge { font-size: 1rem; padding: 0.5em 0.75em; }
        hr { margin-top: 0.5rem; margin-bottom: 1rem; }
    </style>
</head>
<body>

    <%@ include file="manager_navbar.jsp" %>
    <%@ include file="manager_sidebar.jsp" %>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-3">
                 <h1 class="mb-0">Chi tiết Hợp đồng: #<%= contract.getContractId() %></h1>
                 <%-- Nút quay lại danh sách --%>
                 <a href="<%= ctx %>/manager/contracts?action=listAll" class="btn btn-outline-secondary">
                     <i class="fas fa-arrow-left me-1"></i> Quay lại Danh sách
                 </a>
            </div>

            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="row">
                        <%-- Cột 1: Thông tin Khách hàng & Agent --%>
<div class="col-md-4 border-end">
                            <h5><i class="fas fa-user-tie me-2 text-primary"></i>Khách hàng & Agent</h5>
                            <hr>
                            <p class="detail-label">Tên Khách hàng:</p>
                            <p class="detail-value">
                                <i class="fas fa-user me-1 text-muted"></i> <%= customerDetail.getFullName() %>
                            </p>

                            <p class="detail-label">Số điện thoại:</p>
                            <p class="detail-value">
                                <i class="fas fa-phone me-1 text-muted"></i> <%= customerDetail.getPhoneNumber() != null ? customerDetail.getPhoneNumber() : "N/A" %>
                            </p>

                             <p class="detail-label">Email:</p>
                            <p class="detail-value">
                                <i class="fas fa-envelope me-1 text-muted"></i> <%= customerDetail.getEmail() != null ? customerDetail.getEmail() : "N/A" %>
                            </p>

                             <p class="detail-label">Địa chỉ:</p>
                            <p class="detail-value">
                                <i class="fas fa-map-marker-alt me-1 text-muted"></i> <%= customerDetail.getAddress() != null ? customerDetail.getAddress() : "N/A" %>
                            </p>

                            <hr style="margin-top: 1.5rem; margin-bottom: 1rem;"> <%-- Ngăn cách KH và Agent --%>

                            <p class="detail-label">Agent phụ trách:</p>
                            <p class="detail-value">
                                <i class="fas fa-user-shield me-1 text-muted"></i> <%= contract.getAgentName() %>
                            </p>
                             <%-- Có thể thêm SĐT/Email Agent nếu cần --%>
                        </div>
                        <%-- Cột 2: Thông tin Hợp đồng & Sản phẩm --%>
                        <div class="col-md-4 border-end">
                            <h5><i class="fas fa-file-contract me-2 text-primary"></i>Hợp đồng & Sản phẩm</h5>
                            <hr>
                            <p class="detail-label">Tên Sản phẩm:</p>
                            <p class="detail-value"><%= contract.getProductName() %></p>

                            <p class="detail-label">Phí bảo hiểm:</p>
                            <p class="detail-value fs-5 text-success fw-bold"><%= currencyFormat.format(contract.getPremiumAmount()) %></p>

                            <p class="detail-label">Ngày bắt đầu:</p>
                            <p class="detail-value"><%= contract.getStartDate() != null ? dateFormat.format(contract.getStartDate()) : "N/A" %></p>

                            <p class="detail-label">Ngày kết thúc:</p>
                            <p class="detail-value"><%= contract.getEndDate() != null ? dateFormat.format(contract.getEndDate()) : "N/A" %></p>

                             <p class="detail-label">Ngày tạo:</p>
                             <p class="detail-value"><%= contract.getCreatedAt() != null ? dateTimeFormat.format(contract.getCreatedAt()) : "N/A" %></p>

                        </div>

                        <%-- Cột 3: Trạng thái & Hành động --%>
                        <div class="col-md-4">
                             <h5><i class="fas fa-info-circle me-2 text-primary"></i>Trạng thái & Hành động</h5>
                             <hr>
                             <p class="detail-label">Trạng thái hiện tại:</p>
                             <p class="detail-value">
                                 <%-- Huy hiệu trạng thái --%>
                                <span class="badge status-badge
                                    <% if("Active".equals(contract.getStatus())) out.print("bg-success");
                                       else if("Pending".equals(contract.getStatus())) out.print("bg-warning text-dark");
                                       else if("Expired".equals(contract.getStatus())) out.print("bg-secondary");
                                       else if("Cancelled".equals(contract.getStatus())) out.print("bg-danger");
                                       else out.print("bg-dark"); %>
                                "><%= contract.getStatus() %></span>
                             </p>

                             <%-- Chỉ hiển thị nút Duyệt/Từ chối nếu trạng thái là Pending --%>
                             <% if ("Pending".equals(contract.getStatus())) { %>
                                 <p class="detail-label mt-4">Hành động:</p>
                                 <div class="d-flex gap-2">
                                     <form action="<%=ctx%>/manager/contracts" method="post" class="d-inline-block">
                                         <input type="hidden" name="action" value="approve">
                                         <input type="hidden" name="contractId" value="<%= contract.getContractId() %>">
                                         <button type="submit" class="btn btn-success" onclick="return confirm('Duyệt hợp đồng #<%= contract.getContractId() %>?')">
                                             <i class="fa fa-check me-1"></i> Duyệt
                                         </button>
                                     </form>
                                     <form action="<%=ctx%>/manager/contracts" method="post" class="d-inline-block">
                                         <input type="hidden" name="action" value="reject">
                                         <input type="hidden" name="contractId" value="<%= contract.getContractId() %>">
                                         <button type="submit" class="btn btn-danger" onclick="return confirm('Từ chối hợp đồng #<%= contract.getContractId() %>?');">
                                             <i class="fa fa-times me-1"></i> Từ chối
                                         </button>
                                     </form>
                                 </div>
                             <% } %>

                             <%-- Thêm các hành động khác sau này, ví dụ: nút Hủy HĐ Active --%>

                        </div>
                    </div> <%-- Kết thúc .row --%>
                </div> <%-- Kết thúc .card-body --%>
            </div> <%-- Kết thúc .card --%>

        </div> <%-- Kết thúc .container-fluid --%>
    </main>

    <%-- Include Bootstrap JS --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <%-- Script sidebar đã được include trong manager_sidebar.jsp --%>
</body>
</html>