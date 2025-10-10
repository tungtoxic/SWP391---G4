<%-- 
    Document   : register
    Created on : Oct 3, 2025, 9:26:09 PM
    Author     : Helios 16
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Đăng ký</title>
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    <link rel="stylesheet" href="css/register.css">
</head>
<body>
<div class="form-box">
    <h2>Đăng ký tài khoản</h2>
    <form action="register" method="post">
        <input type="text" name="username" placeholder="Tên đăng nhập" required>
        <input type="text" name="fullName" placeholder="Họ và tên" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="password" placeholder="Mật khẩu" required>
        <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
        <input type="text" name="phoneNumber" placeholder="Số điện thoại" required>

        <select name="role" required>
            <option value="">-- Chọn vai trò --</option>
            <option value="Agent">Agent</option>
            <option value="Manager">Manager</option>
        </select>

        <div class="g-recaptcha" data-sitekey="6Lf4T90rAAAAADT-sr3o4XIGcVECgAVjmg9Zm6qE"></div>

        <button type="submit" class="btn">Đăng ký</button>
    </form>

    <p class="redirect-text">Đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error"><%= error %></div>
    <% } %>
</div>
</body>
</html>
