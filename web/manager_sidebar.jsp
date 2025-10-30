<%-- 
    Document   : manager_sidebar
    Created on : Oct 25, 2025, 12:40:57 PM
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%-- Các biến ctx, currentUser, activePage sẽ được lấy từ trang cha gọi include --%>

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
        <a class="nav-link text-white py-2 <%= "dashboard".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/manager/dashboard"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
        <a class="nav-link text-white py-2 <%= "profile".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
        <a class="nav-link text-white py-2 <%= "performance".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/manager/performance"><i class="fas fa-users-cog me-2"></i> Team Performance</a>
        <a class="nav-link text-white py-2 <%= "agentMgmt".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/AgentManagementServlet?action="><i class="fas fa-users-cog me-2"></i> Agent Management</a>

        <%-- ===== MENU LEADERBOARD XỔ XUỐNG (ĐÃ SỬA) ===== --%>
        <%-- 1. Xác định xem section này có active không (cần Servlet gửi activePage="agentLeaderboard" hoặc "managerLeaderboard") --%>
        <% boolean isLeaderboardSectionActive = "agentLeaderboard".equals(activePage) || "managerLeaderboard".equals(activePage); %>
        
        <a class="nav-link text-white py-2 d-flex justify-content-between align-items-center <%= isLeaderboardSectionActive ? "active" : "" %>"
           data-bs-toggle="collapse" href="#leaderboardSubmenu" role="button" aria-expanded="<%= isLeaderboardSectionActive ? "true" : "false" %>" aria-controls="leaderboardSubmenu">
            <span><i class="fas fa-trophy me-2"></i> Leaderboard</span>
            <%-- Dùng class "leaderboard-arrow-icon" riêng biệt --%>
            <i class="fas <%= isLeaderboardSectionActive ? "fa-chevron-down" : "fa-chevron-right" %> small leaderboard-arrow-icon"></i>
        </a>
        <div class="collapse ps-3 <%= isLeaderboardSectionActive ? "show" : "" %>" id="leaderboardSubmenu">
            <%-- Link 1: Xếp hạng Agent (chúng ta sẽ đặt activePage="agentLeaderboard" cho trang này) --%>
            <a class="nav-link text-white py-1 <%= "agentLeaderboard".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/agents/leaderboard">
                 <i class="fas fa-user-friends me-2 small"></i> Agent Ranking
            </a>
            <%-- Link 2: Xếp hạng Manager (chúng ta sẽ đặt activePage="managerLeaderboard" cho trang này) --%>
            <a class="nav-link text-white py-1 <%= "managerLeaderboard".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/managers/leaderboard">
                 <i class="fas fa-sitemap me-2 small"></i> Manager Ranking
            </a>
        </div>
        <%-- ===== HẾT PHẦN SỬA LEADERBOARD ===== --%>
        <a class="nav-link text-white py-2 d-flex justify-content-between align-items-center <%= isLeaderboardSectionActive ? "active" : "" %>"
           data-bs-toggle="collapse" href="#leaderboardSubmenu" role="button" aria-expanded="<%= isLeaderboardSectionActive ? "true" : "false" %>" aria-controls="leaderboardSubmenu">
            <span><i class="fas fa-trophy me-2"></i> Policies</span>
            <%-- Dùng class "leaderboard-arrow-icon" riêng biệt --%>
            <i class="fas <%= isLeaderboardSectionActive ? "fa-chevron-down" : "fa-chevron-right" %> small leaderboard-arrow-icon"></i>
        </a>
        <div class="collapse ps-3 <%= isLeaderboardSectionActive ? "show" : "" %>" id="leaderboardSubmenu">
            <%-- Link 1: Xếp hạng Agent (chúng ta sẽ đặt activePage="agentLeaderboard" cho trang này) --%>
            <a class="nav-link text-white py-1 <%= "agentLeaderboard".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/CommissionPoliciesServlet">
                 <i class="fas fa-user-friends me-2 small"></i> Commission Policies
            </a>
            <%-- Link 2: Xếp hạng Manager (chúng ta sẽ đặt activePage="managerLeaderboard" cho trang này) --%>
            <a class="nav-link text-white py-1 <%= "managerLeaderboard".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/managers/leaderboard">
                 <i class="fas fa-sitemap me-2 small"></i> Contract Policies
            </a>
        </div>
        <a class="nav-link text-white py-2 <%= "productMgmt".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/ProductServlet?action=list"><i class="fas fa-box me-2"></i> Product</a>

        <%-- Menu Contract (Giữ nguyên) --%>
         <% boolean isContractSectionActive = "all".equals(activePage) || "pending".equals(activePage); %>
         <a class="nav-link text-white py-2 d-flex justify-content-between align-items-center <%= isContractSectionActive ? "active" : "" %>"
           data-bs-toggle="collapse" href="#contractSubmenu" role="button" aria-expanded="<%= isContractSectionActive ? "true" : "false" %>" aria-controls="contractSubmenu">
            <span><i class="fas fa-file-signature me-2"></i> Contract</span>
            <i class="fas <%= isContractSectionActive ? "fa-chevron-down" : "fa-chevron-right" %> small contract-arrow-icon"></i>
        </a>
        <div class="collapse ps-3 <%= isContractSectionActive ? "show" : "" %>" id="contractSubmenu">
            <a class="nav-link text-white py-1 <%= "all".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/manager/contracts?action=listAll">
                 <i class="fas fa-list me-2 small"></i> All Contracts
            </a>
            <a class="nav-link text-white py-1 <%= "pending".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/manager/contracts?action=listPending">
                 <i class="fas fa-check-double me-2 small"></i> Approval List
            </a>
        </div>

        
        <div class="mt-3 px-2">
            <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </nav>
</aside>

<%-- Script đổi icon (ĐÃ BỔ SUNG SCRIPT CHO LEADERBOARD) --%>
<script>
document.addEventListener('DOMContentLoaded', function () {
    
    // === Script cho Contract (Giữ nguyên) ===
    var contractCollapseElement = document.getElementById('contractSubmenu');
    var contractLinkElement = document.querySelector('a[data-bs-toggle="collapse"][href="#contractSubmenu"]');
    if (contractLinkElement) { 
        var arrowIconElement = contractLinkElement.querySelector('.contract-arrow-icon');
        if (contractCollapseElement && arrowIconElement) {
            contractCollapseElement.addEventListener('show.bs.collapse', function () {
                arrowIconElement.classList.remove('fa-chevron-right');
                arrowIconElement.classList.add('fa-chevron-down');
            });
            contractCollapseElement.addEventListener('hide.bs.collapse', function () {
                arrowIconElement.classList.remove('fa-chevron-down');
                arrowIconElement.classList.add('fa-chevron-right');
            });
        }
    }
    
    // ===== THÊM SCRIPT CHO LEADERBOARD =====
    var leaderboardCollapseElement = document.getElementById('leaderboardSubmenu');
    var leaderboardLinkElement = document.querySelector('a[data-bs-toggle="collapse"][href="#leaderboardSubmenu"]');
    
    if (leaderboardLinkElement) { // Chỉ chạy nếu tìm thấy link
        var leaderboardArrowIcon = leaderboardLinkElement.querySelector('.leaderboard-arrow-icon'); // Dùng class riêng

        if (leaderboardCollapseElement && leaderboardArrowIcon) {
            // Lắng nghe sự kiện MỞ
            leaderboardCollapseElement.addEventListener('show.bs.collapse', function () {
                leaderboardArrowIcon.classList.remove('fa-chevron-right');
                leaderboardArrowIcon.classList.add('fa-chevron-down');
            });
            // Lắng nghe sự kiện ĐÓNG
            leaderboardCollapseElement.addEventListener('hide.bs.collapse', function () {
                leaderboardArrowIcon.classList.remove('fa-chevron-down');
                leaderboardArrowIcon.classList.add('fa-chevron-right');
            });
        }
    }
    // ======================================
});
</script>