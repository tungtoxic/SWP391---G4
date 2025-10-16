<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Profile</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .profile-card {
            background: #fff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            width: 400px;
            text-align: center;
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 15px;
        }

        p {
            color: #555;
            margin: 8px 0;
            font-size: 15px;
        }

        .btn-change-pass, .btn-logout {
            display: inline-block;
            margin: 10px 5px;
            padding: 8px 14px;
            border-radius: 6px;
            text-decoration: none;
            color: #fff;
        }

        .btn-change-pass {
            background-color: #3498db;
        }

        .btn-logout {
            background-color: #e74c3c;
        }

        .btn-change-pass:hover {
            background-color: #2980b9;
        }

        .btn-logout:hover {
            background-color: #c0392b;
        }
    </style>
</head>
<body>
    <div class="profile-card">
        <h2>Welcome, <%= user.getFullName() %>!</h2>
        <p><strong>Email:</strong> <%= user.getEmail() %></p>
        <p><strong>Phone:</strong> <%= user.getPhoneNumber() %></p>
        <p><strong>Role ID:</strong> <%= user.getRoleId() %></p>
        <p><strong>Status:</strong> <%= user.getStatus() %></p>

        <a href="ChangePasswordServlet" class="btn-change-pass">Change Password</a>
        <a href="LogoutController" class="btn-logout">Logout</a>
    </div>
</body>
</html>
