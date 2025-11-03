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
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
    List<AgentPerformanceDTO> leaderboardList = (List<AgentPerformanceDTO>) request.getAttribute("agentLeaderboard");
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
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
     <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company</a>
            <ul class="navbar-nav d-flex flex-row align-items-center">
                <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/home.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </nav>

    <aside class="sidebar bg-primary text-white">
        <div class="sidebar-top p-3">
            <div class="d-flex align-items-center mb-3">
                <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                <div>
                    <div class="fw-bold"><%= currentUser != null ? currentUser.getFullName() : "Agent" %></div>
                    <div style="font-size:.85rem;opacity:.9">Sales Agent</div>
                </div>
            </div>
        </div>
        <nav class="nav flex-column px-2">
            <%-- ĐÃ SỬA LỖI ĐIỀU HƯỚNG --%>
            <a class="nav-link text-white active py-2" href="<%=ctx%>/agent/dashboard"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agents/leaderboard"><i class="fas fa-trophy me-2"></i> Leaderboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/commission-report"><i class="fas fa-percent me-2"></i> Commission Report</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-box me-2"></i> Product</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/contracts"><i class="fas fa-file-signature me-2"></i> Contract</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/customers"><i class="fas fa-users me-2"></i> Customer</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>


    <%-- ================== SIDEBAR (THEO ĐÚNG MẪU CỦA BẠN) ================== --%>
    <aside class="sidebar bg-primary text-white">
        <div class="sidebar-top p-3">
            <div class="d-flex align-items-center mb-3">
                <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                <div>
                    <div class="fw-bold"><%= currentUser != null ? currentUser.getFullName() : "Agent" %></div>
                    <div style="font-size:.85rem;opacity:.9">Sales Agent</div>
                </div>
            </div>
        </div>

        <nav class="nav flex-column px-2">
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/dashboard""><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
            <a class="nav-link text-white active py-2" href="<%=ctx%>/leaderboard/agents"><i class="fas fa-trophy me-2"></i> Leader Board</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/commission-report"><i class="fas fa-percent me-2"></i> Commission Report</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-box me-2"></i> Product</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/contracts"><i class="fas fa-file-signature me-2"></i> Contract</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/customers"><i class="fas fa-users me-2"></i> Customer</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>

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