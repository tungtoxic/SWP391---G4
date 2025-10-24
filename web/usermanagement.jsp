<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.User" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
    List<User> userList = (List<User>) request.getAttribute("userList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
    <%-- Navbar & Sidebar --%>
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <%-- (Nội dung Navbar của Admin) --%>
    </nav>
    <aside class="sidebar bg-primary text-white">
         <div class="sidebar-top p-3">
             <div class="d-flex align-items-center mb-3">
                 <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                 <div>
                     <div class="fw-bold"><%= currentUser != null ? currentUser.getFullName() : "Admin" %></div>
                     <div style="font-size:.85rem;opacity:.9">Administrator</div>
                 </div>
             </div>
        </div>
        <nav class="nav flex-column px-2">
            <a class="nav-link text-white py-2" href="#">Dashboard</a>
            <a class="nav-link text-white active py-2" href="<%=ctx%>/admin/users">User Management</a>
            <%-- (Các link khác của Admin) --%>
        </nav>
    </aside>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="mb-0">User Management</h1>
                <a href="addUser.jsp" class="btn btn-primary"><i class="fas fa-plus me-1"></i> Add New User</a>
            </div>

            <div class="card">
                <div class="card-header">
                    <form action="<%=ctx%>/admin/users" method="GET" class="d-flex gap-2">
                        <select name="role_id" class="form-select w-auto">
                            <option value="">All Roles</option>
                            <option value="1">Agent</option>
                            <option value="2">Manager</option>
                            <option value="3">Admin</option>
                        </select>
                        <button type="submit" class="btn btn-primary">Filter</button>
                    </form>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Full Name</th>
                                    <th>Username</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (userList != null && !userList.isEmpty()) {
                                    for (User user : userList) {
                                %>
                                        <tr>
                                            <td><%= user.getUserId() %></td>
                                            <td>
                                                <div><%= user.getFullName() %></div>
                                                <small class="text-muted"><%= user.getEmail() %></small>
                                            </td>
                                            <td><%= user.getUsername() %></td>
                                            <td><%= user.getRoleName() %></td>
                                            <td>
                                                <%-- Badge cho status --%>
                                                <span class="badge bg-<%= "Active".equals(user.getStatus()) ? "success" : "secondary" %>">
                                                    <%= user.getStatus() %>
                                                </span>
                                            </td>
                                            <td>
                                                <a href="<%=ctx%>/admin/users?action=edit&id=<%=user.getUserId()%>" class="btn btn-sm btn-warning">Edit</a>
                                                <a href="<%=ctx%>/admin/users?action=delete&id=<%=user.getUserId()%>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                                            </td>
                                        </tr>
                                <% } } else { %>
                                    <tr><td colspan="6" class="text-center p-4">No users found.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>