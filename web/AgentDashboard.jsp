<%--
    Document   : AgentDashboard
    Created on : Oct 6, 2025, 4:49:19 PM
    Author     : Nguyễn Tùng
   
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, entity.*, java.math.BigDecimal, java.text.DecimalFormat, java.time.temporal.ChronoUnit, java.time.LocalDate"%>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
    
    // --- 1. Lấy dữ liệu (ĐÃ THÊM NULL CHECKS ĐỂ SỬA LỖI) ---
    BigDecimal pendingCommission = (BigDecimal) request.getAttribute("pendingCommission");
    Integer leadCount = (Integer) request.getAttribute("leadCount");
    Integer clientCount = (Integer) request.getAttribute("clientCount");
    List<ContractDTO> expiringContracts = (List<ContractDTO>) request.getAttribute("expiringContracts");
    List<Task> followUps = (List<Task>) request.getAttribute("followUps");
    List<Task> personalTasks = (List<Task>) request.getAttribute("personalTasks");
    List<AgentPerformanceDTO> topAgents = (List<AgentPerformanceDTO>) request.getAttribute("topAgents");
    List<String> salesChartLabels = (List<String>) request.getAttribute("salesChartLabels");
    List<Double> salesChartValues = (List<Double>) request.getAttribute("salesChartValues");

    // --- 2. Xử lý an toàn (Nếu dữ liệu là null, dùng giá trị mặc định) ---
    if (pendingCommission == null) pendingCommission = BigDecimal.ZERO;
    if (leadCount == null) leadCount = 0;
    if (clientCount == null) clientCount = 0;
    if (expiringContracts == null) expiringContracts = new ArrayList<>();
    if (followUps == null) followUps = new ArrayList<>();
    if (personalTasks == null) personalTasks = new ArrayList<>();
    if (topAgents == null) topAgents = new ArrayList<>();
    if (salesChartLabels == null) salesChartLabels = new ArrayList<>();
    if (salesChartValues == null) salesChartValues = new ArrayList<>();

    // --- 3. Định dạng & Tính toán ---
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VND'");
    double conversionRate = 0.0;
    if (leadCount + clientCount > 0) {
        conversionRate = ((double) clientCount / (clientCount + leadCount)) * 100;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Agent Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
    <style>
        .kpi-card-icon { font-size: 2.5rem; opacity: 0.3; }
        .list-group-item-action:hover { cursor: pointer; background-color: #f8f9fa; }
        .list-group-item { border-left: 0; border-right: 0; }
        .card-body .list-group-item:first-child { border-top: 0; }
        .card-body .list-group-item:last-child { border-bottom: 0; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company</a>
            <ul class="navbar-nav d-flex flex-row align-items-center">
                <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/home.jsp">Home</a></li>
                <a class="nav-link" href="#">
                        <i class="fas fa-bell"></i>
                        <span class="badge rounded-pill badge-notification bg-danger">1</span>
                    </a>
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

    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Agent Dashboard</h1>
            
            <%-- ================== ROW 1: KPIs ================== --%>
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card bg-success text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Pending Commission</h6>
                                <h3 class="display-6 fw-bold mb-0"><%= currencyFormat.format(pendingCommission) %></h3>
                                <small>From "Pending" contracts</small>
                            </div>
                            <i class="fas fa-wallet kpi-card-icon"></i>
                        </div>
                        <div class="card-footer bg-success border-0 text-white-50">
                            <a href="<%=ctx%>/agent/commission-report" class="text-white">View Details <i class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card bg-primary text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Active Clients</h6>
                                <h3 class="display-6 fw-bold mb-0"><%= clientCount %></h3>
                                <small>Customers with contracts</small>
                            </div>
                            <i class="fas fa-users kpi-card-icon"></i>
                        </div>
                        <div class="card-footer bg-primary border-0 text-white-50">
                            <a href="<%=ctx%>/agent/customers" class="text-white">Manage Clients <i class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card bg-info text-dark">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Active Leads</h6>
                                <h3 class="display-6 fw-bold mb-0"><%= leadCount %></h3>
                                <small>Leads in progress</small>
                            </div>
                            <i class="fas fa-funnel-dollar kpi-card-icon"></i>
                        </div>
                        <div class="card-footer bg-info border-0 text-dark-50">
                            <a href="<%=ctx%>/agent/customers?type=Lead" class="text-dark">Manage Leads <i class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card bg-warning text-dark">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Conversion Rate</h6>
                                <h3 class="display-6 fw-bold mb-0"><%= String.format("%.1f", conversionRate) %>%</h3>
                                <small>(Clients / (Leads + Clients))</small>
                            </div>
                            <i class="fas fa-chart-pie kpi-card-icon"></i>
                        </div>
                        <div class="card-footer bg-warning border-0 text-dark-50">
                            <a href="#" class="text-dark">View Report <i class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>
            
            <%-- ================== ROW 2: CHARTS & LEADERBOARD ================== --%>
            <div class="row">
                <div class="col-lg-7 mb-4">
                    <div class="card h-100">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i> Sales Performance</h5>
                        </div>
                        <div class="card-body p-3 chart-250">
                            <canvas id="salesChart"></canvas>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-5 mb-4">
                    <div class="card h-100">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-trophy me-2"></i> Leaderboard (Top 5)</h5>
                        </div>
                        <div class="card-body p-0">
                            <ul class="list-group list-group-flush">
                                <% if (topAgents != null && !topAgents.isEmpty()) {
                                    int rank = 0;
                                    for (AgentPerformanceDTO agent : topAgents) {
                                        rank++;
                                        boolean isCurrentUser = (currentUser != null && agent.getAgentId() == currentUser.getUserId());
                                %>
                                <li class="list-group-item d-flex justify-content-between align-items-center <%= isCurrentUser ? "list-group-item-primary" : "" %>">
                                    <span class="fw-bold">
                                        <% if(rank == 1) { %>1<% } else if(rank == 2) { %>2<% } else if(rank == 3) { %>3<% } else { %>#<%= rank %><% } %>
                                        <%= agent.getAgentName() %>
                                    </span>
                                    <span class="badge bg-success"><%= currencyFormat.format(agent.getTotalPremium()) %></span>
                                </li>
                                <% } } else { %>
                                    <li class="list-group-item text-muted text-center">No leaderboard data.</li>
                                <% } %>
                                <li class="list-group-item list-group-item-action text-center">
                                    <a href="<%=ctx%>/agents/leaderboard" class="text-primary fw-bold">View Full Leaderboard <i class="fa fa-arrow-right"></i></a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <%-- ================== ROW 3: ACTION ITEMS ================== --%>
            <div class="row">
                <div class="col-lg-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-danger text-white"><h5 class="mb-0"><i class="fas fa-calendar-alt me-2"></i> Renewal Alerts</h5></div>
                        <div class="card-body p-0">
                            <ul class="list-group list-group-flush">
                                <% if (expiringContracts != null && !expiringContracts.isEmpty()) {
                                    for (ContractDTO contract : expiringContracts) {
                                        long daysLeft = ChronoUnit.DAYS.between(LocalDate.now(), contract.getEndDate().toLocalDate());
                                %>
                                <li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                    <a href="<%=ctx%>/agent/contracts?action=view&id=<%= contract.getContractId() %>" class="text-decoration-none text-dark">
                                        <span class="<%= daysLeft <= 7 ? "text-danger fw-bold" : "" %>"><i class="fas fa-exclamation-triangle me-2"></i> HĐ #<%= contract.getContractId() %> (<%= contract.getCustomerName() %>)</span>
                                        <div><small><%= contract.getProductName() %></small></div>
                                    </a>
                                    <span class="badge <%= daysLeft <= 7 ? "bg-danger" : "bg-warning text-dark" %>"><%= daysLeft <= 0 ? "Expired" : "In " + daysLeft + " days" %></span>
                                </li>
                                <% } } else { %>
                                    <li class="list-group-item text-muted text-center">No contracts are expiring soon.</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-primary text-white"><h5 class="mb-0"><i class="fas fa-phone me-2"></i> Today's Follow-ups</h5></div>
                        <div class="card-body p-0">
                            <ul class="list-group list-group-flush">
                                <% if (followUps != null && !followUps.isEmpty()) {
                                    for (Task task : followUps) { %>
                                <li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                    <div>
                                        <span class="fw-bold"><i class="fas fa-user-tag me-2"></i> <%= task.getTitle() %></span>
                                        <div><small class="text-muted"><%= task.getCustomerName() %></small></div>
                                    </div>
                                    <%-- Thêm nút hoàn thành task sau --%>
                                </li>
                                <% } } else { %>
                                    <li class="list-group-item text-muted text-center">No follow-ups scheduled for today.</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            
            <%-- ================== ROW 4: TO-DO LIST & GOAL ================== --%>
<div class="row">
                <div class="col-lg-7 mb-4">
                    <div class="card h-100">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fa fa-list-check me-2"></i> Personal To-Do List</h5>
                        </div>
                        <div class="card-body p-0">
                             <ul class="list-group list-group-flush">
                                <% if (personalTasks != null && !personalTasks.isEmpty()) {
                                    for (Task task : personalTasks) { %>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <%-- Form để Cập nhật Trạng thái (Checkbox) --%>
                                    <%-- THÊM: method="POST" --%>
                                    <form action="<%=ctx%>/tasks" method="POST" class="d-flex align-items-center flex-grow-1 task-item-form">
                                        <input type="hidden" name="action" value="completeTask">
                                        <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                                        <input type="checkbox" name="isCompleted" class="form-check-input me-2" onchange="this.form.submit()"
                                               <%= task.isCompleted() ? "checked" : "" %> value="on"> <%-- Thêm value="on" --%>
                                        <span class="<%= task.isCompleted() ? "task-title-completed" : "" %>">
                                            <%= task.getTitle() %>
                                        </span>
                                    </form>
                                    
                                    <%-- Form để Xóa Task --%>
                                    <%-- THÊM: method="POST" --%>
                                    <form action="<%=ctx%>/tasks" method="POST" class="task-item-form">
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
                            <%-- Form để Thêm Task mới (Đã đúng method="POST") --%>
                            <form action="<%=ctx%>/tasks" method="POST" class="d-flex gap-2">
                                <input type="hidden" name="action" value="addPersonalTask">
                                <input type="text" class="form-control" name="taskTitle" placeholder="Add a new to-do..." required>
                                <button type="submit" class="btn btn-primary flex-shrink-0">Add</button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5 mb-4">
                     <div class="card h-100">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-bullseye me-2"></i> Monthly Goal (Demo)</h5>
                        </div>
                        <div class="card-body p-3 position-relative chart-250">
                            <canvas id="goalChart"></canvas>
                            <div class="position-absolute top-50 start-50 translate-middle text-center">
                                <h3 class="mb-0 text-success">65%</h3>
                                <small>Achieved</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </main>
    
    <footer class="main-footer text-muted">
        <div class="container-fluid">
            <div class="d-flex justify-content-between py-2">
                <div>© Your Company</div>
                <div><b>Version</b> 1.0</div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
    <%-- <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script> --%>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            
            // SỬA LỖI NULLPOINTER: Dữ liệu được lấy từ biến Java đã được kiểm tra null ở trên
            const salesLabels = <%= salesChartLabels %>;
            const salesValues = <%= salesChartValues %>;

            // Sales bar chart
            const ctxSales = document.getElementById('salesChart').getContext('2d');
            new Chart(ctxSales, {
                type: 'bar',
                data: {
                    labels: salesLabels.length > 0 ? salesLabels : ['No Data'],
                    datasets: [{
                        label: 'Revenue (VND)',
                        data: salesValues.length > 0 ? salesValues : [0],
                        backgroundColor: 'rgba(0, 123, 255, 0.8)'
                    }]
                },
                options: {
                    maintainAspectRatio: false,
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

            // Goal doughnut chart (Dữ liệu này vẫn đang là giả lập)
            const ctxGoal = document.getElementById('goalChart').getContext('2d');
            new Chart(ctxGoal, {
                type: 'doughnut',
                data: {
                    labels: ['Achieved', 'Remaining'],
                    datasets: [{
                        data: [130, 70], // Giả lập 130tr / 200tr
                        backgroundColor: ['#28a745', '#e0e0e0']
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    cutout: '70%',
                    plugins: { 
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return context.label + ': ' + context.raw + ' Triệu VNĐ';
                                }
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>