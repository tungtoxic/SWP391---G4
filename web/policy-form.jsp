<%-- 
    Document   : policy-form
    Created on : Nov 4, 2025, 12:23:28 PM
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User, entity.CommissionPolicy" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser");
    String activePage = (String) request.getAttribute("activePage");
    
    // Dữ liệu từ Servlet (nếu có lỗi validation)
    String errorMessage = (String) request.getAttribute("errorMessage");

    // === LOGIC "THÔNG MINH" CỦA FORM ===
    // 1. Lấy policy từ request (chỉ tồn tại ở chế độ "Edit")
    CommissionPolicy policy = (CommissionPolicy) request.getAttribute("policy");
    
    // 2. Kiểm tra xem đang ở chế độ "Edit" hay "Add"
    boolean isEditMode = (policy != null);
    
    // 3. Đặt tiêu đề và action cho form
    String pageTitle = isEditMode ? "Chỉnh sửa Chính sách" : "Thêm Chính sách Mới";
    String formAction = isEditMode ? "update" : "add";
    
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title><%= pageTitle %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
</head>
<body>

    <%@ include file="manager_navbar.jsp" %>
    <%@ include file="manager_sidebar.jsp" %>

    <main class="main-content">
        <div class="container-fluid">

            <div class="row justify-content-center">
                <div class="col-lg-7">
                    
                    <div class="d-flex align-items-center mb-3">
                        <a href="<%=ctx%>/manager/policies" class="btn btn-outline-secondary me-3">
                            <i class="fa fa-arrow-left"></i> Quay lại
                        </a>
                        <h1 class="h3 mb-0"><%= pageTitle %></h1>
                    </div>

                    <%-- Hiển thị lỗi validation (nếu có) --%>
                    <% if (errorMessage != null) { %>
                        <div class="alert alert-danger"><%= errorMessage %></div>
                    <% } %>

                    <div class="card shadow-sm">
                        <div class="card-body p-4">
                            <form action="<%= ctx %>/manager/policies" method="POST">
                                <input type="hidden" name="action" value="<%= formAction %>">
                                
                                <% if (isEditMode) { %>
                                    <input type="hidden" name="policyId" value="<%= policy.getPolicyId() %>">
                                <% } %>

                                <div class="mb-3">
                                    <label for="policyName" class="form-label">Tên Chính sách</label>
                                    <input type="text" class="form-control" id="policyName" name="policyName" 
                                           value="<%= isEditMode ? policy.getPolicyName() : "" %>" required>
                                </div>

                                <div class="mb-3">
                                    <label for="rate" class="form-label">Tỷ lệ (Rate)</label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="rate" name="rate" 
                                               step="0.01" min="0" max="100" 
                                               value="<%= isEditMode ? policy.getRate() : "" %>" required>
                                        <span class="input-group-text">%</span>
                                    </div>
                                    <div class="form-text">Ví dụ: Nhập 5.5 cho 5.5%</div>
                                </div>

                                <div class="mb-3">
                                    <label for="effectiveFrom" class="form-label">Ngày có hiệu lực</label>
                                    <%-- 
                                        Input type="date" cần định dạng "yyyy-MM-dd".
                                        java.sql.Date.toString() tự động làm việc này.
                                    --%>
                                    <input type="date" class="form-control" id="effectiveFrom" name="effectiveFrom"
                                           value="<%= isEditMode ? policy.getEffectiveFrom().toString() : "" %>" required>
                                </div>

                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-save me-1"></i> Lưu Chính sách
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>