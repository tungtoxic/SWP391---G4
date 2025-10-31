<%-- 
    Document   : commission_report
    Created on : Oct 20, 2025, 12:33:41 AM
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.User" %>
<%@ page import="entity.CommissionReportDTO" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Lấy context path
    String ctx = request.getContextPath();

    // Lấy dữ liệu từ session và request
    User currentUser = (User) session.getAttribute("user");
    List<CommissionReportDTO> reportList = (List<CommissionReportDTO>) request.getAttribute("reportList");
    Double totalCommission = (Double) request.getAttribute("totalCommission");
    String startDate = (String) request.getAttribute("startDate");
    String endDate = (String) request.getAttribute("endDate");

    // Khởi tạo các đối tượng định dạng
    DecimalFormat currencyFormat = new DecimalFormat("###,###,### 'VND'");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    // Xử lý giá trị null để tránh lỗi
    if (totalCommission == null) totalCommission = 0.0;
    if (startDate == null) startDate = "";
    if (endDate == null) endDate = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Báo cáo Hoa hồng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
    <%-- ======================== NAVBAR ======================== --%>
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
                    <div style="font-size:.85rem;opacity:.9">Agent</div>
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
    <%-- ======================== MAIN CONTENT ======================== --%>
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Báo cáo Hoa hồng Cá nhân</h1>

            <div class="card mb-4">
                <div class="card-body">
                    <form action="<%= ctx %>/agent/commission-report" method="GET" class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label for="startDate" class="form-label">Từ ngày</label>
                            <input type="date" class="form-control" id="startDate" name="startDate" value="<%= startDate %>">
                        </div>
                        <div class="col-md-4">
                            <label for="endDate" class="form-label">Đến ngày</label>
                            <input type="date" class="form-control" id="endDate" name="endDate" value="<%= endDate %>">
                        </div>
                        <div class="col-md-2">
                             <button type="submit" class="btn btn-primary w-100">Lọc</button>
                        </div>
                        <div class="col-md-2">
                             <a href="<%= ctx %>/agent/commission-report" class="btn btn-secondary w-100">Xóa lọc</a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card bg-light mb-4">
                <div class="card-body">
                    <h5 class="card-title">Tổng Thu Nhập (theo bộ lọc)</h5>
                    <p class="card-text fs-3 fw-bold text-success">
                        <%= currencyFormat.format(totalCommission) %>
                    </p>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    Chi tiết Hoa hồng theo Hợp đồng
                </div>
                <div class="card-body">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>Mã HĐ</th>
                                <th>Tên Khách Hàng</th>
                                <th>Gói Bảo Hiểm</th>
                                <th>Tiền Hoa Hồng</th>
                                <th>Trạng Thái</th>
                                <th>Ngày Ghi Nhận</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            if (reportList != null && !reportList.isEmpty()) {
                                for (CommissionReportDTO item : reportList) {
                            %>
                                    <tr>
                                        <td>#<%= item.getContractId() %></td>
                                        <td><%= item.getCustomerName() %></td>
                                        <td><%= item.getPolicyName() %></td>
                                        <td class="fw-bold"><%= currencyFormat.format(item.getCommissionAmount()) %></td>
                                        <td>
                                            <%
                                            String status = item.getStatus();
                                            if ("Paid".equals(status)) {
                                                out.print("<span class=\"badge bg-success\">Đã Thanh Toán</span>");
                                            } else if ("Pending".equals(status)) {
                                                out.print("<span class=\"badge bg-warning text-dark\">Đang Chờ</span>");
                                            } else {
                                                out.print("<span class=\"badge bg-danger\">Đã Hủy</span>");
                                            }
                                            %>
                                        </td>
                                        <td><%= dateFormat.format(item.getCommissionDate()) %></td>
                                    </tr>
                            <%
                                } // Kết thúc vòng lặp for
                            } else {
                            %>
                                <tr>
                                    <td colspan="6" class="text-center text-muted p-4">Không tìm thấy khoản hoa hồng nào phù hợp.</td>
                                </tr>
                            <%
                            } // Kết thúc if-else
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <%-- ======================== FOOTER ======================== --%>
    <footer class="main-footer">
        <div class="text-center py-3">
             © 2025 Your Company
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>