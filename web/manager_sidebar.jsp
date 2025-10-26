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
                <%-- Dùng biến currentUser được truyền từ trang cha --%>
                <div class="fw-bold"><%= currentUser != null ? currentUser.getFullName() : "Manager" %></div>
                <div style="font-size:.85rem;opacity:.9">Manager</div>
            </div>
        </div>
    </div>

    <nav class="nav flex-column px-2">
        <%-- Dùng biến activePage được truyền từ trang cha để tô sáng --%>
        <a class="nav-link text-white py-2 <%= "dashboard".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/ManagerDashboard.jsp"><i class="fas fa-chart-line me-2"></i> Dashboard</a>
        <a class="nav-link text-white py-2 <%= "profile".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/profile.jsp"><i class="fas fa-user me-2"></i> Profile</a>
        <a class="nav-link text-white py-2 <%= "performance".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/manager/performance"><i class="fas fa-users-cog me-2"></i> Team Performance</a>
        <a class="nav-link text-white py-2 <%= "agentMgmt".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/agentmanagement.jsp"><i class="fas fa-users-cog me-2"></i> Agent Management</a>
        <a class="nav-link text-white py-2 <%= "leaderboard".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/managers/leaderboard"><i class="fas fa-trophy me-2"></i> Leader Board</a>
        <a class="nav-link text-white py-2 <%= "commPolicies".equals(activePage) ? "active" : "" %>" href="#"><i class="fas fa-file-invoice-dollar me-2"></i> Commission Policies</a>
        <a class="nav-link text-white py-2 <%= "productMgmt".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/productmanagement.jsp"><i class="fas fa-box me-2"></i> Product</a>

        <%-- Menu Contract xổ xuống (Logic active + Mở sẵn nếu cần) --%>
         <% boolean isContractSectionActive = "all".equals(activePage) || "pending".equals(activePage); %>
         <a class="nav-link text-white py-2 d-flex justify-content-between align-items-center <%= isContractSectionActive ? "active" : "" %>"
           data-bs-toggle="collapse" href="#contractSubmenu" role="button" aria-expanded="<%= isContractSectionActive ? "true" : "false" %>" aria-controls="contractSubmenu">
            <span><i class="fas fa-file-signature me-2"></i> Contract</span>
            <%-- Icon mũi tên ban đầu dựa trên trạng thái active, dùng class riêng --%>
            <i class="fas <%= isContractSectionActive ? "fa-chevron-down" : "fa-chevron-right" %> small contract-arrow-icon"></i>
        </a>
        <%-- Thêm class 'show' nếu section đang active để menu mở sẵn --%>
        <div class="collapse ps-3 <%= isContractSectionActive ? "show" : "" %>" id="contractSubmenu">
            <a class="nav-link text-white py-1 <%= "all".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/manager/contracts?action=listAll">
                 <i class="fas fa-list me-2 small"></i> All Contracts
            </a>
            <a class="nav-link text-white py-1 <%= "pending".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/manager/contracts?action=listPending">
                 <i class="fas fa-check-double me-2 small"></i> Approval List
            </a>
        </div>

        <a class="nav-link text-white py-2 <%= "policies".equals(activePage) ? "active" : "" %>" href="#"><i class="fas fa-file-alt me-2"></i> Policies</a>
        <div class="mt-3 px-2">
            <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </nav>
</aside>

<%-- Script đổi icon mũi tên đặt ngay trong file sidebar này --%>
<script>
document.addEventListener('DOMContentLoaded', function () {
    var contractCollapseElement = document.getElementById('contractSubmenu');
    // Tìm thẻ a điều khiển collapse một cách đáng tin cậy hơn
    var contractLinkElement = document.querySelector('a[data-bs-toggle="collapse"][href="#contractSubmenu"]');

    if (contractLinkElement) { // Chỉ chạy nếu tìm thấy link điều khiển
        var arrowIconElement = contractLinkElement.querySelector('.contract-arrow-icon'); // Sử dụng class riêng để tìm icon

        if (contractCollapseElement && arrowIconElement) {
            // Lắng nghe sự kiện MỞ
            contractCollapseElement.addEventListener('show.bs.collapse', function () {
                arrowIconElement.classList.remove('fa-chevron-right');
                arrowIconElement.classList.add('fa-chevron-down');
            });
            // Lắng nghe sự kiện ĐÓNG
            contractCollapseElement.addEventListener('hide.bs.collapse', function () {
                arrowIconElement.classList.remove('fa-chevron-down');
                arrowIconElement.classList.add('fa-chevron-right');
            });
        }
    }
});
</script>