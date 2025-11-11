<%-- 
    Document   : view_policies
    Created on : Nov 11, 2025, 8:37:53 PM
    Author     : Nguyễn Tùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User, entity.CommissionPolicy, java.util.List, java.util.ArrayList, java.math.BigDecimal, java.text.DecimalFormat, java.text.SimpleDateFormat" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser");
    String activePage = (String) request.getAttribute("activePage");
    List<CommissionPolicy> policyList = (List<CommissionPolicy>) request.getAttribute("policyList");
    if (policyList == null) policyList = new ArrayList<>();
    
    // Khởi tạo an toàn (nếu truy cập trực tiếp)
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    
    DecimalFormat rateFormat = new DecimalFormat("#,##0.00'%'");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chính sách Hoa hồng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
    
    <%-- Navbar (Giả định bạn dùng chung navbar) --%>
    <%@ include file="agent_navbar.jsp" %> 

    <%-- ===== SIDEBAR THÔNG MINH ===== --%>
    <%
        if (currentUser.getRoleId() == 1) { // 1 = Agent
    %>
            <%@ include file="agent_sidebar.jsp" %>
    <%
        } else if (currentUser.getRoleId() == 2) { // 2 = Manager
    %>
            <%@ include file="manager_sidebar.jsp" %>
    <%
        }
    %>
    <%-- ============================ --%>

    <main class="main-content">
        <div class="container-fluid">
            <h1 class="h3 mb-3">Chính sách Hoa hồng</h1>
            <p class="text-muted">Các chính sách hoa hồng đang và đã áp dụng trong toàn hệ thống.</p>

            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-file-alt me-2"></i> Danh sách Chính sách</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tên Chính sách</th>
                                    <th class="text-end">Tỷ lệ (Rate)</th>
                                    <th>Ngày Hiệu lực</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (policyList.isEmpty()) { %>
                                    <tr>
                                        <td colspan="4" class="text-center text-muted p-4">
                                            Chưa có chính sách nào được cấu hình. (Đang dùng 1 chính sách gốc).
                                        </td>
                                    </tr>
                                <% } else { %>
                                    <% for (CommissionPolicy p : policyList) { %>
                                        <tr>
                                            <td>#<%= p.getPolicyId() %></td>
                                            <td class="fw-bold"><%= p.getPolicyName() %></td>
                                            <td class="text-end text-success fw-bold"><%= rateFormat.format(p.getRate()) %></td>
                                            <td><%= dateFormat.format(p.getEffectiveFrom()) %></td>
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