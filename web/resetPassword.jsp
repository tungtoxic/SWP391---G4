<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Reset Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 350px;
        }
        input[type="text"], input[type="password"], input[type="email"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .hidden {
            display: none;
        }
    </style>
    <script>
        function verifyOTP() {
            const otp = document.getElementById("otp").value;
            // Giả sử mã xác nhận là 123456, ở thực tế bạn sẽ kiểm tra với server
            if(otp === "123456") {
                document.getElementById("newPasswordSection").classList.remove("hidden");
                alert("Mã xác nhận đúng! Vui lòng nhập mật khẩu mới.");
            } else {
                alert("Mã xác nhận không đúng!");
            }
        }
    </script>
</head>
<body>
<div class="container">
    <h2>Reset Password</h2>
    <form action="ResetPasswordServlet" method="post">
        <input type="email" name="email" placeholder="Email" required>

        <input type="text" name="otp" id="otp" placeholder="Mã xác nhận" required>
        <button type="button" onclick="verifyOTP()">Xác nhận mã</button>

        <div id="newPasswordSection" class="hidden">
            <input type="password" name="newPassword" placeholder="Mật khẩu mới" required>
            <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" required>
            <button type="submit">Đổi mật khẩu</button>
        </div>
    </form>
</div>
</body>
</html>

