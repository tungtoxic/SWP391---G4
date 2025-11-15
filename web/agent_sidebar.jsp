<%-- 
    Document   : agent_sidebar
    Created on : Oct 26, 2025, 3:19:50 PM
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
                <div class="fw-bold"><%= currentUser != null ? currentUser.getFullName() : "Agent" %></div>
                <div style="font-size:.85rem;opacity:.9">Sales Agent</div>
            </div>
        </div>
    </div>

    <%-- ===== SỬA LẠI TOÀN BỘ NAV THEO THỨ TỰ MỚI ===== --%>
    <nav class="nav flex-column px-2">
        <%-- Dùng biến activePage được truyền từ trang cha để tô sáng --%>
        
        <a class="nav-link text-white py-2 <%= "dashboard".equals(activePage) ? "active" : "" %>" href="<%= ctx %>/agent/dashboard">
            <i class="fas fa-chart-line me-2"></i> Dashboard
        </a>
        
        <a class="nav-link text-white py-2 <%= "profile".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/profile">
            <i class="fas fa-user me-2"></i> Profile
        </a>
        
        <a class="nav-link text-white py-2 <%= "leaderboard".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/agents/leaderboard">
            <i class="fas fa-trophy me-2"></i> Leaderboard
        </a>
        
        <a class="nav-link text-white py-2 <%= "commission".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/agent/commission-report">
            <i class="fas fa-percent me-2"></i> Commission Report
        </a>
        
        <a class="nav-link text-white py-2 <%= "product".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/agent/products"> <%-- Sửa link # sau --%>
            <i class="fas fa-box me-2"></i> Product
        </a>
        
        <a class="nav-link text-white py-2 <%= "contracts".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/agent/contracts">
            <i class="fas fa-file-signature me-2"></i> Contract
        </a>
        
        <a class="nav-link text-white py-2 <%= "customers".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/agent/customers">
            <i class="fas fa-users me-2"></i> Customer
        </a>
        
        <a class="nav-link text-white py-2 <%= "policies".equals(activePage) ? "active" : "" %>" href="<%=ctx%>/agent/policies"> 
            <i class="fas fa-file-alt me-2"></i> Policies
        </a>
        
        <div class="mt-3 px-2">
            <a class="btn btn-danger w-100" href="<%=ctx%>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </nav>
</aside>
