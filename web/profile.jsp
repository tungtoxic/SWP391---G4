<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String message = (String) request.getAttribute("message");
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

        p { color: #555; margin: 8px 0; font-size: 15px; }

        input[type="text"], input[type="email"], input[type="tel"] {
            width: 90%;
            padding: 8px;
            margin: 6px 0;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .btn {
            display: inline-block;
            margin: 10px 5px;
            padding: 8px 14px;
            border-radius: 6px;
            text-decoration: none;
            color: #fff;
            border: none;
            cursor: pointer;
        }

        .btn-change-pass { background-color: #3498db; }
        .btn-logout { background-color: #e74c3c; }
        .btn-update { background-color: #2ecc71; }
        .btn-save { background-color: #27ae60; }
        .btn-cancel { background-color: #95a5a6; }
        .btn:hover { opacity: 0.9; }

        .message { margin-bottom: 10px; color: green; font-weight: bold; }
        .error { color: red; }
    </style>
</head>
<body>

<div class="profile-card">
    <h2>Welcome, <%= user.getFullName() %>!</h2>

    <% if (message != null) { %>
        <div class="message"><%= message %></div>
    <% } %>

    <!-- Chế độ xem -->
    <div id="view-mode">
        <p><strong>Email:</strong> <%= user.getEmail() %></p>
        <p><strong>Phone:</strong> <%= user.getPhoneNumber() %></p>
        <p><strong>Role ID:</strong> <%= user.getRoleId() %></p>
        <p><strong>Status:</strong> <%= user.getStatus() %></p>

        <a href="ChangePassword" class="btn btn-change-pass">Change Password</a>
        <button class="btn btn-update" onclick="switchToEdit()">Update Profile</button>
    </div>

    <!--Edit-->
    <form id="edit-mode" action="UpdateProfileServlet" method="post" style="display:none;">
        <input type="hidden" name="userId" value="<%= user.getUserId() %>">
        <input type="text" name="fullName" value="<%= user.getFullName() %>" placeholder="Full Name" required><br>
        <input type="email" name="email" value="<%= user.getEmail() %>" placeholder="Email" required><br>
        <input type="tel" name="phoneNumber" value="<%= user.getPhoneNumber() %>" placeholder="Phone Number"><br>
        <label><strong>Status:</strong></label><br>
        <select name="status" required>
            <option value="Active" <%= "Active".equalsIgnoreCase(user.getStatus()) ? "selected" : "" %>>Active</option>
            <option value="Inactive" <%= "Inactive".equalsIgnoreCase(user.getStatus()) ? "selected" : "" %>>Inactive</option>
        </select><br>
        <button type="submit" class="btn btn-save">Save</button>
        <button type="button" class="btn btn-cancel" onclick="switchToView()">Cancel</button>
    </form>
</div>

<script>
    function switchToEdit() {
        document.getElementById("view-mode").style.display = "none";
        document.getElementById("edit-mode").style.display = "block";
    }
    function switchToView() {
        document.getElementById("edit-mode").style.display = "none";
        document.getElementById("view-mode").style.display = "block";
    }
</script>

</body>
</html>
