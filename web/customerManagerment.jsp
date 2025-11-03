<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Customer" %>
<%@ page import="entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
    String message = request.getParameter("message"); // Lấy thông báo từ URL

    // Định dạng ngày tháng
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Quản Lý Khách Hàng</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
</head>
<body>
    
    <%-- Navbar (Dựa trên layout.css) --%>
     <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company</a>
            <ul class="navbar-nav d-flex flex-row align-items-center">
                <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/home.jsp">Home</a></li>
                <a class="nav-link" href="#">
                        <i class="fas fa-bell"></i>
                        <span class="badge rounded-pill badge-notification bg-danger">1</span>
                    </a>
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
            
            <%-- Hiển thị thông báo thành công/lỗi --%>
            <% if ("DeleteSuccess".equals(message)) { %>
                <div class="alert alert-success">Đã xóa khách hàng thành công!</div>
            <% } else if ("TypeUpdateSuccess".equals(message)) { %> <div class="alert alert-success">Cập nhật trạng thái khách hàng thành công!</div>
            <% } else if ("AuthError".equals(message)) { %> <div class="alert alert-danger">Bạn không có quyền thực hiện thao tác này!</div>
            <% } %>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-user-friends me-2"></i> Khách Hàng Của Tôi</h5>
                    <a href="<%=ctx%>/agent/customers?action=showAddForm" class="btn btn-primary">
                    <i class="fa fa-plus me-1"></i> New Customer
                </a>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Tên Khách Hàng</th>
                                    <th>Ngày Sinh</th>
                                    <th>Số Điện Thoại</th>
                                    <th>Email</th>
                                    <th>Trạng Thái</th> <th>Ngày Tạo</th>
                                    <th style="width: 150px;">Thao Tác</th> </tr>
                            </thead>
                            <tbody>
                                <%  
                                    if (customerList != null && !customerList.isEmpty()) {
                                        for (Customer customer : customerList) { 
                                %>
                                        <tr>
                                            <td><%= customer.getCustomerId() %></td>
                                            <td><%= customer.getFullName() %></td>
                                            <td><%= customer.getDateOfBirth() != null ? dateFormat.format(customer.getDateOfBirth()) : "" %></td>
                                            <td><%= customer.getPhoneNumber() %></td>
                                            <td><%= customer.getEmail() %></td>
                                            
                                            <td>
                                                <% if ("Lead".equals(customer.getCustomerType())) { %>
                                                    <span class="badge bg-warning text-dark">Lead</span>
                                                <% } else if ("Client".equals(customer.getCustomerType())) { %>
                                                    <span class="badge bg-success">Client</span>
                                                <% } else { %>
                                                    <span class="badge bg-secondary"><%= customer.getCustomerType() %></span>
                                                <% } %>
                                            </td>
                                            <td><%= customer.getCreatedAt() != null ? new SimpleDateFormat("dd/MM/yyyy").format(customer.getCreatedAt()) : "" %></td>
                                            
                                            <td>
                                                <a href="<%=ctx%>/agent/customers?action=showEditForm&id=<%= customer.getCustomerId() %>" class="btn btn-sm btn-warning" title="Chỉnh sửa"><i class="fa fa-edit"></i></a>
                                                <a href="<%=ctx%>/agent/customers?action=delete&id=<%= customer.getCustomerId() %>" class="btn btn-sm btn-danger" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng này không?');"><i class="fa fa-trash"></i></a>
                                                
                                                <div class="btn-group d-inline-block">
                                                    <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" title="Đổi trạng thái">
                                                        <i class="fa fa-sync-alt"></i>
                                                    </button>
                                                    <ul class="dropdown-menu">
                                                        <li><a class="dropdown-item" href="<%=ctx%>/agent/customers?action=updateType&id=<%=customer.getCustomerId()%>&type=Lead">Chuyển thành Lead</a></li>
                                                        <li><a class="dropdown-item" href="<%=ctx%>/agent/customers?action=updateType&id=<%=customer.getCustomerId()%>&type=Client">Chuyển thành Client</a></li>
                                                    </ul>
                                                </div>
                                            </td>
                                        </tr>
                                <%  
                                        }
                                    } else {
                                %>
                                        <tr>
                                            <td colspan="8" class="text-center text-muted py-4">Chưa có khách hàng nào được bạn thêm vào.</td>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>