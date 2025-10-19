<%-- 
    Document    : agentperformance.jsp
    Mục đích    : Hiển thị bảng Agent Performance Matrix cho Manager.
    (Phiên bản không dùng JSTL)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="entity.User"%>
<%@page import="entity.AgentPerformanceDTO"%>
<%@page import="java.text.DecimalFormat"%>
<%
    String ctx = request.getContextPath();
    
    // Lấy thông tin User từ session
    User currentUser = (User) session.getAttribute("user");
    
    // Lấy danh sách team performance từ request
    List<AgentPerformanceDTO> teamPerformanceList = (List<AgentPerformanceDTO>) request.getAttribute("teamPerformanceList");

    // Chuẩn bị các định dạng số
    DecimalFormat premiumFormat = new DecimalFormat("#,##0.00");
    DecimalFormat percentFormat = new DecimalFormat("#0.0");
    DecimalFormat progressFormat = new DecimalFormat("#0");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Agent Performance Tracking</title>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%=ctx%>/css/layout.css" />
    <style>
        .performance-gauge { height: 10px; border-radius: 5px; overflow: hidden; background-color: #e9ecef; }
        .performance-gauge > div { transition: width 0.5s ease-in-out; }
    </style>
</head>
<body>
    <%-- Navbar --%>
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="<%=ctx%>/home.jsp">Company Manager</a>
            <ul class="navbar-nav d-flex flex-row align-items-center">
                <li class="nav-item me-3"><a class="nav-link" href="<%=ctx%>/ManagerDashboard.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>
    </nav>

    <%-- Sidebar --%>
    <aside class="sidebar bg-primary text-white">
        <div class="sidebar-top p-3">
              <div class="d-flex align-items-center mb-3">
                  <div class="avatar rounded-circle bg-white me-2" style="width:36px;height:36px;"></div>
                  <div>
                      <div class="fw-bold"><%= currentUser != null ? currentUser.getFullName() : "Manager" %></div>
                      <div style="font-size:.85rem;opacity:.9"><%= currentUser != null ? currentUser.getRoleName() : "" %></div>
                  </div>
              </div>
        </div>
        <nav class="nav flex-column px-2">
            <a class="nav-link text-white py-2" href="<%=ctx%>/manager/dashboard"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
            <a class="nav-link text-white active py-2" href="<%=ctx%>/manager/performance-tracking"><i class="fas fa-users-line me-2"></i> Agent Performance</a>
            <a class="nav-link text-white py-2" href="#"><i class="fas fa-file-invoice-dollar me-2"></i> Commission Policies</a>
        </nav>
    </aside>

    <%-- Main Content --%>
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
                                <%-- Lặp qua List DTO bằng Scriptlet --%>
                                <%
                                if (teamPerformanceList != null && !teamPerformanceList.isEmpty()) {
                                    int index = 0;
                                    for (AgentPerformanceDTO agent : teamPerformanceList) {
                                        index++;
                                %>
                                        <tr>
                                            <td><%= index %></td>
                                            <td class="fw-bold"><%= agent.getAgentName() %></td>
                                            <td>
                                                <%-- Định dạng Premium --%>
                                                <%= premiumFormat.format(agent.getTotalPremium() / 1000000.0) %> Triệu
                                            </td>
                                            <td><%= agent.getContractsCount() %> HĐ</td>
                                            <td>
                                                <%-- Tỷ lệ chuyển đổi --%>
                                                <%= percentFormat.format(agent.getConversionRate() * 100) %>%
                                            </td>
                                            <td>
                                                <%-- Tính toán thanh tiến trình --%>
                                                <%
                                                    double target = 100000000.0;
                                                    double progress = (agent.getTotalPremium() / target) * 100;
                                                    double displayProgress = progress > 100 ? 100 : progress;
                                                %>
                                                <div class="performance-gauge">
                                                    <div class="bg-info h-100" style="width: <%= displayProgress %>%;"></div>
                                                </div>
                                                <small><%= progressFormat.format(progress) %>%</small>
                                            </td>
                                        </tr>
                                <%
                                    } // end for
                                } else { // nếu list rỗng
                                %>
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-4">
                                            Không có Agent nào dưới quyền quản lý hoặc chưa có Hợp đồng Active.
                                        </td>
                                    </tr>
                                <%
                                } // end if-else
                                %>
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