<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Product, entity.InsuranceProductDetails, entity.ProductCategory, java.util.List" %>
<%
    String ctx = request.getContextPath();
    Product product = (Product) request.getAttribute("product");
    InsuranceProductDetails details = (InsuranceProductDetails) request.getAttribute("details");
    List<ProductCategory> categories = (List<ProductCategory>) request.getAttribute("categories");

    if (product == null) {
        out.println("<p style='color:red'>❌ Không có dữ liệu sản phẩm để chỉnh sửa.</p>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>✏️ Chỉnh sửa sản phẩm bảo hiểm</title>

    <!-- Bootstrap + FontAwesome -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css"/>

    <style>
        /* CSS layout theo bạn gửi */
        :root {
            --sidebar-width: 240px;
            --navbar-height: 56px;
            --bg-page: #f4f6f8;
            --text: #2f3542;
            --primary: #0d6efd;
        }

        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            background: var(--bg-page);
            color: var(--text);
            font-family: 'Source Sans Pro', 'Poppins', Arial, sans-serif;
        }

        body {
            padding-top: var(--navbar-height);
        }

        .navbar {
            height: var(--navbar-height);
            box-shadow: 0 1px 0 rgba(0,0,0,0.04);
        }

        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: var(--sidebar-width);
            height: 100vh;
            z-index: 1040;
            padding-top: var(--navbar-height);
            overflow-y: auto;
        }

        .sidebar .sidebar-top {
            padding: 1rem;
        }

        .sidebar .nav-link {
            color: rgba(255,255,255,0.95);
            border-radius: 6px;
        }

        .sidebar .nav-link.active, .sidebar .nav-link:hover {
            background: rgba(255,255,255,0.06);
            color: #fff;
        }

        .main-content {
            margin-left: var(--sidebar-width);
            min-height: calc(100vh - var(--navbar-height));
            padding: 2rem;
        }

        .main-footer {
            margin-left: var(--sidebar-width);
            background: transparent;
            color: #666;
            border-top: 0;
        }

        /* Form styling */
        .container-form {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
            padding: 30px;
            max-width: 800px;
            margin: auto;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin: 6px 0 18px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .btn-submit {
            background-color: var(--primary);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
        }

        .btn-submit:hover {
            background-color: #0b5ed7;
        }

        .field-group {
            display: none;
            border-top: 1px solid #eaeaea;
            padding-top: 10px;
        }
    </style>

    <script>
        function showFields() {
            const category = document.getElementById("category").value;
            document.querySelectorAll(".field-group").forEach(div => div.style.display = "none");

            if (category === "life") {
                document.getElementById("life-fields").style.display = "block";
            } else if (category === "health") {
                document.getElementById("health-fields").style.display = "block";
            } else if (category === "car") {
                document.getElementById("car-fields").style.display = "block";
            }
        }
        window.onload = showFields;
    </script>
</head>

<body>
    <!-- NAVBAR -->
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
    <!-- MAIN CONTENT -->
    <main class="main-content">
        <div class="container-form">
            <h2 class="mb-4">✏️ Chỉnh sửa sản phẩm bảo hiểm</h2>
            <form action="ProductServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= product.getProductId() %>">

                <label>Tên sản phẩm:</label>
                <input type="text" name="product_name" value="<%= product.getProductName() %>" required>

                <label>Giá cơ bản:</label>
                <input type="number" name="base_price" value="<%= product.getBasePrice() %>" required>

                <label>Loại sản phẩm:</label>
                <select id="category" name="category" onchange="showFields()">
                    <option value="life" <%= (product.getCategoryId()==1 ? "selected" : "") %>>Bảo hiểm nhân thọ</option>
                    <option value="health" <%= (product.getCategoryId()==2 ? "selected" : "") %>>Bảo hiểm sức khỏe</option>
                    <option value="car" <%= (product.getCategoryId()==3 ? "selected" : "") %>>Bảo hiểm ô tô</option>
                </select>

                <label>Thời hạn (năm):</label>
                <input type="number" name="duration_years" value="<%= details.getDurationYears() %>" required>

                <label>Giá trị bảo hiểm (Coverage Amount):</label>
                <input type="number" name="coverage_amount" value="<%= details.getCoverageAmount() %>" required>

                <!-- Bảo hiểm nhân thọ -->
                <div id="life-fields" class="field-group">
                    <h5>Thông tin nhân thọ</h5>
                    <label>Người thụ hưởng:</label>
                    <input type="text" name="beneficiaries" value="<%= details.getBeneficiaries() != null ? details.getBeneficiaries() : "" %>">
                    <label>Quyền lợi đáo hạn:</label>
                    <input type="text" name="maturity_benefit" value="<%= details.getMaturityBenefit() != null ? details.getMaturityBenefit() : "" %>">
                    <label>Số tiền đáo hạn:</label>
                    <input type="number" name="maturity_amount" value="<%= details.getMaturityAmount() != null ? details.getMaturityAmount() : 0 %>">
                </div>

                <!-- Bảo hiểm sức khỏe -->
                <div id="health-fields" class="field-group">
                    <h5>Thông tin sức khỏe</h5>
                    <label>Giới hạn viện phí:</label>
                    <input type="number" name="hospital_limit" value="<%= details.getHospitalizationLimit() != null ? details.getHospitalizationLimit() : 0 %>">
                    <label>Giới hạn phẫu thuật:</label>
                    <input type="number" name="surgery_limit" value="<%= details.getSurgeryLimit() != null ? details.getSurgeryLimit() : 0 %>">
                    <label>Giới hạn thai sản:</label>
                    <input type="number" name="maternity_limit" value="<%= details.getMaternityLimit() != null ? details.getMaternityLimit() : 0 %>">
                    <label>Thời gian chờ (ngày):</label>
                    <input type="number" name="waiting_period" value="<%= details.getWaitingPeriod() != null ? details.getWaitingPeriod() : 0 %>">
                    <label>Độ tuổi tối thiểu:</label>
                    <input type="number" name="min_age" value="<%= details.getMinAge() != null ? details.getMinAge() : 0 %>">
                    <label>Độ tuổi tối đa:</label>
                    <input type="number" name="max_age" value="<%= details.getMaxAge() != null ? details.getMaxAge() : 0 %>">
                </div>

                <!-- Bảo hiểm ô tô -->
                <div id="car-fields" class="field-group">
                    <h5>Thông tin ô tô</h5>
                    <label>Loại xe:</label>
                    <input type="text" name="vehicle_type" value="<%= details.getVehicleType() != null ? details.getVehicleType() : "" %>">
                    <label>Giá trị xe:</label>
                    <input type="number" name="vehicle_value" value="<%= details.getVehicleValue() != null ? details.getVehicleValue() : 0 %>">
                    <label>Kiểu bảo hiểm:</label>
                    <input type="text" name="coverage_type" value="<%= details.getCoverageType() != null ? details.getCoverageType() : "" %>">
                </div>

                <div class="text-center mt-4">
                    <button type="submit" class="btn-submit"><i class="fas fa-save me-2"></i> Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </main>

    <footer class="main-footer text-center py-3">
        <small>© 2025 Insurance Management System</small>
    </footer>
</body>
</html>
