<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="entity.Role" %>
<%@ page import="dao.RoleDao" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) request.getAttribute("user");
    RoleDao roleDao = new RoleDao();
    List<Role> roles = roleDao.getAllRoles();
%>

<html>
    <head>
        <title>Chỉnh sửa người dùng</title>
        <link rel="stylesheet" href="../css/bootstrap.min.css">
    </head>
    <body class="container mt-4">

        <h2>✏️ Edit User</h2>
        <form action="<%= request.getContextPath() %>/admin/management" method="post">
            <input type="hidden" name="action" value="edit"/>
            <input type="hidden" name="userId" value="<%= user.getUserId() %>"/>

            <div class="mb-3">
                <label class="form-label">Username:</label>
                <input type="text" name="username" value="<%= user.getUsername() %>" class="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Full Name:</label>
                <input type="text" name="fullName" value="<%= user.getFullName() %>" class="form-control"/>
            </div>

            <div class="mb-3">
                <label class="form-label">Email:</label>
                <input type="email" name="email" value="<%= user.getEmail() %>" class="form-control"/>
            </div>

            <div class="mb-3">
                <label class="form-label">Phone Number:</label>
                <input type="text" name="phoneNumber" value="<%= user.getPhoneNumber() %>" class="form-control"/>
            </div>

            <div class="mb-3">
                <label class="form-label">Role:</label>
                <select name="role_id" class="form-select">
                    <% for(Role r : roles) { %>
                    <option value="<%= r.getRoleId() %>" <%= (r.getRoleId()==user.getRoleId() ? "selected" : "") %> >
                        <%= r.getRoleName() %>
                    </option>
                    <% } %>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Status:</label>
                <select name="status" class="form-select">
                    <option value="Active" <%= "Active".equals(user.getStatus()) ? "selected" : "" %>>Active</option>
                    <option value="Inactive" <%= "Inactive".equals(user.getStatus()) ? "selected" : "" %>>Inactive</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Update</button>
            <a href="<%= request.getContextPath() %>/usermanagement.jsp" class="btn btn-secondary">Return</a>
        </form>

    </body>
</html>
