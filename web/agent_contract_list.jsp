<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.*, java.text.*" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
    List<ContractDTO> contractList = (List<ContractDTO>) request.getAttribute("contractList");
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Contracts</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
     <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company</a>
            <ul class="navbar-nav d-flex flex-row align-items-center">
                <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/home.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </nav>

    <aside class="sidebar bg-primary text-white">
        <div class="sidebar-top p-3">
            <div class="d-flex align-items-center mb-3">
                <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                <div>
                    <div class="fw-bold"><%= currentUser != null ? currentUser.getFullName() : "Agent" %></div>
                    <div style="font-size:.85rem;opacity:.9">Sales Agent</div>
                </div>
            </div>
        </div>
        <nav class="nav flex-column px-2">
            <%-- ĐÃ SỬA LỖI ĐIỀU HƯỚNG --%>
            <a class="nav-link text-white active py-2" href="<%=ctx%>/agent/dashboard"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agents/leaderboard"><i class="fas fa-trophy me-2"></i> Leaderboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/commission-report"><i class="fas fa-percent me-2"></i> Commission Report</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-box me-2"></i> Product</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/contracts"><i class="fas fa-file-signature me-2"></i> Contract</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/customers"><i class="fas fa-users me-2"></i> Customer</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>

    <main class="main-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="mb-0">My Contracts</h1>
                <a href="<%=ctx%>/agent/contracts?action=showAddForm" class="btn btn-primary">
                    <i class="fa fa-plus me-1"></i> New Contract
                </a>
            </div>
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Customer</th>
                                    <th>Product</th>
                                    <th>Start Date</th>
                                    <th>Status</th>
                                    <th class="text-end">Premium</th>
                                    <th style="width: 120px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% if (contractList != null && !contractList.isEmpty()) {
                                for (ContractDTO c : contractList) { %>
                                <tr>
                                    <td>#<%= c.getContractId() %></td>
                                    <td><%= c.getCustomerName() %></td>
                                    <td><%= c.getProductName() %></td>
                                    <td><%= dateFormat.format(c.getStartDate()) %></td>
                                    <td>
                                        <span class="badge 
                                            <% if("Active".equals(c.getStatus())) out.print("bg-success");
                                               else if("Pending".equals(c.getStatus())) out.print("bg-warning text-dark");
                                               else if("Expired".equals(c.getStatus())) out.print("bg-danger");
                                               else out.print("bg-secondary"); %>
                                        "><%= c.getStatus() %></span>
                                    </td>
                                    <td class="text-end"><%= currencyFormat.format(c.getPremiumAmount()) %></td>
                                    <td>
                                        <%-- Chỉ hiển thị nút Sửa/Xóa cho hợp đồng Pending --%>
                                        <% if ("Pending".equals(c.getStatus())) { %>
                                            <a href="<%=ctx%>/agent/contracts?action=showEditForm&id=<%=c.getContractId()%>" class="btn btn-sm btn-warning" title="Edit">
                                                <i class="fa fa-edit"></i>
                                            </a>
                                            <a href="<%=ctx%>/agent/contracts?action=delete&id=<%=c.getContractId()%>" class="btn btn-sm btn-danger" title="Delete" onclick="return confirm('Are you sure you want to delete this pending contract?');">
                                                <i class="fa fa-trash"></i>
                                            </a>
                                        <% } else { %>
                                            <%-- Có thể để trống hoặc hiển thị nút xem chi tiết --%>
                                            <a href="#" class="btn btn-sm btn-info" title="View Details"><i class="fa fa-eye"></i></a>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr><td colspan="7" class="text-center p-4">You have no contracts.</td></tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>