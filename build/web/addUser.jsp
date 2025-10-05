<%-- 
    Document   : addUser
    Created on : Oct 5, 2025, 11:51:15 AM
    Author     : hoang
--%>

<%-- 
    Document   : addUser
    Created on : Oct 5, 2025, 11:51:15 AM
    Author     : hoang
--%>

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
        <link rel="stylesheet" href="../css/bootstrap.min.css">
    </head>
    <body class="container mt-4">

        <h2>➕ Thêm Người Dùng</h2>

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= error %>
        </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/admin/management" method="post">
            <input type="hidden" name="action" value="add"/>

            <div class="mb-3">
                <label class="form-label">Username:</label>
                <input type="text" name="username" class="form-control" required/>
            </div>

            <div class="mb-3">
                <label class="form-label">Họ tên:</label>
                <input type="text" name="fullName" class="form-control"/>
            </div>

            <div class="mb-3">
                <label class="form-label">Email:</label>
                <input type="email" name="email" class="form-control" required/>
            </div>

            <div class="mb-3">
                <label class="form-label">Số điện thoại:</label>
                <input type="text" name="phoneNumber" class="form-control" required/>
            </div>

            <div class="mb-3">
                <label class="form-label">Vai trò:</label>
                <select name="role_id" class="form-select">
                    <% for(Role r : roles) { %>
                    <option value="<%= r.getRoleId() %>"><%= r.getRoleName() %></option>
                    <% } %>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Trạng thái:</label>
                <select name="status" class="form-select">
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>

            <button type="submit" class="btn btn-success">Thêm</button>
            <a href="<%= request.getContextPath() %>/usermanagement.jsp" class="btn btn-secondary">Quay lại</a>
        </form>

    </body>
</html>
