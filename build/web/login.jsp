<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đăng nhập</title>
    <style>
        /* CSS cơ bản, bạn có thể chỉnh theo login.css */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        .form-box {
            width: 350px;
            margin: 80px auto;
            padding: 30px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
        }
        .form-box h2 { text-align: center; margin-bottom: 20px; }
        .form-box input {
            width: 100%; padding: 10px; margin: 10px 0;
            border: 1px solid #ccc; border-radius: 5px;
        }
        .btn {
            width: 100%; padding: 10px; background-color: #007bff;
            border: none; color: #fff; border-radius: 5px;
            cursor: pointer; font-size: 16px;
        }
        .btn:hover { background-color: #0056b3; }
        .redirect-text, .change-pass-text { text-align: center; margin-top: 10px; }
        .redirect-text a, .change-pass-text a { color: #007bff; text-decoration: none; }
        .error { color: red; text-align: center; margin-top: 10px; }
    </style>
</head>
<body>
<div class="form-box">
    <h2>Login</h2>

    <form action="LoginServlet" method="post">
        <input type="text" name="username" placeholder="Enter Username" required>
        <input type="password" name="password" placeholder="Enter password" required>
        <button type="submit" class="btn">Login</button>
    </form>

<<<<<<< HEAD
    <p class="redirect-text">
        Chưa có tài khoản? <a href="register.jsp">Đăng ký</a>
    </p>

    <p class="change-pass-text">
        Quên mật khẩu? <a href="changePassword.jsp">Đổi mật khẩu</a>
=======
    <p class="redirect-text">Don't have an account?
        <a href="register.jsp">Register</a>
    </p>
    
    <p class="redirect-text">Forgot password?
        <a href="resetPassword.jsp">Reset password</a>
>>>>>>> VuTT
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
