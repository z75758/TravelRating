<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.User" %>
<%
    User profileUser = (User) session.getAttribute("user");
    if (profileUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<%@ include file="../header.jsp" %>
<main>
    <section class="section">
        <div class="container" style="max-width:640px;">
            <div class="section-header">
                <h2>Profile</h2>
                <p>Manage your account settings.</p>
            </div>

            <!-- Profile Form -->
            <div class="card" style="margin-bottom:var(--space-8);">
                <div class="card-body" style="padding:var(--space-8);">
                    <div class="flex items-center gap-4 mb-6">
                        <span class="avatar" style="width:64px;height:64px;font-size:var(--text-2xl);"><%= profileUser.getInitial() %></span>
                        <div>
                            <h4><%= profileUser.getUsername() %></h4>
                            <span style="font-size:var(--text-sm);color:var(--color-text-secondary);"><%= profileUser.getEmail() %></span>
                            <% if (profileUser.isAdmin()) { %>
                                <span class="tag tag-blue" style="margin-left:var(--space-2);">Admin</span>
                            <% } %>
                        </div>
                    </div>

                    <form action="<%=contextPath%>/user/profile" method="post">
                        <div class="form-group">
                            <label class="form-label" for="username">Username</label>
                            <input type="text" id="username" name="username" class="form-input"
                                   value="<%= profileUser.getUsername() %>" required minlength="2">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="email">Email</label>
                            <input type="email" id="email" name="email" class="form-input"
                                   value="<%= profileUser.getEmail() %>" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Update Profile</button>
                    </form>
                </div>
            </div>

            <!-- Change Password -->
            <div class="card">
                <div class="card-body" style="padding:var(--space-8);">
                    <h4 style="margin-bottom:var(--space-6);">Change Password</h4>
                    <form action="<%=contextPath%>/user/change-password" method="post">
                        <div class="form-group">
                            <label class="form-label" for="oldPassword">Current Password</label>
                            <input type="password" id="oldPassword" name="oldPassword" class="form-input"
                                   placeholder="Enter current password" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="newPassword">New Password</label>
                            <input type="password" id="newPassword" name="newPassword" class="form-input"
                                   placeholder="At least 6 characters" required minlength="6">
                        </div>
                        <button type="submit" class="btn btn-outline">Change Password</button>
                    </form>
                </div>
            </div>
        </div>
    </section>
</main>
<%@ include file="../footer.jsp" %>
