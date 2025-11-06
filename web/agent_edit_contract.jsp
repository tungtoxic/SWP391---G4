<%-- 
    Document   : agent_edit_contract 
    Created on : Oct 22, 2025, 3:42:13 AM
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.*, java.text.DecimalFormat" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser"); 
    String activePage = (String) request.getAttribute("activePage");
    ContractDTO contract = (ContractDTO) request.getAttribute("contract");
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
    List<Product> productList = (List<Product>) request.getAttribute("productList");
    
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (contract == null) {
         response.sendRedirect(ctx + "/agent/contracts?message=AuthError");
         return;
    }
    if (customerList == null) customerList = new ArrayList<>();
    if (productList == null) productList = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chỉnh Sửa Hợp đồng #<%= contract.getContractId() %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
    <style>
        .rule-display { font-size: 1.25rem; font-weight: bold; }
        .rule-label { font-size: 0.9rem; color: #6c757d; }
        .rule-box { background-color: #f8f9fa; padding: 1rem; border-radius: 0.25rem; }
    </style>
</head>
<body>
    <%@ include file="agent_navbar.jsp" %>
    <%@ include file="agent_sidebar.jsp" %>
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Chỉnh Sửa Hợp đồng #<%= contract.getContractId() %></h1>

            <div class="card">
                <div class="card-body">
                    <form action="<%= ctx %>/agent/contracts" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="contractId" value="<%= contract.getContractId() %>">
                        
                        <div class="mb-3">
                            <label for="customerId" class="form-label">1. Chọn Khách hàng</label>
                            <select class="form-select" id="customerId" name="customerId" required>
                                <% if (customerList != null) {  
                                    for (Customer c : customerList) { %>
                                        <option value="<%= c.getCustomerId() %>" <%= c.getCustomerId() == contract.getCustomerId() ? "selected" : "" %>>
                                            <%= c.getFullName() %>
                                        </option>
                                <% } } %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="productId" class="form-label">2. Chọn Sản phẩm ("Cái khuôn")</label>
                            <%-- ========================================================== --%>
                            <%-- BƯỚC 3.1: THÊM "onchange" VÀ "data-" ATTRIBUTES (LUẬT) --%>
                            <%-- ========================================================== --%>
                            <select class="form-select" id="productId" name="productId" required
                                    onchange="updateProductRules()">
                                <% if (productList != null) {  
                                    for (Product p : productList) { %>
                                        <option value="<%= p.getProductId() %>" 
                                                data-price="<%= p.getBasePrice() %>" 
                                                data-duration="<%= p.getDurationMonths() %>"
                                                <%= p.getProductId() == contract.getProductId() ? "selected" : "" %>>
                                            <%= p.getProductName() %>
                                        </option>
                                <% } } %>
                            </select>
                        </div>
                        
                        <%-- ========================================================== --%>
                        <%-- BƯỚC 3.2: "KHÓA" INPUT VÀ HIỂN THỊ "LUẬT" --%>
                        <%-- ========================================================== --%>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="startDate" class="form-label">3. Chọn Ngày bắt đầu hiệu lực</label>
                                <input type="date" class="form-control" id="startDate" name="startDate" value="<%= contract.getStartDate() %>" required>
                            </div>

                            <%-- XÓA BỎ INPUT NHẬP TAY (premiumAmount) --%>
                            
                            <%-- THAY THẾ BẰNG 2 BOX HIỂN THỊ "LUẬT" (CHỈ ĐỌC) --%>
                            <div class="col-md-6 mb-3">
                                <div class="rule-box h-100">
                                    <span class="rule-label">PHÍ BẢO HIỂM (TỰ ĐỘNG)</span>
                                    <div id="product-price-display" class="rule-display text-success">
                                        <%-- Sẽ được JS auto-fill --%>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="rule-box">
                                <span class="rule-label">THỜI HẠN HỢP ĐỒNG (TỰ ĐỘNG)</span>
                                <div id="product-duration-display" class="rule-display text-primary">
                                    <%-- Sẽ được JS auto-fill --%>
                                </div>
                            </div>
                        </div>

                        
                        <button type="submit" class="btn btn-primary">Cập Nhật Hợp đồng</button>
                        <a href="<%= ctx %>/agent/contracts" class="btn btn-secondary">Hủy</a>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <%-- ========================================================== --%>
    <%-- BƯỚC 3.3: THÊM JAVASCRIPT "AUTO-FILL" (VỚI DOMContentLoaded) --%>
    <%-- ========================================================== --%>
    <script>
        // Hàm format tiền tệ
        const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

        function updateProductRules() {
            const select = document.getElementById('productId');
            const selectedOption = select.options[select.selectedIndex];
            
            const priceDisplay = document.getElementById('product-price-display');
            const durationDisplay = document.getElementById('product-duration-display');

            if (select.value === "") {
                priceDisplay.innerHTML = "-- Vui lòng chọn sản phẩm --";
                durationDisplay.innerHTML = "-- Vui lòng chọn sản phẩm --";
                priceDisplay.classList.remove('text-success');
                durationDisplay.classList.remove('text-primary');
            } else {
                const price = selectedOption.getAttribute('data-price');
                const duration = selectedOption.getAttribute('data-duration');
                
                priceDisplay.innerHTML = formatter.format(price);
                durationDisplay.innerHTML = duration + " tháng";
                
                priceDisplay.classList.add('text-success');
                durationDisplay.classList.add('text-primary');
            }
        }

        // === NÂNG CẤP CHO TRANG EDIT ===
        // Chạy hàm này ngay khi trang tải xong để hiển thị "luật" của sản phẩm đã chọn
        document.addEventListener('DOMContentLoaded', updateProductRules);
    </dcript>
</body>
</html>