<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User, entity.Customer, entity.CustomerStage" %> 
<%@ page import="java.util.List, java.util.ArrayList, java.text.SimpleDateFormat" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
    String activePage = (String) request.getAttribute("activePage");
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
    List<CustomerStage> stageList = (List<CustomerStage>) request.getAttribute("stageList"); // <-- LẤY DỮ LIỆU MỚI
    String message = request.getParameter("message");
    if (customerList == null) customerList = new ArrayList<>();
    if (stageList == null) stageList = new ArrayList<>(); // <-- KHỞI TẠO
    if (currentUser == null) {
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
    <%@ include file="agent_sidebar.jsp" %> 

   <main class="main-content">
        <div class="container-fluid">

            <%-- Hiển thị thông báo (SỬA: Thêm StageUpdateSuccess) --%>
            <% if ("DeleteSuccess".equals(message)) { %>
                <div class="alert alert-success">Đã xóa khách hàng thành công!</div>
            <% } else if ("StageUpdateSuccess".equals(message)) { %> 
                <div class="alert alert-success">Cập nhật Giai đoạn (Journey) khách hàng thành công!</div>
            <% } else if ("AuthError".equals(message)) { %> 
                <div class="alert alert-danger">Bạn không có quyền thực hiện thao tác này!</div>
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
                                    <th>#</th>
                                    <th>Tên Khách Hàng</th>
                                    <th>Số Điện Thoại</th>
                                    <th>Email</th>
                                    <th>Giai đoạn (Journey)</th> <%-- SỬA TIÊU ĐỀ --%>
                                    <th>Ngày Tạo</th>
                                    <th style="width: 200px;">Thao Tác</th> <%-- Tăng độ rộng --%>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                if (customerList != null && !customerList.isEmpty()) {
                                    int index = 0; 
                                    for (Customer customer : customerList) { 
                                        index++;
                                %>
                                <tr>
                                    <td><%= index %></td>
                                    <td><%= customer.getFullName() %></td>
                                    <td><%= customer.getPhoneNumber() %></td>
                                    <td><%= customer.getEmail() %></td>
                                    
                                    <%-- SỬA LỖI: Cột Trạng Thái (Giờ dùng 4 Giai đoạn) --%>
                                    <td>
                                        <% String stageName = customer.getStageName();
                                           if ("Lead".equals(stageName)) { %>
                                            <span class="badge bg-warning text-dark">Lead</span>
                                        <% } else if ("Potential".equals(stageName)) { %>
                                            <span class="badge bg-info text-dark">Potential</span>
                                        <% } else if ("Client".equals(stageName)) { %>
                                            <span class="badge bg-success">Client</span>
                                        <% } else if ("Loyal".equals(stageName)) { %>
                                            <span class="badge bg-primary">Loyal</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary"><%= stageName %></span>
                                        <% } %>
                                    </td>
                                    
                                    <td><%= dateFormat.format(customer.getCreatedAt()) %></td>
                                    
                                    <%-- SỬA LỖI: Cột Thao Tác (Load 4 Giai đoạn động) --%>
                                    <td>
                                        <a href="<%=ctx%>/agent/customers?action=viewDetail&id=<%= customer.getCustomerId() %>" class="btn btn-sm btn-info" title="Xem chi tiết (CRM)">
                                            <i class="fa fa-eye"></i>
                                        </a>
                                        
                                        <a href="<%=ctx%>/agent/customers?action=showEditForm&id=<%= customer.getCustomerId() %>" class="btn btn-sm btn-warning" title="Chỉnh sửa thông tin">
                                            <i class="fa fa-edit"></i>
                                        </a>
                                        
                                        <a href="<%=ctx%>/agent/customers?action=delete&id=<%= customer.getCustomerId() %>" class="btn btn-sm btn-danger" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng này không?');">
                                            <i class="fa fa-trash"></i>
                                        </a>
                                        
                                        
                                    </td>
                                </tr>
                                <%
                                    } // Đóng vòng lặp for
                                } else { // Nếu danh sách rỗng
                                %>
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">Chưa có khách hàng nào.</td>
                                </tr>
                                <%
                                } // Đóng if-else
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