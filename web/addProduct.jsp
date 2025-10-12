<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ProductCategoryDao, entity.ProductCategory, java.util.List" %>
<%
    // Lấy danh sách danh mục từ DB
    ProductCategoryDao categoryDao = new ProductCategoryDao();
    List<ProductCategory> categories = categoryDao.getAllCategories();

    String selectedCategory = (String) request.getAttribute("selectedCategory");
    if (selectedCategory == null) selectedCategory = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>🛡️ Thêm sản phẩm mới</title>
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

        input[type="text"], input[type="number"], textarea, select {
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
    </style>
</head>
<body>
    <div class="container">
        <h2>🛡️ Thêm sản phẩm mới</h2>

        <form action="ProductServlet" method="post">
            <input type="hidden" name="action" value="add">

            <label>Tên sản phẩm:</label>
            <input type="text" name="product_name" placeholder="Nhập tên sản phẩm..." required>

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

            <button type="submit">💾 Thêm sản phẩm</button>
        </form>

        <a href="ProductServlet?action=list" class="back-link">← Quay lại danh sách sản phẩm</a>
    </div>
</body>
</html>
