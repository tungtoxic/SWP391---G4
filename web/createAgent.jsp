<%-- 
    Document   : createAgent
    Created on : Oct 11, 2025, 3:44:40 PM
    Author     : Helios 16
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Create Agent</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 400px;
            margin: 50px auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 { text-align: center; margin-bottom: 20px; }
        label { display: block; margin: 10px 0 5px; }
        input[type=text], input[type=email], input[type=tel] {
            width: 100%;
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        .btn {
            margin-top: 15px;
            padding: 8px 15px;
            border-radius: 6px;
            border: none;
            background-color: #007bff;
            color: #fff;
            cursor: pointer;
        }
        .btn:hover { background-color: #0056b3; }
        .alert { color: red; margin-top: 10px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Create New Agent</h2>

    <c:if test="${not empty message}">
        <div class="alert">${message}</div>
    </c:if>

    <form action="AgentManagementServlet?action=create" method="post">
        <label>Username:</label>
        <input type="text" name="username" required>

        <label>Full Name:</label>
        <input type="text" name="fullName" required>

        <label>Email:</label>
        <input type="email" name="email" required>

        <label>Phone Number:</label>
        <input type="tel" name="phoneNumber">

        <button type="submit" class="btn">Create Agent</button>
    </form>

    <div style="margin-top: 15px; text-align: center;">
        <a href="AgentManagementServlet">Back to Agent List</a>
    </div>
</div>
</body>
</html>

