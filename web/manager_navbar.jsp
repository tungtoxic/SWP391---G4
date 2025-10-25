<%-- 
    Document   : manager_navbar
    Created on : Oct 25, 2025, 12:47:44 PM
    Author     : Nguyễn Tùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %> <%-- Đảm bảo có ctx --%>

<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="#">Manager Portal</a>
        <ul class="navbar-nav d-flex flex-row align-items-center">
            <%-- Sửa link Dashboard để trỏ đúng trang --%>
            <li class="nav-item me-3"><a class="nav-link" href="<%= ctx %>/ManagerDashboard.jsp">Dashboard</a></li>
            <li class="nav-item"><a class="nav-link" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>
</nav>