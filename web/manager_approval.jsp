<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.*, java.text.*" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("user");
    List<ContractDTO> pendingList = (List<ContractDTO>) request.getAttribute("pendingList");
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
    String message = request.getParameter("message");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Contract Approval</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
    
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="#">Manager Portal</a>
            <ul class="navbar-nav d-flex flex-row align-items-center">
                <li class="nav-item me-3"><a class="nav-link" href="#">Dashboard</a></li>
                
            </ul>
        </div>
    </nav>

    <aside class="sidebar bg-primary text-white">
        <div class="sidebar-top p-3">
              <div class="d-flex align-items-center mb-3">
                  <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                  <div>
                      <div class="fw-bold"><%= currentUser != null ? currentUser.getFullName() : "Manager" %></div>
                      <div style="font-size:.85rem;opacity:.9">Manager</div>
                  </div>
              </div>
        </div>
        <nav class="nav flex-column px-2">
            <a class="nav-link text-white active py-2" href="#"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/manager/performance"><i class="fas fa-users-cog me-2"></i> Team Performance</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/agentmanagement.jsp"><i class="fas fa-users-cog me-2"></i> Agent Management</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/managers/leaderboard"><i class="fas fa-trophy me-2"></i> Leader Board</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-invoice-dollar me-2"></i> Commission Policies</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/productmanagement.jsp"><i class="fas fa-box me-2"></i> Product</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/manager/contracts"><i class="fas fa-file-signature me-2"></i> Contract</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>

    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Pending Contracts for Approval</h1>

            <%-- Hiển thị thông báo (nếu có) --%>
            <% if ("approveSuccess".equals(message)) { %>
                <div class="alert alert-success">Contract approved successfully! A commission has been created.</div>
            <% } else if ("rejectSuccess".equals(message)) { %>
                <div class="alert alert-warning">Contract has been rejected.</div>
            <% } %>

            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Contract ID</th>
                                    <th>Agent</th>
                                    <th>Customer</th>
                                    <th>Product</th>
                                    <th class="text-end">Premium</th>
                                    <th style="width: 210px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% if (pendingList != null && !pendingList.isEmpty()) {
                                for (ContractDTO c : pendingList) { %>
                                <tr>
                                    <td>#<%= c.getContractId() %></td>
                                    <td><%= c.getAgentName() %></td>
                                    <td><%= c.getCustomerName() %></td>
                                    <td><%= c.getProductName() %></td>
                                    <td class="text-end"><%= currencyFormat.format(c.getPremiumAmount()) %></td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <%-- Form cho nút Approve --%>
                                            <form action="<%=ctx%>/manager/contracts" method="post" class="d-inline-block">
                                                <input type="hidden" name="action" value="approve">
                                                <input type="hidden" name="contractId" value="<%= c.getContractId() %>">
                                                <button type="submit" class="btn btn-success btn-sm" onclick="return confirm('Approve this contract?')">
                                                    <i class="fa fa-check me-1"></i> Approve
                                                </button>
                                            </form>
                                            
                                            <%-- Form cho nút Reject --%>
                                            <form action="<%=ctx%>/manager/contracts" method="post" class="d-inline-block">
                                                <input type="hidden" name="action" value="reject">
                                                <input type="hidden" name="contractId" value="<%= c.getContractId() %>">
                                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to reject this contract?');">
                                                    <i class="fa fa-times me-1"></i> Reject
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr><td colspan="6" class="text-center p-4 text-muted">No pending contracts to approve.</td></tr>
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