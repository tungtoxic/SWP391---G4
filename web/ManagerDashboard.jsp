<%--
    Document   : ManagerDashboard
    Created on : Oct 13, 2025
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User, entity.AgentPerformanceDTO, java.util.*, java.math.BigDecimal, java.text.DecimalFormat" %>
<%@ page import="entity.Task" %> <%-- Đã import Task --%>
<%
    String ctx = request.getContextPath();
    // ----- DỮ LIỆU GIỜ ĐƯỢC LẤY TỪ REQUEST (DO SERVLET GỬI) -----
    User currentUser = (User) request.getAttribute("currentUser");
    String activePage = (String) request.getAttribute("activePage");

    // Lấy dữ liệu KPI
    BigDecimal teamPremiumThisMonth = (BigDecimal) request.getAttribute("teamPremiumThisMonth");
    Integer expiringContractsCount = (Integer) request.getAttribute("expiringContractsCount");
    Integer pendingContractsCount = (Integer) request.getAttribute("pendingContractsCount");

    // Lấy dữ liệu Bảng và Widget
    List<AgentPerformanceDTO> teamPerformanceList = (List<AgentPerformanceDTO>) request.getAttribute("teamPerformanceList");
    List<AgentPerformanceDTO> leaderboardWidgetList = (List<AgentPerformanceDTO>) request.getAttribute("leaderboardWidgetList");
    
    // Lấy personalTasks
    List<Task> personalTasks = (List<Task>) request.getAttribute("personalTasks");

    // Xử lý Null (Quan trọng)
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (activePage == null) activePage = "dashboard";
    if (teamPremiumThisMonth == null) teamPremiumThisMonth = BigDecimal.ZERO;
    if (expiringContractsCount == null) expiringContractsCount = 0;
    if (pendingContractsCount == null) pendingContractsCount = 0;
    if (teamPerformanceList == null) teamPerformanceList = new ArrayList<>();
    if (leaderboardWidgetList == null) leaderboardWidgetList = new ArrayList<>();
    if (personalTasks == null) personalTasks = new ArrayList<>();
    
    // Định dạng tiền tệ
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
    DecimalFormat compactFormat = new DecimalFormat("0.#");
%>
<%! 
    /**
     * Hàm trợ giúp chuyển đổi BigDecimal sang định dạng Triệu hoặc VNĐ.
     */
    private String formatToMillion(BigDecimal value, DecimalFormat compactFormat, DecimalFormat currencyFormat) {
        if (value == null) value = BigDecimal.ZERO;
        if (value.compareTo(new BigDecimal("1000000")) >= 0) {
            return compactFormat.format(value.divide(new BigDecimal("1000000"))) + " Triệu";
        }
        if (value.compareTo(BigDecimal.ZERO) == 0) {
             return "0 VNĐ";
        }
        return currencyFormat.format(value);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Manager Dashboard</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
    <link rel="stylesheet" href="<%=ctx%>/css/manager-dashboard.css" />
    <style>
        .kpi-card-icon { font-size: 2.5rem; opacity: 0.5; }
        .table-responsive { overflow-x: auto; }
        .performance-gauge { height: 10px; border-radius: 5px; overflow: hidden; background-color: #e9ecef; }
        .performance-bar { height: 100%; }
        .task-item-form { margin-bottom: 0; }
        .task-title-completed { text-decoration: line-through; color: #6c757d; }
    </style>
</head>
<body>

    <%@ include file="manager_navbar.jsp" %>
    <%@ include file="manager_sidebar.jsp" %> 

    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Manager Dashboard: <%= currentUser.getFullName() %></h1> 

            <%-- Hàng chứa các KPI Cards --%>
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="card bg-info text-white h-100"> 
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Team Premium (Tháng Này)</h6>
                                <h3 class="display-6 fw-bold mb-0"><%= formatToMillion(teamPremiumThisMonth, compactFormat, currencyFormat) %></h3> 
                                <small>Target: 800 Triệu (Demo)</small>
                            </div>
                            <i class="fas fa-dollar-sign kpi-card-icon"></i>
                        </div>
                         <div class="card-footer bg-info border-0 text-white-50">
                             <a href="<%=ctx%>/manager/performance" class="text-white">Xem Chi tiết Team <i class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="card bg-warning text-dark h-100"> 
                         <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Hợp đồng Chờ Duyệt</h6>
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
                     <div class="card bg-danger text-white h-100">
                         <div class="card-body d-flex justify-content-between align-items-center">
                             <div>
                                <h6 class="text-uppercase mb-0">HĐ Sắp Hết Hạn (90 ngày)</h6>
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

            <%-- ===== HÀNG NỘI DUNG CHÍNH (ĐÃ GỘP) ===== --%>
            <div class="row">
                
                <%-- ===== CỘT BÊN TRÁI (Performance + ToDo) ===== --%>
                <div class="col-lg-8 mb-4">
                    
                    <%-- Card 1: Agent Performance (Thêm mb-4) --%>
                    <div class="card mb-4"> 
                        <div class="card-header"><h5 class="mb-0"><i class="fas fa-users-line me-2"></i> Agent Performance (Team)</h5></div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover mb-0 align-middle">
                                    <thead class="bg-light">
                                        <tr>
                                            <th>Agent Name</th>
                                            <th class="text-end">Premium (Active)</th>
                                            <th class="text-center">HĐ (Active)</th>
                                            <th class="text-center">Conversion (Demo)</th>
                                            <th>Target (Tháng <%= java.time.LocalDate.now().getMonthValue() %>)</th> <%-- Sửa Target động --%>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (teamPerformanceList.isEmpty()) { %>
                                            <tr><td colspan="5" class="text-center text-muted p-4">Không có dữ liệu hiệu suất của team.</td></tr>
                                        <% } else {
                                            for (AgentPerformanceDTO agent : teamPerformanceList) { 
                                                double target = agent.getTargetAmount(); // Lấy target động
                                                double progress = 0.0;
                                                if (target > 0) {
                                                    progress = (agent.getTotalPremium() / target) * 100;
                                                }
                                                if (progress > 100) progress = 100;
                                                String barClass = "bg-danger";
                                                if (progress >= 100) barClass = "bg-success";
                                                else if (progress >= 70) barClass = "bg-primary";
                                                else if (progress >= 40) barClass = "bg-warning";
                                        %>
                                            <tr>
                                                <td class="fw-bold"><%= agent.getAgentName() %></td>
                                                <td class="text-end text-success fw-bold"><%= currencyFormat.format(agent.getTotalPremium()) %></td>
                                                <td class="text-center"><%= agent.getContractsCount() %></td>
                                                <td class="text-center">N/A</td> 
                                                <td>
                                                    <div class="performance-gauge" title="Target: <%= currencyFormat.format(target) %>">
                                                        <div class="performance-bar <%= barClass %>" style="width: <%= progress %>%;"></div>
                                                    </div>
                                                    <%-- Hiển thị % và target --%>
                                                    <small><%= String.format("%.0f", progress) %>% (<%= currencyFormat.format(target) %>)</small>
                                                </td>
                                            </tr>
                                        <%  } // end for
                                           } // end if %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                         <div class="card-footer text-center">
                            <a href="<%= ctx %>/manager/performance"><i class="fas fa-external-link-alt me-1"></i> Xem Chi tiết & Đặt Target</a>
                        </div>
                    </div>

                    <%-- Card 2: To-Do List (ĐÃ DI CHUYỂN VÀO ĐÂY) --%>
                <div class="col-lg-15 mb-4">
                    <div class="card h-100">
                        <div class="card-header"><h5 class="mb-0"><i class="fa fa-list-check me-2"></i> Personal To-Do List</h5></div>
                        <div class="card-body p-0">
                             <ul class="list-group list-group-flush">
                                <% if (personalTasks != null && !personalTasks.isEmpty()) {
                                    for (Task task : personalTasks) { %>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <%-- Form Cập nhật (SỬA: Thêm 'source' input) --%>
                                    <form action="<%=ctx%>/manager/dashboard" method="POST" class="d-flex align-items-center flex-grow-1 task-item-form">
                                        <input type="hidden" name="action" value="completeTask">
                                        <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                                        <input type="checkbox" name="isCompleted" class="form-check-input me-2" onchange="this.form.submit()"
                                               <%= task.isCompleted() ? "checked" : "" %> value="on">
                                        <span class="<%= task.isCompleted() ? "task-title-completed" : "" %>">
                                            <%= task.getTitle() %>
                                        </span>
                                    </form>
                                    <%-- Form Xóa (SỬA: Thêm 'source' input) --%>
                                    <form action="<%=ctx%>/manager/dashboard" method="POST" class="task-item-form">
                                        <input type="hidden" name="action" value="deleteTask">
                                        <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                                        <button type="submit" class="btn btn-sm btn-link text-danger" title="Delete Task"
                                                onclick="return confirm('Delete this task?')">
                                            <i class="fa fa-trash"></i>
                                        </button>
                                    </form>
                                </li>
                                <% } } else { %>
                                    <li class="list-group-item text-muted text-center">No personal tasks.</li>
                                <% } %>
                             </ul>
                        </div>
                        <div class="card-footer">
                            <%-- Form Thêm Task mới (SỬA: Thêm 'source' input) --%>
                            <form action="<%=ctx%>/manager/dashboard" method="POST" class="d-flex gap-2">
                                <input type="hidden" name="action" value="addPersonalTask">
                                <input type="text" class="form-control" name="taskTitle" placeholder="Add a new to-do..." required>
                                <button type="submit" class="btn btn-primary flex-shrink-0">Add</button>
                            </form>
                        </div>
                    </div>
                </div>
          
                </div> <%-- Hết Cột Trái (col-lg-8) --%>

                
                <%-- ===== CỘT BÊN PHẢI (Leaderboard, Product, Goal) ===== --%>
                <div class="col-lg-4 mb-4">
                
                     <div class="card mb-4">
                          <div class="card-header"><h5 class="mb-0"><i class="fas fa-trophy me-2"></i> Manager Leaderboard (Top 5)</h5></div>
                            <div class="card-body">
                                <ul class="list-group list-group-flush">
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
                </div> <%-- Hết Cột Phải (col-lg-4) --%>
                <div class="card mb-4"> 

                <div class="card mb-4">
                    <div class="card-header"><h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i> Team Sales Trend </h5></div>
                    <div class="card-body p-3 chart-250">
                        <%-- SỬA: Đổi ID và kiểm tra dữ liệu "sạch" --%>
                        <%
                            List<String> teamSalesLabels = (List<String>) request.getAttribute("teamSalesLabels");
                            if (teamSalesLabels == null || teamSalesLabels.isEmpty()) { 
                        %>
                            <p class="text-center text-muted mt-5">Không có dữ liệu doanh số.</p>
                        <% } else { %>
                            <canvas id="teamSalesChart"></canvas> 
                        <% } %>
                    </div>
                </div>
            <div class="mt-4">
                <small class="text-muted">Manager Dashboard Version 1.0</small>
            </div>
        </div>
    </main>

    <%-- Footer --%>
    <footer class="main-footer text-muted">
         <div class="container-fluid">
            <div class="d-flex justify-content-between py-2">
                <div>© Your Company 2025</div>
                <div><b>Version</b> 1.0</div>
            </div>
        </div>
    </footer>

    <%-- JS Includes --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            
            // ==========================================================
            // "VÁ" MỤC TIÊU 2: "THẮP SÁNG" (Light Up) BIỂU ĐỒ BAR CHART
            // ==========================================================
            
            // 1. Lấy dữ liệu "sạch" từ Servlet (Bước 2)
            const teamSalesLabels = <%= request.getAttribute("teamSalesLabels") %>;
            const teamSalesData = <%= request.getAttribute("teamSalesData") %>;
            // 2. Tìm <canvas>
            const ctxSales = document.getElementById('teamSalesChart');
            
            // 3. "Vẽ" (Draw) Biểu đồ Bar Chart "sạch" (Clean)
            if (ctxSales && teamSalesLabels.length > 0) { 
                new Chart(ctxSales, {
                    type: 'bar',
                    data: {
                        labels: teamSalesLabels, // <-- Dữ liệu "sạch"
                        datasets: [{
                            label: 'Team Revenue (VND)',
                            data: teamSalesData, // <-- Dữ liệu "sạch"
                            backgroundColor: 'rgba(0, 123, 255, 0.8)'
                        }]
                    },
                    options: { 
                        maintainAspectRatio: false,
                        responsive: true,
                        plugins: { 
                            legend: { display: false },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        return context.dataset.label + ': ' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.raw);
                                    }
                                }
                            }
                        },
                         scales: {
                            y: { beginAtZero: true, ticks: { callback: function(value) { return value / 1000000 + ' Tr'; } } },
                            x: { grid: { display: false } }
                        }
                    }
                });
            }
        });
    </script>
</body>
</html>