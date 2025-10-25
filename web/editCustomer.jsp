<%-- 
    Document   : editCustomer
    Created on : Oct 20, 2025, 4:41:01 PM
    Author     : Nguyễn Tùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User, entity.Customer" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
    Customer customer = (Customer) request.getAttribute("customer");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chỉnh Sửa Khách Hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company</a>
            <ul class="navbar-nav d-flex flex-row align-items-center">
                <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/home.jsp">Home</a></li>
                <a class="nav-link" href="#">
                        <i class="fas fa-bell"></i>
                        <span class="badge rounded-pill badge-notification bg-danger">1</span>
                    </a>
            </ul>
        </div>
    </nav>

    <aside class="sidebar bg-primary text-white">
        <div class="sidebar-top p-3">
            <div class="d-flex align-items-center mb-3">
                <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                <div>
                    <div class="fw-bold"><%= currentUser != null ? currentUser.getFullName() : "Agent" %></div>
                    <div style="font-size:.85rem;opacity:.9">Sales Agent</div>
                </div>
            </div>
        </div>
        <nav class="nav flex-column px-2">
            <%-- ĐÃ SỬA LỖI ĐIỀU HƯỚNG --%>
            <a class="nav-link text-white active py-2" href="<%=ctx%>/agent/dashboard"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/leaderboard/agents"><i class="fas fa-trophy me-2"></i> Leaderboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/commission-report"><i class="fas fa-percent me-2"></i> Commission Report</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-box me-2"></i> Product</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/contracts"><i class="fas fa-file-signature me-2"></i> Contract</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/customers"><i class="fas fa-users me-2"></i> Customer</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>
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
</body>
</html>