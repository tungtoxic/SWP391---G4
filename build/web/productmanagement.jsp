<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.Product, entity.ProductCategory, entity.InsuranceProductDetails" %>
<%
    String ctx = request.getContextPath();

    List<Product> productList = (List<Product>) request.getAttribute("productList");
    List<ProductCategory> categoryList = (List<ProductCategory>) request.getAttribute("categoryList");
    Map<Integer, InsuranceProductDetails> detailMap = (Map<Integer, InsuranceProductDetails>) request.getAttribute("detailMap");

    List<Product> lifeList = new ArrayList<>();
    List<Product> healthList = new ArrayList<>();
    List<Product> carList = new ArrayList<>();

    if (productList != null) {
        for (Product p : productList) {
            switch (p.getCategoryId()) {
                case 1: lifeList.add(p); break;
                case 2: healthList.add(p); break;
                case 3: carList.add(p); break;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>📋 Quản lý sản phẩm bảo hiểm</title>

    <!-- Bootstrap + FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <!-- Layout CSS (CSS :root bạn gửi ở trên) -->
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />

    <style>
        /* Bổ sung CSS riêng cho trang này */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            display: none;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
        }
        th, td {
            padding: 10px 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background: var(--primary);
            color: white;
        }
        tr:nth-child(even) { background-color: #f9fafc; }
        tr:hover { background-color: #eef4ff; }

        .action-btn {
            padding: 5px 10px;
            border-radius: 6px;
            text-decoration: none;
            color: white;
            font-weight: 500;
        }
        .edit-btn { background: #28a745; }
        .edit-btn:hover { background: #1e7e34; }
        .delete-btn { background: #dc3545; }
        .delete-btn:hover { background: #a71d2a; }
        .no-data { text-align: center; color: red; font-weight: 500; }
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
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-invoice-dollar me-2"></i> Commission Contracts</a>
            <a class="nav-link text-white py-2" href="ProductServlet?action=list"><i class="fas fa-box me-2"></i> Product</a>
            <a class="nav-link text-white py-2" href="ContractManagementServlet?action=list"><i class="fas fa-file-alt me-2"></i> Contracts</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container-fluid">
            <div class="card mb-4">
                <div class="card-body">
                    <h2 class="text-center mb-4">📦 QUẢN LÝ SẢN PHẨM BẢO HIỂM</h2>

                    <div class="text-end mb-3">
                        <a href="ProductServlet?action=addCategory" class="btn btn-primary"><i class="fas fa-plus"></i> Thêm sản phẩm</a>
                    </div>

                    <label for="categorySelect"><b>Chọn danh mục:</b></label>
                    <select id="categorySelect" class="form-select w-auto d-inline-block mb-3" onchange="showTable()">
                        <option value="life">🧍 Bảo hiểm nhân thọ</option>
                        <option value="health">🏥 Bảo hiểm sức khỏe</option>
                        <option value="car">🚗 Bảo hiểm ô tô</option>
                    </select>

                    <!-- Bảng Nhân thọ -->
                    <table id="lifeTable" class="table table-bordered table-striped">
                        <tr>
                            <th>ID</th><th>Tên sản phẩm</th><th>Thời hạn</th><th>Người thụ hưởng</th><th>Giá trị bảo hiểm</th><th>Số tiền đáo hạn</th><th>Lợi ích đáo hạn</th><th>Giá cơ bản</th><th>Ngày tạo</th><th>Hành động</th>
                        </tr>
                        <% if (!lifeList.isEmpty()) {
                            for (Product p : lifeList) {
                                InsuranceProductDetails d = detailMap.get(p.getProductId());
                        %>
                        <tr>
                            <td><%= p.getProductId() %></td>
                            <td><%= p.getProductName() %></td>
                            <td><%= d != null ? d.getDurationYears()+" năm" : "-" %></td>
                            <td><%= d != null ? d.getBeneficiaries() : "-" %></td>
                            <td><%= d != null ? String.format("%,.0f VNĐ", d.getCoverageAmount()) : "-" %></td>
                            <td><%= d != null ? String.format("%,.0f VNĐ", d.getMaturityAmount()) : "-" %></td>
                            <td><%= d != null ? d.getMaturityBenefit() : "-" %></td>
                            <td><%= String.format("%,.0f VNĐ", p.getBasePrice()) %></td>
                            <td><%= p.getCreatedAt() %></td>
                            <td class="text-center">
                                <a href="ProductServlet?action=edit&id=<%= p.getProductId() %>" class="action-btn edit-btn">✏️</a>
                                <a href="ProductServlet?action=delete&id=<%= p.getProductId() %>" class="action-btn delete-btn"
                                   onclick="return confirm('Xóa sản phẩm này?');">🗑️</a>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="10" class="no-data">Không có sản phẩm nhân thọ.</td></tr>
                        <% } %>
                    </table>

                    <!-- Bảng Sức khỏe -->
                    <table id="healthTable" class="table table-bordered table-striped">
                        <tr>
                            <th>ID</th><th>Tên sản phẩm</th><th>Thời hạn</th><th>Giới hạn nằm viện</th><th>Giới hạn phẫu thuật</th>
                            <th>Giới hạn sinh đẻ</th><th>Giá trị bảo hiểm</th><th>Độ tuổi nhỏ nhất</th><th>Độ tuổi lớn nhất</th><th>Thời gian chờ</th><th>Giá cơ bản</th><th>Ngày tạo</th><th>Hành động</th>
                        </tr>
                        <% if (!healthList.isEmpty()) {
                            for (Product p : healthList) {
                                InsuranceProductDetails d = detailMap.get(p.getProductId());
                        %>
                        <tr>
                            <td><%= p.getProductId() %></td>
                            <td><%= p.getProductName() %></td>
                            <td><%= d != null ? d.getDurationYears()+" năm" : "-" %></td>
                            <td><%= d != null ? String.format("%,.0f VNĐ", d.getHospitalizationLimit()) : "-" %></td>
                            <td><%= d != null ? String.format("%,.0f VNĐ", d.getSurgeryLimit()) : "-" %></td>
                            <td><%= d != null ? String.format("%,.0f VNĐ", d.getMaternityLimit()) : "-" %></td>
                            <td><%= d != null ? String.format("%,.0f VNĐ", d.getCoverageAmount()) : "-" %></td>
                            <td><%= d != null ? d.getMinAge()+" tuổi" : "-" %></td>
                            <td><%= d != null ? d.getMaxAge()+" tuổi" : "-" %></td>
                            <td><%= d != null ? d.getWaitingPeriod()+" ngày" : "-" %></td>
                            <td><%= String.format("%,.0f VNĐ", p.getBasePrice()) %></td>
                            <td><%= p.getCreatedAt() %></td>
                            <td class="text-center">
                                <a href="ProductServlet?action=edit&id=<%= p.getProductId() %>" class="action-btn edit-btn">✏️</a>
                                <a href="ProductServlet?action=delete&id=<%= p.getProductId() %>" class="action-btn delete-btn"
                                   onclick="return confirm('Xóa sản phẩm này?');">🗑️</a>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="13" class="no-data">Không có sản phẩm sức khỏe.</td></tr>
                        <% } %>
                    </table>

                    <!-- Bảng Ô tô -->
                    <table id="carTable" class="table table-bordered table-striped">
                        <tr>
                            <th>ID</th><th>Tên sản phẩm</th><th>Thời hạn</th><th>Loại xe</th><th>Giá trị xe</th><th>Kiểu bảo hiểm</th>
                            <th>Giá trị bảo hiểm</th><th>Giá cơ bản</th><th>Ngày tạo</th><th>Hành động</th>
                        </tr>
                        <% if (!carList.isEmpty()) {
                            for (Product p : carList) {
                                InsuranceProductDetails d = detailMap.get(p.getProductId());
                        %>
                        <tr>
                            <td><%= p.getProductId() %></td>
                            <td><%= p.getProductName() %></td>
                            <td><%= d != null ? d.getDurationYears()+" năm" : "-" %></td>
                            <td><%= d != null ? d.getVehicleType() : "-" %></td>
                            <td><%= d != null ? String.format("%,.0f VNĐ", d.getVehicleValue()) : "-" %></td>
                            <td><%= d != null ? d.getCoverageType() : "-" %></td>
                            <td><%= d != null ? String.format("%,.0f VNĐ", d.getCoverageAmount()) : "-" %></td>
                            <td><%= String.format("%,.0f VNĐ", p.getBasePrice()) %></td>
                            <td><%= p.getCreatedAt() %></td>
                            <td class="text-center">
                                <a href="ProductServlet?action=edit&id=<%= p.getProductId() %>" class="action-btn edit-btn">✏️</a>
                                <a href="ProductServlet?action=delete&id=<%= p.getProductId() %>" class="action-btn delete-btn"
                                   onclick="return confirm('Xóa sản phẩm này?');">🗑️</a>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr><td colspan="10" class="no-data">Không có sản phẩm ô tô.</td></tr>
                        <% } %>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <footer class="main-footer text-muted">
        <div class="container-fluid d-flex justify-content-between py-2">
            <div>© Your Company</div>
            <div><b>Version</b> 1.0</div>
        </div>
    </footer>

    <script>
        function showTable() {
            const selected = document.getElementById('categorySelect').value;
            ['lifeTable', 'healthTable', 'carTable'].forEach(id => {
                document.getElementById(id).style.display = 'none';
            });
            document.getElementById(selected + 'Table').style.display = 'table';
        }
        showTable();
    </script>

</body>
</html>
