<%-- 
    Document   : agent_navbar
    Created on : Oct 26, 2025, 3:18:53 PM
    Author     : Nguyễn Tùng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="<%= ctx %>/agent/dashboard">Agent Portal</a>
        <ul class="navbar-nav d-flex flex-row align-items-center">
            <li class="nav-item me-3">
                <a class="nav-link" href="<%= ctx %>/agent/dashboard">Dashboard</a>
            </li>
            <a class="nav-link" href="#">
                        <i class="fas fa-bell"></i>
                        <span class="badge rounded-pill badge-notification bg-danger">1</span>
                    </a>
        </ul>
    </div>
</nav>