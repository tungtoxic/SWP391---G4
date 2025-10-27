<%-- 
    Document   : manager_leaderboard
    Created on : Oct 22, 2025, 6:23:46 AM
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.User, entity.AgentPerformanceDTO, java.text.DecimalFormat" %>
<%
    // 1. Khai báo biến
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser"); // Lấy từ Servlet
    String activePage = (String) request.getAttribute("activePage"); // Lấy "leaderboard"

    // 2. Lấy dữ liệu (Đã được Servlet tách)
    AgentPerformanceDTO top1 = (AgentPerformanceDTO) request.getAttribute("top1Manager");
    AgentPerformanceDTO top2 = (AgentPerformanceDTO) request.getAttribute("top2Manager");
    AgentPerformanceDTO top3 = (AgentPerformanceDTO) request.getAttribute("top3Manager");
    List<AgentPerformanceDTO> remainingManagers = (List<AgentPerformanceDTO>) request.getAttribute("remainingManagers");
    
    // 3. Formatters
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
    DecimalFormat percentFormat = new DecimalFormat("0.0'%'");

    // 4. Xử lý null
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (remainingManagers == null) remainingManagers = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Manager Leaderboard</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
    
    <%-- CSS TÙY CHỈNH CHO BỤC VINH DANH (PODIUM) (Copy từ agent_leaderboard) --%>
    <style>
        .podium-container {
            display: flex;
            align-items: flex-end; /* Căn đáy */
            justify-content: center;
            padding: 2rem 0;
            gap: 1.5rem;
        }
        .podium-card {
            width: 100%;
            max-width: 280px;
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
            padding-top: 1.5rem;
            padding-bottom: 1.5rem;
        }
        .podium-card .podium-rank { font-size: 3.5rem; margin-bottom: 0.5rem; }
        .podium-card .podium-name { font-size: 1.15rem; font-weight: 600; }
        .podium-card .podium-revenue { font-size: 1.5rem; font-weight: 700; }
        .podium-card .podium-percent { font-size: 1rem; font-weight: 500; }
        
        .podium-1 { background-color: #ffc107; color: #493900; order: 2; min-height: 280px; }
        .podium-2 { background-color: #0d6efd; color: white; order: 1; min-height: 240px; }
        .podium-3 { background-color: #6c757d; color: white; order: 3; min-height: 220px; }
        
        .rank-table .progress { height: 8px; background-color: #e9ecef; }
    </style>
</head>
<body>

    <%@ include file="manager_navbar.jsp" %>
    <%@ include file="manager_sidebar.jsp" %> <%-- Sẽ tự động highlight "Leader Board" --%>

    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4"><i class="fas fa-sitemap me-2"></i> Manager Leaderboard</h1>

            <%-- ================================================== --%>
            <%-- PHẦN 1: BỤC VINH DANH (PODIUM) TOP 3 --%>
            <%-- ================================================== --%>
            <div class="row">
                <div class="col-12">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0">🏆 Top 3 Managers (Theo Doanh thu Team)</h5>
                        </div>
                        <div class="card-body podium-container">
                        
                            <%-- Bục Hạng 2 --%>
                            <% if (top2 != null) { %>
                            <div class="podium-card podium-2">
                                <div class="podium-rank"><i class="fas fa-medal"></i></div>
                                <div class="podium-name"><%= top2.getAgentName() %></div>
                                <div class="podium-revenue"><%= currencyFormat.format(top2.getTotalPremium()) %></div>
                                <div class="podium-percent"><%= percentFormat.format(top2.getRevenuePercentage()) %></div>
                            </div>
                            <% } %>
                            
                            <%-- Bục Hạng 1 --%>
                            <% if (top1 != null) { %>
                            <div class="podium-card podium-1">
                                <div class="podium-rank"><i class="fas fa-trophy"></i></div>
                                <div class="podium-name"><%= top1.getAgentName() %></div>
                                <div class="podium-revenue"><%= currencyFormat.format(top1.getTotalPremium()) %></div>
                                <div class="podium-percent"><%= percentFormat.format(top1.getRevenuePercentage()) %></div>
                            </div>
                            <% } %>
                            
                            <%-- Bục Hạng 3 --%>
                            <% if (top3 != null) { %>
                            <div class="podium-card podium-3">
                                <div class="podium-rank"><i class="fas fa-medal"></i></div>
                                <div class="podium-name"><%= top3.getAgentName() %></div>
                                <div class="podium-revenue"><%= currencyFormat.format(top3.getTotalPremium()) %></div>
                                <div class="podium-percent"><%= percentFormat.format(top3.getRevenuePercentage()) %></div>
                            </div>
                            <% } %>
                            
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
                                    <th>Manager</th>
                                    <th classR="text-end">Team Revenue</th>
                                    <th style="width: 25%;">Contribution</th>
                                    <th style="width: 80px;" class="text-end">%</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% if (remainingManagers.isEmpty()) { %>
                                <tr><td colspan="5" class="text-center p-4 text-muted">Không có dữ liệu xếp hạng từ hạng 4 trở đi.</td></tr>
                            <% } else {
                                int rank = 3; // Bắt đầu đếm từ hạng 4
                                for (AgentPerformanceDTO manager : remainingManagers) {
                                    rank++;
                                    boolean isCurrentUser = (manager.getAgentId() == currentUser.getUserId());
                            %>
                                    <tr class="<%= isCurrentUser ? "table-primary fw-bold" : "" %>">
                                        <td class="text-center fw-bold"><%= rank %></td>
                                        <td>
                                            <%= manager.getAgentName() %>
                                            <% if(isCurrentUser) { %> <span class="badge bg-secondary">Bạn</span> <% } %>
                                        </td>
                                        <td class="text-end fw-bold"><%= currencyFormat.format(manager.getTotalPremium()) %></td>
                                        <td>
                                            <%-- Thanh Progress Bar động --%>
                                            <div class="progress">
                                                <div class="progress-bar" role="progressbar" 
                                                     style="width: <%= manager.getRevenuePercentage() %>%;" 
                                                     aria-valuenow="<%= manager.getRevenuePercentage() %>" 
                                                     aria-valuemin="0" aria-valuemax="100">
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-end"><%= percentFormat.format(manager.getRevenuePercentage()) %></td>
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
</body>
</html>