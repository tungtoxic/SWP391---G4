<%-- 
    Document   : agentprofile
    Created on : Oct 11, 2025, 2:37:33 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.User" %>

<html>
<head>
    <title>Agent Management</title>
    <style>
        /* 🎨 CSS thủ công */
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 90%;
            max-width: 1000px;
            margin: 40px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }

        .btn {
            display: inline-block;
            padding: 8px 14px;
            border-radius: 6px;
            text-decoration: none;
            color: #fff;
            font-weight: 500;
            transition: 0.2s;
            cursor: pointer;
        }

        .btn-primary { background-color: #007bff; }
        .btn-primary:hover { background-color: #0056b3; }

        .btn-warning { background-color: #ffc107; color: #000; }
        .btn-warning:hover { background-color: #d39e00; }

        .btn-danger { background-color: #dc3545; }
        .btn-danger:hover { background-color: #b52a37; }

        .btn-success { background-color: #198754; }
        .btn-success:hover { background-color: #0d6e3d; }

        .text-end { text-align: right; margin-bottom: 15px; }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        thead {
            background-color: #333;
            color: #fff;
        }

        th, td {
            padding: 10px 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        tr:nth-child(even) { background-color: #f9f9f9; }

        .badge {
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 0.9em;
            color: #fff;
        }
        .bg-success { background-color: #28a745; }
        .bg-secondary { background-color: #6c757d; }

        .alert {
            background-color: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
        }
    </style>
</head>

<body>
<div class="container">
    <h2>Agent Management</h2>

    <div class="text-end">
        <a href="addAgent.jsp" class="btn btn-primary">+ Add New Agent</a>
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
            <th>Created At</th>
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
                    <span class="badge 
                        ${agent.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
                        ${agent.status}
                    </span>
                </td>
                <td>${agent.createdAt}</td>
                <td>
                    <a href="AgentManagementServlet?action=edit&id=${agent.userId}" class="btn btn-warning btn-sm">Edit</a>

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
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>


