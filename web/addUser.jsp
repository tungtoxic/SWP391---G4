<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Role" %>
<%@ page import="dao.RoleDao" %>

<%
    RoleDao roleDao = new RoleDao();
    List<Role> roles = roleDao.getAllRoles();
%>

<html>
    <head>
        <title>Thêm người dùng</title>
        <link rel="stylesheet" href="./css/bootstrap.min.css">
    </head>
    <body class="container mt-4">

        <h2>➕ Add User</h2>

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= error %>
        </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/addUser" method="post">
            <input type="hidden" name="action" value="add"/>

            <div class="mb-3">
                <label class="form-label">Username:</label>
                <input type="text" name="username" class="form-control" required/>
            </div>

            <div class="mb-3">
                <label class="form-label">Full Name:</label>
                <input type="text" name="fullName" class="form-control" required/>
            </div>

            <div class="mb-3">
                <label class="form-label">Email:</label>
                <input type="email" name="email" class="form-control" required/>
            </div>

            <div class="mb-3">
                <label class="form-label">Phone Number:</label>
                <input type="text" name="phoneNumber" class="form-control" required/>
            </div>

            <div class="mb-3">
                <label class="form-label">Role:</label>
                <select name="role_id" class="form-select">
                    <option value="1" ${user.roleId == 1 ? "selected" : ""}>Agent</option>
                    <option value="2" ${user.roleId == 2 ? "selected" : ""}>Manager</option>
                </select>

            </div>

            <div class="mb-3">
                <label class="form-label">Status:</label>
                <select name="status" class="form-select">
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>

            <button type="submit" class="btn btn-success">Add</button>
            <a href="<%= request.getContextPath() %>/usermanagement.jsp" class="btn btn-secondary">Return</a>
        </form>

    </body>
</html>
