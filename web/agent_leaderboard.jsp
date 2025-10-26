<%-- 
    Document   : agent_leaderboard
    Created on : Oct 22, 2025, 6:14:05 AM
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.User" %>
<%@ page import="entity.AgentPerformanceDTO" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="entity.Customer, entity.User, java.util.*, java.text.SimpleDateFormat" %>

<%
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser");
    String activePage = (String) request.getAttribute("activePage");
    List<AgentPerformanceDTO> leaderboardList = (List<AgentPerformanceDTO>) request.getAttribute("agentLeaderboard");
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (leaderboardList == null) leaderboardList = new ArrayList<>();
    if (activePage == null) activePage = "leaderboard"; // Mặc định
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Agent Leaderboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
    <%@ include file="agent_navbar.jsp" %>
    <%@ include file="agent_sidebar.jsp" %>
    <%-- ================== MAIN CONTENT (NỘI DUNG CHÍNH CỦA TRANG) ================== --%>
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4"><i class="fas fa-trophy me-2"></i> Agent Leaderboard</h1>

            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 80px;" class="text-center">Hạng</th>
                                    <th>Agent</th>
                                    <th class="text-end">Tổng Doanh Thu</th>
                                    <th class="text-center">Số Hợp đồng</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% if (leaderboardList != null && !leaderboardList.isEmpty()) {
                                int rank = 0;
                                for (AgentPerformanceDTO agent : leaderboardList) {
                                    rank++;
                                    boolean isCurrentUser = (currentUser != null && agent.getAgentId() == currentUser.getUserId());
                            %>
                                    <tr class="<%= isCurrentUser ? "table-primary fw-bold" : "" %>">
                                        <td class="text-center fs-5">
                                            <% if (rank == 1) { %> 🥇 <%
                                               } else if (rank == 2) { %> 🥈 <%
                                               } else if (rank == 3) { %> 🥉 <%
                                               } else { %> <%= rank %> <% } %>
                                        </td>
                                        <td><%= agent.getAgentName() %></td>
                                        <td class="text-end"><%= currencyFormat.format(agent.getTotalPremium()) %></td>
                                        <td class="text-center"><%= agent.getContractsCount() %></td>
                                    </tr>
                            <% } } else { %>
                                <tr><td colspan="4" class="text-center p-4 text-muted">Chưa có dữ liệu doanh thu để xếp hạng.</td></tr>
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