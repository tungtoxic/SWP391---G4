<%-- 
    Document   : register
    Created on : Oct 3, 2025, 9:26:09 PM
    Author     : Helios 16
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register with Captcha</title>
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    <link rel="stylesheet" href="css/register.css">
</head>
<body>
    <div class="form-box">
        <h2>Register</h2>
        <form action="register" method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="text" name="fullName" placeholder="Full Name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="password" name="confirmPassword" placeholder="Confirm Password" required>
            <input type="text" name="phoneNumber" placeholder="Phone Number" required>

            <!-- Chọn vai trò -->
            <select name="role" required>
                <option value="">-- Select Role --</option>
                <option value="Agent">Agent</option>
                <option value="Manager">Manager</option>
                <option value="Admin">Admin</option>
            </select>

            <!-- Captcha -->
            <div class="g-recaptcha" data-sitekey="6Lf4T90rAAAAADT-sr3o4XIGcVECgAVjmg9Zm6qE"></div>

            <button type="submit">Register</button>
        </form>

        <!-- Hiển thị lỗi/thành công -->
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="success">${success}</div>
        </c:if>
    </div>
</body>
</html>

