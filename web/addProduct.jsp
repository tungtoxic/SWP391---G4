<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ProductCategoryDao, entity.ProductCategory, java.util.List" %>
<%
    // Lấy danh sách danh mục từ DB
    ProductCategoryDao categoryDao = new ProductCategoryDao();
    List<ProductCategory> categories = categoryDao.getAllCategories();

    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>➕ Thêm sản phẩm mới</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f6f8;
                margin: 0;
                padding: 0;
            }

            .container {
                width: 500px;
                margin: 60px auto;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
            }

            h2 {
                text-align: center;
                color: #333;
            }

            form {
                display: flex;
                flex-direction: column;
            }

            label {
                margin: 8px 0 5px;
                font-weight: bold;
            }

            input, textarea, select {
                padding: 10px;
                border-radius: 5px;
                border: 1px solid #ccc;
            }

            textarea {
                resize: none;
            }

            .btn-container {
                text-align: center;
                margin-top: 20px;
            }

            .btn-container input {
                padding: 10px 20px;
                border: none;
                background-color: #27ae60;
                color: white;
                font-weight: bold;
                border-radius: 5px;
                cursor: pointer;
            }

            .btn-container input:hover {
                background-color: #1e8449;
            }

            .error {
                color: red;
                text-align: center;
                margin-bottom: 10px;
            }

            .success {
                color: green;
                text-align: center;
                margin-bottom: 10px;
            }

            a.back {
                display: block;
                text-align: center;
                margin-top: 15px;
                color: #3498db;
                text-decoration: none;
            }

            a.back:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <h2>➕ Thêm sản phẩm bảo hiểm</h2>

            <% if (error != null) { %>
                <p class="error"><%= error %></p>
            <% } else if (message != null) { %>
                <p class="success"><%= message %></p>
            <% } %>

            <form action="ProductServlet" method="post">
                <input type="hidden" name="action" value="add">

                <label>Tên sản phẩm:</label>
                <input type="text" name="product_name" placeholder="Nhập tên sản phẩm" required>

                <label>Mô tả:</label>
                <textarea name="description" rows="4" placeholder="Mô tả chi tiết sản phẩm"></textarea>

                <label>Giá cơ bản:</label>
                <input type="number" step="0.01" name="base_price" placeholder="Nhập giá sản phẩm" required>

                <label>Danh mục:</label>
                <select name="category_id" required>
                    <option value="">-- Chọn danh mục --</option>
                    <% for (ProductCategory c : categories) { %>
                        <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                    <% } %>
                </select>

                <div class="btn-container">
                    <input type="submit" value="💾 Thêm sản phẩm">
                </div>
            </form>

            <a href="ProductServlet?action=list" class="back">⬅ Quay lại danh sách sản phẩm</a>
        </div>

    </body>
</html>
