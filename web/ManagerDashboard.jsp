<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Manager Dashboard</title>
        <style>
            /* Reset */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: "Segoe UI", Arial, sans-serif;
                background-color: #f4f6f8;
                color: #333;
            }

            /* Layout chính */
            .container {
                display: flex;
                min-height: 100vh;
            }

            /* Thanh menu bên trái */
            .navbar {
                width: 20%;
                background-color: #2c3e50;
                color: #ecf0f1;
                padding: 30px 20px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .navbar h2 {
                font-size: 22px;
                margin-bottom: 30px;
                text-align: center;
            }

            .nav-links {
                display: flex;
                flex-direction: column;
            }

            .nav-links a {
                display: block;
                color: #ecf0f1;
                text-decoration: none;
                margin: 10px 0;
                padding: 10px 15px;
                border-radius: 8px;
                transition: background 0.2s;
            }

            .nav-links a:hover {
                background-color: #34495e;
                color: #f1c40f;
            }

            .logout {
                text-align: center;
                margin-top: 40px;
            }

            .logout a {
                color: #e74c3c;
                text-decoration: none;
                font-weight: bold;
            }

            .logout a:hover {
                color: #ff6b6b;
            }

            /* Khu vực nội dung */
            .content {
                width: 80%;
                padding: 40px;
                background-color: #fff;
            }

            .content h1 {
                font-size: 26px;
                color: #2c3e50;
                margin-bottom: 20px;
            }

            .content p {
                font-size: 16px;
                color: #555;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <!-- Navbar -->
            <div class="navbar">
                <div>
                    <a href="<%= request.getContextPath() %>/profile.jsp" class="profile-btn">👤 Profile</a>
                    <h2>Manager Panel</h2>
                    <div class="nav-links">
                        <a href="dashboard.jsp">🏠 Trang chủ</a>
                        <a href="CustomerServlet">👥 Khách hàng</a>
                        <a href="ProductServlet?action=list">📦 Sản phẩm</a>
                        <a href="ContractServlet">📝 Hợp đồng</a>
                        <a href="AgentManagementServlet?action=">Agent</a>
                    </div>
                </div>

                <div class="logout">
                    <a href="LogoutServlet">🚪 Đăng xuất</a>
                </div>
            </div>

            <!-- Content -->
            <div class="content">
                <h1>Chào mừng, Manager!</h1>
                <p>Hãy chọn một chức năng từ menu bên trái để bắt đầu quản lý hệ thống bảo hiểm.</p>
            </div>
        </div>

    </body>
</html>
