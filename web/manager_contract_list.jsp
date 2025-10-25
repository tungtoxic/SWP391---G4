<%-- 
    Document   : manager_contract_list
    Created on : Oct 25, 2025, 11:14:09 AM
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, entity.*, java.text.*" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) request.getAttribute("currentUser"); // Get from request
    List<ContractDTO> contractList = (List<ContractDTO>) request.getAttribute("contractList");
    String viewTitle = (String) request.getAttribute("viewTitle");
    Boolean isPendingView = (Boolean) request.getAttribute("isPendingView"); // Check which view this is

    // Default values in case attributes are somehow null
    if (viewTitle == null) viewTitle = "Managed Contracts";
    if (isPendingView == null) isPendingView = false;
    if (contractList == null) contractList = new ArrayList<>();


    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    String message = request.getParameter("message"); // For success/error messages
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= viewTitle %></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
</head>
<body>
    <%-- Navbar & Sidebar for Manager (Make sure this includes currentUser) --%>
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
         <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="#">Manager Portal</a>
            <ul class="navbar-nav d-flex flex-row align-items-center">
                <li class="nav-item me-3"><a class="nav-link" href="<%= ctx %>/ManagerDashboard.jsp">Dashboard</a></li> <%-- Link to Manager Dashboard --%>
                 <li class="nav-item"><a class="nav-link" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
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
            <a class="nav-link text-white py-2" href="<%= ctx %>/ManagerDashboard.jsp"><i class="fas fa-chart-line me-2"></i> Dashboard</a> <%-- Link to Manager Dashboard --%>
            <a class="nav-link text-white py-2" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
            <a class="nav-link text-white py-2" href="<%=ctx%>/manager/performance"><i class="fas fa-users-cog me-2"></i> Team Performance</a>
             <a class="nav-link text-white py-2" href="<%=ctx%>/agentmanagement.jsp"><i class="fas fa-users-cog me-2"></i> Agent Management</a> <%-- Assuming this exists --%>
             <a class="nav-link text-white py-2" href="<%=ctx%>/managers/leaderboard"><i class="fas fa-trophy me-2"></i> Leader Board</a> <%-- Assuming this exists --%>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-invoice-dollar me-2"></i> Commission Policies</a>
             <a class="nav-link text-white py-2" href="<%=ctx%>/productmanagement.jsp"><i class="fas fa-box me-2"></i> Product</a> <%-- Assuming this exists --%>
             <%-- Make Contract link active based on context --%>
            <a class="nav-link text-white active py-2" href="<%=ctx%>/manager/contracts"><i class="fas fa-file-signature me-2"></i> Contract Approval</a>
             <a class="nav-link text-white py-2" href="<%=ctx%>/manager/contracts?action=listAll"><i class="fas fa-list me-2"></i> All Contracts</a> <%-- Link to view all --%>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
            <div class="mt-3 px-2">
                <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </nav>
    </aside>

    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4"><%= viewTitle %></h1>

            <%-- Display messages --%>
             <% if ("approveSuccess".equals(message)) { %>
                <div class="alert alert-success">Contract approved successfully! A commission has been created (if applicable).</div>
            <% } else if ("rejectSuccess".equals(message)) { %>
                <div class="alert alert-warning">Contract has been rejected/cancelled.</div>
             <% } else if ("rejectError".equals(message)) { %>
                 <div class="alert alert-danger">Failed to reject the contract. Please try again.</div>
             <% } else if ("AuthError".equals(message)) { %>
                 <div class="alert alert-danger">You do not have permission for this action.</div>
             <% } %>

            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Agent</th> <%-- Added Agent column --%>
                                    <th>Customer</th>
                                    <th>Product</th>
                                    <th>Start Date</th> <%-- Added Start Date --%>
                                    <th>Status</th>
                                    <th class="text-end">Premium</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% if (!contractList.isEmpty()) {
                                for (ContractDTO c : contractList) { %>
                                <tr>
                                    <td>#<%= c.getContractId() %></td>
                                    <td><%= c.getAgentName() %></td> <%-- Display Agent Name --%>
                                    <td><%= c.getCustomerName() %></td>
                                    <td><%= c.getProductName() %></td>
                                    <td><%= c.getStartDate() != null ? dateFormat.format(c.getStartDate()) : "N/A" %></td> <%-- Display Start Date --%>
                                    <td>
                                        <%-- Status Badge Logic (copied from agent list) --%>
                                        <span class="badge
                                            <% if("Active".equals(c.getStatus())) out.print("bg-success");
                                               else if("Pending".equals(c.getStatus())) out.print("bg-warning text-dark");
                                               else if("Expired".equals(c.getStatus())) out.print("bg-secondary"); // Use secondary for Expired
                                               else if("Cancelled".equals(c.getStatus())) out.print("bg-danger"); // Use danger for Cancelled
                                               else out.print("bg-dark"); %>
                                        "><%= c.getStatus() %></span>
                                    </td>
                                    <td class="text-end"><%= currencyFormat.format(c.getPremiumAmount()) %></td>
                                    <td>
                                        <%-- Actions depend on the view (Pending or All) --%>
                                        <% if (isPendingView) { %>
                                            <%-- Show Approve/Reject buttons only in Pending view --%>
                                            <div class="d-flex gap-1">
                                                <form action="<%=ctx%>/manager/contracts" method="post" class="d-inline-block">
                                                    <input type="hidden" name="action" value="approve">
                                                    <input type="hidden" name="contractId" value="<%= c.getContractId() %>">
                                                    <button type="submit" class="btn btn-success btn-sm" onclick="return confirm('Approve contract #<%= c.getContractId() %>?')">
                                                        <i class="fa fa-check"></i>
                                                    </button>
                                                </form>
                                                <form action="<%=ctx%>/manager/contracts" method="post" class="d-inline-block">
                                                    <input type="hidden" name="action" value="reject">
                                                    <input type="hidden" name="contractId" value="<%= c.getContractId() %>">
                                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Reject contract #<%= c.getContractId() %>?');">
                                                        <i class="fa fa-times"></i>
                                                    </button>
                                                </form>
                                                 <%-- Add View Detail Button --%>
                                                 <a href="#" class="btn btn-info btn-sm" title="View Details"><i class="fa fa-eye"></i></a>
                                            </div>
                                        <% } else { %>
                                            <%-- Show only View Detail button in All Contracts view --%>
                                            <a href="#" class="btn btn-info btn-sm" title="View Details"><i class="fa fa-eye"></i></a>
                                             <%-- Maybe add other actions later, like manually cancelling an Active contract --%>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } // end for loop
                               } else { %>
                                <tr>
                                    <td colspan="8" class="text-center p-4 text-muted">
                                        <% if (isPendingView) { %>
                                            No pending contracts found for your team.
                                        <% } else { %>
                                            No contracts found for your team.
                                        <% } %>
                                    </td>
                                </tr>
                            <% } // end if-else empty check %>
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