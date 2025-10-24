<%-- 
    Document   : policymanagement
    Created on : Oct 17, 2025, 3:32:09 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.*" %>
<%
    String ctx = request.getContextPath();

    List<Contract> contractList = (List<Contract>) request.getAttribute("contractList");
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
    List<Product> productList = (List<Product>) request.getAttribute("productList");

    Map<Integer, String> customerMap = new HashMap<>();
    if (customerList != null) {
        for (Customer c : customerList) {
            customerMap.put(c.getCustomerId(), c.getFullName());
        }
    }

    Map<Integer, Product> productMap = new HashMap<>();
    if (productList != null) {
        for (Product p : productList) {
            productMap.put(p.getProductId(), p);
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>📑 Quản lý hợp đồng bảo hiểm</title>

        <!-- Bootstrap + FontAwesome -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

        <!-- Layout CSS -->
        <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />

        <style>
            .main-content {
                margin-left: 220px;
                padding: 80px 20px 20px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
                border-radius: 8px;
                overflow: hidden;
            }
            th, td {
                padding: 10px 12px;
                border: 1px solid #ddd;
                text-align: left;
            }
            th {
                background-color: var(--primary, #007bff);
                color: #fff;
            }
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            tr:hover {
                background-color: #eef4ff;
            }
            .filter-box {
                margin-bottom: 20px;
            }
            .no-data {
                text-align: center;
                color: red;
                font-weight: 500;
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
            <div class="container-fluid">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h2 class="text-center mb-4">📄 Quản lý Hợp đồng Bảo hiểm</h2>

                        <!-- Bộ lọc -->
                        <div class="filter-box d-flex justify-content-between align-items-center flex-wrap">
                            <div>
                                <label><b>Chọn danh mục sản phẩm:</b></label>
                                <select id="productTypeSelect" class="form-select d-inline-block w-auto me-3" onchange="filterContracts()">
                                    <option value="all">Tất cả</option>
                                    <option value="life">Bảo hiểm nhân thọ</option>
                                    <option value="health">Bảo hiểm sức khỏe</option>
                                    <option value="car">Bảo hiểm ô tô</option>
                                </select>

                                <label><b>Trạng thái:</b></label>
                                <select id="statusSelect" class="form-select d-inline-block w-auto" onchange="filterContracts()">
                                    <option value="all">Tất cả</option>
                                    <option value="Active">Active</option>
                                    <option value="Pending">Pending</option>
                                    <option value="Expired">Expired</option>
                                    <option value="Cancelled">Canceled</option>
                                </select>
                            </div>

                        </div>


                        <!-- Bảng hợp đồng -->
                        <table id="contractTable" class="table table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Khách hàng</th>
                                    <th>Tên Agent</th>
                                    <th>Thụ hưởng</th>
                                    <th>Sản phẩm</th>
                                    <th>Loại Sản Phẩm</th>                                                                      
                                    <th>Trạng thái</th>
                                    <th>Phí bảo hiểm</th>
                                    <th>Bắt đầu</th>
                                    <th>Kết thúc</th>
                                    <th>Ngày tạo</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                if (contractList != null && !contractList.isEmpty()) {
                                    for (Contract c : contractList) {
                                        Product p = productMap.get(c.getProductId());
                                        String type = (p != null) ? p.getCategoryId() + "" : "";
                                        String categoryType = "other";
                                        if (p != null) {
                                            switch (p.getCategoryId()) {
                                                case 1: categoryType = "life"; break;
                                                case 2: categoryType = "health"; break;
                                                case 3: categoryType = "car"; break;
                                            }
                                        }
                                %>
                                <tr data-type="<%=categoryType%>">
                                    <td><%=c.getContractId()%></td>

                                    <td><%=c.getBeneficiaries() != null ? c.getBeneficiaries() : "-" %></td>
                                    <td><%=c.getAgentName()%></td>
                                    <td><%=customerMap.getOrDefault(c.getCustomerId(),"N/A")%></td>
                                    <td><%=p != null ? p.getProductName() : "N/A"%></td>
                                    <td><%=categoryType%></td>                                                                    
                                    <td><%=c.getStatus()%></td>
                                    <td><%=c.getPremiumAmount()%></td>
                                    <td><%=c.getStartDate()%></td>
                                    <td><%=c.getEndDate() != null ? c.getEndDate() : "-" %></td>
                                    <td><%=c.getCreatedAt()%></td>
                                    <td>
                                        <% if ("Pending".equalsIgnoreCase(c.getStatus())) { %>
                                        <form action="ContractManagementServlet" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="approve">
                                            <input type="hidden" name="contractId" value="<%=c.getContractId()%>">
                                            <button type="submit" class="btn btn-sm btn-danger"
                                                    onclick="return confirm('Bạn có chắc muốn duyệt hợp đồng này không?');">
                                                <i class="fa fa-times"></i> Duyệt
                                            </button>
                                        </form>
                                        <% } else if ("Active".equalsIgnoreCase(c.getStatus())) { %>
                                        <form action="ContractManagementServlet" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="contractId" value="<%=c.getContractId()%>">
                                            <button type="submit" class="btn btn-sm btn-danger"
                                                    onclick="return confirm('Bạn có chắc muốn hủy hợp đồng này không?');">
                                                <i class="fa fa-times"></i> Hủy
                                            </button>
                                        </form>
                                        <% } else if ("Expired".equalsIgnoreCase(c.getStatus())) { %>
                                        <form action="ContractManagementServlet" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="renew">
                                            <input type="hidden" name="contractId" value="<%=c.getContractId()%>">

                                            <!-- Người dùng nhập số năm muốn gia hạn -->
                                            <input type="number" name="renewYears" min="1" max="10" placeholder="Số năm" required style="width:80px;">

                                            <button type="submit" class="btn btn-sm btn-danger"
                                                    onclick="return confirm('Bạn có chắc muốn gia hạn hợp đồng này không?');">
                                                <i class="fa fa-refresh"></i> Gia hạn
                                            </button>
                                        </form>
                                        <% } else { %>
                                        <span class="text-secondary">Đã hủy</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr><td colspan="12" class="no-data">Không có hợp đồng nào.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>

        <script>
            function filterContracts() {
                const type = document.getElementById('productTypeSelect').value.toLowerCase();
                const status = document.getElementById('statusSelect').value.toLowerCase();

                const rows = document.querySelectorAll('#contractTable tbody tr');

                rows.forEach(row => {
                    const rowType = (row.dataset.type || '').toLowerCase();
                    const rowStatus = (row.cells[6]?.innerText || '').toLowerCase();

                    const matchType = (type === 'all' || rowType === type);
                    const matchStatus = (status === 'all' || rowStatus.includes(status));

                    // Hiển thị hoặc ẩn hàng theo điều kiện lọc
                    row.style.display = (matchType && matchStatus) ? '' : 'none';
                });
            }
        </script>



    </body>
</html>


