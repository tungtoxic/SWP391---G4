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

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" crossorigin="anonymous">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />

    <link rel="stylesheet" href="<%=ctx%>/css/agent-dashboard.css" />
    <style>
        /* Tùy chỉnh nhỏ để các KPI card trông đẹp hơn */
        .kpi-card-icon {
            font-size: 2.5rem;
            opacity: 0.5;
        }
        .list-group-item-action:hover {
            cursor: pointer;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company</a>
            <div>
                <ul class="navbar-nav d-flex flex-row align-items-center">
                    <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/home.jsp">Home</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <%-- ... (Phần Sidebar không đổi) ... --%>
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
            <a class="nav-link text-white active py-2" href="<%=ctx%>/AgentDashboard.jsp"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-trophy me-2"></i> Leader Board</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-percent me-2"></i> Commission Report</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-box me-2"></i> Product</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/customerManagerment.jsp"><i class="fas fa-users me-2"></i> Customer</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>

    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Agent Dashboard</h1>
            
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card bg-success text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Hoa hồng Dự kiến (T.Này)</h6>
                                <h3 class="display-6 fw-bold mb-0">32.5 Triệu</h3>
                                <small>Đã đạt: 100% / Target: 30 Triệu</small>
                            </div>
                            <i class="fas fa-wallet kpi-card-icon"></i>
                        </div>
                        <div class="card-footer bg-success border-0 text-white-50"><a href="#" class="text-white">Xem chi tiết <i class="fas fa-arrow-circle-right"></i></a></div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card bg-primary text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Khách hàng (Active)</h6>
                                <h3 class="display-6 fw-bold mb-0">156</h3>
                                <small>Mới: +5 Clients T.Này</small>
                            </div>
                            <i class="fas fa-users kpi-card-icon"></i>
                        </div>
                        <div class="card-footer bg-primary border-0 text-white-50"><a href="#" class="text-white">Quản lý khách hàng <i class="fas fa-arrow-circle-right"></i></a></div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card bg-info text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Leads (Negotiation)</h6>
                                <h3 class="display-6 fw-bold mb-0">8</h3>
                                <small>Tỷ lệ chuyển đổi: 15%</small>
                            </div>
                            <i class="fas fa-funnel-dollar kpi-card-icon"></i>
                        </div>
                        <div class="card-footer bg-info border-0 text-white-50"><a href="#" class="text-white">Quản lý Leads <i class="fas fa-arrow-circle-right"></i></a></div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="card bg-warning text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Tỷ lệ Chốt HĐ</h6>
                                <h3 class="display-6 fw-bold mb-0">18%</h3>
                                <small>Mục tiêu: 20%</small>
                            </div>
                            <i class="fas fa-chart-pie kpi-card-icon"></i>
                        </div>
                        <div class="card-footer bg-warning border-0 text-white-50"><a href="#" class="text-white">Xem báo cáo <i class="fas fa-arrow-circle-right"></i></a></div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-lg-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-danger text-white"><h5 class="mb-0"><i class="fas fa-calendar-alt me-2"></i> RENEWAL ALERTS (Hợp đồng Sắp Hết hạn)</h5></div>
                        <div class="card-body p-0">
                            <ul class="list-group list-group-flush">
                                <%-- Dữ liệu giả lập, cần thay bằng JSP loop --%>
                                <li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                    <span class="text-danger fw-bold"><i class="fas fa-exclamation-triangle me-2"></i> Hợp đồng #12345 (Nguyễn Văn A)</span>
                                    <span class="badge bg-danger">Hạn: 5 Ngày Nữa</span>
                                </li>
                                <li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-clock me-2"></i> Hợp đồng #67890 (Trần Thị B)</span>
                                    <span class="badge bg-warning text-dark">Hạn: 25 Ngày Nữa</span>
                                </li>
                                <li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-clock me-2"></i> Hợp đồng #11223 (Phạm Duy C)</span>
                                    <span class="badge bg-secondary">Hạn: 45 Ngày Nữa</span>
                                </li>
                                <li class="list-group-item list-group-item-action text-center">
                                    <a href="#"><i class="fas fa-search me-1"></i> Xem tất cả 12 cảnh báo</a>
                                </li>
                                <%-- End Dữ liệu giả lập --%>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-primary text-white"><h5 class="mb-0"><i class="fas fa-phone me-2"></i> TODAY'S FOLLOW-UPS (Hôm nay cần liên hệ)</h5></div>
                        <div class="card-body p-0">
                            <ul class="list-group list-group-flush">
                                <%-- Dữ liệu giả lập, cần thay bằng JSP loop --%>
                                <li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                    <span class="fw-bold"><i class="fas fa-user-tag me-2"></i> Lead: Lê Văn D (Thái độ: Rất Quan Tâm)</span>
                                    <span class="badge bg-success">Hẹn: 10:00 AM</span>
                                </li>
                                <li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-user me-2"></i> Client: Nguyễn Thu E (Cần giải thích thêm)</span>
                                    <span class="badge bg-primary">Hẹn: 2:30 PM</span>
                                </li>
                                <li class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-user me-2"></i> Lead: Hoàng Thị F (Tạo báo giá mới)</span>
                                    <span class="badge bg-secondary">Hẹn: 4:00 PM</span>
                                </li>
                                <li class="list-group-item list-group-item-action text-center">
                                    <a href="#"><i class="fas fa-search me-1"></i> Xem toàn bộ lịch hẹn</a>
                                </li>
                                <%-- End Dữ liệu giả lập --%>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-1">
                <div class="col-md-7">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i> Sales Performance (6 Tháng)</h5>
                            <small class="text-muted">So sánh doanh thu bán hàng theo tháng (triệu VNĐ)</small>
                        </div>
                        <div class="card-body p-3 chart-250">
                            <canvas id="salesChart"></canvas>
                            <div class="mt-2 text-center">
                                <span class="badge bg-success">Tăng 25% so với tháng trước</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-5">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-bullseye me-2"></i> Monthly Goal</h5>
                            <small class="text-muted">Mục tiêu doanh thu: **200 triệu VNĐ**</small>
                        </div>
                        <div class="card-body p-3 position-relative chart-250">
                            <canvas id="goalChart"></canvas>
                            <div class="position-absolute top-50 start-50 translate-middle text-center">
                                <h3 class="mb-0 text-success">65%</h3>
                                <small>Đã đạt</small>
                            </div>
                            <div class="mt-2 text-center">
                                <span class="badge bg-info"><i class="fas fa-check-circle me-1"></i> Đã đạt: 130 triệu / Còn lại: 70 triệu</span>
                                <span class="badge bg-warning mt-1"><i class="fas fa-clock me-1"></i> Thời gian còn lại: 3 tháng</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row mt-1">
                <div class="col-md-12">
                     <div class="card">
                        <div class="card-header"><h5 class="mb-0"><i class="fas fa-trophy me-2"></i> Leader Board (Top 5 T.Này)</h5></div>
                        <div class="card-body">
                            <ul class="list-group list-group-flush list-group-horizontal-md">
                                <li class="list-group-item d-flex justify-content-between align-items-center col-md-3">
                                    <span><i class="fas fa-trophy text-warning me-2"></i> 1. Agent One</span>
                                    <span class="badge bg-warning text-dark">20 sales / 150M</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center col-md-3">
                                    <span><i class="fas fa-trophy text-warning me-2"></i> 2. Agent Two</span>
                                    <span class="badge bg-warning text-dark">15 sales / 120M</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center col-md-3">
                                    <span><i class="fas fa-trophy text-warning me-2"></i> 3. Agent TAM (You)</span>
                                    <span class="badge bg-success">12 sales / 90M</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center col-md-3">
                                    <span><i class="fas fa-trophy text-warning me-2"></i> 4. Agent Four</span>
                                    <span class="badge bg-warning text-dark">8 sales / 75M</span>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            Chart.register(ChartDataLabels);

            // Sales bar chart
            const ctxSales = document.getElementById('salesChart').getContext('2d');
            new Chart(ctxSales, {
                type: 'bar',
                data: {
                    labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'],
                    datasets: [{
                        label: 'Doanh thu',
                        data: [40, 35, 45, 30, 50, 65], // Dữ liệu 6 tháng
                        backgroundColor: 'rgba(60,141,188,0.8)',
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