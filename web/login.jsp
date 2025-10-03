<%-- 
    Document   : login
    Created on : Oct 2, 2025, 3:35:21 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
</head>
<body>
<h2>Login</h2>

<form action="LoginServlet" method="post">
    <label>Email:</label>
    <input type="text" name="username" required><br><br>

    <label>Password:</label>
    <input type="password" name="password" required><br><br>

    <input type="submit" value="Login">
</form>

<% String error = (String) request.getAttribute("error");
   if (error != null) { %>
    <p style="color:red;"><%= error %></p>
<% } %>
</body>
</html>
