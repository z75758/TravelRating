package com.travel.controller;

import com.travel.model.User;
import com.travel.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Handles user registration, login, logout, profile.
 */
@WebServlet("/user/*")
public class UserServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/logout".equals(path)) {
            handleLogout(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();

        if ("/login".equals(path)) {
            handleLogin(req, resp);
        } else if ("/register".equals(path)) {
            handleRegister(req, resp);
        } else if ("/profile".equals(path)) {
            handleProfile(req, resp);
        } else if ("/change-password".equals(path)) {
            handleChangePassword(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String login = req.getParameter("login");
        String password = req.getParameter("password");

        User user = userService.login(login, password);
        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/");
            }
        } else {
            req.getSession().setAttribute("error", "Invalid username or password.");
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        String error = userService.register(username, email, password, confirmPassword);
        if (error != null) {
            req.getSession().setAttribute("error", error);
            resp.sendRedirect(req.getContextPath() + "/register.jsp");
        } else {
            req.getSession().setAttribute("success", "Registration successful. Please log in.");
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/");
    }

    private void handleProfile(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String username = req.getParameter("username");
        String email = req.getParameter("email");

        currentUser.setUsername(username);
        currentUser.setEmail(email);
        if (userService.updateProfile(currentUser)) {
            session.setAttribute("user", currentUser);
            session.setAttribute("success", "Profile updated.");
        } else {
            session.setAttribute("error", "Update failed.");
        }
        resp.sendRedirect(req.getContextPath() + "/user/profile.jsp");
    }

    private void handleChangePassword(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");

        if (userService.changePassword(user.getId(), oldPassword, newPassword)) {
            session.setAttribute("success", "Password changed.");
        } else {
            session.setAttribute("error", "Old password is incorrect.");
        }
        resp.sendRedirect(req.getContextPath() + "/user/profile.jsp");
    }
}
