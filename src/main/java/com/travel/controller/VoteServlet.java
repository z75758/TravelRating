package com.travel.controller;

import com.travel.model.User;
import com.travel.service.VoteService;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Handles vote/like toggle via AJAX.
 */
@WebServlet("/vote")
public class VoteServlet extends HttpServlet {

    private final VoteService voteService = new VoteService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        if (user == null) {
            resp.setStatus(401);
            out.print("{\"success\":false,\"message\":\"Login required\"}");
            out.flush();
            return;
        }

        try {
            int destinationId = Integer.parseInt(req.getParameter("destinationId"));
            boolean voted = voteService.toggleVote(destinationId, user.getId());
            int count = voteService.getVoteCount(destinationId);

            out.print("{\"success\":true,\"voted\":" + voted + ",\"voteCount\":" + count + "}");
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid destination ID\"}");
        }
        out.flush();
    }
}
