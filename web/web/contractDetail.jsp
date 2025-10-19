<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Contract Details</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<%
    // Lấy role của user từ session
    String role = (String) session.getAttribute("role");
    String dashboardUrl = "home.jsp"; // mặc định nếu không xác định role

    if ("Admin".equals(role)) dashboardUrl = "AdminDashboard.jsp";
    else if ("Manager".equals(role)) dashboardUrl = "usermanagement.jsp";
    else if ("Agent".equals(role)) dashboardUrl = "AgentDashboard.jsp";
%>

<div class="container mt-5">
    <div class="card shadow-lg">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h3 class="mb-0">📑 Contract Details</h3>
            <a href="<%=dashboardUrl%>" class="btn btn-light">⬅ Back to Dashboard</a>
        </div>

        <div class="card-body">
            <!-- Bộ lọc -->
            <form method="get" action="contracts" class="row g-3 mb-4">
                <div class="col-md-3">
                    <input type="text" class="form-control" name="agent" placeholder="Agent Name">
                </div>
                <div class="col-md-3">
                    <select class="form-select" name="status">
                        <option value="">All Status</option>
                        <option value="Active">Active</option>
                        <option value="Pending">Pending</option>
                        <option value="Expired">Expired</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <input type="text" class="form-control" name="search" placeholder="Search customer or product">
                </div>
                <div class="col-md-2">
                    <button class="btn btn-success w-100">Filter</button>
                </div>
            </form>

            <!-- Thống kê tổng -->
            <div class="alert alert-info">
                <strong>Total Contracts:</strong> ${totalContracts} |
                <strong>Total Premium:</strong> ${totalPremium}
            </div>

            <!-- Bảng dữ liệu -->
            <table class="table table-striped table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Customer</th>
                        <th>Agent</th>
                        <th>Product</th>
                        <th>Start</th>
                        <th>End</th>
                        <th>Status</th>
                        <th>Premium</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${contracts}" var="c">
                        <tr>
                            <td>${c.contractId}</td>
                            <td>${c.customer}</td>
                            <td>${c.agent}</td>
                            <td>${c.product}</td>
                            <td>${c.startDate}</td>
                            <td>${c.endDate}</td>
                            <td>
                                <span class="badge
                                    <c:choose>
                                        <c:when test="${c.status == 'Active'}">bg-success</c:when>
                                        <c:when test="${c.status == 'Pending'}">bg-warning text-dark</c:when>
                                        <c:when test="${c.status == 'Expired'}">bg-danger</c:when>
                                        <c:otherwise>bg-secondary</c:otherwise>
                                    </c:choose>">
                                    ${c.status}
                                </span>
                            </td>
                            <td class="text-end">${c.premiumAmount}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
