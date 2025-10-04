<%-- 
    Document   : home
    Created on : Oct 2, 2025, 3:37:19 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Home</title>
    <link rel="stylesheet" type="text/css" href="css/home.css">
</head>
<body>
    <div class="profile-card">
        <h2>Welcome, <%= user.getFullName() %>!</h2>
        <p><strong>Email:</strong> <%= user.getEmail() %></p>
        <p><strong>Role ID:</strong> <%= user.getRoleId() %></p>
        <p><strong>Status:</strong> <%= user.getStatus() %></p>

        <a href="logout" class="btn-logout">Logout</a>
    </div>
</body>
</html>
