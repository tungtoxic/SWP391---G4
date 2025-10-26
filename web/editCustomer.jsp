<%-- 
    Document   : editCustomer
    Created on : Oct 20, 2025, 4:41:01 PM
    Author     : Nguyễn Tùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User, entity.Customer" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser"); 
    String activePage = (String) request.getAttribute("activePage");
    Customer customer = (Customer) request.getAttribute("customer");
    if (currentUser == null) {
        currentUser = (User) session.getAttribute("user"); // Thử lấy từ session
        if (currentUser == null) {
             response.sendRedirect(ctx + "/login.jsp");
             return;
        }
    }
    if (customer == null) { // Nếu không có customer, không thể sửa
        response.sendRedirect(ctx + "/agent/customers?message=AuthError");
        return;
    }
    if (activePage == null) activePage = "customers";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chỉnh Sửa Khách Hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
    <%@ include file="agent_navbar.jsp" %>
    <%@ include file="agent_sidebar.jsp" %>
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Chỉnh Sửa Thông Tin Khách Hàng</h1>

            <div class="card">
                <div class="card-body">
                    <form action="<%= ctx %>/agent/customers" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>">
                        
                        <div class="mb-3">
                            <label for="fullName" class="form-label">Họ và Tên</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" value="<%= customer.getFullName() %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="dateOfBirth" class="form-label">Ngày Sinh</label>
                            <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" value="<%= customer.getDateOfBirth() %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">Số Điện Thoại</label>
                            <input type="tel" class="form-control" id="phone" name="phone" value="<%= customer.getPhoneNumber() %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" value="<%= customer.getEmail() %>" required>
                        </div>
                        <div class="mb-3">
                            <label for="address" class="form-label">Địa chỉ</label>
                            <textarea class="form-control" id="address" name="address" rows="3"><%= customer.getAddress() %></textarea>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">Cập Nhật</button>
                        <a href="<%= ctx %>/agent/customers" class="btn btn-secondary">Hủy</a>
                    </form>
                </div>
            </div>
        </div>
    </main>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>