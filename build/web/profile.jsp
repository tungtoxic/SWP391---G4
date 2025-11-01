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
<<<<<<< HEAD
=======
    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");
    }
>>>>>>> VuTT
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

<<<<<<< HEAD
        <a href="ChangePassword" class="btn-change-pass">Change Password</a>
        <a href="logout" class="btn-logout">Logout</a>
=======
        <div id="view-mode">
            <p><strong>Full Name:</strong> <%= user.getFullName() %></p>
            <p><strong>Email:</strong> <%= user.getEmail() %></p>
            <p><strong>Phone Number:</strong> <%= user.getPhoneNumber() %></p>
            <p><strong>Role ID:</strong> <%= user.getRoleId() %></p>
            <p><strong>Status:</strong> <%= user.getStatus() %></p>
            
            <div class="btn-group">
                <a href="ChangePassword" class="btn btn-change-pass">Change Password</a>
                <button class="btn btn-update" onclick="switchToEdit()">Update Profile</button>
                <a href="AdminDashboard.jsp" class="btn btn-change-pass">Return to Dashboard</a>
            </div>
        </div>

        <form id="edit-mode" action="UpdateProfileServlet" method="post" style="display:none;">
            <input type="hidden" name="userId" value="<%= user.getUserId() %>">

            <label>Full Name:</label>
            <input type="text" name="fullName" value="<%= user.getFullName() %>" required><br>

            <label>Email:</label>
            <input type="email" name="email" value="<%= user.getEmail() %>" required><br>

            <label>Phone Number:</label>
            <input type="tel" name="phoneNumber" value="<%= user.getPhoneNumber() %>" required><br>
         
            <div class="btn-group">
                <button type="submit" class="btn btn-save">Save</button>
                <button type="button" class="btn btn-cancel" onclick="switchToView()">Cancel</button>
            </div>
        </form>
>>>>>>> VuTT
    </div>
</body>
</html>
