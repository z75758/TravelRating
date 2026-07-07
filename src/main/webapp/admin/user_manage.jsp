<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.User" %>
<%@ page import="com.travel.service.UserService" %>
<%@ page import="java.util.List" %>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    UserService us = new UserService();
    List<User> users = us.getAllUsers();
%>
<%@ include file="../header.jsp" %>
<main>
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <h4 style="margin-bottom:var(--space-4);">Admin Panel</h4>
            <nav>
                <ul>
                    <li><a href="dashboard.jsp">Dashboard</a></li>
                    <li><a href="destination_manage.jsp">Destinations</a></li>
                    <li><a href="user_manage.jsp" class="active">Users</a></li>
                </ul>
            </nav>
        </aside>

        <div class="admin-main">
            <div class="section-header">
                <h2>Users (<%= users.size() %>)</h2>
                <p>Manage registered user accounts.</p>
            </div>

            <div style="overflow-x:auto;">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Registered</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (User u : users) { %>
                        <tr>
                            <td><%= u.getId() %></td>
                            <td>
                                <div class="flex items-center gap-2">
                                    <span class="avatar" style="width:28px;height:28px;font-size:11px;"><%= u.getInitial() %></span>
                                    <strong><%= u.getUsername() %></strong>
                                </div>
                            </td>
                            <td><%= u.getEmail() %></td>
                            <td>
                                <% if (u.isAdmin()) { %>
                                    <span class="tag tag-blue">Admin</span>
                                <% } else { %>
                                    <span class="tag tag-green">User</span>
                                <% } %>
                            </td>
                            <td style="font-size:var(--text-xs);color:var(--color-text-tertiary);">
                                <%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0, 10) : "-" %>
                            </td>
                            <td>
                                <% if (!u.isAdmin() && u.getId() != adminUser.getId()) { %>
                                    <a href="#" class="btn btn-outline btn-sm"
                                       style="color:var(--color-error-text);border-color:var(--color-error-text);"
                                       data-confirm="Delete user <%= u.getUsername() %>? This cannot be undone.">
                                        Delete
                                    </a>
                                <% } else { %>
                                    <span style="font-size:var(--text-xs);color:var(--color-text-tertiary);">Protected</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<%@ include file="../footer.jsp" %>
