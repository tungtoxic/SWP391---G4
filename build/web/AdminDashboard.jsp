<%-- 
    Document   : AdminDashboard
    Created on : Oct 5, 2025, 11:02:43 AM
    Author     : hoang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin Dashboard</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
    <link rel="stylesheet" href="<%=ctx%>/css/admin-dashboard.css" />
    <style>
        /* Tùy chỉnh nhỏ cho KPI cards và bảng */
        .kpi-card-icon { font-size: 2.5rem; opacity: 0.5; }
        .alert-widget { border-left: 5px solid #ffc107; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company Admin</a>
            <div>
                <ul class="navbar-nav d-flex flex-row align-items-center">
                    <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/home.jsp">Home</a></li>
                    
                </ul>
            </div>
        </div>
    </nav>

    <aside class="sidebar bg-primary text-white">
        <%-- ... (Phần Sidebar Navigation của Admin) ... --%>
        <div class="sidebar-top p-3">
            <div class="d-flex align-items-center mb-3">
                <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                <div>
                    <div class="fw-bold">Admin User</div>
                    <div style="font-size:.85rem;opacity:.9">System Administrator</div>
                </div>
            </div>
        </div>

        <nav class="nav flex-column px-2">
            <a class="nav-link text-white active py-2" href="#"><i class="fas fa-desktop me-2"></i> Admin Dashboard</a>
            <a class="nav-link text-white py-2" href="usermanagement.jsp"><i class="fas fa-users-cog me-2"></i> User Management</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-tools me-2"></i> System Settings</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-export me-2"></i> Reporting</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>

    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">System Administration Overview</h1>
            
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card bg-primary text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Total System Premium (YTD)</h6>
                                <h3 class="display-6 fw-bold mb-0">15.4 Tỷ VNĐ</h3>
                                <small>Tăng 12% so với năm trước</small>
                            </div>
                            <i class="fas fa-hand-holding-usd kpi-card-icon"></i>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card bg-success text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Total Commission Payout (MTD)</h6>
                                <h3 class="display-6 fw-bold mb-0">1.8 Tỷ VNĐ</h3>
                                <small>Chi trả trong tháng này</small>
                            </div>
                            <i class="fas fa-money-check-alt kpi-card-icon"></i>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card bg-info text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Active Agents (24H)</h6>
                                <h3 class="display-6 fw-bold mb-0">128/150</h3>
                                <small>85% Agent đã đăng nhập</small>
                            </div>
                            <i class="fas fa-users kpi-card-icon"></i>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card bg-warning text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">New Accounts (MTD)</h6>
                                <h3 class="display-6 fw-bold mb-0">5</h3>
                                <small>Admin cần phê duyệt</small>
                            </div>
                            <i class="fas fa-user-plus kpi-card-icon"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-lg-8 mb-4">
                    <div class="card">
                        <div class="card-header"><h5 class="mb-0"><i class="fas fa-chart-area me-2"></i> System Revenue Trend (Year-to-Date)</h5></div>
                        <div class="card-body p-3 chart-250">
                             <%-- Canvas cho biểu đồ Doanh thu (Line Chart) --%>
                            <canvas id="revenueTrendChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 mb-4">
                    <div class="card">
                        <div class="card-header bg-danger text-white"><h5 class="mb-0"><i class="fas fa-exclamation-triangle me-2"></i> Critical System Alerts</h5></div>
                        <div class="card-body p-0">
                            <ul class="list-group list-group-flush">
                                <%-- Dữ liệu giả lập --%>
                                <li class="list-group-item d-flex justify-content-between align-items-center text-danger">
                                    <span class="fw-bold"><i class="fas fa-database me-2"></i> Database Connection Error</span>
                                    <span class="badge bg-danger">HIGH</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-lock me-2"></i> 3 Users Locked Out (Login Attempts)</span>
                                    <span class="badge bg-warning text-dark">MEDIUM</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-user-check me-2"></i> 5 Pending User Approvals</span>
                                    <span class="badge bg-info">LOW</span>
                                </li>
                                <li class="list-group-item text-center">
                                    <a href="#"><i class="fas fa-cog me-1"></i> Go to Admin Logs</a>
                                </li>
                                <%-- End Dữ liệu giả lập --%>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-1">
                <div class="col-lg-6 mb-4">
                    <div class="card">
                        <div class="card-header"><h5 class="mb-0"><i class="fas fa-box-open me-2"></i> Top 5 Selling Products (Theo Premium)</h5></div>
                        <div class="card-body p-0">
                            <ul class="list-group list-group-flush">
                                <%-- Dữ liệu giả lập --%>
                                <li class="list-group-item d-flex justify-content-between align-items-center">Life Protect 2025<span class="badge bg-primary">5.2 Tỷ VNĐ</span></li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">Health Care Plus<span class="badge bg-primary">3.5 Tỷ VNĐ</span></li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">Car Safe<span class="badge bg-primary">2.1 Tỷ VNĐ</span></li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">Home Secure<span class="badge bg-primary">1.8 Tỷ VNĐ</span></li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">Retirement Fund X<span class="badge bg-primary">1.5 Tỷ VNĐ</span></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 mb-4">
                    <div class="card">
                        <div class="card-header"><h5 class="mb-0"><i class="fas fa-user-tag me-2"></i> User Role Breakdown</h5></div>
                        <div class="card-body p-3 chart-250">
                             <%-- Canvas cho biểu đồ Phân phối vai trò (Pie Chart) --%>
                            <canvas id="roleBreakdownChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mt-4">
                <small class="text-muted">Admin Dashboard Version 1.0</small>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Revenue Trend Line Chart
            const ctxRevenue = document.getElementById('revenueTrendChart').getContext('2d');
            new Chart(ctxRevenue, {
                type: 'line',
                data: {
                    labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9'],
                    datasets: [{
                        label: 'Doanh thu Hệ thống (Tỷ VNĐ)',
                        data: [1.2, 1.4, 1.5, 1.6, 1.8, 2.0, 2.2, 2.3, 2.4],
                        borderColor: '#0d6efd',
                        backgroundColor: 'rgba(13, 110, 253, 0.2)',
                        fill: true,
                        tension: 0.3
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    responsive: true,
                    scales: {
                        y: { beginAtZero: false, title: { display: true, text: 'Doanh thu (Tỷ VNĐ)' } }
                    }
                }
            });

            // User Role Breakdown Pie Chart
            const ctxRoles = document.getElementById('roleBreakdownChart').getContext('2d');
            new Chart(ctxRoles, {
                type: 'pie',
                data: {
                    labels: ['Agents', 'Managers', 'Admins'],
                    datasets: [{
                        data: [120, 25, 5], // Số lượng người dùng theo vai trò
                        backgroundColor: ['#198754', '#0d6efd', '#dc3545'],
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    responsive: true,
                    plugins: {
                        legend: { position: 'bottom' },
                        title: { display: true, text: 'Phân phối Người dùng theo Vai trò' }
                    }
                }
            });
        });
    </script>
</body>
</html>
