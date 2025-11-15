<%-- 
    Document   : agent_add_contract 
    Created on : Oct 22, 2025, 2:41:46 AM
    Author     : Nguyễn Tùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.*, java.text.DecimalFormat" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser"); // Lấy từ Servlet
    String activePage = (String) request.getAttribute("activePage");
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    
    // Format tiền tệ cho JavaScript
    DecimalFormat jsFormatter = new DecimalFormat("#,##0");

    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (customerList == null) customerList = new ArrayList<>();
    if (productList == null) productList = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Tạo Hợp đồng mới</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
    <style>
        /* CSS để làm nổi bật "luật" được auto-fill */
        .rule-display {
            font-size: 1.25rem;
            font-weight: bold;
            color: #28a745; /* Màu xanh lá */
        }
        .rule-label {
            font-size: 0.9rem;
            color: #6c757d;
        }
        .rule-box {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 0.25rem;
        }
    </style>
</head>
<body>
    <%@ include file="agent_navbar.jsp" %>
    <%@ include file="agent_sidebar.jsp" %>
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Tạo Hợp đồng mới</h1>

            <div class="card">
                <div class="card-body">
                    <form action="<%= ctx %>/agent/contracts" method="post">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label for="customerId" class="form-label">1. Chọn Khách hàng</label>
                            <select class="form-select" id="customerId" name="customerId" required>
                                <option value="">-- Chọn khách hàng --</option>
                                <% if (customerList != null) {  
                                    for (Customer c : customerList) { %>
                                        <option value="<%= c.getCustomerId() %>"><%= c.getFullName() %></option>
                                <% } } %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="productId" class="form-label">2. Chọn Sản phẩm </label>
                            <%-- ========================================================== --%>
                            <%-- BƯỚC 2.1: THÊM "onchange" VÀ "data-" ATTRIBUTES (LUẬT) --%>
                            <%-- ========================================================== --%>
                            <select class="form-select" id="productId" name="productId" required 
                                    onchange="updateProductRules()">
                                <option value="">-- Chọn sản phẩm --</option>
                                <% if (productList != null) {  
                                    for (Product p : productList) { %>
                                        <option value="<%= p.getProductId() %>" 
                                                data-price="<%= p.getBasePrice() %>" 
                                                data-duration="<%= p.getDurationMonths() %>">
                                            <%= p.getProductName() %>
                                        </option>
                                <% } } %>
                            </select>
                        </div>
                        
                        <%-- ========================================================== --%>
                        <%-- BƯỚC 2.2: "KHÓA" INPUT VÀ HIỂN THỊ "LUẬT" --%>
                        <%-- ========================================================== --%>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="startDate" class="form-label">3. Chọn Ngày bắt đầu hiệu lực</label>
                                <input type="date" class="form-control" id="startDate" name="startDate" value="<%= java.time.LocalDate.now().toString() %>" required>
                            </div>

                            <%-- XÓA BỎ INPUT NHẬP TAY (premiumAmount) --%>
                            
                            <%-- THAY THẾ BẰNG 2 BOX HIỂN THỊ "LUẬT" (CHỈ ĐỌC) --%>
                            <div class="col-md-6 mb-3">
                                <div class="rule-box h-100">
                                    <span class="rule-label">PHÍ BẢO HIỂM </span>
                                    <div id="product-price-display" class="rule-display text-success">
                                        -- Vui lòng chọn sản phẩm --
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="rule-box">
                                <span class="rule-label">THỜI HẠN HỢP ĐỒNG </span>
                                <div id="product-duration-display" class="rule-display text-primary">
                                    -- Vui lòng chọn sản phẩm --
                                </div>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">Tạo Hợp đồng</button>
                        <a href="<%= ctx %>/agent/contracts" class="btn btn-secondary">Hủy</a>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <%-- ========================================================== --%>
    <%-- BƯỚC 2.3: THÊM JAVASCRIPT "AUTO-FILL" --%>
    <%-- ========================================================== --%>
    <script>
        // Hàm format tiền tệ (ví dụ: 10,000,000 VNĐ)
        const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

        function updateProductRules() {
            const select = document.getElementById('productId');
            const selectedOption = select.options[select.selectedIndex];
            
            const priceDisplay = document.getElementById('product-price-display');
            const durationDisplay = document.getElementById('product-duration-display');

            if (select.value === "") {
                // Nếu không chọn gì, reset
                priceDisplay.innerHTML = "-- Vui lòng chọn sản phẩm --";
                durationDisplay.innerHTML = "-- Vui lòng chọn sản phẩm --";
                priceDisplay.classList.remove('text-success');
                durationDisplay.classList.remove('text-primary');
            } else {
                // Lấy "luật" từ data- attributes
                const price = selectedOption.getAttribute('data-price');
                const duration = selectedOption.getAttribute('data-duration');
                
                // Hiển thị "luật"
                priceDisplay.innerHTML = formatter.format(price);
                durationDisplay.innerHTML = duration + " tháng";
                
                priceDisplay.classList.add('text-success');
                durationDisplay.classList.add('text-primary');
            }
        }
    </script>
</body>
</html>