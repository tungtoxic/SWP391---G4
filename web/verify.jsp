<%-- 
    Document   : verify
    Created on : Oct 3, 2025, 5:35:16 PM
    Author     : Helios 16
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>
<html>
<head>
    <title>Xác minh OTP</title>
    <link rel="stylesheet" href="css/verify.css">
</head>
<body>
<div class="verify-container">
    <h2>Xác minh OTP</h2>

    <% if (error != null) { %>
        <p class="error"><%= error %></p>
    <% } else if (message != null) { %>
        <p class="message"><%= message %></p>
    <% } %>

    <!-- Form xác minh OTP -->
    <form action="VerifyServlet" method="post" id="otpForm">
        <div class="otp-box">
            <label for="otp">Nhập mã OTP (6 số):</label><br>
            <input type="text" name="otp" id="otp" maxlength="6"
                   pattern="[0-9]{6}" required
                   placeholder="Nhập mã gồm 6 chữ số"
                   class="otp-input">
        </div>
        <input type="submit" value="Xác minh" class="btn-verify">
    </form>

    <!-- Nút gửi lại OTP -->
    <button id="resendBtn" class="btn-resend">Gửi lại OTP</button>
    <p id="resendMsg" class="message"></p>

    <!-- Countdown -->
    <div id="countdown" style="margin-top:15px;font-weight:bold;color:#333;">
        ⏳ Mã OTP hết hạn sau: <span id="timer">05:00</span>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const otpInput = document.getElementById('otp');
    const countdownDisplay = document.getElementById("timer");
    const resendBtn = document.getElementById("resendBtn");
    const resendMsg = document.getElementById("resendMsg");

    // ✅ Chỉ cho phép nhập số
    otpInput.addEventListener('input', () => {
        otpInput.value = otpInput.value.replace(/[^0-9]/g, '');
    });

    // ✅ Bộ đếm 5 phút (300 giây)
    let timeLeft = 300;
    let countdownInterval;

    function startCountdown() {
        clearInterval(countdownInterval);
        countdownInterval = setInterval(() => {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            countdownDisplay.textContent = `${minutes}:${seconds < 10 ? '0' + seconds : seconds}`;

            if (timeLeft <= 0) {
                clearInterval(countdownInterval);
                countdownDisplay.textContent = "Hết hạn!";
                document.getElementById("countdown").style.color = "red";
            }
            timeLeft--;
        }, 1000);
    }

    startCountdown();

    // ✅ Gửi lại OTP (demo fetch)
    resendBtn.addEventListener("click", async () => {
        resendBtn.disabled = true;
        resendMsg.textContent = "⏳ Đang gửi lại OTP...";

        try {
            // Giả lập gọi API (bạn thay 'resendOtp' bằng servlet thật)
            const response = await fetch("resendOtp", { method: "POST" });
            let data;
            try {
                data = await response.json();
            } catch {
                // Nếu server không trả JSON, tạo phản hồi giả
                data = { status: "success", message: "Đã gửi lại OTP mới!" };
            }

            if (data.status === "success") {
                resendMsg.textContent = data.message;
                timeLeft = 300;
                startCountdown();
            } else {
                resendMsg.textContent = data.message;
            }
        } catch (error) {
            resendMsg.textContent = "⚠️ Lỗi khi gửi lại OTP.";
        }

        resendBtn.disabled = false;
    });
});
</script>
</body>
</html>


