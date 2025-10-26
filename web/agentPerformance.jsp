<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.User" %>
<%@ page import="entity.AgentPerformanceDTO" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
    List<AgentPerformanceDTO> teamPerformanceList = (List<AgentPerformanceDTO>) request.getAttribute("teamPerformanceList");
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
    String activePage = "performance";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Agent Performance</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
    <style>
        .progress { height: 8px; }
    </style>
</head>
<body>
  <%-- Include Navbar --%>
    <%@ include file="manager_navbar.jsp" %>

    <%-- Include Sidebar  --%>
    <%@ include file="manager_sidebar.jsp" %>
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Agent Performance Matrix</h1>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i> Team Performance Summary</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>Agent Name</th>
                                    <th class="text-end">Total Revenue (Active Contracts)</th>
                                    <th class="text-center">Contracts Sold</th>
                                    <th style="width: 20%;">Target Progress (Example)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (teamPerformanceList != null && !teamPerformanceList.isEmpty()) {
                                    int index = 0;
                                    for (AgentPerformanceDTO agent : teamPerformanceList) {
                                        index++;
                                        double target = 50000000; // Ví dụ target là 50 triệu
                                        double progress = (agent.getTotalPremium() / target) * 100;
                                %>
                                        <tr>
                                            <td><%= index %></td>
                                            <td class="fw-bold"><%= agent.getAgentName() %></td>
                                            <td class="text-end"><%= currencyFormat.format(agent.getTotalPremium()) %></td>
                                            <td class="text-center"><%= agent.getContractsCount() %></td>
                                            <td>
                                                <div class="progress">
                                                    <div class="progress-bar" role="progressbar" 
                                                         style="width: <%= progress > 100 ? 100 : progress %>%;" 
                                                         aria-valuenow="<%= progress %>" aria-valuemin="0" aria-valuemax="100">
                                                    </div>
                                                </div>
                                                <small class="text-muted"><%= String.format("%.1f", progress) %>%</small>
                                            </td>
                                        </tr>
                                <%
                                    }
                                } else {
                                %>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted p-4">
                                            No performance data available for your team.
                                        </td>
                                    </tr>
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