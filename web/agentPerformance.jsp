<%-- agentPerformance.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.math.BigDecimal, java.text.DecimalFormat" %>
<%@ page import="entity.User, entity.AgentPerformanceDTO" %>
<%
    String ctx = request.getContextPath();

    // 1. Lấy dữ liệu (Giữ nguyên)
    User currentUser = (User) request.getAttribute("currentUser");
    String activePage = (String) request.getAttribute("activePage");
    List<AgentPerformanceDTO> teamPerformanceList = (List<AgentPerformanceDTO>) request.getAttribute("teamPerformanceList");
    String currentFilter = (String) request.getAttribute("currentFilter");
    Integer currentMonth = (Integer) request.getAttribute("currentTargetMonth");
    Integer currentYear = (Integer) request.getAttribute("currentTargetYear");
    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message"); 
    }

    // 2. Xử lý null (Giữ nguyên)
    if (currentUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (teamPerformanceList == null) teamPerformanceList = new ArrayList<>();
    if (activePage == null) activePage = "performance";
    if (currentFilter == null) currentFilter = "all";
    if (currentMonth == null) currentMonth = java.time.LocalDate.now().getMonthValue();
    if (currentYear == null) currentYear = java.time.LocalDate.now().getYear();

    // 3. Formatters (Giữ nguyên)
    DecimalFormat currencyFormat = new DecimalFormat("###,###,##0 'VNĐ'");
    DecimalFormat numberFormat = new DecimalFormat("###,###,##0"); 
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Agent Performance</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="<%= ctx %>/css/layout.css" />
    
    <%-- Style (Giữ nguyên) --%>
    <style>
        .progress-bar { transition: width 0.6s ease; }
        .btn-set-target {
            font-size: 0.8rem;
            padding: 0.2rem 0.5rem;
        }
        .progress-stack {
            position: relative; 
            background-color: #e9ecef; 
            overflow: hidden;
        }
        .progress-bar-over {
            position: absolute; 
            top: 0;
            left: 0; 
            height: 100%;
            background-color: #0dcaf0; 
            background-image: linear-gradient(45deg, rgba(255, 255, 255, 0.15) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, 0.15) 50%, rgba(255, 255, 255, 0.15) 75%, transparent 75%, transparent);
            background-size: 1rem 1rem;
            transition: width 0.6s ease;
        }
    </style>
</head>
<body>
    <%@ include file="manager_navbar.jsp" %>
    <%@ include file="manager_sidebar.jsp" %>
    
    <main class="main-content">
        <div class="container-fluid">
            <h1 class="mb-4">Agent Performance Matrix (Tháng <%= currentMonth %>/<%= currentYear %>)</h1>
            
            <%-- Hiển thị thông báo (Message) (Giữ nguyên) --%>
            <% if (message != null && !message.isEmpty()) { %>
                <div class="alert <%= message.startsWith("Error:") ? "alert-danger" : "alert-success" %> alert-dismissible fade show" role="alert">
                    <%= message %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <%-- Bộ LỌC (FILTER) (Giữ nguyên) --%>
            <div class="d-flex justify-content-between align-items-center mb-3">
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

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i> Team Performance Summary</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            
                            <%-- Header (Giữ nguyên) --%>
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>Agent Name</th>
                                    <th class="text-end">Revenue (Active)</th>
                                    <th class="text-center">Contracts (Active)</th>
                                    <th style="width: 25%;">Target Progress (Tháng <%= currentMonth %>)</th>
                                    <th class="text-center">Achievement</th> 
                                    <th class="text-center">Actions</th> 
                                </tr>
                            </thead>

                            <tbody>
                                <% if (teamPerformanceList.isEmpty()) { %>
                                    <tr><td colspan="7" class="text-center text-muted p-4">
                                        <%-- (Code "Không tìm thấy" (Not Found) giữ nguyên) --%>
                                    </td></tr>
                                <% } else {
                                    int index = 0;
                                    for (AgentPerformanceDTO agent : teamPerformanceList) {
                                        index++;
                                        
                                        // === Logic Tính toán (Giữ nguyên) ===
                                        double target = agent.getTargetAmount();
                                        double totalPremium = agent.getTotalPremium();
                                        double overAchievementPercent = agent.getOverAchievementRate(); 
                                        double baseProgressPercent = (target > 0) ? (totalPremium / target) * 100 : 0;
                                        double barProgressDisplay = Math.min(100, baseProgressPercent);
                                        double overBarDisplay = Math.min(100, overAchievementPercent); 

                                        String barClass = "bg-danger";
                                        if (overAchievementPercent > 0) barClass = "bg-success";
                                        else if (baseProgressPercent >= 70) barClass = "bg-primary";
                                        else if (baseProgressPercent >= 40) barClass = "bg-warning";

                                        String achievementBadge = "";
                                        String badgeClass = "secondary";
                                        if (overAchievementPercent >= 50) {
                                            achievementBadge = "Super Star";
                                            badgeClass = "warning text-dark"; 
                                        } else if (overAchievementPercent >= 25) { 
                                            achievementBadge = "High Performer";
                                            badgeClass = "success"; 
                                        } else if (overAchievementPercent > 0) {
                                            achievementBadge = "Achiever";
                                            badgeClass = "info text-dark"; 
                                        } else if (baseProgressPercent >= 100) { 
                                            achievementBadge = "On Target";
                                            badgeClass = "primary"; 
                                        }
                                        
                                        // (KHÔNG (NO) CẦN "isAlreadyCompleted" NỮA)
                                        // ===================================
                                %>
                                    <tr>
                                        <td class="text-center"><%= index %></td>
                                        <td class="fw-bold"><%= agent.getAgentName() %></td>
                                        <td class="text-end text-success fw-bold"><%= currencyFormat.format(agent.getTotalPremium()) %></td>
                                        <td class="text-center"><%= agent.getContractsCount() %></td>
                                        
                                        <%-- Cột Progress Bar (Giữ nguyên) --%>
                                        <td>
                                            <div class="progress progress-stack" title="Target: <%= currencyFormat.format(target) %>">
                                                <div class="progress-bar <%= barClass %>" role="progressbar" 
                                                     style="width: <%= barProgressDisplay %>%;" 
                                                     title="Đạt <%= String.format("%.0f", baseProgressPercent) %>% target">
                                                </div>
                                                <% if (overBarDisplay > 0) { %>
                                                    <div class="progress-bar-over" 
                                                         style="width: <%= overBarDisplay %>%;" 
                                                         title="Vượt target: <%= String.format("%.0f", overAchievementPercent) %>%">
                                                    </div>
                                                <% } %>
                                            </div>
                                            
                                            <div class="mt-1">
                                                <small class="text-muted">
                                                    <strong><%= String.format("%.0f", baseProgressPercent) %>%</strong> 
                                                    (<%= currencyFormat.format(target) %>)
                                                    
                                                    <% if (overAchievementPercent > 0) { %>
                                                        <span class="text-success fw-bold">
                                                            <i class="fas fa-arrow-up"></i> 
                                                            +<%= String.format("%.0f", overAchievementPercent) %>% Vượt
                                                        </span>
                                                    <% } else if (baseProgressPercent >= 100) { %>
                                                        <span class="text-success">
                                                            <i class="fas fa-check-circle"></i> Đã hoàn thành
                                                        </span>
                                                    <% } %>
                                                </small>
                                            </div>
                                        </td>
                                        
                                        <%-- Cột Huy hiệu (Giữ nguyên) --%>
                                        <td class="text-center">
                                            <% if (!achievementBadge.isEmpty()) { %>
                                                <span class="badge bg-<%= badgeClass %>">
                                                    <i class="fas fa-trophy me-1"></i>
                                                    <%= achievementBadge %>
                                                </span>
                                            <% } %>
                                        </td>
                                        
                                        <%-- === BƯỚC "VÁ" (PATCH) (GỠ BỎ "disabled") === --%>
                                        <td class="text-center">
                                            <button type="button" class="btn btn-outline-primary btn-sm btn-set-target" 
                                                    data-bs-toggle="modal" data-bs-target="#setTargetModal"
                                                    data-agent-id="<%= agent.getAgentId() %>" 
                                                    data-agent-name="<%= agent.getAgentName() %>"
                                                    data-agent-target="<%= numberFormat.format(agent.getTargetAmount()) %>"
                                                    title="Set Target"
                                                    >
                                                Set Target
                                            </button>
                                        </td>
                                        <%-- ============================================= --%>
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
    <%-- MODAL (POPUP) ĐỂ SET TEAM TARGET (SỬA TEXT) --%>
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
                            
                            <%-- "VÁ" (PATCH) LẠI TEXT TRỢ GIÚP (GỠ BỎ "KHÓA") --%>
                            <div class="form-text">
                                Lưu ý: Áp dụng cho TẤT CẢ agents. (Sẽ bị 'chặn' (block) nếu Target mới < Doanh số (Sales) hiện tại).
                            </div>
                        </div>
                        
                        <input type="hidden" name="targetMonth" value="<%= currentMonth %>">
                        <input type="hidden" name="targetYear" value="<%= currentYear %>">
                        
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-danger">Apply to Team</button>
                    </div>
                </form>
            </div>
        </div>
    </div>    
    
    <%-- ================================================= --%>
    <%-- MODAL (POPUP) ĐỂ SET TARGET CA NHAN (Giữ nguyên) --%>
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
    
    <%-- SCRIPT ĐỂ TRUYỀN DỮ LIỆU VÀO MODAL (Giữ nguyên) --%>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var setTargetModal = document.getElementById('setTargetModal');
            if (setTargetModal) {
                setTargetModal.addEventListener('show.bs.modal', function (event) {
                    var button = event.relatedTarget;
                    var agentId = button.getAttribute('data-agent-id');
                    var agentName = button.getAttribute('data-agent-name');
                    var agentTarget = button.getAttribute('data-agent-target').replace(/,/g, ''); 

                    var modalTitle = setTargetModal.querySelector('#setTargetModalLabel #modalAgentName');
                    var modalAgentIdInput = setTargetModal.querySelector('#modalAgentId');
                    var modalTargetAmountInput = setTargetModal.querySelector('#modalTargetAmount');
                    
                    modalTitle.textContent = agentName;
                    modalAgentIdInput.value = agentId;
                    modalTargetAmountInput.value = agentTarget; 
                });
            }
        });
    </script>
</body>
</html>