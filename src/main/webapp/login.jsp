<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<main>
    <div class="auth-container">
        <div class="auth-card reveal">
            <h2>Welcome back</h2>
            <p class="subtitle">Sign in to your account to continue.</p>
            <form action="<%=contextPath%>/user/login" method="post">
                <div class="form-group">
                    <label class="form-label" for="login">Username or Email</label>
                    <input type="text" id="login" name="login" class="form-input"
                           placeholder="Enter your username or email" required autocomplete="username">
                </div>
                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-input"
                           placeholder="Enter your password" required autocomplete="current-password">
                </div>
                <button type="submit" class="btn btn-primary w-full" style="width:100%;">Sign In</button>
            </form>
            <div class="auth-footer">
                Don't have an account? <a href="<%=contextPath%>/register.jsp">Sign up</a>
            </div>
        </div>
    </div>
</main>
<%@ include file="footer.jsp" %>
