<%-- 
    Document   : manager_leaderboard
    Created on : Oct 22, 2025, 6:23:46 AM
    Author     : Nguyễn Tùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.User" %>
<%@ page import="entity.AgentPerformanceDTO" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
    String activePage = (String) request.getAttribute("activePage");
    List<AgentPerformanceDTO> leaderboardList = (List<AgentPerformanceDTO>) request.getAttribute("managerLeaderboard");
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (activePage == null) activePage = "leaderboard";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Manager Leaderboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
    <%@ include file="manager_navbar.jsp" %>
    <%@ include file="manager_sidebar.jsp" %>

    
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4"><i class="fas fa-sitemap me-2"></i> Manager Leaderboard</h1>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Xếp hạng hiệu suất Team</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 80px;" class="text-center">Hạng</th>
                                    <th>Manager</th>
                                    <th class="text-end">Tổng Doanh thu Team</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% if (leaderboardList != null && !leaderboardList.isEmpty()) {
                                int rank = 0;
                                for (AgentPerformanceDTO managerPerformance : leaderboardList) {
                                    rank++;
                                    boolean isCurrentUser = (currentUser != null && managerPerformance.getAgentId() == currentUser.getUserId());
                            %>
                                    <tr class="<%= isCurrentUser ? "table-primary fw-bold" : "" %>">
                                        <td class="text-center fs-5">
                                            <% if (rank == 1) { %> 🥇 <%
                                               } else if (rank == 2) { %> 🥈 <%
                                               } else if (rank == 3) { %> 🥉 <%
                                               } else { %> <%= rank %> <% } %>
                                        </td>
                                        <td><%= managerPerformance.getAgentName() %></td>
                                        <td class="text-end"><%= currencyFormat.format(managerPerformance.getTotalPremium()) %></td>
                                    </tr>
                            <% } } else { %>
                                <tr><td colspan="3" class="text-center p-4 text-muted">Chưa có dữ liệu doanh thu để xếp hạng.</td></tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
                                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>