<%-- 
    Document   : agent_edit_contract
    Created on : Oct 22, 2025, 3:42:13 AM
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.*" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser"); // Lấy từ Servlet
    String activePage = (String) request.getAttribute("activePage");
    ContractDTO contract = (ContractDTO) request.getAttribute("contract");
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (contract == null) {
        // Nếu không có hợp đồng (ví dụ: truy cập URL sai), báo lỗi
        request.setAttribute("errorMessage", "Không tìm thấy hợp đồng để sửa.");
        // Không thể dùng forward ở đây, tốt nhất là Servlet đã xử lý
         response.sendRedirect(ctx + "/agent/contracts?message=AuthError");
         return;
    }
    if (customerList == null) customerList = new ArrayList<>();
    if (productList == null) productList = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chỉnh Sửa Hợp đồng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
    <%@ include file="agent_navbar.jsp" %>
    <%@ include file="agent_sidebar.jsp" %>
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Chỉnh Sửa Hợp đồng #<%= contract.getContractId() %></h1>

            <div class="card">
                <div class="card-body">
                    <form action="<%= ctx %>/agent/contracts" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="contractId" value="<%= contract.getContractId() %>">
                        
                        <div class="mb-3">
                            <label for="customerId" class="form-label">Khách hàng</label>
                            <select class="form-select" id="customerId" name="customerId" required>
                                <% if (customerList != null) { 
                                    for (Customer c : customerList) { %>
                                        <option value="<%= c.getCustomerId() %>" <%= c.getCustomerId() == contract.getCustomerId() ? "selected" : "" %>>
                                            <%= c.getFullName() %>
                                        </option>
                                <% } } %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="productId" class="form-label">Sản phẩm bảo hiểm</label>
                            <select class="form-select" id="productId" name="productId" required>
                                <% if (productList != null) { 
                                    for (Product p : productList) { %>
                                        <option value="<%= p.getProductId() %>" <%= p.getProductId() == contract.getProductId() ? "selected" : "" %>>
                                            <%= p.getProductName() %>
                                        </option>
                                <% } } %>
                            </select>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="startDate" class="form-label">Ngày bắt đầu</label>
                                <input type="date" class="form-control" id="startDate" name="startDate" value="<%= contract.getStartDate() %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="premiumAmount" class="form-label">Phí bảo hiểm (VNĐ)</label>
                                <input type="number" class="form-control" id="premiumAmount" name="premiumAmount" step="1000" min="0" value="<%= contract.getPremiumAmount().toBigInteger() %>" required>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">Cập Nhật Hợp đồng</button>
                        <a href="<%= ctx %>/agent/contracts" class="btn btn-secondary">Hủy</a>
                    </form>
                </div>
            </div>
        </div>
    </main>
</body>
</html>