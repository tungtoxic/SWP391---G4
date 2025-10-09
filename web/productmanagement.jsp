<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Product" %>
<%@ page import="dao.ProductDao" %>
<%@ page import="dao.ProductCategoryDao" %>
<%@ page import="entity.ProductCategory" %>

<%
    ProductDao productDao = new ProductDao();
    ProductCategoryDao categoryDao = new ProductCategoryDao();
    List<ProductCategory> categoryList = categoryDao.getAllCategories();

    // Lấy categoryId được chọn (lọc sản phẩm)
    String categoryIdParam = request.getParameter("categoryId");
    Integer categoryId = null;
    if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
        categoryId = Integer.parseInt(categoryIdParam);
    }

    List<Product> productList = (categoryId != null)
        ? productDao.getProductsByCategory(categoryId)
        : productDao.getAllProducts();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Quản lý sản phẩm bảo hiểm</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 95%;
            margin: 30px auto;
            background: white;
            padding: 20px 40px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .add-btn {
            text-decoration: none;
            background-color: #2ecc71;
            color: white;
            padding: 10px 15px;
            border-radius: 5px;
            font-weight: bold;
        }
        .add-btn:hover {
            background-color: #27ae60;
        }
        select {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        table th, table td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }
        table th {
            background-color: #3498db;
            color: white;
        }
        .action-btn {
            padding: 7px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            color: white;
            font-weight: bold;
            text-decoration: none;
        }
        .edit-btn {
            background-color: #f39c12;
        }
        .edit-btn:hover {
            background-color: #e67e22;
        }
        .delete-btn {
            background-color: #e74c3c;
        }
        .delete-btn:hover {
            background-color: #c0392b;
        }
        .no-data {
            text-align: center;
            color: #999;
            font-style: italic;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="top-bar">
        <h2>📋 Danh sách sản phẩm bảo hiểm</h2>
        <div>
            <form method="get" action="productmanagement.jsp" style="display:inline;">
                <label for="categoryId">Lọc theo danh mục: </label>
                <select name="categoryId" id="categoryId" onchange="this.form.submit()">
                    <option value="">-- Tất cả --</option>
                    <% for (ProductCategory c : categoryList) { %>
                        <option value="<%= c.getCategoryId() %>"
                            <%= (categoryId != null && categoryId == c.getCategoryId()) ? "selected" : "" %>>
                            <%= c.getCategoryName() %>
                        </option>
                    <% } %>
                </select>
            </form>

            <a href="addProduct.jsp" class="add-btn">➕ Thêm sản phẩm</a>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Tên sản phẩm</th>
                <th>Mô tả</th>
                <th>Giá cơ bản</th>
                <th>Danh mục</th>
                <th>Ngày tạo</th>
                <th>Cập nhật</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
        <% 
            if (productList != null && !productList.isEmpty()) {
                for (Product p : productList) {
                    String categoryName = "";
                    for (ProductCategory c : categoryList) {
                        if (c.getCategoryId() == p.getCategoryId()) {
                            categoryName = c.getCategoryName();
                            break;
                        }
                    }
        %>
            <tr>
                <td><%= p.getProductId() %></td>
                <td><%= p.getProductName() %></td>
                <td><%= p.getDescription() %></td>
                <td><%= String.format("%,.0f VNĐ", p.getBasePrice()) %></td>
                <td><%= categoryName %></td>
                <td><%= p.getCreatedAt() %></td>
                <td><%= p.getUpdatedAt() %></td>
                <td>
                    <a href="editproduct.jsp?id=<%= p.getProductId() %>" class="action-btn edit-btn">Sửa</a>
                    <a href="ProductServlet?action=delete&id=<%= p.getProductId() %>"
                       class="action-btn delete-btn"
                       onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này không?');">
                        Xóa
                    </a>
                </td>
            </tr>
        <% 
                }
            } else { 
        %>
            <tr>
                <td colspan="8" class="no-data">Không có sản phẩm nào thuộc danh mục này.</td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>

</body>
</html>
