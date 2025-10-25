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
    List<AgentPerformanceDTO> leaderboardList = (List<AgentPerformanceDTO>) request.getAttribute("managerLeaderboard");
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
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
        <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company</a>
            <div>
                <ul class="navbar-nav d-flex flex-row align-items-center">
                    <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/home.jsp">Home</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <aside class="sidebar bg-primary text-white">
        <div class="sidebar-top p-3">
            <div class="d-flex align-items-center mb-3">
                <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                <div>
                    <div class="fw-bold">Manager Name</div>
                    <div style="font-size:.85rem;opacity:.9">Sales Manager</div>
                </div>
            </div>
        </div>

        <nav class="nav flex-column px-2">
            <a class="nav-link text-white active py-2" href="#"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/manager/performance"><i class="fas fa-users-cog me-2"></i> Team Performance</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agentmanagement.jsp"><i class="fas fa-users-cog me-2"></i> Agent Management</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/managers/leaderboard"><i class="fas fa-trophy me-2"></i> Leader Board</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-invoice-dollar me-2"></i> Commission Policies</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/productmanagement.jsp"><i class="fas fa-box me-2"></i> Product</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/manager/contracts"><i class="fas fa-file-signature me-2"></i> Contract</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>
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
</body>
</html>