<%-- 
    Document   : commissionPolicies
    Created on : Oct 25, 2025, 4:44:48 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.Product, entity.ProductCategory" %>
<%
    String ctx = request.getContextPath();

    List<Product> productList = (List<Product>) request.getAttribute("productList");

%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Commission Policies</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

        <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
        <style>
            /* Headings */
            h2 {
                color: var(--primary);
                font-weight: 600;
            }

            ul {
                margin-top: 0.5rem;
            }
        </style>
    </head>
    <body>

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
                <a class="nav-link text-white py-2" href="<%=ctx%>/manager/performance"><i class="fas fa-users-cog me-2"></i> Team Performance</a>
                <a class="nav-link text-white py-2" href="<%=ctx%>/agentmanagement.jsp"><i class="fas fa-users-cog me-2"></i> Agent Management</a>
                <a class="nav-link text-white py-2" href="<%=ctx%>/managers/leaderboard"><i class="fas fa-trophy me-2"></i> Leader Board</a>
                <a class="nav-link text-white py-2" href="<%=ctx%>/CommissionPoliciesServlet"><i class="fas fa-file-invoice-dollar me-2"></i> Commission Policies</a>
                <a class="nav-link text-white py-2" href="<%=ctx%>/productmanagement.jsp"><i class="fas fa-box me-2"></i> Product</a>
                <a class="nav-link text-white py-2" href="<%=ctx%>/manager/contracts"><i class="fas fa-file-signature me-2"></i> Contract</a>
                <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
                <div class="mt-3 px-2">
                    <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </nav>
        </aside>

        <div class="main-content">
            <div class="container">
                <h2 class="mb-4">Commission Policies</h2>

                <!-- Life Insurance -->
                <div class="card mb-4">
                    <div class="card-body">
                        <h4 class="card-title">Life Insurance</h4>
                        <ul>
                            <li>Contracts over 1 year: Maximum 30% of actual first-year premium.</li>
                            <li>Contracts under 1 year or renewed annually: Maximum 20% of actual premium collected.</li>
                            <li>Renewal contracts over 1 year (care services): Maximum 7% of renewal premium collected.</li>
                            <li>Pension insurance contracts: Maximum 3% of total premium.</li>
                        </ul>
                    </div>
                </div>

                <!-- Health Insurance -->
                <div class="card mb-4">
                    <div class="card-body">
                        <h4 class="card-title">Health Insurance</h4>
                        <ul>
                            <li>Contracts under 1 year: Maximum 20% of actual premium collected.</li>
                            <li>Contracts over 1 year: Maximum 20% of first-year premium, subject to specific contract terms.</li>
                            <li>Special products: May have specific rules, e.g., group insurance contracts.</li>
                        </ul>
                    </div>
                </div>

                <!-- Vehicle Insurance -->
                <div class="card mb-4">
                    <div class="card-body">
                        <h4 class="card-title">Vehicle Insurance</h4>
                        <ul>
                            <li>Maximum 20% of premium for contracts lasting up to 1 year or renewed annually.</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <footer class="main-footer text-center py-3">
            <small>© 2025 Insurance Agent System</small>
        </footer>

    </body>
</html>

