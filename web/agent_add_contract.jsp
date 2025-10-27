<%-- 
    Document   : agent_add_contract
    Created on : Oct 22, 2025, 2:41:46 AM
    Author     : Nguyễn Tùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.*" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser"); // Lấy từ Servlet
    String activePage = (String) request.getAttribute("activePage");
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (customerList == null) customerList = new ArrayList<>();
    if (productList == null) productList = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Tạo Hợp đồng mới</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
   <%@ include file="agent_navbar.jsp" %>
    <%@ include file="agent_sidebar.jsp" %>
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Tạo Hợp đồng mới</h1>

            <div class="card">
                <div class="card-body">
                    <form action="<%= ctx %>/agent/contracts" method="post">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label for="customerId" class="form-label">Khách hàng</label>
                            <select class="form-select" id="customerId" name="customerId" required>
                                <option value="">-- Chọn khách hàng --</option>
                                <% if (customerList != null) { 
                                    for (Customer c : customerList) { %>
                                        <option value="<%= c.getCustomerId() %>"><%= c.getFullName() %></option>
                                <% } } %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="productId" class="form-label">Sản phẩm bảo hiểm</label>
                            <select class="form-select" id="productId" name="productId" required>
                                <option value="">-- Chọn sản phẩm --</option>
                                <% if (productList != null) { 
                                    for (Product p : productList) { %>
                                        <option value="<%= p.getProductId() %>"><%= p.getProductName() %></option>
                                <% } } %>
                            </select>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="startDate" class="form-label">Ngày bắt đầu hiệu lực</label>
                                <input type="date" class="form-control" id="startDate" name="startDate" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="premiumAmount" class="form-label">Phí bảo hiểm (VNĐ)</label>
                                <input type="number" class="form-control" id="premiumAmount" name="premiumAmount" step="1000" min="0" required>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">Tạo Hợp đồng</button>
                        <a href="<%= ctx %>/agent/contracts" class="btn btn-secondary">Hủy</a>
                    </form>
                </div>
            </div>
        </div>
    </main>
</body>
</html>