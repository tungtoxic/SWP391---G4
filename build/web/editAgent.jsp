<%-- 
    Document   : editAgent
    Created on : Oct 11, 2025, 4:54:34 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>✏️ Edit Agent</title>

    <!-- Bootstrap + FontAwesome -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
    <style>       
        /* ==== Form Styling ==== */
        .container-form {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
            padding: 30px;
            max-width: 700px;
            margin: auto;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin: 6px 0 18px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .btn-submit {
            background-color: var(--primary);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
        }

        .alert {
            margin-bottom: 20px;
        }
    </style>
</head>

<body>
    <!-- NAVBAR -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company</a>
            <div>
                <ul class="navbar-nav d-flex flex-row align-items-center">
                    <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/home.jsp">Home</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <aside class="sidebar bg-primary text-white">
        <%-- ... (Phần Sidebar Navigation của Manager sẽ tương tự Agent nhưng có thể thêm mục Admin nếu có) ... --%>
        <div class="sidebar-top p-3">
            <div class="d-flex align-items-center mb-3">
                <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                <div>
                    <div class="fw-bold">Manager Name</div>
                    <div style="font-size:.85rem;opacity:.9">Sales Manager</div>
                </div>
            </div>
        </div>

        <nav class="nav flex-column px-2">
            <a class="nav-link text-white active py-2" href="#"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
            <a class="nav-link text-white py-2" href="AgentManagementServlet?action="><i class="fas fa-users-cog me-2"></i> Agent Management</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-invoice-dollar me-2"></i> Commission Contracts</a>
            <a class="nav-link text-white py-2" href="ProductServlet?action=list"><i class="fas fa-box me-2"></i> Product</a>
            <a class="nav-link text-white py-2" href="ContractManagementServlet?action=list"><i class="fas fa-file-alt me-2"></i> Contracts</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">
        <div class="container-form">
            <h2 class="mb-4">✏️ Edit Agent</h2>

            <c:if test="${not empty message}">
                <div class="alert alert-info">${message}</div>
            </c:if>

            <form action="AgentManagementServlet" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" value="${agent.userId}">

                <label>Full Name:</label>
                <input type="text" name="fullName" value="${agent.fullName}" required>

                <label>Email:</label>
                <input type="email" name="email" value="${agent.email}" required>

                <label>Phone:</label>
                <input type="tel" name="phoneNumber" value="${agent.phoneNumber}">

                <label>Status:</label>
                <select name="status">
                    <option ${agent.status == 'Active' ? 'selected' : ''}>Active</option>
                    <option ${agent.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                    <option ${agent.status == 'Pending' ? 'selected' : ''}>Pending</option>
                </select>

                <div class="text-center mt-4">
                    <button type="submit" class="btn-submit"><i class="fas fa-save me-2"></i> Save Changes</button>
                    <a href="AgentManagementServlet" class="btn btn-secondary ms-2">Cancel</a>
                </div>
            </form>
        </div>
    </main>

    <footer class="main-footer text-center py-3">
        <small>© 2025 Insurance Management System</small>
    </footer>
</body>
</html>

