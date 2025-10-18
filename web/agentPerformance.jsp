<%--
    Document    : agentperformance.jsp
    Mục đích    : Hiển thị bảng Agent Performance Matrix cho Manager.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Agent Performance Tracking</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
    <%-- Thêm CSS tùy chỉnh cho trang này (nếu có) --%>
    <style>
        .performance-gauge { height: 10px; border-radius: 5px; overflow: hidden; background-color: #e9ecef; }
        .performance-gauge > div { transition: width 0.5s ease-in-out; }
    </style>
</head>
<body>
    <%-- Navbar dựa trên layout.css --%>
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company Manager</a>
            <ul class="navbar-nav d-flex flex-row align-items-center">
                <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/manager/dashboard">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </nav>

    <%-- Sidebar dựa trên layout.css --%>
    <aside class="sidebar bg-primary text-white">
        <div class="sidebar-top p-3">
             <div class="d-flex align-items-center mb-3">
                <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                <div>
                    <div class="fw-bold"><c:out value="${sessionScope.user.fullName}" /></div>
                    <div style="font-size:.85rem;opacity:.9"><c:out value="${sessionScope.user.roleName}" /></div>
                </div>
            </div>
        </div>
        <nav class="nav flex-column px-2">
            <a class="nav-link text-white py-2" href="<%=ctx%>/manager/dashboard"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white active py-2" href="<%=ctx%>/manager/performance-tracking"><i class="fas fa-users-line me-2"></i> Agent Performance</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-invoice-dollar me-2"></i> Commission Policies</a>
        </nav>
    </aside>

    <%-- Main Content dựa trên layout.css --%>
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Agent Performance Matrix</h1>
            
            <div class="card mb-4">
                <div class="card-header bg-primary text-white"><h5 class="mb-0"><i class="fas fa-chart-line me-2"></i> Team Sales & Target Progress</h5></div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th>#</th>
                                    <th>Agent Name</th>
                                    <th>Premium (Active HĐ)</th>
                                    <th>Contracts Sold</th>
                                    <th>Conversion Rate (Target)</th>
                                    <th>Target Progress</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%-- Lặp qua List DTO từ Servlet --%>
                                <c:choose>
                                    <c:when test="${not empty teamPerformanceList}">
                                        <c:forEach var="agent" items="${teamPerformanceList}" varStatus="loop">
                                            <tr>
                                                <td><c:out value="${loop.index + 1}" /></td>
                                                <td class="fw-bold"><c:out value="${agent.agentName}" /></td>
                                                <td>
                                                    <%-- Định dạng Premium thành triệu VNĐ --%>
                                                    <fmt:formatNumber value="${agent.totalPremium / 1000000.0}" pattern="#,##0.00" /> Triệu
                                                </td>
                                                <td><c:out value="${agent.contractsCount}" /> HĐ</td>
                                                <td>
                                                    <%-- Tỷ lệ chuyển đổi (Hiện tại là 0% vì chưa tính Leads) --%>
                                                    <fmt:formatNumber value="${agent.conversionRate * 100}" pattern="#0.0" />%
                                                </td>
                                                <td>
                                                    <%-- Ví dụ thanh tiến trình (Giả định Target là 100 Triệu) --%>
                                                    <c:set var="target" value="100000000" />
                                                    <c:set var="progress" value="${(agent.totalPremium / target) * 100}" />
                                                    
                                                    <div class="performance-gauge">
                                                        <div class="bg-info h-100" style="width: ${progress > 100 ? 100 : progress}%;"></div>
                                                    </div>
                                                    <small><fmt:formatNumber value="${progress}" pattern="#0" />%</small>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">
                                                Không có Agent nào dưới quyền quản lý hoặc chưa có Hợp đồng Active.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer text-center">
                    <a href="#"><i class="fas fa-file-export me-1"></i> Export Full Report</a>
                </div>
            </div>
            
        </div>
    </main>

    <%-- Footer dựa trên layout.css --%>
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