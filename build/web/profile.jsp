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
</head>
<body>
<h2>Welcome, <%= user.getFullName() %>!</h2>
<p>Email: <%= user.getEmail() %></p>
<p>Role ID: <%= user.getRoleId() %></p>
<p>Status: <%= user.getStatus() %></p>

<a href="logout">Logout</a>
</body>
</html>
