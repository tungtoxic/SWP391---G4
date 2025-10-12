<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.Product, entity.ProductCategory, entity.InsuranceProductDetails" %>
<%
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    List<ProductCategory> categoryList = (List<ProductCategory>) request.getAttribute("categoryList");
    Map<Integer, InsuranceProductDetails> detailMap = (Map<Integer, InsuranceProductDetails>) request.getAttribute("detailMap");

    List<Product> lifeList = new ArrayList<>();
    List<Product> healthList = new ArrayList<>();
    List<Product> carList = new ArrayList<>();

    if (productList != null) {
<<<<<<< HEAD
        for (Product p : productList) {
            for (ProductCategory c : categoryList) {
                if (c.getCategoryId() == p.getCategoryId()) {
                    switch (c.getCategoryName()) { case "Bảo hiểm nhân thọ": lifeList.add(p); break; case "Bảo hiểm sức khỏe": healthList.add(p); break; case "Bảo hiểm ô tô": carList.add(p); break; }
                }
            }
        }
    }
=======
    for (Product p : productList) {
        switch (p.getCategoryId()) {
            case 1: lifeList.add(p); break;   // nhân thọ
            case 2: healthList.add(p); break; // sức khỏe
            case 3: carList.add(p); break;    // ô tô
        }
    }
}
>>>>>>> thanhhe180566
%>

<html>
    <head>
        <title>📋 Quản lý sản phẩm bảo hiểm</title>
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background: #f4f6f8;
                margin: 0;
                padding: 20px;
            }
            .container {
                width: 95%;
                margin: auto;
                background: #fff;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                color: #333;
            }
            select {
                padding: 6px 10px;
                font-size: 15px;
                margin-bottom: 20px;
                border-radius: 6px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
                display: none;
            }
            th, td {
                padding: 10px 12px;
                border: 1px solid #ddd;
                text-align: left;
                vertical-align: top;
            }
            th {
                background: #007bff;
                color: white;
                text-align: center;
            }
            tr:nth-child(even) {
                background-color: #f9fafc;
            }
            tr:hover {
                background-color: #eef4ff;
            }
            .action-btn {
                padding: 5px 10px;
                border-radius: 6px;
                text-decoration: none;
                color: white;
                font-weight: 500;
            }
            .edit-btn {
                background: #28a745;
            }
            .edit-btn:hover {
                background: #1e7e34;
            }
            .delete-btn {
                background: #dc3545;
            }
            .delete-btn:hover {
                background: #a71d2a;
            }
            .no-data {
                text-align: center;
                color: red;
                font-weight: 500;
            }

        </style>
    </head>
    <body>
        <div class="container">
            <h2>📦 QUẢN LÝ SẢN PHẨM BẢO HIỂM</h2>

            <div style="text-align:right; margin-bottom:15px;">
                <a href="ProductServlet?action=addCategory" style="background:#007bff;color:white;text-decoration:none;padding:8px 16px;border-radius:6px;">➕ Thêm sản phẩm</a>
            </div>

            <label for="categorySelect"><b>Chọn danh mục:</b></label>
            <select id="categorySelect" onchange="showTable()">
                <option value="life">🧍 Bảo hiểm nhân thọ</option>
                <option value="health">🏥 Bảo hiểm sức khỏe</option>
                <option value="car">🚗 Bảo hiểm ô tô</option>
            </select>

            <!-- BẢNG NHÂN THỌ -->
            <table id="lifeTable">
                <tr>
                    <th>ID</th><th>Tên sản phẩm</th><th>Thời hạn</th><th>Người thụ hưởng</th><th>Giá trị bảo hiểm</th><th>Số tiền đáo hạn</th><th>Lợi ích đáo hạn</th><th>Giá cơ bản</th><th>Ngày tạo</th>
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
                </tr>
                <td colspan="10">
                    <div style="margin-top:8px; text-align:center;">
                        <a href="ProductServlet?action=edit&id=<%= p.getProductId() %>" class="action-btn edit-btn">✏️ Sửa</a>
                        <a href="ProductServlet?action=delete&id=<%= p.getProductId() %>" class="action-btn delete-btn"
                           onclick="return confirm('Xóa sản phẩm này?');">🗑️ Xóa</a>
                    </div>
                </td>
                <% }} else { %>
                <tr><td colspan="10" class="no-data">Không có sản phẩm nhân thọ.</td></tr>
                <% } %>
            </table>

            <!-- BẢNG SỨC KHỎE -->
            <table id="healthTable">
                <tr>
<<<<<<< HEAD
                    <th>ID</th><th>Tên sản phẩm</th><th>Giới hạn nằm viện</th><th>Giới hạn phẫu thuật</th><th>Giới hạn sinh đẻ</th><th>Giá trị bảo hiểm</th><th>Độ tuổi nhỏ nhất</th><th>Độ tuổi lớn nhất</th><th>Thời gian chờ</th><th>Giá cơ bản</th><th>Ngày tạo</th>
=======
                    <th>ID</th><th>Tên sản phẩm</th><th>Thời hạn</th><th>Giới hạn nằm viện</th><th>Giới hạn phẫu thuật</th><th>Giới hạn sinh đẻ</th><th>Giá trị bảo hiểm</th><th>Độ tuổi nhỏ nhất</th><th>Độ tuổi lớn nhất</th><th>Thời gian chờ</th><th>Giá cơ bản</th><th>Ngày tạo</th>
>>>>>>> thanhhe180566
                </tr>
                <% if (!healthList.isEmpty()) {
                    for (Product p : healthList) {
                        InsuranceProductDetails d = detailMap.get(p.getProductId());
                %>
                <tr>
                    <td><%= p.getProductId() %></td>
                    <td><%= p.getProductName() %></td>
<<<<<<< HEAD
=======
                    <td><%= d != null ? d.getDurationYears()+" năm" : "-" %></td>
>>>>>>> thanhhe180566
                    <td><%= d != null ? String.format("%,.0f VNĐ", d.getHospitalizationLimit()) : "-" %></td>
                    <td><%= d != null ? String.format("%,.0f VNĐ", d.getSurgeryLimit()) : "-" %></td>
                    <td><%= d != null ? String.format("%,.0f VNĐ", d.getMaternityLimit()) : "-" %></td>
                    <td><%= d != null ? String.format("%,.0f VNĐ", d.getCoverageAmount()) : "-" %></td>
                    <td><%= d != null ? d.getMinAge()+" tuổi" : "-" %></td>
                    <td><%= d != null ? d.getMaxAge()+" tuổi" : "-" %></td>
                    <td><%= d != null ? d.getWaitingPeriod()+" ngày" : "-" %></td>
                    <td><%= String.format("%,.0f VNĐ", p.getBasePrice()) %></td>
                    <td><%= p.getCreatedAt() %></td>
                </tr>
                <td colspan="10">
                    <div style="margin-top:8px; text-align:center;">
                        <a href="ProductServlet?action=edit&id=<%= p.getProductId() %>" class="action-btn edit-btn">✏️ Sửa</a>
                        <a href="ProductServlet?action=delete&id=<%= p.getProductId() %>" class="action-btn delete-btn"
                           onclick="return confirm('Xóa sản phẩm này?');">🗑️ Xóa</a>
                    </div>
                </td>
                <% }} else { %>
                <tr><td colspan="12" class="no-data">Không có sản phẩm sức khỏe.</td></tr>
                <% } %>
            </table>

            <!-- BẢNG Ô TÔ -->
            <table id="carTable">
                <tr>
                    <th>ID</th><th>Tên sản phẩm</th><th>Thời hạn</th><th>Loại xe</th><th>Giá trị xe</th><th>Kiểu bảo hiểm</th><th>Giá trị bảo hiểm</th><th>Giá cơ bản</th><th>Ngày tạo</th>
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
                </tr>
                <td colspan="10">
                    <div style="margin-top:8px; text-align:center;">
                        <a href="ProductServlet?action=edit&id=<%= p.getProductId() %>" class="action-btn edit-btn">✏️ Sửa</a>
                        <a href="ProductServlet?action=delete&id=<%= p.getProductId() %>" class="action-btn delete-btn"
                           onclick="return confirm('Xóa sản phẩm này?');">🗑️ Xóa</a>
                    </div>
                </td>
                <% }} else { %>
                <tr><td colspan="10" class="no-data">Không có sản phẩm ô tô.</td></tr>
                <% } %>
            </table>
        </div>

        <script>
            function showTable() {
                const selected = document.getElementById('categorySelect').value;
                document.getElementById('lifeTable').style.display = 'none';
                document.getElementById('healthTable').style.display = 'none';
                document.getElementById('carTable').style.display = 'none';
                if (selected === 'life')
                    document.getElementById('lifeTable').style.display = 'table';
                if (selected === 'health')
                    document.getElementById('healthTable').style.display = 'table';
                if (selected === 'car')
                    document.getElementById('carTable').style.display = 'table';
            }
            // Mặc định hiển thị bảng đầu tiên
            showTable();
        </script>
    </body>
</html>




