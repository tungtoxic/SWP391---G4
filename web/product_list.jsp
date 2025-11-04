<%-- 
    Document   : product_list
    Created on : Nov 3, 2025, 3:57:52 PM
    Author     : Nguyễn Tùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="entity.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%-- Dùng JSTL cho gọn --%>

<%
    // Lấy dữ liệu Servlet đã forward
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser");
    String activePage = (String) request.getAttribute("activePage");
    List<Product> productList = (List<Product>) request.getAttribute("productList");

    // Khởi tạo an toàn
    if (productList == null) productList = new ArrayList<>();
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    
    // Định dạng tiền tệ
    DecimalFormat formatter = new DecimalFormat("#,##0 VNĐ");
%>

<!DOCTYPE html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Danh mục Sản phẩm</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" /> <%-- Giả định bạn dùng layout chung --%>
</head>
<body>

    <%-- 
      Phần này giả định bạn có file layout navbar chung.
      Nếu Manager và Agent dùng navbar khác nhau, bạn cũng có thể
      đặt logic "if-else" ở đây giống như sidebar.
    --%>
    <%@ include file="agent_navbar.jsp" %>

    <%-- ===== SIDEBAR THÔNG MINH ===== --%>
    <%
        if (currentUser.getRoleId() == 1) { // 1 = Agent
    %>
            <%@ include file="agent_sidebar.jsp" %>
            <%@ include file="agent_navbar.jsp" %>
    <%
        } else if (currentUser.getRoleId() == 2) { // 2 = Manager
    %>
            <%@ include file="manager_sidebar.jsp" %>
            <%@ include file="manager_navbar.jsp" %>
    <%
        }
        // Nếu là Admin (vai trò 3), chúng ta sẽ include admin_sidebar.jsp
        // Nhưng theo servlet, chỉ Agent/Manager mới vào được đây.
    %>
    <%-- ============================ --%>

    <main class="main-content">
        <div class="container-fluid">
            
            <h1 class="h3 mb-3">Danh mục Sản phẩm Bảo hiểm</h1>
            <p class="text-muted">Danh sách các sản phẩm bảo hiểm hiện hành.</p>

            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fa fa-box me-2"></i> Danh sách Sản phẩm</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tên Sản phẩm</th>
                                    <th>Mô tả</th>
                                    <th class="text-end">Giá cơ bản (Ước tính)</th>
                                    
                                    <th class="text-center">Thời hạn</th>
                                    </tr>
                            </thead>
                            <tbody>
                                <% if (productList.isEmpty()) { %>
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-4">
                                        Chưa có sản phẩm nào trong cơ sở dữ liệu.
                                        </td>
                                    </tr>
                                <% } else { %>
                                    <% for (Product p : productList) { %>
                                        <tr>
                                            <td><%= p.getProductId() %></td>
                                            <td class="fw-bold"><%= p.getProductName() %></td>
                                            <td><%= (p.getDescription() != null ? p.getDescription() : "N/A") %></td>
                                            <td class="text-end">
                                                <%= (p.getBasePrice() != null ? formatter.format(p.getBasePrice()) : "N/A") %>
                                            </td>
                                            
                                            <td class="text-center">
                                                <%= p.getDurationMonths() %> tháng
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