package com.travel.controller;

import com.travel.model.User;
import com.travel.service.CommentService;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Handles comment submission.
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

        int destinationId = Integer.parseInt(req.getParameter("destinationId"));
        String content = req.getParameter("content");
        int rating = 5;
        try {
            rating = Integer.parseInt(req.getParameter("rating"));
        } catch (NumberFormatException ignored) {}

        if (commentService.addComment(destinationId, user.getId(), content, rating)) {
            session.setAttribute("success", "Comment posted.");
        } else {
            session.setAttribute("error", "Comment cannot be empty.");
        }
        resp.sendRedirect(req.getContextPath() + "/destination/detail.jsp?id=" + destinationId);
    }
}
