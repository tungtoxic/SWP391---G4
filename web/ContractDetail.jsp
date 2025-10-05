<%-- 
    Document   : ContractDetail
    Created on : Oct 5, 2025, 2:50:01 PM
    Author     : LoveWine
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Contract Details</title>
        <link rel="stylesheet" href="styles.css"/>
    </head>
    <body>
        <h2>Contract Details</h2>
        <table border="1" class="table table-striped">
            <tr>
                <th>ID</th><th>Customer</th><th>Product</th>
                <th>Start</th><th>End</th><th>Value</th>
                <th>Status</th><th>Manager</th>
            </tr>
            <c:forEach items="${contracts}" var="c">
                <tr>
                    <td>${c.contractId}</td>
                    <td>${c.customerName}</td>
                    <td>${c.productName}</td>
                    <td>${c.startDate}</td>
                    <td>${c.endDate}</td>
                    <td>${c.value}</td>
                    <td>${c.status}</td>
                    <td>${c.managerName}</td>
                </tr>
            </c:forEach>
        </table>

        <a href="managerDashboard.jsp">⬅ Back to Dashboard</a>
    </body>
</html>

