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
            <div class="countdown">
                <div>
                    <p class="countdown-text">Mã OTP sẽ hết hạn trong vòng <span class="countdown-item">5:00</span> phút</p>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const otpInput = document.getElementById('otp');
                const resendBtn = document.getElementById("resendBtn");
                const resendMsg = document.getElementById("resendMsg");
                const itemCountDown = document.querySelector('.countdown-item');

                // ✅ Chỉ cho phép nhập số
                otpInput.addEventListener('input', () => {
                    otpInput.value = otpInput.value.replace(/[^0-9]/g, '');
                });

                let countdownInterval; // Lưu interval để dừng khi reset

                // ✅ Hàm bắt đầu đếm ngược
                function startCountdown() {
                    clearInterval(countdownInterval); // Dừng đếm cũ nếu có

                    let time = 5 * 60; // 5 phút = 300 giây

                    countdownInterval = setInterval(function () {
                        const phut = Math.floor(time / 60);
                        const giay = time % 60;

                        // Hiển thị mm:ss, thêm 0 khi <10
                        itemCountDown.innerHTML = phut + ":" + (giay < 10 ? "0" + giay : giay);

                        if (time <= 0) {
                            clearInterval(countdownInterval);
                            itemCountDown.innerHTML = "Hết hạn!";
                            itemCountDown.style.color = "red";
                            resendBtn.disabled = false; // Cho phép gửi lại OTP
                        }

                        time--;
                    }, 1000);
                }

                // ✅ Bắt đầu đếm khi load trang
                startCountdown();

                // ✅ Khi bấm Gửi lại OTP
                resendBtn.addEventListener("click", async () => {
                    resendBtn.disabled = true;
                    resendMsg.textContent = "⏳ Đang gửi lại OTP...";
                    itemCountDown.style.color = "#333";

                    try {
                        // Giả lập gọi API
                        const response = await fetch("resendOtp", {method: "POST"});
                        let data;
                        try {
                            data = await response.json();
                        } catch {
                            data = {status: "success", message: "✅ Đã gửi lại OTP mới!"};
                        }

                        if (data.status === "success") {
                            resendMsg.textContent = data.message;

                            // 🔁 Reset countdown về 5:00
                            startCountdown();
                        } else {
                            resendMsg.textContent = data.message || "❌ Gửi lại OTP thất bại.";
                        }
                    } catch (error) {
                        resendMsg.textContent = "⚠️ Lỗi khi gửi lại OTP.";
                    }

                    // Cho phép gửi lại sau 2 giây để tránh spam
                    setTimeout(() => {
                        resendBtn.disabled = false;
                    }, 2000);
                });
            });
        </script>
    </body>
</html>


