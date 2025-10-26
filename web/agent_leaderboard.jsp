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
    AgentPerformanceDTO top1 = (AgentPerformanceDTO) request.getAttribute("top1Agent");
    AgentPerformanceDTO top2 = (AgentPerformanceDTO) request.getAttribute("top2Agent");
    AgentPerformanceDTO top3 = (AgentPerformanceDTO) request.getAttribute("top3Agent");
    List<AgentPerformanceDTO> remainingAgents = (List<AgentPerformanceDTO>) request.getAttribute("remainingAgents");
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
    DecimalFormat percentFormat = new DecimalFormat("0.0'%'");
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (remainingAgents == null) remainingAgents = new ArrayList<>();
    if (activePage == null) activePage = "leaderboard";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Agent Leaderboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
    <%-- CSS TÙY CHỈNH CHO BỤC VINH DANH (PODIUM) --%>
    <style>
        .podium-container {
            display: flex;
            align-items: flex-end; /* Căn đáy */
            justify-content: center;
            padding: 2rem 0;
            gap: 1.5rem; /* Khoảng cách giữa các bục */
        }
        .podium-card {
            width: 100%;
            max-width: 280px; /* Giới hạn độ rộng card */
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
            padding-top: 1.5rem;
            padding-bottom: 1.5rem;
        }
        .podium-card .podium-rank {
            font-size: 3.5rem; /* Icon cúp/huy chương */
            margin-bottom: 0.5rem;
        }
        .podium-card .podium-name {
            font-size: 1.15rem;
            font-weight: 600;
        }
        .podium-card .podium-revenue {
            font-size: 1.5rem;
            font-weight: 700;
        }
        .podium-card .podium-percent {
            font-size: 1rem;
            font-weight: 500;
        }
        
        /* Màu sắc & Chiều cao Bục */
        /* #1 - Vàng */
        .podium-1 {
            background-color: #ffc107; /* Vàng */
            color: #493900;
            order: 2; /* Sắp xếp thứ tự trên Flex */
            min-height: 280px; /* Cao nhất */
        }
        /* #2 - Bạc (Dùng màu xanh dương của bạn) */
        .podium-2 {
            background-color: #0d6efd; /* Xanh dương */
            color: white;
            order: 1;
            min-height: 240px; /* Vừa */
        }
        /* #3 - Đồng */
        .podium-3 {
            background-color: #6c757d; /* Xám */
            color: white;
            order: 3;
            min-height: 220px; /* Thấp hơn */
        }
        
        /* CSS cho bảng bên dưới */
        .rank-table .progress {
            height: 8px; /* Thanh progress mỏng */
            background-color: #e9ecef;
        }
    </style>
</head>
<body>
    <%@ include file="agent_navbar.jsp" %>
    <%@ include file="agent_sidebar.jsp" %>
    <%-- ================== MAIN CONTENT (NỘI DUNG CHÍNH CỦA TRANG) ================== --%>
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4"><i class="fas fa-trophy me-2"></i> Agent Leaderboard</h1>
            <div class="row">
                <div class="col-12">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0">🏆 Top 3 Agents (All Time)</h5>
                        </div>
                        <div class="card-body podium-container">
                        
                            <%-- Bục Hạng 2 (Bạc) --%>
                            <% if (top2 != null) { %>
                            <div class="podium-card podium-2">
                                <div class="podium-rank"><i class="fas fa-medal"></i></div>
                                <%-- Avatar (thêm sau) --%>
                                <div class="podium-name"><%= top2.getAgentName() %></div>
                                <div class="podium-revenue"><%= currencyFormat.format(top2.getTotalPremium()) %></div>
                                <div class="podium-percent"><%= percentFormat.format(top2.getRevenuePercentage()) %></div>
                            </div>
                            <% } %>
                            
                            <%-- Bục Hạng 1 (Vàng) --%>
                            <% if (top1 != null) { %>
                            <div class="podium-card podium-1">
                                <div class="podium-rank"><i class="fas fa-trophy"></i></div>
                                <%-- Avatar (thêm sau) --%>
                                <div class="podium-name"><%= top1.getAgentName() %></div>
                                <div class="podium-revenue"><%= currencyFormat.format(top1.getTotalPremium()) %></div>
                                <div class="podium-percent"><%= percentFormat.format(top1.getRevenuePercentage()) %></div>
                            </div>
                            <% } %>
                            
                            <%-- Bục Hạng 3 (Đồng) --%>
                            <% if (top3 != null) { %>
                            <div class="podium-card podium-3">
                                <div class="podium-rank"><i class="fas fa-medal"></i></div>
                                <%-- Avatar (thêm sau) --%>
                                <div class="podium-name"><%= top3.getAgentName() %></div>
                                <div class="podium-revenue"><%= currencyFormat.format(top3.getTotalPremium()) %></div>
                                <div class="podium-percent"><%= percentFormat.format(top3.getRevenuePercentage()) %></div>
                            </div>
                            <% } %>
                            
                             <%-- Trường hợp không có ai --%>
                            <% if (top1 == null) { %>
                                <p class="text-muted">Chưa có dữ liệu xếp hạng Top 3.</p>
                            <% } %>
                            
                        </div>
                    </div>
                </div>
            </div>

            <%-- ================================================== --%>
            <%-- PHẦN 2: BẢNG XẾP HẠNG CHI TIẾT (TOP 4+) --%>
            <%-- ================================================== --%>
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Bảng Xếp Hạng Chi Tiết (Hạng 4+)</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive rank-table">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 60px;" class="text-center">#</th>
                                    <th>Salesperson</th>
                                    <th class="text-end">Revenue</th>
                                    <th style="width: 25%;">Contribution</th> <%-- Cột thanh progress --%>
                                    <th style="width: 80px;" class="text-end">%</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% if (remainingAgents.isEmpty()) { %>
                                <tr><td colspan="5" class="text-center p-4 text-muted">Không có dữ liệu xếp hạng từ hạng 4 trở đi.</td></tr>
                            <% } else {
                                int rank = 3; // Bắt đầu đếm từ hạng 4
                                for (AgentPerformanceDTO agent : remainingAgents) {
                                    rank++;
                                    boolean isCurrentUser = (agent.getAgentId() == currentUser.getUserId());
                            %>
                                    <tr class="<%= isCurrentUser ? "table-primary fw-bold" : "" %>">
                                        <td class="text-center fw-bold"><%= rank %></td>
                                        <td>
                                            <%= agent.getAgentName() %>
                                            <% if(isCurrentUser) { %> <span class="badge bg-secondary">Bạn</span> <% } %>
                                        </td>
                                        <td class="text-end fw-bold"><%= currencyFormat.format(agent.getTotalPremium()) %></td>
                                        <td>
                                            <%-- Thanh Progress Bar động --%>
                                            <div class="progress">
                                                <div class="progress-bar" role="progressbar" 
                                                     style="width: <%= agent.getRevenuePercentage() %>%;" 
                                                     aria-valuenow="<%= agent.getRevenuePercentage() %>" 
                                                     aria-valuemin="0" aria-valuemax="100">
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-end"><%= percentFormat.format(agent.getRevenuePercentage()) %></td>
                                    </tr>
                            <%  } // end for
                               } // end if %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
        </div>
    </main>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <%-- (Script sidebar đã nằm trong file include) --%>
</body>
</html>