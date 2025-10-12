<%-- 
    Document   : addProduct
    Created on : Oct 9, 2025, 2:39:55 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (selectedCategory == null) selectedCategory = "";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thêm sản phẩm bảo hiểm</title>
        <style>
            body {
                font-family: "Segoe UI", Arial, sans-serif;
                background-color: #f5f7fa;
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: flex-start;
                min-height: 100vh;
            }

            .container {
                background: #fff;
                margin-top: 50px;
                padding: 40px 50px;
                border-radius: 15px;
                box-shadow: 0 5px 25px rgba(0, 0, 0, 0.1);
                width: 450px;
            }

            h2 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 25px;
            }

            form {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            label {
                font-weight: 600;
                color: #34495e;
                margin-bottom: 5px;
            }

            input[type="text"],
            input[type="number"],
            textarea,
            select {
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 15px;
                transition: 0.2s;
            }

            input:focus, textarea:focus {
                border-color: #3498db;
                outline: none;
                box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
            }

            textarea {
                resize: none;
                height: 80px;
            }

            button {
                background-color: #3498db;
                color: white;
                font-weight: bold;
                padding: 12px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 16px;
                transition: 0.3s;
            }

            button:hover {
                background-color: #2980b9;
            }

            .back-link {
                display: block;
                text-align: center;
                margin-top: 20px;
                color: #555;
                text-decoration: none;
                font-size: 14px;
            }

            .back-link:hover {
                color: #3498db;
            }

            .category-tag {
                display: inline-block;
                background-color: #ecf0f1;
                color: #2c3e50;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 14px;
                font-weight: bold;
                margin-top: -10px;
                margin-bottom: 15px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>🛡️ Thêm sản phẩm mới</h2>
            <div class="category-tag">
                <%
                String categoryLabel;
                switch (selectedCategory) {
                    case "life":
                        categoryLabel = "💖 Bảo hiểm nhân thọ";
                        break;
                    case "health":
                        categoryLabel = "🏥 Bảo hiểm sức khỏe";
                        break;
                    case "car":
                        categoryLabel = "🚗 Bảo hiểm ô tô";
                        break;
                    default:
                        categoryLabel = "Không xác định";
                        break;
                }
                %>

                <h2><%= categoryLabel %></h2>
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
                <input type="text" name="maturity_benefit" placeholder="Ví dụ: 	Nhận toàn bộ giá trị hợp đồng khi đáo hạn">              
                <% } else if ("health".equals(selectedCategory)) { %>
                <label>Giới hạn nằm viện:</label>
                <input type="number" name="hospital_limit" placeholder="Ví dụ: 10000000">

                <label>Giới hạn phẫu thuật:</label>
                <input type="number" name="surgery_limit" placeholder="Ví dụ: 10000000">
                
                <label>Giới hạn sinh đẻ:</label>
                <input type="number" name="maternity_limit" placeholder="Ví dụ: 10000000">
                
                <label>Độ tuổi lớn nhất:</label>
                <input type="number" name="max_age" placeholder="Ví dụ: 10000000">
                
                <label>Giới hạn nhỏ nhất:</label>
                <input type="number" name="min_age" placeholder="Ví dụ: 10000000">
                
                <label>Thời gian chờ (ngày):</label>
                <input type="number" name="waiting_period" placeholder="Ví dụ: 30">
                <% } else if ("car".equals(selectedCategory)) { %>           
                <label>Loại xe:</label>
                <input type="text" name="vehicle_type" placeholder="Ví dụ: Sedan, SUV...">

                <label>Giá trị xe (VNĐ):</label>
                <input type="number" name="vehicle_value" placeholder="Ví dụ: 800000000">
                
                <label>Kiểu bảo hiểm:</label>
                <input type="text" name="coverage_type" placeholder="Ví dụ: 800000000">
                <% } %>

                <button type="submit">💾 Thêm sản phẩm</button>
            </form>

            <a href="ProductServlet" class="back-link">← Quay lại danh sách sản phẩm</a>
        </div>
    </body>
</html>



