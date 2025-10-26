<%-- agentPerformance.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.math.BigDecimal, java.text.DecimalFormat" %>
<%@ page import="entity.User, entity.AgentPerformanceDTO" %>
<%
    String ctx = request.getContextPath();
    
    // 1. Lấy dữ liệu từ Servlet
    User currentUser = (User) request.getAttribute("currentUser");
    String activePage = (String) request.getAttribute("activePage");
    List<AgentPerformanceDTO> teamPerformanceList = (List<AgentPerformanceDTO>) request.getAttribute("teamPerformanceList");
    Double targetAmountDemo = (Double) request.getAttribute("targetAmountDemo"); // Target mặc định (nếu có)
    String currentFilter = (String) request.getAttribute("currentFilter");
    
    // Lấy tháng/năm hiện tại (Servlet đã gửi)
    Integer currentMonth = (Integer) request.getAttribute("currentTargetMonth");
    Integer currentYear = (Integer) request.getAttribute("currentTargetYear");

    // 2. Lấy thông báo (Message) từ Session (do doPost set)
    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message"); // Xóa message sau khi lấy
    }

    // 3. Xử lý null
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (teamPerformanceList == null) teamPerformanceList = new ArrayList<>();
    if (activePage == null) activePage = "performance";
    if (currentFilter == null) currentFilter = "all";
    if (currentMonth == null) currentMonth = java.time.LocalDate.now().getMonthValue();
    if (currentYear == null) currentYear = java.time.LocalDate.now().getYear();

    // 4. Formatters
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
    DecimalFormat numberFormat = new DecimalFormat("###,###,##0"); // Format số cho target
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Agent Performance</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
    <style>
        .progress { height: 10px; }
        .progress-bar { transition: width 0.6s ease; }
        /* Style cho nút "Set Target" */
        .btn-set-target {
            font-size: 0.8rem;
            padding: 0.2rem 0.5rem;
        }
    </style>
</head>
<body>
    <%@ include file="manager_navbar.jsp" %>
    <%@ include file="manager_sidebar.jsp" %>
    
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Agent Performance Matrix (Tháng <%= currentMonth %>/<%= currentYear %>)</h1>
            
            <%-- Hiển thị thông báo (nếu có) --%>
            <% if (message != null && !message.isEmpty()) { %>
                <div class="alert <%= message.startsWith("Error:") ? "alert-danger" : "alert-success" %> alert-dismissible fade show" role="alert">
                    <%= message %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <%-- ===== BỘ LỌC (FILTER) ===== --%>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <%-- Nhóm nút Filter (bên trái) --%>
                <div class="btn-group">
                    <a href="<%= ctx %>/manager/performance" class="btn <%= "all".equals(currentFilter) ? "btn-primary" : "btn-outline-primary" %>">
                        <i class="fas fa-users me-1"></i> All Agents
                    </a>
                    <a href="<%= ctx %>/manager/performance?filter=completed" class="btn <%= "completed".equals(currentFilter) ? "btn-success" : "btn-outline-success" %>">
                        <i class="fas fa-check-circle me-1"></i> Completed Target
                    </a>
                    <a href="<%= ctx %>/manager/performance?filter=below" class="btn <%= "below".equals(currentFilter) ? "btn-warning" : "btn-outline-warning" %>">
                        <i class="fas fa-exclamation-triangle me-1"></i> Below Target
                    </a>
                </div>
                <div>
                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#setTeamTargetModal">
                        <i class="fas fa-bullseye me-1"></i> Set Team Target
                    </button>
                </div>
            </div>
            <%-- =================================== --%>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i> Team Performance Summary</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>Agent Name</th>
                                    <th class="text-end">Revenue (Active)</th>
                                    <th class="text-center">Contracts (Active)</th>
                                    <th style="width: 25%;">Target Progress (Tháng <%= currentMonth %>)</th>
                                    <th class="text-center">Actions</th> <%-- THÊM CỘT ACTIONS --%>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (teamPerformanceList.isEmpty()) { %>
                                    <tr><td colspan="6" class="text-center text-muted p-4">
                                        <% if ("completed".equals(currentFilter)) { %>
                                            No agents have completed the target.
                                        <% } else if ("below".equals(currentFilter)) { %>
                                            All agents have completed the target!
                                        <% } else { %>
                                            No performance data available for your team.
                                        <% } %>
                                    </td></tr>
                                <% } else {
                                    int index = 0;
                                    for (AgentPerformanceDTO agent : teamPerformanceList) {
                                        index++;
                                        // SỬA: Dùng target động từ DAO
                                        double target = agent.getTargetAmount(); 
                                        double progress = (target > 0) ? (agent.getTotalPremium() / target) * 100 : 0.0;
                                        String barClass = "bg-danger";
                                        if (progress >= 100) {
                                            progress = 100; barClass = "bg-success";
                                        } else if (progress >= 70) barClass = "bg-primary";
                                        else if (progress >= 40) barClass = "bg-warning";
                                %>
                                    <tr>
                                        <td class="text-center"><%= index %></td>
                                        <td class="fw-bold"><%= agent.getAgentName() %></td>
                                        <td class="text-end text-success fw-bold"><%= currencyFormat.format(agent.getTotalPremium()) %></td>
                                        <td class="text-center"><%= agent.getContractsCount() %></td>
                                        <td>
                                            <div class="progress" title="Target: <%= currencyFormat.format(target) %>">
                                                <div class="progress-bar <%= barClass %>" role="progressbar" 
                                                     style="width: <%= progress %>%;" 
                                                     aria-valuenow="<%= progress %>" aria-valuemin="0" aria-valuemax="100">
                                                </div>
                                            </div>
                                            <small class="text-muted"><%= String.format("%.0f", progress) %>% 
                                                (<%= currencyFormat.format(target) %>)
                                            </small>
                                        </td>
                                        <%-- THÊM NÚT SET TARGET --%>
                                        <td class="text-center">
                                            <button type="button" class="btn btn-outline-primary btn-sm btn-set-target" 
                                                    data-bs-toggle="modal" data-bs-target="#setTargetModal"
                                                    data-agent-id="<%= agent.getAgentId() %>" 
                                                    data-agent-name="<%= agent.getAgentName() %>"
                                                    data-agent-target="<%= numberFormat.format(agent.getTargetAmount()) %>">
                                                Set Target
                                            </button>
                                        </td>
                                    </tr>
                                <%
                                    } // end for
                                } // end if
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <%-- ================================================= --%>
<%-- MODAL (POPUP) ĐỂ SET TEAM TARGET (MỚI) --%>
<%-- ================================================= --%>
<div class="modal fade" id="setTeamTargetModal" tabindex="-1" aria-labelledby="setTeamTargetModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="setTeamTargetModalLabel">Set Team Target (Tháng <%= currentMonth %>/<%= currentYear %>)</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="<%= ctx %>/manager/performance" method="POST">
                <div class="modal-body">
                    <input type="hidden" name="action" value="setTeamTarget">
                    
                    <div class="mb-3">
                        <label for="teamTargetAmount" class="form-label">
                            Nhập Target chung cho **TẤT CẢ** Agent trong team:
                        </label>
                        <input type="number" class="form-control" id="teamTargetAmount" name="teamTargetAmount" placeholder="Ví dụ: 50000000" required>
                        <div class="form-text">
                           Lưu ý: Hành động này sẽ ghi đè Target tháng <%= currentMonth %>/<%= currentYear %> của tất cả agent trong team.
                        </div>
                    </div>
                    
                    <%-- Gửi đi tháng/năm hiện tại (ẩn) --%>
                    <input type="hidden" name="targetMonth" value="<%= currentMonth %>">
                    <input type="hidden" name="targetYear" value="<%= currentYear %>">
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-danger">Apply to All</button>
                </div>
            </form>
        </div>
    </div>
</div>                        
                            
    <%-- ================================================= --%>
    <%-- MODAL (POPUP) ĐỂ SET TARGET CA NHAN --%>
    <%-- ================================================= --%>
    <div class="modal fade" id="setTargetModal" tabindex="-1" aria-labelledby="setTargetModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="setTargetModalLabel">Set Target for <span id="modalAgentName" class="fw-bold">Agent</span></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%= ctx %>/manager/performance" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="setTarget">
                        <input type="hidden" name="agentId" id="modalAgentId" value="">
                        
                        <div class="mb-3">
                            <label for="targetAmount" class="form-label">Target Amount (VNĐ) for <span id="modalMonthYear" class="fw-bold">Tháng <%= currentMonth %>/<%= currentYear %></span>:</label>
                            <input type="number" class="form-control" id="modalTargetAmount" name="targetAmount" placeholder="Ví dụ: 50000000" required>
                        </div>
                        
                        <%-- Gửi đi tháng/năm hiện tại (ẩn) --%>
                        <input type="hidden" name="targetMonth" value="<%= currentMonth %>">
                        <input type="hidden" name="targetYear" value="<%= currentYear %>">
                        
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save Target</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <%-- ================================================= --%>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <%-- SCRIPT ĐỂ TRUYỀN DỮ LIỆU VÀO MODAL --%>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var setTargetModal = document.getElementById('setTargetModal');
            if (setTargetModal) {
                setTargetModal.addEventListener('show.bs.modal', function (event) {
                    // Nút đã kích hoạt modal
                    var button = event.relatedTarget;
                    
                    // Lấy dữ liệu từ data-bs-* attributes của nút
                    var agentId = button.getAttribute('data-agent-id');
                    var agentName = button.getAttribute('data-agent-name');
                    var agentTarget = button.getAttribute('data-agent-target').replace(/,/g, ''); // Xóa dấu phẩy (1,000,000 -> 1000000)

                    // Cập nhật nội dung của modal
                    var modalTitle = setTargetModal.querySelector('#setTargetModalLabel #modalAgentName');
                    var modalAgentIdInput = setTargetModal.querySelector('#modalAgentId');
                    var modalTargetAmountInput = setTargetModal.querySelector('#modalTargetAmount');
                    
                    modalTitle.textContent = agentName;
                    modalAgentIdInput.value = agentId;
                    modalTargetAmountInput.value = agentTarget; // Hiển thị target hiện tại
                });
            }
        });
    </script>
</body>
</html>