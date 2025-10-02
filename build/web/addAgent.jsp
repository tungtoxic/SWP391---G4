<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Thêm Agent</title>
</head>
<body>
  <h1>Thêm Agent mới</h1>

  <!-- Hiển thị thông báo -->
  <%
      String msg = (String) request.getAttribute("message");
      String error = (String) request.getAttribute("error");
      if (msg != null) {
  %>
      <p style="color: green;"><%= msg %></p>
  <%
      } else if (error != null) {
  %>
      <p style="color: red;"><%= error %></p>
  <%
      }
  %>

  <!-- Form thêm agent -->
  <form action="addAgent" method="post">
    <label>Username: <input type="text" name="username" required></label><br>
    <label>Password: <input type="password" name="password" required></label><br>
    <label>Họ và tên: <input type="text" name="full_name" required></label><br>
    <label>Email: <input type="email" name="email" required></label><br>
    <label>Số điện thoại: <input type="text" name="phone_number"></label><br>
    <button type="submit">Thêm Agent</button>
  </form>

  <hr/>

  <h2>Danh sách Agents</h2>
  <!-- Chuyển đến servlet để xem danh sách -->
  <form action="viewAgents" method="get" style="margin-top:10px;">
    <button type="submit">Xem Agents</button>
  </form>
</body>
</html>
