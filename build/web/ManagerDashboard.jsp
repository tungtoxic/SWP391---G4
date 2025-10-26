<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% String ctx = request.getContextPath(); %>
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
        /* Tùy chỉnh nhỏ để các KPI card trông đẹp hơn */
        .kpi-card-icon { font-size: 2.5rem; opacity: 0.5; }
        .table-responsive { overflow-x: auto; }
        .performance-gauge {
            height: 10px;
            border-radius: 5px;
            overflow: hidden;
            background-color: #e9ecef;
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

    <aside class="sidebar bg-primary text-white">
        <%-- ... (Phần Sidebar Navigation của Manager sẽ tương tự Agent nhưng có thể thêm mục Admin nếu có) ... --%>
        <div class="sidebar-top p-3">
            <div class="d-flex align-items-center mb-3">
                <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                <div>
                    <div class="fw-bold">Manager Name</div>
                    <div style="font-size:.85rem;opacity:.9">Sales Manager</div>
                </div>
            </div>
        </div>

        <nav class="nav flex-column px-2">
            <a class="nav-link text-white active py-2" href="#"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
            <a class="nav-link text-white py-2" href="AgentManagementServlet?action="><i class="fas fa-users-cog me-2"></i> Agent Management</a>
            <a class="nav-link text-white active py-2" href="<%=ctx%>/CommissionPoliciesServlet?action=list"><i class="fas fa-file-invoice-dollar me-2"></i> Commission Policies</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-invoice-dollar me-2"></i> Commission Contracts</a>
            <a class="nav-link text-white py-2" href="ProductServlet?action=list"><i class="fas fa-box me-2"></i> Product</a>
            <a class="nav-link text-white py-2" href="ContractManagementServlet?action=list"><i class="fas fa-file-alt me-2"></i> Contracts</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>

    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Manager Dashboard: Sales Team A</h1>
            
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="card bg-info text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Team Premium (Tháng Này)</h6>
                                <h3 class="display-6 fw-bold mb-0">520 Triệu</h3>
                                <small>Mục tiêu: 800 Triệu / Đạt **65%**</small>
                            </div>
                            <i class="fas fa-dollar-sign kpi-card-icon"></i>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="card bg-success text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Team Conversion Rate</h6>
                                <h3 class="display-6 fw-bold mb-0">12.5%</h3>
                                <small>Số HĐ Mới: 35 / Tổng Leads: 280</small>
                            </div>
                            <i class="fas fa-chart-bar kpi-card-icon"></i>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-12 mb-4">
                    <div class="card bg-danger text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">HĐ Cần Tái Tục (90 ngày)</h6>
                                <h3 class="display-6 fw-bold mb-0">18</h3>
                                <small>Cần xử lý gấp: 5 HĐ (Trong 30 ngày)</small>
                            </div>
                            <i class="fas fa-bell kpi-card-icon"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-lg-8 mb-4">
                    <div class="card">
                        <div class="card-header"><h5 class="mb-0"><i class="fas fa-users-line me-2"></i> Agent Performance Matrix (Tháng Này)</h5></div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover mb-0">
                                    <thead class="bg-light">
                                        <tr>
                                            <th>#</th>
                                            <th>Agent Name</th>
                                            <th>Premium (Kết quả)</th>
                                            <th>Interactions (Quá trình)</th>
                                            <th>Conversion Rate</th>
                                            <th>Target Progress</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%-- Dữ liệu giả lập, cần thay bằng JSP loop --%>
                                        <tr>
                                            <td>1</td>
                                            <td class="fw-bold text-success">Nguyễn Tùng</td>
                                            <td>90 Triệu</td>
                                            <td>45</td>
                                            <td>18%</td>
                                            <td>
                                                <div class="performance-gauge bg-success" style="width: 100%;">
                                                    <div class="bg-success h-100" style="width: 100%;"></div>
                                                </div>
                                                <small>100%</small>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>2</td>
                                            <td>Trần Văn A</td>
                                            <td>70 Triệu</td>
                                            <td>60</td>
                                            <td>10%</td>
                                            <td>
                                                <div class="performance-gauge">
                                                    <div class="bg-primary h-100" style="width: 70%;"></div>
                                                </div>
                                                <small>70%</small>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>3</td>
                                            <td class="text-danger">Lê Thị B</td>
                                            <td>25 Triệu</td>
                                            <td>15</td>
                                            <td>15%</td>
                                            <td>
                                                <div class="performance-gauge">
                                                    <div class="bg-danger h-100" style="width: 25%;"></div>
                                                </div>
                                                <small>25%</small>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>4</td>
                                            <td>Hoàng Văn C</td>
                                            <td>55 Triệu</td>
                                            <td>40</td>
                                            <td>14%</td>
                                            <td>
                                                <div class="performance-gauge">
                                                    <div class="bg-primary h-100" style="width: 55%;"></div>
                                                </div>
                                                <small>55%</small>
                                            </td>
                                        </tr>
                                        <%-- End Dữ liệu giả lập --%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="card-footer text-center">
                             <a href="#"><i class="fas fa-file-export me-1"></i> Export Full Team Report</a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 mb-4">
                    <div class="card mb-4">
                        <div class="card-header"><h5 class="mb-0"><i class="fas fa-trophy me-2"></i> Team Leaderboard (Top Premium)</h5></div>
                        <div class="card-body">
                            <%-- Giữ nguyên Leaderboard list-group như Agent Dashboard, chỉ thay đổi dữ liệu --%>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-star me-2 text-warning"></i> 1. Nguyễn Tùng (You)</span>
                                    <span class="badge bg-success">90.000.000 VNĐ</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-medal me-2"></i> 2. Trần Văn A</span>
                                    <span class="badge bg-secondary">70.000.000 VNĐ</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-medal me-2"></i> 3. Hoàng Văn C</span>
                                    <span class="badge bg-secondary">55.000.000 VNĐ</span>
                                </li>
                                <li class="list-group-item text-center">
                                    <a href="#">Xem toàn bộ bảng xếp hạng</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header"><h5 class="mb-0"><i class="fas fa-chart-area me-2"></i> Product Distribution</h5></div>
                        <div class="card-body p-3 chart-250">
                             <%-- Canvas cho biểu đồ Phân phối Sản phẩm (Doughnut Chart) --%>
                            <canvas id="productDistributionChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mt-4">
                <small class="text-muted">Manager Dashboard Version 1.0</small>
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
            // Product Distribution Doughnut Chart
            const ctxProduct = document.getElementById('productDistributionChart').getContext('2d');
            new Chart(ctxProduct, {
                type: 'doughnut',
                data: {
                    labels: ['Life Protect', 'Health Care Plus', 'Car Safe', 'Home Secure'],
                    datasets: [{
                        data: [45, 25, 18, 12], // Phần trăm doanh số theo sản phẩm
                        backgroundColor: ['#0d6efd', '#198754', '#ffc107', '#dc3545'],
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    responsive: true,
                    plugins: {
                        legend: { position: 'bottom' },
                        title: { display: true, text: 'Phân phối Premium theo Sản phẩm' }
                    }
                }
            });

            // Note: Các biểu đồ khác (ví dụ: Team Sales Over Time) có thể thêm tương tự.
        });
    </script>
</body>
</html>
