<%--
    Document   : ManagerDashboard
    Created on : Oct 13, 2025
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User, entity.AgentPerformanceDTO, java.util.*, java.math.BigDecimal, java.text.DecimalFormat" %>
<%
    String ctx = request.getContextPath();
    // ----- DỮ LIỆU GIỜ ĐƯỢC LẤY TỪ REQUEST (DO SERVLET GỬI) -----
    User currentUser = (User) request.getAttribute("currentUser");
    String activePage = (String) request.getAttribute("activePage");

    // Lấy dữ liệu KPI
    BigDecimal teamPremiumThisMonth = (BigDecimal) request.getAttribute("teamPremiumThisMonth");
    Integer expiringContractsCount = (Integer) request.getAttribute("expiringContractsCount");
    Integer pendingContractsCount = (Integer) request.getAttribute("pendingContractsCount"); // Lấy KPI mới

    // Lấy dữ liệu Bảng và Widget
    List<AgentPerformanceDTO> teamPerformanceList = (List<AgentPerformanceDTO>) request.getAttribute("teamPerformanceList");
    List<AgentPerformanceDTO> leaderboardWidgetList = (List<AgentPerformanceDTO>) request.getAttribute("leaderboardWidgetList");

    // Xử lý Null (Quan trọng)
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    // (activePage đã được Servlet set)
    if (teamPremiumThisMonth == null) teamPremiumThisMonth = BigDecimal.ZERO;
    if (expiringContractsCount == null) expiringContractsCount = 0;
    if (pendingContractsCount == null) pendingContractsCount = 0; // Xử lý null
    if (teamPerformanceList == null) teamPerformanceList = new ArrayList<>();
    if (leaderboardWidgetList == null) leaderboardWidgetList = new ArrayList<>();
    
    // Định dạng tiền tệ
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
    DecimalFormat compactFormat = new DecimalFormat("0.#");
%>
<%! // ===== KHAI BÁO HÀM TRỢ GIÚP (DÙNG <%%! ... %>) =====
    /**
     * Hàm trợ giúp chuyển đổi BigDecimal sang định dạng Triệu hoặc VNĐ.
     */
    private String formatToMillion(BigDecimal value, DecimalFormat compactFormat, DecimalFormat currencyFormat) {
        if (value == null) value = BigDecimal.ZERO;
        // Nếu lớn hơn hoặc bằng 1 triệu
        if (value.compareTo(new BigDecimal("1000000")) >= 0) {
            // Chia cho 1 triệu và format
            return compactFormat.format(value.divide(new BigDecimal("1000000"))) + " Triệu";
        }
         // Nếu bằng 0
        if (value.compareTo(BigDecimal.ZERO) == 0) {
             return "0 VNĐ";
        }
        // Dưới 1 triệu, format bình thường
        return currencyFormat.format(value);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Manager Dashboard</title>
    <%-- ... (Tất cả CSS links giữ nguyên) ... --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
    <link rel="stylesheet" href="<%=ctx%>/css/manager-dashboard.css" />
    <style>
        .kpi-card-icon { font-size: 2.5rem; opacity: 0.5; }
        .table-responsive { overflow-x: auto; }
        .performance-gauge { height: 10px; border-radius: 5px; overflow: hidden; background-color: #e9ecef; }
        .performance-bar { height: 100%; } /* Thêm class này */
    </style>
</head>
<body>

    <%@ include file="manager_navbar.jsp" %>
    <%@ include file="manager_sidebar.jsp" %> <%-- Sidebar sẽ tự động lấy activePage="dashboard" --%>

    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Manager Dashboard: <%= currentUser.getFullName() %></h1> <%-- Tên Manager động --%>

            <%-- Hàng chứa các KPI Cards --%>
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="card bg-info text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Team Premium (Tháng Này)</h6>
                                <%-- Dữ liệu động --%>
                                <h3 class="display-6 fw-bold mb-0"><%= formatToMillion(teamPremiumThisMonth, compactFormat, currencyFormat) %></h3> 
                                <small>Mục tiêu: 800 Triệu (Demo)</small>
                            </div>
                            <i class="fas fa-dollar-sign kpi-card-icon"></i>
                        </div>
                         <div class="card-footer bg-info border-0 text-white-50">
                             <a href="<%=ctx%>/manager/performance" class="text-white">Xem Chi tiết Team <i class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6 mb-4">
                     <%-- Sửa KPI này thành HĐ Chờ Duyệt (Pending) --%>
                    <div class="card bg-warning text-dark"> <%-- Đổi màu --%>
                         <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Hợp đồng Chờ Duyệt</h6>
                                <%-- Dữ liệu động --%>
                                <h3 class="display-6 fw-bold mb-0"><%= pendingContractsCount %></h3> 
                                <small>Hợp đồng mới cần bạn xử lý</small>
                            </div>
                            <i class="fas fa-hourglass-half kpi-card-icon"></i>
                        </div>
                        <div class="card-footer bg-warning border-0 text-dark-50">
                             <a href="<%=ctx%>/manager/contracts?action=listPending" class="text-dark">Đi đến Duyệt <i class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-12 mb-4">
                     <div class="card bg-danger text-white">
                         <div class="card-body d-flex justify-content-between align-items-center">
                             <div>
                                <h6 class="text-uppercase mb-0">HĐ Sắp Hết Hạn (90 ngày)</h6>
                                <%-- Dữ liệu động --%>
                                <h3 class="display-6 fw-bold mb-0"><%= expiringContractsCount %></h3> 
                                <small>Cần nhắc Agent gia hạn</small>
                            </div>
                            <i class="fas fa-bell kpi-card-icon"></i>
                        </div>
                         <div class="card-footer bg-danger border-0 text-white-50">
                             <a href="<%=ctx%>/manager/contracts?action=listAll" class="text-white">Xem Danh sách HĐ <i class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Hàng chứa Bảng Performance và Biểu đồ --%>
            <div class="row">
                <div class="col-lg-8 mb-4">
                    <div class="card">
                         <div class="card-header"><h5 class="mb-0"><i class="fas fa-users-line me-2"></i> Agent Performance (Team)</h5></div>
                         <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover mb-0">
                                     <thead class="bg-light">
                                        <tr>
                                            <th>Agent Name</th>
                                            <th class="text-end">Premium (Active)</th>
                                            <th class="text-center">HĐ (Active)</th>
                                            <th class="text-center">Conversion (Demo)</th>
                                            <th>Target (Demo)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%-- Dữ liệu động từ teamPerformanceList --%>
                                        <% if (teamPerformanceList.isEmpty()) { %>
                                            <tr><td colspan="5" class="text-center text-muted p-4">Không có dữ liệu hiệu suất của team.</td></tr>
                                        <% } else {
                                            for (AgentPerformanceDTO agent : teamPerformanceList) { 
                                                // Tính toán demo cho thanh Target (giả sử target là 100tr)
                                                double target = 100000000; 
                                                double progress = (target > 0) ? (agent.getTotalPremium() / target) * 100 : 0;
                                                if (progress > 100) progress = 100;
                                                String barClass = "bg-danger";
                                                if (progress > 80) barClass = "bg-success";
                                                else if (progress > 50) barClass = "bg-primary";
                                                else if (progress > 20) barClass = "bg-warning";
                                        %>
                                            <tr>
                                                <td class="fw-bold"><%= agent.getAgentName() %></td>
                                                <td class="text-end text-success fw-bold"><%= currencyFormat.format(agent.getTotalPremium()) %></td>
                                                <td class="text-center"><%= agent.getContractsCount() %></td>
                                                <td class="text-center">N/A</td> <%-- Tạm để N/A --%>
                                                <td>
                                                    <div class="performance-gauge">
                                                        <div class="performance-bar <%= barClass %>" style="width: <%= progress %>%;"></div>
                                                    </div>
                                                    <small><%= String.format("%.0f", progress) %>%</small>
                                                </td>
                                            </tr>
                                        <%  } // end for
                                           } // end if %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                         <div class="card-footer text-center">
                            <a href="<%= ctx %>/manager/performance"><i class="fas fa-external-link-alt me-1"></i> Xem Chi tiết Performance</a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 mb-4">
                     <div class="card mb-4">
                          <div class="card-header"><h5 class="mb-0"><i class="fas fa-trophy me-2"></i> Manager Leaderboard (Top 5)</h5></div>
                            <div class="card-body">
                                <ul class="list-group list-group-flush">
                                     <%-- Dữ liệu động từ leaderboardWidgetList --%>
                                    <% if (leaderboardWidgetList.isEmpty()) { %>
                                         <li class="list-group-item text-muted text-center">Không có dữ liệu xếp hạng.</li>
                                    <% } else {
                                        int rank = 0;
                                        for (AgentPerformanceDTO manager : leaderboardWidgetList) {
                                            rank++;
                                            String icon = "#" + rank;
                                            String highlight = "";
                                            if (rank == 1) icon = "🥇";
                                            else if (rank == 2) icon = "🥈";
                                            else if (rank == 3) icon = "🥉";
                                            
                                            // Highlight Manager hiện tại
                                            if (manager.getAgentId() == currentUser.getUserId()) highlight = "list-group-item-info fw-bold";
                                    %>
                                        <li class="list-group-item d-flex justify-content-between align-items-center <%= highlight %>">
                                            <span><%= icon %> <%= manager.getAgentName() %></span>
                                            <span class="badge bg-success"><%= currencyFormat.format(manager.getTotalPremium()) %></span>
                                        </li>
                                    <%  } // end for
                                       } // end if %>
                                    <li class="list-group-item text-center"><a href="<%= ctx %>/managers/leaderboard">Xem Bảng Xếp Hạng Đầy Đủ</a></li>
                                </ul>
                            </div>
                    </div>

                    <div class="card">
                         <div class="card-header"><h5 class="mb-0"><i class="fas fa-chart-pie me-2"></i> Product Distribution</h5></div>
                            <div class="card-body p-3 chart-250">
                                <canvas id="productDistributionChart"></canvas> <%-- Dữ liệu vẫn fix cứng trong JS --%>
                            </div>
                    </div>
                </div>
            </div>

            <div class="mt-4">
                <small class="text-muted">Manager Dashboard Version 1.0</small>
            </div>
        </div>
    </main>

    <%-- Footer --%>
    <footer class="main-footer text-muted">
         <div classT="container-fluid">
            <div class="d-flex justify-content-between py-2">
                <div>© Your Company 2025</div>
                <div><b>Version</b> 1.0</div>
            </div>
        </div>
    </footer>

    <%-- JS Includes (Chỉ 1 file bundle) --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
    
    <%-- Script vẽ biểu đồ (Dữ liệu vẫn fix cứng) --%>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Dữ liệu này nên được lấy động từ Servlet (productLabels, productData)
            const productLabels = ['Bảo hiểm Nhân thọ', 'Bảo hiểm Sức khỏe']; // Cập nhật theo DB
            const productData = [45, 55]; // Dữ liệu demo

            const ctxProduct = document.getElementById('productDistributionChart');
            if (ctxProduct) { // Kiểm tra xem canvas có tồn tại không
                new Chart(ctxProduct, {
                    type: 'doughnut',
                    data: {
                        labels: productLabels,
                        datasets: [{
                            data: productData,
                            backgroundColor: ['#0d6efd', '#198754', '#ffc107', '#dc3545'],
                        }]
                    },
                    options: { 
                         maintainAspectRatio: false,
                         responsive: true,
                         plugins: {
                             legend: { position: 'bottom' },
                         }
                     }
                });
            }
            
            // Script cho menu xổ xuống (đã có trong manager_sidebar.jsp)
            // Không cần lặp lại ở đây
        });
    </script>

</body>
</html>