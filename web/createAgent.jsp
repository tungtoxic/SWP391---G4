<%-- 
    Document   : commission_report
    Created on : Oct 20, 2025, 12:33:41 AM
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="entity.User" %>
<%@ page import="entity.CommissionReportDTO" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Lấy context path
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser");
    String activePage = (String) request.getAttribute("activePage");
    List<CommissionReportDTO> reportList = (List<CommissionReportDTO>) request.getAttribute("reportList");
    Double totalCommission = (Double) request.getAttribute("totalCommission");
    String startDate = (String) request.getAttribute("startDate");
    String endDate = (String) request.getAttribute("endDate");

    // Khởi tạo các đối tượng định dạng
    DecimalFormat currencyFormat = new DecimalFormat("###,###,### 'VND'");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    // Xử lý giá trị null để tránh lỗi
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (reportList == null) reportList = new ArrayList<>();
    if (totalCommission == null) totalCommission = 0.0;
    if (startDate == null) startDate = "";
    if (endDate == null) endDate = "";
    if (activePage == null) activePage = "commission"; 
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
    <%@ include file="agent_navbar.jsp" %>
    <%@ include file="agent_sidebar.jsp" %>
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