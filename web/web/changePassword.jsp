<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đổi mật khẩu</title>

    <style>
        body {
            margin: 0;
            height: 100vh;
            font-family: "Poppins", sans-serif;
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            animation: fadeIn 1s ease-in-out;
        }

        .container {
            background: rgba(255, 255, 255, 0.1);
            padding: 50px 60px;
            border-radius: 20px;
            box-shadow: 0 4px 25px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px);
            max-width: 500px;
            width: 100%;
            text-align: center;
        }

        .container h1 {
            font-size: 26px;
            margin-bottom: 25px;
            font-weight: 600;
            color: #fff;
        }

        form {
            text-align: left;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-size: 14px;
            margin-bottom: 6px;
            color: #e0e0e0;
        }

        input {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.85);
            font-size: 14px;
            outline: none;
            color: #333;
        }

        input:focus {
            box-shadow: 0 0 10px rgba(255,255,255,0.4);
        }

        .btn {
            display: inline-block;
            padding: 12px 30px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: 0.3s;
            color: #fff;
            font-size: 15px;
        }

        .btn-confirm {
            background: #43e97b;
            width: 100%;
            margin-top: 10px;
        }

        .btn-confirm:hover {
            background: #38d16a;
            transform: translateY(-2px);
        }

        .btn-back {
            background: #ff6a00;
            margin-top: 15px;
        }

        .btn-back:hover {
            background: #e65c00;
            transform: translateY(-2px);
        }

        .alert {
            margin-top: 20px;
            padding: 12px;
            border-radius: 8px;
            font-weight: 500;
        }

        .success {
            background: rgba(67, 233, 123, 0.2);
            border: 1px solid #43e97b;
        }

        .error {
            background: rgba(255, 106, 0, 0.2);
            border: 1px solid #ff6a00;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Đổi mật khẩu</h1>

    <form action="ChangePassword" method="post">
        <div class="form-group">
            <label>Mật khẩu cũ</label>
            <input type="password" name="oldPassword" placeholder="Nhập mật khẩu cũ" required>
        </div>

        <div class="form-group">
            <label>Mật khẩu mới</label>
            <input type="password" name="newPassword" placeholder="Nhập mật khẩu mới" required>
        </div>

        <div class="form-group">
            <label>Xác nhận mật khẩu mới</label>
            <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
        </div>

        <button type="submit" class="btn btn-confirm">Đổi mật khẩu</button>
    </form>

    <c:if test="${not empty message}">
        <div class="alert success">${message}</div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert error">${error}</div>
    </c:if>

    <a href="profile.jsp" class="btn btn-back">← Quay lại Profile</a>
</div>

</body>
</html>
