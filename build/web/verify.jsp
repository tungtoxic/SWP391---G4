<%-- 
    Document   : verify
    Created on : Oct 3, 2025, 5:35:16 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Verify OTP</title>
</head>
<body>
<h2>Enter OTP</h2>

<form action="VerifyServlet" method="post">
    <label>OTP:</label>
    <input type="text" name="otp" required><br><br>
    <input type="submit" value="Verify">
</form>

<% String error = (String) request.getAttribute("error");
   if (error != null) { %>
    <p style="color:red;"><%= error %></p>
<% } %>
</body>
</html>
