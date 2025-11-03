tao <%-- 
    Document   : addCategoryProduct
    Created on : Oct 10, 2025, 3:23:55 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %> <!DOCTYPE html> <html> <head> <meta charset="UTF-8"> <title>Chọn loại sản phẩm</title> <style> body {
                font-family: Arial, sans-serif;
                background-color: #f4f6f8;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }
            .container {
                background: white;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                width: 400px;
                text-align: center;
            }
            h2 {
                margin-bottom: 20px;
            }
            select, button {
                padding: 10px;
                width: 100%;
                margin-top: 10px;
                border-radius: 5px;
                border: 1px solid #ccc;
            }
            button {
                background-color: #3498db;
                color: white;
                border: none;
                cursor: pointer;
                font-weight: bold;
            }
            button:hover {
                background-color: #2980b9;
            } </style>
    </head> <body>
        <div class="container">
            <h2>🛡️ Chọn loại sản phẩm bảo hiểm</h2> 
            <form action="ProductServlet" method="post"> 
                <input type="hidden" name="action" value="addChosenCategory"> 
                <select name="category" required> 
                    <option value="">-- Chọn loại sản phẩm --</option> 
                    <option value="life">Bảo hiểm nhân thọ</option> 
                    <option value="health">Bảo hiểm sức khỏe</option> 
                    <option value="car">Bảo hiểm ô tô</option> </select> 
                <button type="submit">Thêm sản phẩm ➜</button> 
            </form> 
        </div> 
    </body> 
</html>



