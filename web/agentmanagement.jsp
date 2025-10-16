<%-- 
    Document   : agentmanagement
    Created on : Oct 11, 2025, 2:32:14 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.User" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<html>
    <head>
        <title>Agent Management</title>
        <style>
            /* ===== Body & Container ===== */
            body {
                font-family: 'Segoe UI', Tahoma, sans-serif;
                background-color: #f4f6f8;
                margin: 0;
                padding: 0;
            }
            .container {
                width: 90%;
                max-width: 1100px;
                margin: 40px auto;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                padding: 30px;
            }
            h2 {
                text-align:center;
                margin-bottom: 25px;
                color:#333;
            }

            /* ===== Buttons ===== */
            .btn {
                padding:6px 12px;
                border-radius:6px;
                text-decoration:none;
                color:#fff;
                font-weight:500;
                cursor:pointer;
                font-size:0.85em;
                margin:2px;
                display:inline-block;
            }
            .btn-primary{
                background:#007bff;
            }
            .btn-primary:hover{
                background:#0056b3;
            }
            .btn-success{
                background:#198754;
            }
            .btn-success:hover{
                background:#0d6e3d;
            }
            .btn-danger{
                background:#dc3545;
            }
            .btn-danger:hover{
                background:#b52a37;
            }
            .btn-warning{
                background:#ffc107;
                color:#000;
            }
            .btn-warning:hover{
                background:#d39e00;
            }

            /* ===== Filter buttons ===== */
            .filter-btns{
                margin-bottom:20px;
            }
            .filter-btns a{
                margin-right:5px;
            }

            /* ===== Table ===== */
            table {
                width:100%;
                border-collapse:collapse;
                background:#fff;
                table-layout: fixed;
            }
            thead {
                background:#333;
                color:#fff;
            }
            th, td {
                padding:10px 12px;
                border:1px solid #ddd;
                text-align:center;
                word-wrap:break-word;
            }
            tbody {
                max-height:400px;
                overflow-y:auto;
                display:block;
            }
            tr {
                display:table;
                width:100%;
                table-layout:fixed;
            }
            tr:nth-child(even){
                background:#f9f9f9;
            }

            /* ===== Status Badge ===== */
            .badge {
                padding:4px 8px;
                border-radius:20px;
                font-size:0.8em;
                color:#fff;
            }
            .bg-success{
                background:#28a745;
            }
            .bg-secondary{
                background:#6c757d;
            }

            /* ===== Form inside table ===== */
            form {
                margin:0;
            }
            form input[type="text"]{
                width: 100%;
                padding:4px 6px;
                border-radius:4px;
                border:1px solid #ccc;
                font-size:0.85em;
            }
            form button{
                padding:4px 8px;
                font-size:0.85em;
            }

            /* ===== Alert ===== */
            .alert{
                background:#d1ecf1;
                border:1px solid #bee5eb;
                color:#0c5460;
                padding:10px;
                border-radius:5px;
                margin-bottom:15px;
            }
        </style>

    </head>

    <body>
        <div class="container">
            <h2>Agent Management</h2>

            <div class="text-end">
                <a href="createAgent.jsp" class="btn btn-primary">+ Create New Agent</a>
            </div>

            <div class="filter-btns">
                <a href="AgentManagementServlet?status=Active" class="btn btn-success btn-sm">Active Agents</a>
                <a href="AgentManagementServlet?status=Pending" class="btn btn-success btn-sm">Pending Agents</a>
                <a href="AgentManagementServlet?status=Inactive" class="btn btn-success btn-sm">Inactive Agents</a>
                <a href="AgentManagementServlet" class="btn btn-primary btn-sm">All Agents</a>
            </div>

            <c:if test="${not empty message}">
                <div class="alert">${message}</div>
            </c:if>

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
                    <c:forEach var="agent" items="${agentList}">
                        <tr>
                            <td>${agent.userId}</td>
                            <td>${agent.fullName}</td>
                            <td>${agent.email}</td>
                            <td>${agent.phoneNumber}</td>
                            <td>
                                <span class="badge ${agent.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
                                    ${agent.status}
                                </span>
                            </td>

                            <!-- Username -->
                            <td>
                                <c:choose>
                                    <c:when test="${agent.status == 'Pending'}">
                                        <!-- Chỉ khi mới đăng ký -->
                                        <form action="AgentManagementServlet" method="post" style="display:flex; gap:4px; align-items:center;">
                                            <input type="hidden" name="action" value="approve">
                                            <input type="hidden" name="id" value="${agent.userId}">
                                            <input type="text" name="username" placeholder="Username" required style="width:90px;">
                                        </c:when>
                                        <c:otherwise>
                                            ${agent.username}
                                        </c:otherwise>
                                    </c:choose>
                                    </td>

                                    <!-- Password -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${agent.status == 'Pending'}">
                                                <input type="text" name="password" placeholder="Password" required style="width:90px;">
                                            </c:when>
                                            <c:otherwise>
                                                ${agent.password}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- Actions -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${agent.status == 'Pending'}">
                                                <button type="submit" class="btn btn-success btn-sm">Approve</button>
                                        </form> <!-- đóng form đúng chỗ -->
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${agent.status == 'Active'}">
                                                <a href="AgentManagementServlet?action=deactivate&id=${agent.userId}" class="btn btn-danger btn-sm"
                                                   onclick="return confirm('Deactivate this agent?')">Deactivate</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="AgentManagementServlet?action=activate&id=${agent.userId}" class="btn btn-success btn-sm"
                                                   onclick="return confirm('Activate this agent?')">Activate</a>
                                            </c:otherwise>
                                        </c:choose>
                                        <a href="AgentManagementServlet?action=delete&id=${agent.userId}" class="btn btn-danger btn-sm"
                                           onclick="return confirm('Delete this agent?')">Delete</a>
                                        <a href="AgentManagementServlet?action=edit&id=${agent.userId}" class="btn btn-warning btn-sm">Edit</a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>


            </table>
        </div>
    </body>
</html>






