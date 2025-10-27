<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");
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
        }

        h2 {color: #2cd02d;}

        p {
            color: #555;
            margin: 10px 0;  
            font-size: 15px;
            line-height: 1.6;
        }

        input[type="text"], input[type="email"], input[type="tel"]{
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
        .message {
            text-align: center;
            margin-bottom: 15px;
            padding: 10px;
            border-radius: 6px;
            font-weight: bold;
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
        }

        .welcome-text {text-align: center; margin-bottom: 25px; font-size: 28px}
        .btn-group {text-align: center; margin-top: 15px;}
        .btn-change-pass { background-color: #3498db; }
        .btn-logout { background-color: #e74c3c; }
        .btn-update { background-color: #2ecc71; }
        .btn-save { background-color: #27ae60; }
        .btn-cancel { background-color: #95a5a6; }
        .btn:hover { opacity: 0.9; }       
        .error { color: red; }
        
        form#edit-mode {
            width: 400px;
            margin: 0 auto;
            display: none;
            font-family: Arial, sans-serif;
        }

        form#edit-mode label {
            display: inline-block;
            font-weight: bold;
            width: 120px;
            margin-bottom: 10px;
            vertical-align: middle;
        }

        form#edit-mode input, form#edit-mode select {
            width: 250px;
            padding: 6px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            vertical-align: middle;
        }

        .btn-container {
            text-align: center;
            margin-top: 15px;
        }

        .btn-save {
            background-color: #28a745;
            color: white;
            margin-right: 10px;
        }

        .btn-cancel {
            background-color: #a0a0a0;
            color: white;
        }
    </style>
</head>
<body>
    
    <div class="profile-card">
        <h2 class="welcome-text">Welcome, <%= user.getUsername() %>!</h2>
        <% if (message != null) { %>
            <div id="messageBox" class="message"><%= message %></div>
        <% } else { %>
            <div id="messageBox" class="message" style="display:none;"></div>
        <% } %>

        <div id="view-mode">
            <p><strong>Full Name:</strong> <%= user.getFullName() %></p>
            <p><strong>Email:</strong> <%= user.getEmail() %></p>
            <p><strong>Phone Number:</strong> <%= user.getPhoneNumber() %></p>
            <p><strong>Role ID:</strong> <%= user.getRoleId() %></p>
            <p><strong>Status:</strong> <%= user.getStatus() %></p>
            
            <div class="btn-group">
                <a href="ChangePassword" class="btn btn-change-pass">Change Password</a>
                <button class="btn btn-update" onclick="switchToEdit()">Update Profile</button>
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
    </div>

    <script>
        function switchToEdit() {
            document.getElementById("view-mode").style.display = "none";
            document.getElementById("edit-mode").style.display = "block";
            const msgBox = document.getElementById("messageBox");
            if (msgBox) {
            msgBox.style.display = "none";
            }
        }

        function switchToView() {
            document.getElementById("edit-mode").style.display = "none";
            document.getElementById("view-mode").style.display = "block";
        }
    </script>
</body>
</html>