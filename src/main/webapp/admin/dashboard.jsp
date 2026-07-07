<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.User" %>
<%@ page import="com.travel.service.UserService" %>
<%@ page import="com.travel.service.DestinationService" %>
<%@ page import="com.travel.service.CommentService" %>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    UserService us = new UserService();
    DestinationService ds = new DestinationService();
    CommentService cs = new CommentService();
%>
<%@ include file="../header.jsp" %>
<main>
    <div class="admin-layout">
        <!-- Sidebar -->
        <aside class="admin-sidebar">
            <h4 style="margin-bottom:var(--space-4);">Admin Panel</h4>
            <nav>
                <ul>
                    <li><a href="dashboard.jsp" class="active">Dashboard</a></li>
                    <li><a href="destination_manage.jsp">Destinations</a></li>
                    <li><a href="user_manage.jsp">Users</a></li>
                </ul>
            </nav>
            <div style="margin-top:auto;padding-top:var(--space-6);border-top:1px solid var(--color-border);margin-top:var(--space-6);">
                <a href="<%=contextPath%>/user/logout" class="btn btn-outline btn-sm w-full" style="width:100%;">Log Out</a>
            </div>
        </aside>

        <!-- Main Content -->
        <div class="admin-main">
            <div class="section-header">
                <h2>Dashboard</h2>
                <p>System overview at a glance.</p>
            </div>

            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value"><%= ds.getCount() %></div>
                    <div class="stat-label">Total Destinations</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= us.getUserCount() %></div>
                    <div class="stat-label">Registered Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= cs.getCommentCount() %></div>
                    <div class="stat-label">Total Comments</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= ds.getAllRegions().size() %></div>
                    <div class="stat-label">Active Regions</div>
                </div>
            </div>

            <!-- Quick Actions -->
            <h3 style="margin-bottom:var(--space-4);">Quick Actions</h3>
            <div class="flex gap-2">
                <a href="destination_manage.jsp" class="btn btn-primary">Manage Destinations</a>
                <a href="user_manage.jsp" class="btn btn-outline">Manage Users</a>
                <a href="<%=contextPath%>/" class="btn btn-outline">View Site</a>
            </div>
        </div>
    </div>
</main>
<%@ include file="../footer.jsp" %>
