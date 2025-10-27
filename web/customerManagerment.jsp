<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Customer" %>
<%@ page import="entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="entity.Customer, entity.User, java.util.*, java.text.SimpleDateFormat" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
    String activePage = (String) request.getAttribute("activePage");
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
    String message = request.getParameter("message"); // Lấy thông báo từ URL
    if (customerList == null) customerList = new ArrayList<>();
    if (currentUser == null) { // Phòng trường hợp truy cập trực tiếp
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    // Định dạng ngày tháng
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    if (activePage == null) activePage = "customers";
%>

<!DOCTYPE html>

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Quản Lý Khách Hàng</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
</head>
<body>

    <%@ include file="agent_navbar.jsp" %>
    <%@ include file="agent_sidebar.jsp" %> <%-- Sidebar sẽ tự động lấy activePage="dashboard" --%>

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
                                    // KHAI BÁO BIẾN ĐẾM Ở ĐÂY (bên ngoài vòng lặp)
                                    int index = 0; 
        
                                    // BẮT ĐẦU VÒNG LẶP
                                    for (Customer customer : customerList) { 
                                        index++; // Tăng biến đếm
                                %>
                                <tr>
                                    <td><%= index %></td> <%-- Dùng biến đếm --%>
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
                                        <span class="badge bg-secondary">N/A</span>
                                        <% } %>
                                    </td>
                                    <td><%= customer.getCreatedAt() != null ? new SimpleDateFormat("dd/MM/yyyy").format(customer.getCreatedAt()) : "" %></td>
                                    <td>
                                        <%-- Các nút actions (giữ nguyên) --%>
                                        <div class="btn-group d-inline-block">
                                            <button type-="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" title="Đổi trạng thái">
                                                <i class="fa fa-sync-alt"></i>
                                            </button>
                                            <ul class="dropdown-menu">
                                                <li><a class="dropdown-item" href="<%=ctx%>/agent/customers?action=updateType&id=<%=customer.getCustomerId()%>&type=Lead">Chuyển thành Lead</a></li>
                                                <li><a class="dropdown-item" href="<%=ctx%>/agent/customers?action=updateType&id=<%=customer.getCustomerId()%>&type=Client">Chuyển thành Client</a></li>
                                            </ul>
                                        </div>
                                        <a href="<%=ctx%>/agent/customers?action=showEditForm&id=<%= customer.getCustomerId() %>" class="btn btn-sm btn-warning" title="Chỉnh sửa"><i class="fa fa-edit"></i></a>
                                        <a href="<%=ctx%>/agent/customers?action=delete&id=<%= customer.getCustomerId() %>" class="btn btn-sm btn-danger" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng này không?');"><i class="fa fa-trash"></i></a>
                                    </td>
                                </tr>
                                <%
                                    } // ĐÓNG VÒNG LẶP FOR
                                } else { // ĐÂY LÀ KHỐI ELSE KHI DANH SÁCH RỖNG
                                %>
                                <tr>
                                    <td colspan="8" class="text-center text-muted py-4">Chưa có khách hàng nào được bạn thêm vào.</td>
                                </tr>
                                <%
                                } // ĐÓNG IF-ELSE
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
