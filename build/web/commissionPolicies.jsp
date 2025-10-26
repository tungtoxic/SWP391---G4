<%-- 
    Document   : commissionPolicies
    Created on : Oct 25, 2025, 4:44:48 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.Product" %>
<%
    String ctx = request.getContextPath();
    List<Product> productList = (List<Product>) request.getAttribute("productList");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Commission Policies</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
        <style>
            h2 { color: var(--primary); font-weight: 600; }
            ul { margin-top: 0.5rem; }
        </style>
    </head>
    <body>

        <!-- Navbar -->
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

        <!-- Sidebar -->
        <aside class="sidebar bg-primary text-white">
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
                <a class="nav-link text-white py-2" href="<%=ctx%>/manager/performance"><i class="fas fa-users-cog me-2"></i> Team Performance</a>
                <a class="nav-link text-white py-2" href="<%=ctx%>/agentmanagement.jsp"><i class="fas fa-users-cog me-2"></i> Agent Management</a>
                <a class="nav-link text-white py-2" href="<%=ctx%>/managers/leaderboard"><i class="fas fa-trophy me-2"></i> Leader Board</a>
                <a class="nav-link text-white py-2" href="<%=ctx%>/CommissionPoliciesServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Commission Policies</a>
                <a class="nav-link text-white py-2" href="<%=ctx%>/productmanagement.jsp"><i class="fas fa-box me-2"></i> Product</a>
                <a class="nav-link text-white py-2" href="<%=ctx%>/manager/contracts"><i class="fas fa-file-signature me-2"></i> Contract</a>
                <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
                <div class="mt-3 px-2">
                    <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="main-content">
            <div class="container">
                <h2 class="mb-4">Commission Policies</h2>

                <% if (productList != null && !productList.isEmpty()) { 
                       for (Product product : productList) { 
                           int cate = product.getCategoryId();
                %>
                    <div class="card mb-4">
                        <div class="card-body">
                            <h4 class="card-title"><%= product.getProductName() %></h4>
                            <ul>
                                <%-- Bảo hiểm nhân thọ --%>
                                <% if (cate == 1) { %>
                                    <li>Đối với các hợp đồng bảo hiểm có thời hạn từ 01 năm trở xuống và 01 năm tái tục hàng năm (áp dụng từ 01/7/2024): Tỷ lệ hoa hồng đại lý bảo hiểm tối đa là 20%.</li>
                                    <li>Đối với các hợp đồng bảo hiểm trên 01 năm: Sẽ áp dụng theo quy định riêng, tuy nhiên, các đại lý ghi nhận mức hoa hồng năm đầu tiên thường dưới 30% và tối đa có thể lên đến 40% tùy sản phẩm.</li>
                                    <li>Đối với hợp đồng bảo hiểm nhân thọ nhóm: Tỷ lệ hoa hồng đại lý tối đa bằng 50% các tỷ lệ tương ứng áp dụng cho hợp đồng bảo hiểm nhân thọ cá nhân cùng loại.</li>
                                    <li>Đối với hợp đồng bảo hiểm hưu trí: Tỷ lệ hoa hồng đại lý tối đa là 3% tổng phí bảo hiểm.</li>
                                    <li>Đối với các hợp đồng bảo hiểm thuộc bảo hiểm sức khỏe: Tỷ lệ hoa hồng đại lý tối đa là 20%.</li>
                                <% } else if (cate == 2) { %>
                                    <li>Đối với hợp đồng bảo hiểm sức khỏe từ 1 năm trở xuống và 1 năm tái tục hàng năm: Tỷ lệ hoa hồng đại lý tối đa là 20%.</li>
                                    <li>Đối với hợp đồng bảo hiểm sức khỏe trên 1 năm:</li>
                                    <ul>
                                        <li>Hoa hồng khai thác mới: Tối đa 30% phí bảo hiểm thực tế thu được trong năm đầu.</li>
                                        <li>Hoa hồng tái tục: Tối đa 7% phí bảo hiểm tái tục thực tế thu được trong năm.</li>
                                    </ul>
                                <% } else if (cate == 3) { %>
                                    <li>Bảo hiểm bắt buộc trách nhiệm dân sự của chủ xe cơ giới:</li>
                                    <ul>
                                        <li>Xe mô tô, xe máy: Tối đa 20%.</li>
                                        <li>Ô tô: Tối đa 5%.</li>
                                    </ul>
                                <% } else { %>
                                    <li>Chính sách hoa hồng sẽ được xác định riêng cho từng sản phẩm.</li>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                <%   } 
                   } else { %>
                    <p class="text-muted">❌ Không có sản phẩm nào để hiển thị chính sách hoa hồng.</p>
                <% } %>
            </div>
        </div>

        <footer class="main-footer text-center py-3">
            <small>© 2025 Insurance Agent System</small>
        </footer>
    </body>
</html>

