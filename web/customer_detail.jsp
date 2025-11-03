<%-- 
    Document   : customer_detail
    Created on : Nov 3, 2025, 1:46:19 PM
    Author     : Nguyễn Tùng
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User, entity.Customer, entity.Interaction, entity.InteractionType, entity.Contract, java.util.List, java.util.ArrayList, java.text.SimpleDateFormat" %>
<%@ page import="entity.User, entity.Customer, entity.Interaction, entity.InteractionType, java.util.List, java.util.ArrayList, java.text.SimpleDateFormat" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
    String activePage = (String) request.getAttribute("activePage");
    
    // Lấy dữ liệu đã được Servlet forward
    Customer customer = (Customer) request.getAttribute("customer");
    List<Interaction> interactionList = (List<Interaction>) request.getAttribute("interactionList");
    List<InteractionType> typeList = (List<InteractionType>) request.getAttribute("typeList");
    List<Contract> contractList = (List<Contract>) request.getAttribute("contractList"); // <-- THÊM DÒNG NÀY
    // Lấy thông báo từ URL
    String message = request.getParameter("message");

    // Xử lý các trường hợp lỗi hoặc rỗng
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (customer == null) { // Nếu không có customer, không thể xem
        response.sendRedirect(ctx + "/agent/customers?message=AuthError");
        return;
    }
    if (interactionList == null) interactionList = new ArrayList<>();
    if (typeList == null) typeList = new ArrayList<>();
    if (contractList == null) contractList = new ArrayList<>(); // <-- THÊM DÒNG NÀY
    if (activePage == null) activePage = "customers";

    // Định dạng ngày tháng
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdtf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi Tiết Khách Hàng - <%= customer.getFullName() %></title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
    
    <%-- CSS Tùy chỉnh cho trang chi tiết --%>
    <style>
        .timeline { list-style: none; padding: 0; }
        .timeline-item { display: flex; margin-bottom: 1.5rem; }
        .timeline-icon {
            width: 40px; height: 40px; border-radius: 50%;
            background-color: #eee; display: flex;
            align-items: center; justify-content: center;
            margin-right: 15px; flex-shrink: 0;
            color: #555;
        }
        .timeline-content { flex-grow: 1; }
        .timeline-content .notes {
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            padding: 10px 15px; border-radius: 5px;
            margin-top: 5px;
        }
        .timeline-content .meta {
            font-size: 0.85rem; color: #6c757d;
        }
    </style>
</head>
<body>

    <%@ include file="agent_navbar.jsp" %>
    <%@ include file="agent_sidebar.jsp" %>

    <main class="main-content">
        <div class="container-fluid">

            <%-- Hiển thị thông báo thành công/lỗi --%>
            <% if ("AddInteractionSuccess".equals(message)) { %>
                <div class="alert alert-success">Đã thêm tương tác mới thành công!</div>
            <% } else if ("UpdateSuccess".equals(message)) { %>
                <div class="alert alert-success">Cập nhật thông tin khách hàng thành công!</div>
            <% } %>

            <div class="d-flex align-items-center mb-3">
                <a href="<%=ctx%>/agent/customers" class="btn btn-outline-secondary me-3">
                    <i class="fa fa-arrow-left"></i> Quay lại
                </a>
                <h1 class="h3 mb-0">Chi Tiết Khách Hàng</h1>
            </div>

            <div class="row">
                <div class="col-lg-5">
                    <div class="card shadow-sm mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fa fa-user me-2"></i> Thông Tin
                            </h5>
                            <a href="<%=ctx%>/agent/customers?action=showEditForm&id=<%= customer.getCustomerId() %>" class="btn btn-sm btn-outline-primary">
                                <i class="fa fa-edit me-1"></i> Chỉnh sửa
                            </a>
                        </div>
                        <div class="card-body">
                            <h3 class="mb-3"><%= customer.getFullName() %></h3>
                            <p class="mb-2">
                                <i class="fa fa-phone me-2 text-muted"></i>
                                <%= (customer.getPhoneNumber() != null ? customer.getPhoneNumber() : "Chưa có SĐT") %>
                            </p>
                            <p class="mb-2">
                                <i class="fa fa-envelope me-2 text-muted"></i>
                                <%= (customer.getEmail() != null ? customer.getEmail() : "Chưa có Email") %>
                            </p>
                            <p class="mb-2">
                                <i class="fa fa-map-marker-alt me-2 text-muted"></i>
                                <%= (customer.getAddress() != null ? customer.getAddress() : "Chưa có địa chỉ") %>
                            </p>
                            <hr class="my-3">
                            <p class="mb-2">
                                <i class="fa fa-calendar-alt me-2 text-muted"></i>
                                Ngày sinh: <%= (customer.getDateOfBirth() != null ? sdf.format(customer.getDateOfBirth()) : "N/A") %>
                            </p>
                            <p class="mb-0">
                                <i class="fa fa-info-circle me-2 text-muted"></i>
                                Trạng thái: 
                                <% if ("Lead".equals(customer.getCustomerType())) { %>
                                    <span class="badge bg-warning text-dark">Lead</span>
                                <% } else { %>
                                    <span class="badge bg-success">Client</span>
                                <% } %>
                            </p>
                        </div>
                    </div>
                            <div class="card shadow-sm mb-4">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fa fa-file-signature me-2"></i> Hợp đồng đã ký
                            </h5>
                        </div>
                        <div class="card-body p-0">
                            <% if (contractList.isEmpty()) { %>
                                <div class="p-3 text-center text-muted">Khách hàng này chưa có hợp đồng nào.</div>
                            <% } else { %>
                                <ul class="list-group list-group-flush">
                                    <% for (Contract contract : contractList) { %>
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <div>
                                                <div class="fw-bold"><%= contract.getProductName() %></div>
                                                <small class="text-muted">
                                                    <%= new java.text.DecimalFormat("#,##0").format(contract.getPremiumAmount()) %> VNĐ
                                                </small>
                                            </div>
                                            <% if ("Active".equals(contract.getStatus())) { %>
                                                <span class="badge bg-success">Active</span>
                                            <% } else if ("Pending".equals(contract.getStatus())) { %>
                                                <span class="badge bg-warning text-dark">Pending</span>
                                            <% } else if ("Expired".equals(contract.getStatus())) { %>
                                                <span class="badge bg-secondary">Expired</span>
                                            <% } else { %>
                                                <span class="badge bg-danger">Cancelled</span>
                                            <% } %>
                                        </li>
                                    <% } %>
                                </ul>
                            <% } %>
                        </div>
                    </div>
                </div>

                <div class="col-lg-7">
                    <div class="card shadow-sm mb-4">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fa fa-plus-circle me-2"></i> Thêm Tương Tác Mới</h5>
                        </div>
                        <div class="card-body">
                            <form action="<%=ctx%>/agent/customers" method="post">
                                <input type="hidden" name="action" value="addInteraction">
                                <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>">
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="interactionType" class="form-label">Loại tương tác</label>
                                        <select class="form-select" id="interactionType" name="interactionType" required>
                                            <% for (InteractionType type : typeList) { %>
                                                <option value="<%= type.getTypeId() %>"><%= type.getTypeName() %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="interactionDate" class="form-label">Ngày diễn ra</label>
                                        <input type="datetime-local" class="form-control" id="interactionDate" name="interactionDate" required>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="notes" class="form-label">Ghi chú (Notes)</label>
                                    <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Ghi lại nội dung cuộc gọi, thông tin cuộc gặp..."></textarea>
                                </div>
                                
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-save me-1"></i> Lưu lại
                                </button>
                            </form>
                        </div>
                    </div>

                    <div class="card shadow-sm">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fa fa-history me-2"></i> Lịch Sử Tương Tác</h5>
                        </div>
                        <div class="card-body">
                            <ul class="timeline">
                                <% if (interactionList.isEmpty()) { %>
                                    <li class="text-center text-muted">Chưa có tương tác nào với khách hàng này.</li>
                                <% } else { %>
                                    <% for (Interaction interaction : interactionList) { %>
                                        <li class="timeline-item">
                                            <div class="timeline-icon" title="<%= interaction.getInteractionTypeName() %>">
                                                <i class="<%= interaction.getInteractionTypeIcon() %>"></i>
                                            </div>
                                            <div class="timeline-content">
                                                <div class="meta">
                                                    <strong><%= interaction.getInteractionTypeName() %></strong> 
                                                    lúc 
                                                    <%= sdtf.format(interaction.getInteractionDate()) %>
                                                </div>
                                                <% if (interaction.getNotes() != null && !interaction.getNotes().isEmpty()) { %>
                                                    <div class="notes">
                                                        <%= interaction.getNotes().replace("\n", "<br>")  %>
                                                    </div>
                                                <% } %>
                                            </div>
                                        </li>
                                    <% } %>
                                <% } %>
                            </ul>
                        </div>
                    </div>
                </div> </div> </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const now = new Date();
            // Trừ 7 tiếng múi giờ Việt Nam (UTC+7)
            now.setHours(now.getHours() + 7); 
            // Cắt chuỗi theo định dạng "YYYY-MM-DDTHH:mm"
            const localDateTime = now.toISOString().slice(0, 16);
            
            const dateInput = document.getElementById("interactionDate");
            if(dateInput) {
                dateInput.value = localDateTime;
            }
        });
    </script>
</body>
</html>