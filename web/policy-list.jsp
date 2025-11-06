<%-- 
    Document   : policy-list
    Created on : Nov 4, 2025, 12:23:11 PM
    Author     : Nguyễn Tùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User, entity.CommissionPolicy, java.util.List, java.util.ArrayList, java.text.DecimalFormat, java.text.SimpleDateFormat" %>
<%
    // Lấy dữ liệu Servlet đã forward
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser");
    String activePage = (String) request.getAttribute("activePage");
    List<CommissionPolicy> policyList = (List<CommissionPolicy>) request.getAttribute("policyList");

    // Lấy thông báo từ URL (nếu có)
    String message = request.getParameter("message");
    
    // Khởi tạo an toàn
    if (policyList == null) policyList = new ArrayList<>();
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    
    // Định dạng
    DecimalFormat rateFormat = new DecimalFormat("#,##0.00'%'"); // Ví dụ: 5.50%
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Quản lý Chính sách Hoa hồng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
</head>
<body>

    <%@ include file="manager_navbar.jsp" %>
    <%@ include file="manager_sidebar.jsp" %>

    <main class="main-content">
        <div class="container-fluid">
            
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h1 class="h3 mb-0">Quản lý Chính sách Hoa hồng</h1>
                <a href="<%= ctx %>/manager/policies?action=showAddForm" class="btn btn-primary">
                    <i class="fa fa-plus me-1"></i> Thêm Chính sách Mới
                </a>
            </div>

            <%-- Hiển thị thông báo (nếu có) --%>
            <% if ("addSuccess".equals(message)) { %>
                <div class="alert alert-success">Đã thêm chính sách mới thành công!</div>
            <% } else if ("updateSuccess".equals(message)) { %>
                <div class="alert alert-success">Đã cập nhật chính sách thành công!</div>
            <% } else if ("notFound".equals(message)) { %>
                <div class="alert alert-danger">Không tìm thấy chính sách để cập nhật.</div>
            <% } %>

            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fa fa-file-invoice-dollar me-2"></i> Các Chính sách Hiện hành</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tên Chính sách</th>
                                    <th class="text-end">Tỷ lệ (Rate)</th>
                                    <th>Ngày có hiệu lực</th>
                                    <th class="text-center">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (policyList.isEmpty()) { %>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">
                                            Chưa có chính sách nào. Hãy thêm một chính sách mới.
                                        </td>
                                    </tr>
                                <% } else { %>
                                    <% for (CommissionPolicy p : policyList) { %>
                                        <tr>
                                            <td><%= p.getPolicyId() %></td>
                                            <td class="fw-bold"><%= p.getPolicyName() %></td>
                                            <td class="text-end"><%= rateFormat.format(p.getRate()) %></td>
                                            <td><%= dateFormat.format(p.getEffectiveFrom()) %></td>
                                            <td class="text-center">
                                                <a href="<%= ctx %>/manager/policies?action=showEditForm&id=<%= p.getPolicyId() %>" class="btn btn-sm btn-warning">
                                                    <i class="fa fa-edit"></i> Sửa
                                                </a>
                                                <%-- Chúng ta thống nhất TẠM THỜI không làm "Xóa" --%>
                                            </td>
                                        </tr>
                                    <% } %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>