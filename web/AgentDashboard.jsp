<%-- 
    Document   : AgentDashboard
    Created on : Oct 6, 2025, 4:49:19 PM
    Author     : Nguyễn Tùng 
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Agent Dashboard</title>

    <!-- Bootstrap 5 (CDN) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" crossorigin="anonymous">

    <!-- Font Awesome (icons) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

    <!-- Layout CSS (shared: navbar + sidebar) -->
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />

    <!-- Page CSS (content-specific) -->
    <link rel="stylesheet" href="<%=ctx%>/css/agent-dashboard.css" />
</head>
<body>
    <!-- Navbar (fixed-top) -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company</a>
            <div>
                <ul class="navbar-nav d-flex flex-row align-items-center">
                    <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/home.jsp">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Sidebar (fixed left, always visible) -->
    <aside class="sidebar bg-primary text-white">
        <div class="sidebar-top p-3">
            <div class="d-flex align-items-center mb-3">
                <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                <div>
                    <div class="fw-bold">Agent TAm</div>
                    <div style="font-size:.85rem;opacity:.9">Sales Agent</div>
                </div>
            </div>
        </div>

        <nav class="nav flex-column px-2">
            <a class="nav-link text-white active py-2" href="#"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-trophy me-2"></i> Leader Board</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-percent me-2"></i> Commission Detail</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-box me-2"></i> Product</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-users me-2"></i> Customer</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>

    <!-- Main content -->
    <main class="main-content">
        <div class="container-fluid">
            <!-- Row: Sales + Goal -->
            <div class="row">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-chart-line me-2"></i> Sales</h5>
                            <small class="text-muted">So sánh doanh thu tháng này vs tháng trước (triệu VNĐ)</small>
                        </div>
                        <!-- Sử dụng class chart-250 thay vì inline style overflow:hidden -->
                        <div class="card-body p-3 chart-250">
                            <canvas id="salesChart"></canvas>
                            <div class="mt-2 text-center">
                                <span class="badge bg-success">Tăng 25% so với tháng trước</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">Goal</h5>
                            <small class="text-muted">Mục tiêu doanh thu: 200 triệu VNĐ</small>
                        </div>
                        <!-- Sử dụng class chart-250 để legend của doughnut không bị cắt -->
                        <div class="card-body p-3 position-relative chart-250">
                            <canvas id="goalChart"></canvas>
                            <div class="position-absolute top-50 start-50 translate-middle text-center">
                                <h3 class="mb-0">65%</h3>
                                <small>Đã đạt</small>
                            </div>
                            <div class="mt-2 text-center">
                                <span class="badge bg-info"><i class="fas fa-check-circle me-1"></i> Đã đạt: 130 triệu / Còn lại: 70 triệu</span>
                                <span class="badge bg-warning mt-1"><i class="fas fa-clock me-1"></i> Thời gian còn lại: 3 tháng</span>
                                <span class="badge bg-secondary mt-1"><i class="fas fa-trend-up me-1"></i> Tăng trưởng: +10% so với tuần trước</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Row: Product + Leaderboard -->
            <div class="row mt-3">
                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header"><h5 class="mb-0">Product</h5></div>
                        <div class="card-body">
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-box text-primary me-2"></i> Life Protect 2025</span>
                                    <span class="badge bg-primary">10 bán / 100.000.000 VNĐ</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-box text-primary me-2"></i> Health Care Plus</span>
                                    <span class="badge bg-primary">5 bán / 25.000.000 VNĐ</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-box text-primary me-2"></i> Car Safe</span>
                                    <span class="badge bg-primary">7 bán / 49.000.000 VNĐ</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-box text-primary me-2"></i> Home Secure</span>
                                    <span class="badge bg-primary">3 bán / 15.000.000 VNĐ</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card">
                        <div class="card-header"><h5 class="mb-0">Leader board</h5></div>
                        <div class="card-body">
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-trophy text-warning me-2"></i> 1. Agent One</span>
                                    <span class="badge bg-warning text-dark">20 sales</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-trophy text-warning me-2"></i> 2. Agent Two</span>
                                    <span class="badge bg-warning text-dark">15 sales</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-trophy text-warning me-2"></i> 3. Agent TAM</span>
                                    <span class="badge bg-warning text-dark">12 sales</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-trophy text-warning me-2"></i> 4. Agent Four</span>
                                    <span class="badge bg-warning text-dark">8 sales</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mt-4">
                <small class="text-muted">Agent Dashboard Version 1.0</small>
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

    <!-- Scripts: Bootstrap bundle + Chart.js (one time) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>

    <!-- Init charts (vanilla JS) -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            Chart.register(ChartDataLabels);

            // Sales bar chart
            const ctxSales = document.getElementById('salesChart').getContext('2d');
            new Chart(ctxSales, {
                type: 'bar',
                data: {
                    labels: ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Tuần 4'],
                    datasets: [{
                        label: 'Tháng này',
                        data: [40, 35, 45, 30],
                        backgroundColor: 'rgba(60,141,188,0.8)',
                    }, {
                        label: 'Tháng trước',
                        data: [30, 28, 35, 27],
                        backgroundColor: 'rgba(211,211,211,0.8)',
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: true },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return context.dataset.label + ': ' + context.raw + ' triệu VNĐ';
                                }
                            }
                        },
                        datalabels: {
                            display: true,
                            color: '#fff',
                            anchor: 'end',
                            align: 'top',
                            formatter: function(value) { return value + 'tr'; }
                        }
                    },
                    scales: {
                        y: { beginAtZero: true, title: { display: true, text: 'Doanh thu (triệu VNĐ)' } },
                        x: { grid: { display: false } }
                    }
                }
            });

            // Goal doughnut chart
            const ctxGoal = document.getElementById('goalChart').getContext('2d');
            new Chart(ctxGoal, {
                type: 'doughnut',
                data: {
                    labels: ['Đã đạt', 'Còn lại'],
                    datasets: [{
                        data: [130, 70],
                        backgroundColor: ['#28a745', '#e0e0e0']
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    cutout: '70%',
                    plugins: {
                        legend: { display: true, position: 'bottom' },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return context.label + ': ' + context.raw + ' triệu VNĐ';
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
