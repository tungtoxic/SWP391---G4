<%-- 
    Document   : addCustomer
    Created on : Oct 20, 2025, 4:39:43 PM
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser"); // Lấy từ Servlet
    String activePage = (String) request.getAttribute("activePage");
    if (currentUser == null) {
        // Thử lấy từ session (như code gốc của bạn)
        currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
             response.sendRedirect(ctx + "/login.jsp");
             return;
        }
    }
    if (activePage == null) activePage = "customers";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Thêm Khách Hàng Mới</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
    <%@ include file="agent_navbar.jsp" %>
    <%@ include file="agent_sidebar.jsp" %>
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Thêm Khách Hàng Mới</h1>

            <div class="card">
                <div class="card-body">
                    <form action="<%= ctx %>/agent/customers" method="post">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label for="fullName" class="form-label">Họ và Tên</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" required>
                        </div>
                        <div class="mb-3">
                            <label for="dateOfBirth" class="form-label">Ngày Sinh</label>
                            <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">Số Điện Thoại</label>
                            <input type="tel" class="form-control" id="phone" name="phone" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="address" class="form-label">Địa chỉ</label>
                            <textarea class="form-control" id="address" name="address" rows="3"></textarea>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">Lưu Khách Hàng</button>
                        <a href="<%= ctx %>/agent/customers" class="btn btn-secondary">Hủy</a>
                    </form>
                </div>
            </div>
        </div>
    </main>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>