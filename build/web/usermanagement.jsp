<%-- 
    Document   : usermanagement
    Created on : Oct 5, 2025, 11:17:38 AM
    Author     : hoang
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.User, dao.UserDao" %>
<%
    UserDao userDao = new UserDao();
    List<User> userList = new ArrayList<>();
    try {
        userList = userDao.getAllUsers();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<html>
    <head>
        <title>User Management</title>
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: center;
            }
            th {
                background-color: #2c3e50;
                color: white;
            }
            a {
                text-decoration: none; /* ❌ bỏ gạch chân */
                color: #2980b9;
                font-weight: bold;
            }
            a:hover {
                color: #e74c3c;
            }
        </style>
    </head>
    <body>
        <h2>User Management</h2>
        <a href="addUser.jsp">➕ Thêm User</a>
        <table>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Role</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <%
                for (User u : userList) {
            %>
            <tr>
                <td><%= u.getUserId() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getFullName() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getPhoneNumber() %></td>
                <td><%= u.getRoleName() %></td>
                <td><%= u.getStatus() %></td>
                <td>
                    <a href="admin/management?action=edit&id=<%=u.getUserId()%>">Edit</a> | 
                    <a href="admin/management?action=delete&id=<%=u.getUserId()%>" onclick="return confirm('Xóa user này?');">Delete</a>
                </td>
            </tr>
            <% } %>
        </table>

        <br>

    </body>
</html>

