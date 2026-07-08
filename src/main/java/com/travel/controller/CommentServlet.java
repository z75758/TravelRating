package com.travel.controller;

import com.travel.model.User;
import com.travel.service.CommentService;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Handles comment submission and deletion.
 */
@WebServlet("/comment")
public class CommentServlet extends HttpServlet {

    private final CommentService commentService = new CommentService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            handleDelete(req, resp, user);
        } else {
            handleAdd(req, resp, user);
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int destinationId = Integer.parseInt(req.getParameter("destinationId"));
        String content = req.getParameter("content");
        int rating = 5;
        try {
            rating = Integer.parseInt(req.getParameter("rating"));
        } catch (NumberFormatException ignored) {}

        if (commentService.addComment(destinationId, user.getId(), content, rating)) {
            req.getSession().setAttribute("success", "Comment posted.");
        } else {
            req.getSession().setAttribute("error", "Comment cannot be empty.");
        }
        resp.sendRedirect(req.getContextPath() + "/destination/detail.jsp?id=" + destinationId);
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int commentId = Integer.parseInt(req.getParameter("commentId"));
        int destinationId = Integer.parseInt(req.getParameter("destinationId"));

        String error = commentService.deleteComment(commentId, user.getId(), user.isAdmin());
        if (error != null) {
            req.getSession().setAttribute("error", error);
        } else {
            req.getSession().setAttribute("success", "评论已删除。");
        }
        resp.sendRedirect(req.getContextPath() + "/destination/detail.jsp?id=" + destinationId);
    }
}
