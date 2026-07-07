<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TravelVote - Discover & Rate Destinations</title>
    <link rel="stylesheet" href="<%=contextPath%>/css/taste-tokens.css">
    <link rel="stylesheet" href="<%=contextPath%>/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter+Tight:wght@400;500;600;700&family=Newsreader:opsz,wght@6..72,400;6..72,500;6..72,600&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Navbar - Taste-Skill: 64px height, 1px border-bottom -->
    <nav class="navbar">
        <div class="container">
            <a href="<%=contextPath%>/" class="navbar-brand">
                <span class="brand-icon">&#9830;</span>
                TravelVote
            </a>
            <ul class="navbar-links">
                <li><a href="<%=contextPath%>/destination/list.jsp">Destinations</a></li>
                <% if (currentUser != null) { %>
                    <% if (currentUser.isAdmin()) { %>
                        <li><a href="<%=contextPath%>/admin/dashboard.jsp">Admin</a></li>
                    <% } %>
                    <li class="navbar-user">
                        <a href="<%=contextPath%>/user/profile.jsp" class="flex items-center gap-2">
                            <span class="avatar"><%= currentUser.getInitial() %></span>
                            <span><%= currentUser.getUsername() %></span>
                        </a>
                    </li>
                    <li><a href="<%=contextPath%>/user/logout" class="btn btn-outline btn-sm">Log Out</a></li>
                <% } else { %>
                    <li><a href="<%=contextPath%>/login.jsp" class="btn-login">Sign In</a></li>
                <% } %>
            </ul>
        </div>
    </nav>

    <!-- Toast / Alert Messages -->
    <%
        String error = (String) session.getAttribute("error");
        String success = (String) session.getAttribute("success");
        if (error != null) {
    %>
        <div style="max-width:600px;margin:16px auto 0;padding:0 16px;">
            <div class="alert alert-error"><%= error %></div>
        </div>
    <% session.removeAttribute("error"); } %>
    <% if (success != null) { %>
        <div style="max-width:600px;margin:16px auto 0;padding:0 16px;">
            <div class="alert alert-success"><%= success %></div>
        </div>
    <% session.removeAttribute("success"); } %>
