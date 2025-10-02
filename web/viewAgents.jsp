<%-- 
    Document   : viewAgents
    Created on : Sep 27, 2025, 5:25:37 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Agent" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Agent List</title>
</head>
<body>
    <h1>Danh sách Agents</h1>

    <a href="addAgent.html">➕ Thêm Agent mới</a>
    <br/><br/>

    <table border="1" cellpadding="8" cellspacing="0">
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Status</th>
        </tr>

        <%
            List<Agent> agents = (List<Agent>) request.getAttribute("agents");
            if (agents != null && !agents.isEmpty()) {
                for (Agent a : agents) {
        %>
        <tr>
            <td><%= a.getUserId() %></td>
            <td><%= a.getUsername() %></td>
            <td><%= a.getFullName() %></td>
            <td><%= a.getEmail() %></td>
            <td><%= a.getPhoneNumber() %></td>
            <td><%= a.getStatus() %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="6">⚠ Không có agent nào.</td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>
