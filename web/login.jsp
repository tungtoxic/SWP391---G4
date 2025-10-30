<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đăng nhập</title>
    <link rel="stylesheet" href="css/login.css">
</head>
<body>
<div class="form-box">
    <h2>Login</h2>

    <form action="LoginServlet" method="post">
        <input type="text" name="username" placeholder="Enter Email or Username" required>
        <input type="password" name="password" placeholder="Enter password" required>
        <button type="submit" class="btn">Login</button>
    </form>

    <p class="redirect-text">Don't have an account?
        <a href="register.jsp">Register</a>
    </p>
    
    <p class="redirect-text">Forgot password?
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
