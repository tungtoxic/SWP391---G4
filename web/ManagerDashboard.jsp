<%--
    Document   : ManagerDashboard
    Created on : Oct 13, 2025
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %> <%-- Import User entity --%>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user"); // Lấy currentUser từ session
    String activePage = "dashboard"; // Trang này mặc định là dashboard
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
    <link rel="stylesheet" href="<%=ctx%>/css/manager-dashboard.css" /> <%-- Giữ lại CSS riêng nếu có --%>
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

    <%-- Include Navbar --%>
    <%@ include file="manager_navbar.jsp" %>

    <%-- Include Sidebar --%>
    <%@ include file="manager_sidebar.jsp" %>

    <%-- Phần nội dung chính của trang Dashboard --%>
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Manager Dashboard: Sales Team A</h1> <%-- Ví dụ tên Team --%>

            <%-- Hàng chứa các KPI Cards --%>
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="card bg-info text-white">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-uppercase mb-0">Team Premium (This Month)</h6>
                                <h3 class="display-6 fw-bold mb-0">520 Mil</h3> <%-- Dữ liệu động --%>
                                <small>Target: 800 Mil / **65%** Achieved</small>
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
                                <h3 class="display-6 fw-bold mb-0">12.5%</h3> <%-- Dữ liệu động --%>
                                <small>New Contracts: 35 / Total Leads: 280</small>
                            </div>
                            <i class="fas fa-chart-bar kpi-card-icon"></i>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-12 mb-4">
                     <div class="card bg-danger text-white">
                         <div class="card-body d-flex justify-content-between align-items-center">
                             <div>
                                <h6 class="text-uppercase mb-0">Renewals Due (90d)</h6>
                                <h3 class="display-6 fw-bold mb-0">18</h3> <%-- Dữ liệu động --%>
                                <small>Urgent (30d): 5 Contracts</small>
                            </div>
                            <i class="fas fa-bell kpi-card-icon"></i>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Hàng chứa Bảng Performance và Biểu đồ --%>
            <div class="row">
                <div class="col-lg-8 mb-4">
                    <div class="card">
                        <%-- ... Code bảng Agent Performance Matrix ... --%>
                         <div class="card-header"><h5 class="mb-0"><i class="fas fa-users-line me-2"></i> Agent Performance Matrix (This Month)</h5></div>
                         <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover mb-0">
                                     <%-- ... thead và tbody của bảng ... --%>
                                     <thead class="bg-light">
                                        <tr>
                                            <th>#</th>
                                            <th>Agent Name</th>
                                            <th>Premium</th>
                                            <th>Interactions</th>
                                            <th>Conversion Rate</th>
                                            <th>Target Progress</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%-- Dữ liệu động sẽ được load ở đây --%>
                                        <tr><td>1</td><td class="fw-bold text-success">Agent One (Tùng)</td><td>90 Mil</td><td>45</td><td>18%</td><td>...</td></tr>
                                        <tr><td>2</td><td>Agent Two</td><td>70 Mil</td><td>60</td><td>10%</td><td>...</td></tr>
                                        <%-- ... more rows ... --%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="card-footer text-center">
                            <a href="<%= ctx %>/manager/performance"><i class="fas fa-external-link-alt me-1"></i> View Full Team Performance</a> <%-- Link đến trang chi tiết --%>
                        </div>

                    </div>
                </div>

                <div class="col-lg-4 mb-4">
                     <div class="card mb-4">
                         <%-- ... Code widget Leaderboard ... --%>
                          <div class="card-header"><h5 class="mb-0"><i class="fas fa-trophy me-2"></i> Team Leaderboard (Top Premium)</h5></div>
                            <div class="card-body">
                                <ul class="list-group list-group-flush">
                                     <%-- Dữ liệu động sẽ được load ở đây --%>
                                    <li class="list-group-item d-flex justify-content-between align-items-center"><span><i class="fas fa-star me-2 text-warning"></i> 1. Agent One (Tùng)</span><span class="badge bg-success">90,000,000 VNĐ</span></li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center"><span><i class="fas fa-medal me-2"></i> 2. Agent Two</span><span class="badge bg-secondary">70,000,000 VNĐ</span></li>
                                    <%-- ... more items ... --%>
                                    <li class="list-group-item text-center"><a href="<%= ctx %>/managers/leaderboard">View Full Leaderboard</a></li>
                                </ul>
                            </div>

                    </div>

                    <div class="card">
                         <%-- ... Code biểu đồ Product Distribution ... --%>
                          <div class="card-header"><h5 class="mb-0"><i class="fas fa-chart-pie me-2"></i> Product Distribution</h5></div>
                            <div class="card-body p-3 chart-250">
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

    <%-- Footer (Nếu muốn dùng chung, cũng có thể tách ra file include) --%>
    <footer class="main-footer text-muted">
         <div class="container-fluid">
            <div class="d-flex justify-content-between py-2">
                <div>© Your Company 2025</div>
                <div><b>Version</b> 1.0</div>
            </div>
        </div>
    </footer>

    <%-- Include Bootstrap JS (chỉ cần 1 lần) --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <%-- Include Chart.js --%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
    <%-- Script vẽ biểu đồ cho trang Dashboard --%>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Product Distribution Doughnut Chart (Dữ liệu này cần được lấy động từ Servlet)
            const productLabels = ['Life Protect', 'Health Care Plus', 'Car Safe']; // Lấy từ request.getAttribute
            const productData = [45, 35, 20]; // Lấy từ request.getAttribute

            const ctxProduct = document.getElementById('productDistributionChart').getContext('2d');
            new Chart(ctxProduct, {
                type: 'doughnut',
                data: {
                    labels: productLabels,
                    datasets: [{
                        data: productData,
                        backgroundColor: ['#0d6efd', '#198754', '#ffc107']
                    }]
                },
                options: { /* ... options ... */
                     maintainAspectRatio: false,
                     responsive: true,
                     plugins: {
                         legend: { position: 'bottom' }
                         // title: { display: true, text: 'Product Premium Distribution' } // Bỏ title nếu đã có ở card-header
                     }
                 }
            });

            // Có thể thêm code vẽ các biểu đồ khác ở đây
        });
    </script>

</body>
</html>