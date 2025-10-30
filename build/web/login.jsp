<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đăng nhập</title>
    <link rel="stylesheet" href="css/login.css">
</head>
<body>
<div class="form-box">
    <h2>Đăng nhập</h2>

    <form action="LoginServlet" method="post">
        <input type="text" name="username" placeholder="Email hoặc Username" required>
        <input type="password" name="password" placeholder="Mật khẩu" required>
        <button type="submit" class="btn">Đăng nhập</button>
    </form>

    <p class="redirect-text">Chưa có tài khoản?
        <a href="register.jsp">Đăng ký</a>
    </p>
    
    <p class="redirect-text">Quên mật khẩu?
        <a href="resetPassword.jsp">Reset password</a>
    </p>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error"><%= error %></div>
    <% } %>
</div>
</body>
</html>
