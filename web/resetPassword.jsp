<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Reset Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f6f7fb;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .card {
            width: 380px;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .btn-primary {
            background-color: #007bff;
            border: none;
            width: 100%;
        }
        .btn-primary:hover {
            background-color: #0069d9;
        }
        .form-control {
            margin-bottom: 15px;
            height: 45px;
        }
        h3 {
            text-align: center;
            font-weight: 600;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="card">
    <h3>Reset mật khẩu</h3>

    <div id="stepEmail">
        <input type="email" id="email" class="form-control" placeholder="Nhập email của bạn">
        <button class="btn btn-primary" onclick="sendOTP()">Gửi OTP</button>
    </div>

    <div id="stepOTP" style="display:none;">
        <input type="text" id="otp" class="form-control" placeholder="Nhập mã OTP">
        <button class="btn btn-primary" onclick="verifyOTP()">Xác nhận OTP</button>
    </div>

    <div id="stepNewPass" style="display:none;">
        <input type="password" id="newPass" class="form-control" placeholder="Mật khẩu mới">
        <input type="password" id="confirmPass" class="form-control" placeholder="Xác nhận mật khẩu mới">
        <button class="btn btn-primary" onclick="confirmPassword()">Xác nhận mật khẩu</button>
    </div>
</div>

<script>
    function sendOTP() {
        const email = document.getElementById("email").value.trim();
        if (email === "") {
            alert("Vui lòng nhập email!");
            return;
        }

        // TODO: Gọi servlet gửi OTP ở đây
        // fetch('/sendOTP', { method: 'POST', body: JSON.stringify({email}) })

        alert("Đã gửi mã OTP đến email " + email);
        document.getElementById("stepEmail").style.display = "none";
        document.getElementById("stepOTP").style.display = "block";
    }

    function verifyOTP() {
        const otp = document.getElementById("otp").value.trim();
        if (otp === "") {
            alert("Vui lòng nhập mã OTP!");
            return;
        }

        // TODO: Gọi servlet xác thực OTP
        // fetch('/verifyOTP', { method: 'POST', body: JSON.stringify({otp}) })

        alert("Mã OTP chính xác!");
        document.getElementById("stepOTP").style.display = "none";
        document.getElementById("stepNewPass").style.display = "block";
    }

    function confirmPassword() {
        const pass1 = document.getElementById("newPass").value;
        const pass2 = document.getElementById("confirmPass").value;

        if (pass1 === "" || pass2 === "") {
            alert("Vui lòng nhập đầy đủ mật khẩu!");
            return;
        }
        if (pass1 !== pass2) {
            alert("Mật khẩu không khớp!");
            return;
        }

        // TODO: Gửi mật khẩu mới đến server để cập nhật
        // fetch('/resetPassword', { method: 'POST', body: JSON.stringify({password: pass1}) })

        alert("Đặt lại mật khẩu thành công!");
        window.location.href = "login.jsp";
    }
</script>
</body>
</html>
