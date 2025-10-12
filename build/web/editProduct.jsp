<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Product, entity.InsuranceProductDetails, entity.ProductCategory, java.util.List" %>

<%
    Product product = (Product) request.getAttribute("product");
    InsuranceProductDetails details = (InsuranceProductDetails) request.getAttribute("details");
    List<ProductCategory> categories = (List<ProductCategory>) request.getAttribute("categories");

    if (product == null) {
        out.println("<p style='color:red'>❌ Không có dữ liệu sản phẩm để chỉnh sửa.</p>");
        return;
    }
%>

<html>
<head>
    <title>✏️ Chỉnh sửa sản phẩm bảo hiểm</title>
    <link rel="stylesheet" href="css/product-form.css">

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

    <style>
        .container {
            width: 60%;
            margin: 30px auto;
            background: #fff;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        input, select {
            width: 100%;
            padding: 8px;
            margin: 5px 0 15px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .btn-submit {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
        .btn-submit:hover {
            background-color: #0056b3;
        }
        .field-group {
            display: none;
        }
    </style>
</head>

<body>
<div class="container">
    <h2>✏️ Chỉnh sửa sản phẩm</h2>

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

        <label>Giá trị bảo hiểm:</label>
        <input type="number" name="coverage_amount" value="<%= details.getCoverageAmount() %>" required>

        <!-- BẢO HIỂM NHÂN THỌ -->
        <div id="life-fields" class="field-group">
            <h3>Thông tin nhân thọ</h3>
            <label>Người thụ hưởng:</label>
            <input type="text" name="beneficiaries" value="<%= details.getBeneficiaries() != null ? details.getBeneficiaries() : "" %>">

            <label>Quyền lợi đáo hạn:</label>
            <input type="text" name="maturity_benefit" value="<%= details.getMaturityBenefit() != null ? details.getMaturityBenefit() : "" %>">

            <label>Số tiền đáo hạn:</label>
            <input type="number" name="maturity_amount" value="<%= details.getMaturityAmount() != null ? details.getMaturityAmount() : 0 %>">
        </div>

        <!-- BẢO HIỂM SỨC KHỎE -->
        <div id="health-fields" class="field-group">
            <h3>Thông tin sức khỏe</h3>
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

        <!-- BẢO HIỂM Ô TÔ -->
        <div id="car-fields" class="field-group">
            <h3>Thông tin ô tô</h3>
            <label>Loại xe:</label>
            <input type="text" name="vehicle_type" value="<%= details.getVehicleType() != null ? details.getVehicleType() : "" %>">

            <label>Giá trị xe:</label>
            <input type="number" name="vehicle_value" value="<%= details.getVehicleValue() != null ? details.getVehicleValue() : 0 %>">

            <label>Kiểu bảo hiểm:</label>
            <input type="text" name="coverage_type" value="<%= details.getCoverageType() != null ? details.getCoverageType() : "" %>">
        </div>

        <button type="submit" class="btn-submit">💾 Lưu thay đổi</button>
    </form>
</div>
</body>
</html>

