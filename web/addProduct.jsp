<%-- 
    Document   : addProduct
    Created on : Oct 17, 2025, 2:22:14 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (selectedCategory == null) selectedCategory = "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm sản phẩm bảo hiểm</title>

    <!-- Bootstrap + FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <!-- Layout CSS -->
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />

    <style>
        main {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: calc(100vh - var(--navbar-height));
            background: var(--bg-page);
            padding-top: 40px;
        }

        .container-form {
            background: #fff;
            padding: 40px 50px;
            border-radius: 15px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.1);
            width: 500px;
        }

        h2 {
            text-align: center;
            color: var(--text);
            margin-bottom: 25px;
        }

        label {
            font-weight: 600;
            color: #34495e;
            margin-top: 10px;
        }

        input, textarea, select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
            margin-top: 5px;
            transition: 0.2s;
        }

        input:focus, textarea:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 5px rgba(13, 110, 253, 0.3);
        }

        textarea { resize: none; height: 80px; }

        button {
            background-color: var(--primary);
            color: white;
            font-weight: bold;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
            transition: 0.3s;
        }

        button:hover {
            background-color: #0b5ed7;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #555;
            text-decoration: none;
            font-size: 14px;
        }

        .back-link:hover { color: var(--primary); }

        .category-tag {
            text-align: center;
            margin-bottom: 20px;
            font-weight: bold;
            color: #2c3e50;
            font-size: 18px;
        }
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
        <div class="container-form">
            <h2>🛡️ Thêm sản phẩm mới</h2>

            <div class="category-tag">
                <%
                    String categoryLabel;
                    switch (selectedCategory) {
                        case "life": categoryLabel = "💖 Bảo hiểm nhân thọ"; break;
                        case "health": categoryLabel = "🏥 Bảo hiểm sức khỏe"; break;
                        case "car": categoryLabel = "🚗 Bảo hiểm ô tô"; break;
                        default: categoryLabel = "Không xác định";
                    }
                %>
                <%= categoryLabel %>
            </div>

            <form action="ProductServlet" method="post">
                <input type="hidden" name="action" value="addProduct">
                <input type="hidden" name="category" value="<%= selectedCategory %>">

                <label>Tên sản phẩm:</label>
                <input type="text" name="product_name" placeholder="Nhập tên sản phẩm..." required>

                <label>Thời hạn:</label>
                <input type="number" name="duration_years" placeholder="Ví dụ: 10,20,..." required>

                <label>Giá cơ bản (VNĐ):</label>
                <input type="number" name="base_price" placeholder="Ví dụ: 5000000" required>

                <label>Giá trị bảo hiểm:</label>
                <input type="number" name="coverage_amount" placeholder="Ví dụ: 10000000">

                <% if ("life".equals(selectedCategory)) { %>
                    <label>Người thụ hưởng:</label>
                    <input type="text" name="beneficiaries" placeholder="Nhập người thụ hưởng...">

                    <label>Số tiền đáo hạn:</label>
                    <input type="number" name="maturity_amount" placeholder="Ví dụ: 10000000">

                    <label>Lợi ích đáo hạn:</label>
                    <input type="text" name="maturity_benefit" placeholder="Ví dụ: Nhận toàn bộ giá trị hợp đồng khi đáo hạn">

                <% } else if ("health".equals(selectedCategory)) { %>
                    <label>Giới hạn nằm viện:</label>
                    <input type="number" name="hospital_limit" placeholder="Ví dụ: 10000000">

                    <label>Giới hạn phẫu thuật:</label>
                    <input type="number" name="surgery_limit" placeholder="Ví dụ: 10000000">

                    <label>Giới hạn sinh đẻ:</label>
                    <input type="number" name="maternity_limit" placeholder="Ví dụ: 10000000">

                    <label>Độ tuổi nhỏ nhất:</label>
                    <input type="number" name="min_age" placeholder="Ví dụ: 18">

                    <label>Độ tuổi lớn nhất:</label>
                    <input type="number" name="max_age" placeholder="Ví dụ: 60">

                    <label>Thời gian chờ (ngày):</label>
                    <input type="number" name="waiting_period" placeholder="Ví dụ: 30">

                <% } else if ("car".equals(selectedCategory)) { %>
                    <label>Loại xe:</label>
                    <input type="text" name="vehicle_type" placeholder="Ví dụ: Sedan, SUV...">

                    <label>Giá trị xe (VNĐ):</label>
                    <input type="number" name="vehicle_value" placeholder="Ví dụ: 800000000">

                    <label>Kiểu bảo hiểm:</label>
                    <input type="text" name="coverage_type" placeholder="Ví dụ: Toàn phần, trách nhiệm dân sự...">
                <% } %>

                <button type="submit">💾 Thêm sản phẩm</button>
            </form>

            <a href="ProductServlet" class="back-link">← Quay lại danh sách sản phẩm</a>
        </div>
    </main>

    <footer class="main-footer text-muted">
        <div class="container-fluid d-flex justify-content-between py-2">
            <div>© Your Company</div>
            <div><b>Version</b> 1.0</div>
        </div>
    </footer>
</body>
</html>