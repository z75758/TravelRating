package com.travel.filter;

import com.travel.model.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication filter.
 * Redirects unauthenticated users to login page for protected paths.
 * Filter order is configured in web.xml (runs after EncodingFilter).
 */
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        String path = request.getRequestURI();
        String contextPath = request.getContextPath();

        // Allow static resources
        if (path.startsWith(contextPath + "/css/")
                || path.startsWith(contextPath + "/js/")
                || path.startsWith(contextPath + "/images/")
                || path.startsWith(contextPath + "/uploads/")) {
            chain.doFilter(request, response);
            return;
        }

        // Public paths
        if (path.equals(contextPath + "/")
                || path.endsWith("login.jsp")
                || path.endsWith("register.jsp")
                || path.endsWith("index.jsp")
                || path.contains("/destination/list.jsp")
                || path.contains("/destination/detail.jsp")
                || path.endsWith("/user/login")
                || path.endsWith("/user/register")
                || path.endsWith("/search")) {
            chain.doFilter(request, response);
            return;
        }

        // Protected paths
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        // Admin-only paths
        if (path.contains("/admin/") && !user.isAdmin()) {
            response.sendRedirect(contextPath + "/");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
