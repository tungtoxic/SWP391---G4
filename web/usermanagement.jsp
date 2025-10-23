<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.User, dao.UserDao" %>
<%
    UserDao userDao = new UserDao();
    List<User> userList = new ArrayList<>();
    String filter = request.getParameter("filter");

    try {
        if ("active".equalsIgnoreCase(filter)) {
            userList = userDao.getUsersByStatus("Active");
        } else if ("inactive".equalsIgnoreCase(filter)) {
            userList = userDao.getUsersByStatus("Inactive");
        } else {
            userList = userDao.getAllUsers();
        }
    } catch (Exception e) {
        e.printStackTrace();
}
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 1100px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .filter-buttons a {text-decoration: none;}
        
        .filter-buttons button, .btn-add {
            border: none;
            border-radius: 6px;
            padding: 8px 14px;
            font-weight: bold;
            cursor: pointer;
            color: white;
        }

        .filter-buttons button {
            background-color: #2ecc71;
            margin-right: 10px;
        }

        .filter-buttons button:nth-child(2) {
            background-color: #f39c12;
        }

        .filter-buttons button:nth-child(3) {
            background-color: #3498db;
        }

        .btn-add {
            background-color: #007bff;
            text-decoration: none;
        }

        .btn-add:hover, .filter-buttons button:hover {
            opacity: 0.9;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 12px 10px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #2c3e50;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f8f8f8;
        }

        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
            color: white;
        }

        .badge.active {
            background-color: #28a745;
        }

        .badge.inactive {
            background-color: #dc3545;
        }

        .action-btn {
            border: none;
            border-radius: 5px;
            padding: 6px 10px;
            margin: 0 2px;
            font-size: 13px;
            cursor: pointer;
            color: white;
            font-weight: bold;
        }

        .btn-edit {
            background-color: #f1c40f;
        }

        .btn-delete {
            background-color: #e74c3c;
        }

        .btn-toggle {
            background-color: #27ae60;
        }

        .btn-toggle.inactive {
            background-color: #c0392b;
        }

        .action-btn:hover {
            opacity: 0.9;
            text-decoration: none;
        }

        .footer-link {
            text-align: right;
            margin-top: 25px;
        }

        .footer-link a {
            text-decoration: none;
            color: #2980b9;
            font-weight: bold;
        }

        .footer-link a:hover {
            color: #e74c3c;
        }        
        td a {text-decoration: none;}
        
        #btn-sortActive {background-color: #28a745}
        #btn-sortInactive {background-color: #dc3545}
        #btn-sortAll {background-color: #f1c40f}
    </style>
</head>
<body>
    <div class="container">
        <h2>User Management</h2>

        <div class="top-bar">
            <div class="filter-buttons">
                <a href="usermanagement.jsp?filter=active">
                    <button id="btn-sortActive" type="button">Active Users</button>
                </a>
                <a href="usermanagement.jsp?filter=inactive">
                    <button id="btn-sortInactive" type="button">Inactive Users</button>
                </a>
                <a href="usermanagement.jsp?filter=all">
                    <button id="btn-sortAll" type="button">All Users</button>
                </a>
            </div>

            <a href="addUser.jsp" class="btn-add">+ Add User</a>
        </div>

        <table>
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Phone Number</th>
                <th>Role</th>
                <th>Status</th>
                <th>Username</th>
                <th>Actions</th>
            </tr>
            <%
            for (User u : userList) {
                if ("Admin".equalsIgnoreCase(u.getRoleName())) continue;
                String statusClass = "Active".equalsIgnoreCase(u.getStatus()) ? "active" : "inactive";
            %>
            <tr>
                <td><%= u.getUserId() %></td>
                <td><%= u.getFullName() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getPhoneNumber() %></td>
                <td><%= u.getRoleName() %></td>
                <td><span class="badge <%= statusClass %>"><%= u.getStatus() %></span></td>
                <td><%= u.getUsername() %></td>
                <td>
                    <form action="admin/management" method="get" style="display:inline;">
                        <input type="hidden" name="action" value="toggleStatus">
                        <input type="hidden" name="id" value="<%=u.getUserId()%>">                       
                    </form>                   
                    <a href="admin/management?action=edit&id=<%=u.getUserId()%>">
                        <button class="action-btn btn-edit">Edit</button>
                    </a>
                        <a href="admin/management?action=delete&id=<%=u.getUserId()%>" 
                       onclick="return confirm('Are you sure you want to delete this user?');">
                        <button class="action-btn btn-delete">Delete</button>
                    </a>
                </td>
            </tr>
            <% } %>
        </table>

        <div class="footer-link">
            <a href="<%= request.getContextPath() %>/AdminDashboard.jsp">⬅ Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
