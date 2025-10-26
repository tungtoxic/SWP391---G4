<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.User" %>
<%
    // Lấy danh sách agent từ request
    List<User> agentList = (List<User>) request.getAttribute("agentList");
    String message = (String) request.getAttribute("message");
%>
<html>
<head>
    <title>Agent Management</title>
    <style>
        /* (Toàn bộ CSS của bạn giữ nguyên ở đây) */
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #f4f6f8; margin: 0; padding: 0; }
        .container { width: 90%; max-width: 1100px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); padding: 30px; }
        h2 { text-align:center; margin-bottom: 25px; color:#333; }
        .btn { padding:6px 12px; border-radius:6px; text-decoration:none; color:#fff; font-weight:500; cursor:pointer; font-size:0.85em; margin:2px; display:inline-block; border: none; }
        .btn-primary { background:#007bff; } .btn-primary:hover { background:#0056b3; }
        .btn-success { background:#198754; } .btn-success:hover { background:#0d6e3d; }
        .btn-danger { background:#dc3545; } .btn-danger:hover { background:#b52a37; }
        .btn-warning { background:#ffc107; color:#000; } .btn-warning:hover { background:#d39e00; }
        .filter-btns { margin-bottom:20px; text-align: left; } .filter-btns a { margin-right:5px; }
        .text-end { text-align: right; margin-bottom: 20px; }
        table { width:100%; border-collapse:collapse; background:#fff; }
        thead { background:#333; color:#fff; }
        th, td { padding:10px 12px; border:1px solid #ddd; text-align:center; word-wrap:break-word; }
        tbody tr:nth-child(even) { background:#f9f9f9; }
        .badge { padding:4px 8px; border-radius:20px; font-size:0.8em; color:#fff; }
        .bg-success { background:#28a745; } .bg-secondary { background:#6c757d; }
        form { margin:0; }
        form input[type="text"] { width: 90px; padding:4px 6px; border-radius:4px; border:1px solid #ccc; font-size:0.85em; }
        .alert { background:#d1ecf1; border:1px solid #bee5eb; color:#0c5460; padding:10px; border-radius:5px; margin-bottom:15px; }
    </style>
</head>

<body>
    <div class="container">
        <h2>Agent Management</h2>

        <div class="text-end">
            <a href="createAgent.jsp" class="btn btn-primary">+ Create New Agent</a>
        </div>

        <div class="filter-btns">
            <a href="AgentManagementServlet?status=Active" class="btn btn-success">Active Agents</a>
            <a href="AgentManagementServlet?status=Pending" class="btn btn-success">Pending Agents</a>
            <a href="AgentManagementServlet?status=Inactive" class="btn btn-secondary">Inactive Agents</a>
            <a href="AgentManagementServlet" class="btn btn-primary">All Agents</a>
        </div>

        <%-- Hiển thị thông báo (nếu có) --%>
        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert"><%= message %></div>
        <% } %>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Status</th>
                    <th>Username</th>
                    <th>Password</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%-- Lặp qua danh sách agent --%>
                <% if (agentList != null && !agentList.isEmpty()) {
                    for (User agent : agentList) {
                %>
                        <tr>
                            <td><%= agent.getUserId() %></td>
                            <td><%= agent.getFullName() %></td>
                            <td><%= agent.getEmail() %></td>
                            <td><%= agent.getPhoneNumber() %></td>
                            <td>
                                <% if ("Active".equals(agent.getStatus())) { %>
                                    <span class="badge bg-success">Active</span>
                                <% } else { %>
                                    <span class="badge bg-secondary"><%= agent.getStatus() %></span>
                                <% } %>
                            </td>
                            
                            <%-- Username, Password, và Actions --%>
                            <% if ("Pending".equals(agent.getStatus())) { %>
                                <form action="AgentManagementServlet" method="post">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="id" value="<%= agent.getUserId() %>">
                                    
                                    <td> <input type="text" name="username" placeholder="Username" required>
                                    </td>
                                    <td> <input type="text" name="password" placeholder="Password" required>
                                    </td>
                                    <td> <button type="submit" class="btn btn-success">Approve</button>
                                    </td>
                                </form>
                            <% } else { %>
                                <td><%= agent.getUsername() != null ? agent.getUsername() : "" %></td>
                                <td>********</td>
                                <td>
                                    <% if ("Active".equals(agent.getStatus())) { %>
                                        <a href="AgentManagementServlet?action=deactivate&id=<%= agent.getUserId() %>" class="btn btn-danger" onclick="return confirm('Deactivate this agent?')">Deactivate</a>
                                    <% } else { %>
                                        <a href="AgentManagementServlet?action=activate&id=<%= agent.getUserId() %>" class="btn btn-success" onclick="return confirm('Activate this agent?')">Activate</a>
                                    <% } %>
                                    <a href="AgentManagementServlet?action=delete&id=<%= agent.getUserId() %>" class="btn btn-danger" onclick="return confirm('Delete this agent?')">Delete</a>
                                    <a href="editAgent.jsp?id=<%= agent.getUserId() %>" class="btn btn-warning">Edit</a>
                                </td>
                            <% } %>
                        </tr>
                <%
                    } // Kết thúc vòng lặp
                } else {
                %>
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 20px;">No agents found.</td>
                    </tr>
                <% } // Kết thúc if-else %>
            </tbody>
        </table>
    </div>
</body>
</html>