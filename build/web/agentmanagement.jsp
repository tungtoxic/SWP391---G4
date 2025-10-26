<%-- 
    Document   : agentmanagement
    Created on : Oct 11, 2025, 2:32:14 PM
    Author     : Helios 16
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>👤 Quản lý Agent</title>

        <!-- Bootstrap + FontAwesome -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

        <!-- Layout CSS (file bạn có sẵn) -->
        <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />

        <!-- CSS riêng cho bảng -->
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
                background: #fff;
                border-radius: 8px;
                overflow: hidden;
            }
            th, td {
                padding: 10px 12px;
                border: 1px solid #ddd;
                text-align: left;
                vertical-align: middle;
            }
            th {
                background: var(--primary);
                color: white;
            }
            tr:nth-child(even) {
                background-color: #f9fafc;
            }
            tr:hover {
                background-color: #eef4ff;
            }

            .action-btn {
                padding: 5px 10px;
                border-radius: 6px;
                text-decoration: none;
                color: white;
                font-weight: 500;
                display: inline-block;
                text-align: center;
            }
            .edit-btn {
                background: #28a745;
            }
            .edit-btn:hover {
                background: #1e7e34;
            }
            .delete-btn {
                background: #dc3545;
            }
            .delete-btn:hover {
                background: #a71d2a;
            }

            .no-data {
                text-align: center;
                color: red;
                font-weight: 500;
            }

            /* Giấu mật khẩu */
            td.password-cell {
                font-family: 'text-security-disc', 'Arial';
                -webkit-text-security: disc;
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
                <div class="card mb-4">
                    <div class="card-body">
                        <h2 class="text-center mb-4">👤 Quản lý Agent</h2>

                        <div class="text-end mb-3">
                            <a href="createAgent.jsp" class="btn btn-primary"><i class="fas fa-plus"></i> Thêm Agent</a>
                        </div>

                        <div class="filter-btns mb-3 d-flex gap-2">
                            <a href="AgentManagementServlet?status=Active" class="btn btn-success btn-sm">Active</a>
                            <a href="AgentManagementServlet?status=Pending" class="btn btn-warning btn-sm">Pending</a>
                            <a href="AgentManagementServlet?status=Inactive" class="btn btn-secondary btn-sm">Inactive</a>
                            <a href="AgentManagementServlet" class="btn btn-primary btn-sm">Tất cả</a>
                        </div>

                        <c:if test="${not empty message}">
                            <div class="alert alert-info">${message}</div>
                        </c:if>

                        <table class="table table-bordered table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Status</th>
                                    <th>Username</th>
                                    <th>Password</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="agent" items="${agentList}">
                                    <tr>
                                        <td>${agent.userId}</td>
                                        <td>${agent.fullName}</td>
                                        <td>${agent.email}</td>
                                        <td>${agent.phoneNumber}</td>
                                        <td>
                                            <span class="badge
                                                  ${agent.status == 'Active' ? 'bg-success' 
                                                    : agent.status == 'Pending' ? 'bg-warning' 
                                                    : 'bg-secondary'}">
                                                      ${agent.status}
                                                  </span>
                                            </td>

                                            <c:choose>
                                                <c:when test="${agent.status == 'Pending'}">
                                            <form action="AgentManagementServlet" method="post" class="d-flex gap-2 align-items-center">
                                                <input type="hidden" name="action" value="approve">
                                                <input type="hidden" name="id" value="${agent.userId}">
                                                <td><input type="text" name="username" placeholder="Username" required class="form-control form-control-sm" style="width:100px;"></td>
                                                <td><input type="text" name="password" placeholder="Password" required class="form-control form-control-sm" style="width:100px;"></td>
                                                <td>
                                                    <button type="submit" class="btn btn-success btn-sm">
                                                        <i class="fas fa-check"></i> Approve
                                                    </button>
                                                </td>
                                            </form>
                                        </c:when>

                                        <c:otherwise>
                                            <td>${agent.username}</td>
                                            <td>${agent.password}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${agent.status == 'Active'}">
                                                        <a href="AgentManagementServlet?action=deactivate&id=${agent.userId}" 
                                                           class="btn btn-danger btn-sm" 
                                                           onclick="return confirm('Deactivate this agent?')">
                                                            <i class="fas fa-ban"></i> Deactivate
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="AgentManagementServlet?action=activate&id=${agent.userId}" 
                                                           class="btn btn-success btn-sm"
                                                           onclick="return confirm('Activate this agent?')">
                                                            <i class="fas fa-play"></i> Activate
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>

                                                <a href="AgentManagementServlet?action=delete&id=${agent.userId}" 
                                                   class="btn btn-danger btn-sm"
                                                   onclick="return confirm('Delete this agent?')">
                                                    <i class="fas fa-trash"></i>
                                                </a>

                                                <a href="AgentManagementServlet?action=edit&id=${agent.userId}" 
                                                   class="btn btn-warning btn-sm">
                                                    <i class="fas fa-pen"></i>
                                                </a>
                                            </td>
                                        </c:otherwise>
                                    </c:choose>
                                    </tr>
                                </c:forEach>

                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
            </main>

            <footer class="main-footer text-muted">
                <div class="container-fluid d-flex justify-content-between py-2">
                    <div>© 2025 SWP391 - Insurance Management System</div>
                    <div><b>Version</b> 1.0</div>
                </div>
            </footer>

        </body>
    </html>






