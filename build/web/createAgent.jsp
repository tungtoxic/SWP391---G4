<%-- 
    Document   : createAgent
    Created on : Oct 11, 2025, 3:44:40 PM
    Author     : Helios 16
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create New Agent</title>

    <!-- Bootstrap + FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <!-- Layout CSS (màu chủ đạo, sidebar, main-content, v.v.) -->
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css">

    <style>
        .form-container {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-top: 100px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .form-container h2 {
            text-align: center;
            color: var(--primary);
            margin-bottom: 25px;
        }

        label {
            font-weight: 600;
            margin-top: 10px;
        }

        input[type="text"], input[type="email"], input[type="tel"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .btn-primary {
            background: var(--primary);
            border: none;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
        }

        .alert {
            background: #e6f4ea;
            color: #2e7d32;
            border-left: 4px solid #2e7d32;
            padding: 10px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
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

    <!-- Main Content -->
    <main class="main-content">
        <div class="form-container">
            <h2><i class="fas fa-user-plus me-2"></i>Create New Agent</h2>

            <c:if test="${not empty message}">
                <div class="alert">${message}</div>
            </c:if>

            <form action="AgentManagementServlet?action=create" method="post">
                <div class="mb-3">
                    <label>Username:</label>
                    <input type="text" name="username" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label>Full Name:</label>
                    <input type="text" name="fullName" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label>Email:</label>
                    <input type="email" name="email" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label>Phone Number:</label>
                    <input type="tel" name="phoneNumber" class="form-control">
                </div>

                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-save me-2"></i>Create Agent
                </button>
            </form>

            <div class="text-center mt-3">
                <a href="AgentManagementServlet" class="text-decoration-none">
                    <i class="fas fa-arrow-left me-1"></i>Back to Agent List
                </a>
            </div>
        </div>
    </main>

    <footer class="main-footer text-muted">
        <div class="container-fluid d-flex justify-content-between py-2">
            <div>© 2025 SWP391 - Insurance Management System</div>
            <div><b>Version</b> 1.0</div>
        </div>
    </footer>

</body>
</html>