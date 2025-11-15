<%-- profile.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    /* === BƯỚC 1: ĐỊNH NGHĨA BIẾN "CHA" (PARENT) === */
    String ctx = request.getContextPath();
    
    User profileUser = (User) request.getAttribute("profileUser");
    User currentUser = (User) session.getAttribute("user");
    String activePage = "profile"; 

    String message = (String) session.getAttribute("profileMessage");
    if (message != null) {
        session.removeAttribute("profileMessage"); 
    }

    // "Chốt chặn" (Checkpoint) (Quan trọng nhất)
    if (profileUser == null || currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    
    // (KHÔNG (NO) CẦN "layoutPrefix" nữa)
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>My Profile</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
    <%-- === BƯỚC 2: "VÁ" (PATCH) (DÙNG LOGIC "STATIC INCLUDE" CỦA BẠN) === --%>
    <%
        if (currentUser.getRoleId() == 1) { // 1 = ROLE_AGENT
    %>
            <%@ include file="agent_navbar.jsp" %>
            <%@ include file="agent_sidebar.jsp" %>
    <%
        } else if (currentUser.getRoleId() == 2) { // 2 = ROLE_MANAGER
    %>
            <%@ include file="manager_navbar.jsp" %>
            <%@ include file="manager_sidebar.jsp" %>
    <%
        } 
        // (Không (No) "else" (khác) (vì bạn "không có" (don't have) Admin))
    %>
    <%-- ========================================================== --%>
    
    
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">My Profile (Hồ sơ của tôi)</h1>

            <%-- (Hiển thị (Render) "Thông báo" (Message) (Giữ nguyên)) --%>
            <% if (message != null && !message.isEmpty()) { %>
                <div class="alert <%= message.startsWith("Error:") ? "alert-danger" : "alert-success" %> alert-dismissible fade show" role="alert">
                    <%= message %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <div class="row">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i>Update Your Information</h5>
                        </div>
                        <div class="card-body">
                            
                            <%-- Form "Cập nhật" (Update) (Giữ nguyên) --%>
                            <form action="<%= ctx %>/profile" method="POST">
                                
                                <div class="mb-3">
                                    <label for="username" class="form-label">Username</label>
                                    <input type="text" class="form-control" id="username" 
                                           value="<%= profileUser.getUsername() %>" disabled readonly>
                                    <div class="form-text">Username cannot be changed.</div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="roleName" class="form-label">Role</label>
                                    <input type="text" class="form-control" id="roleName" 
                                           value="<%= profileUser.getRoleName() %>" disabled readonly>
                                </div>

                                <div class="mb-3">
                                    <label for="fullName" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName"
                                           value="<%= profileUser.getFullName() %>" required>
                                </div>

                                <div class="mb-3">
                                    <label for="email" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email"
                                           value="<%= profileUser.getEmail() %>" required>
                                </div>

                                <div class="mb-3">
                                    <label for="phoneNumber" class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber"
                                           value="<%= profileUser.getPhoneNumber() %>" required>
                                </div>

                                <hr>
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save me-2"></i>Save Changes</button>
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