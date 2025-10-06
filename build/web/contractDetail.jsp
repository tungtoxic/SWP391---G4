<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Contract Details</title>
        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">

        <div class="container mt-5">
            <div class="card shadow-lg">
                <div class="card-header bg-primary text-white">
                    <h3 class="mb-0">📑 Contract Details</h3>
                </div>
                <div class="card-body">
                    <p><a href="Dashboard.jsp" class="btn btn-outline-secondary btn-sm">⬅ Back to Dashboard</a></p>

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

    </body>
</html>
