<%-- 
    Document   : AgentDashboard
    Created on : Oct 6, 2025, 4:49:19 PM
    Author     : Nguyễn Tùng
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Agent Dashboard</title>
        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
            }

            /* Layout chính */
            .container {
                display: flex;
                min-height: 100vh;
            }

            /* Navbar (4 cột ~ 33.33%) */
            .navbar {
                width: 20%;
                background-color: #2c3e50;
                color: #ecf0f1;
                padding: 20px;
                box-sizing: border-box;
            }

            .navbar h2 {
                margin-bottom: 20px;
            }

            .navbar a {
                display: block;
                color: #ecf0f1;
                text-decoration: none; /* ❌ bỏ gạch chân */
                margin: 10px 0;
                font-weight: bold;
            }

            .navbar a:hover {
                color: #f39c12;
            }

            /* Content (8 cột ~ 66.66%) */
            .content {
                width: 8%;
                padding: 20px;
                box-sizing: border-box;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <!-- Navbar -->
            <div class="navbar">
                <h2>Agent Dashboard</h2>
                
            </div>

            <!-- Content-->
            <div class="content">
                <h2>Welcome, Agent</h2>
                <p>Chọn chức năng ở thanh menu bên trái.</p>
            </div>
        </div>

    </body>
</html>