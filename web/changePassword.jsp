<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            width: 100%;
            max-width: 400px;
            padding: 20px;
        }

        .form-box {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0,0,0,0.1);
            text-align: center;
        }

        .form-box h2 {
            margin-bottom: 20px;
            color: #333;
        }

        .form-box input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .form-box .btn {
            width: 100%;
            padding: 10px;
            background: #28a745;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .form-box .btn:hover {
            background: #218838;
        }

        .success {
            color: green;
            margin-top: 10px;
        }

        .error {
            color: red;
            margin-top: 10px;
        }

        .section-title {
            margin-top: 20px;
            margin-bottom: 10px;
            font-weight: bold;
            color: #555;
            text-align: left;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="form-box">

        <!-- ======================== Phần 1: Header / Title ======================== -->
        <h2>Đổi mật khẩu</h2>

        <!-- ======================== Phần 2: Form đổi mật khẩu ======================== -->
        <form action="ChangePasswordServlet" method="post">
            <!-- Mật khẩu cũ -->
            <div class="section-title">Mật khẩu cũ</div>
            <input type="password" name="oldPassword" placeholder="Nhập mật khẩu cũ" required>

            <!-- Mật khẩu mới -->
            <div class="section-title">Mật khẩu mới</div>
            <input type="password" name="newPassword" placeholder="Nhập mật khẩu mới" required>

            <!-- Nhập lại mật khẩu mới -->
            <div class="section-title">Xác nhận mật khẩu mới</div>
            <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>

            <button type="submit" class="btn">Đổi mật khẩu</button>
        </form>

        <!-- ======================== Phần 3: Thông báo lỗi / thành công ======================== -->
        <c:if test="${not empty message}">
            <div class="success">${message}</div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <!-- ======================== Phần 4: Link điều hướng ======================== -->
        <p class="redirect-text">
            <a href="profile.jsp">Quay lại Profile</a>
        </p>

    </div>
</div>

</body>
</html>
