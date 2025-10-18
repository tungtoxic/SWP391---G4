<%--
    Document    : customerManagerment.jsp
    Mục đích    : Hiển thị danh sách khách hàng (Customer Management) cho Agent.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Customer" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<% String ctx = request.getContextPath(); %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Quản Lý Khách Hàng</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
    <link rel="stylesheet" href="<%=ctx%>/css/agent-dashboard.css" />
    <style>
        /* Tương tự như style trong Dashboard, bạn có thể chuyển style này vào file CSS chung */
        .card-header { background-color: var(--primary); color: white; }
    </style>
</head>
<body>
    
    <%-- Navbar (Dựa trên layout.css) --%>
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company</a>
            <ul class="navbar-nav d-flex flex-row align-items-center">
                <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/agent/dashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </nav>

    <%-- Sidebar (Dựa trên layout.css) --%>
    <aside class="sidebar bg-primary text-white">
        <div class="sidebar-top p-3">
             <div class="d-flex align-items-center mb-3">
                <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                <div>
                    <div class="fw-bold">Agent User</div>
                    <div style="font-size:.85rem;opacity:.9">Sales Agent</div>
                </div>
            </div>
        </div>
        <nav class="nav flex-column px-2">
            <a class="nav-link text-white py-2" href="<%=ctx%>/agent/dashboard"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white active py-2" href="<%=ctx%>/agent/customer-management"><i class="fas fa-users me-2"></i> Customer Management</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Quản Lý Khách Hàng</h1>
            
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="fas fa-user-friends me-2"></i> Khách Hàng Của Tôi</h5>
                    
                    <%-- Nút Thêm Mới --%>
                    <a href="<%=ctx%>/agent/customer-management?action=showAddForm" class="btn btn-sm btn-light text-dark fw-bold">
                        <i class="fa fa-plus me-1"></i> Thêm Khách Hàng
                    </a>
                </div>
                <div class="card-body">
                    
                    <%-- Lấy List Khách hàng từ Servlet --%>
                    <% List<Customer> customerList = (List<Customer>) request.getAttribute("customerList"); %>

                    <div class="table-responsive">
                        <table class="table table-hover table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên Khách Hàng</th>
                                    <th>Ngày Sinh</th>
                                    <th>Số Điện Thoại</th>
                                    <th>Email</th>
                                    <th>Ngày Tạo</th>
                                    <th style="width: 150px;">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    if (customerList != null && !customerList.isEmpty()) {
                                        for (Customer customer : customerList) { 
                                %>
                                            <tr>
                                                <td><%= customer.getCustomerId() %></td>
                                                <td><%= customer.getFullName() %></td>
                                                <td><%= customer.getDateOfBirth() %></td>
                                                <td><%= customer.getPhoneNumber() %></td>
                                                <td><%= customer.getEmail() %></td>
                                                <td><%= customer.getCreatedAt() %></td>
                                                <td>
                                                    <a href="<%=ctx%>/agent/customer-management?action=showEditForm&id=<%= customer.getCustomerId() %>" class="btn btn-sm btn-info" title="Chỉnh sửa"><i class="fa fa-edit"></i></a>
                                                    <a href="<%=ctx%>/agent/customer-management?action=delete&id=<%= customer.getCustomerId() %>" class="btn btn-sm btn-danger" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng này không? Khách hàng có thể có HĐ liên quan.');"><i class="fa fa-trash"></i></a>
                                                </td>
                                            </tr>
                                <% 
                                        }
                                    } else {
                                %>
                                        <tr>
                                            <td colspan="7" class="text-center text-muted py-4">Chưa có khách hàng nào được bạn thêm vào.</td>
                                        </tr>
                                <% 
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="main-footer text-muted">
        <div class="container-fluid">
            <div class="d-flex justify-content-between py-2">
                <div>© Your Company</div>
                <div><b>Version</b> 1.0</div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>