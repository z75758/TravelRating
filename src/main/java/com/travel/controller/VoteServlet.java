package com.travel.controller;

import com.travel.model.User;
import com.travel.service.VoteService;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Handles star rating via AJAX.
 * POST /vote?action=rate     → submit/update rating (params: destinationId, score)
 * POST /vote?action=unrate   → remove rating (params: destinationId)
 * GET  /vote?destinationId=X → get current user's rating info
 */
@WebServlet("/vote")
public class VoteServlet extends HttpServlet {

    private final VoteService voteService = new VoteService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        resp.setContentType("application/json; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        if (user == null) {
            resp.setStatus(401);
            out.print("{\"success\":false,\"message\":\"Login required\"}");
            return;
        }

        String action = req.getParameter("action");

        try {
            int destinationId = Integer.parseInt(req.getParameter("destinationId"));

            if ("unrate".equals(action)) {
                // Remove rating
                double newAvg = voteService.removeRating(destinationId, user.getId());
                int count = voteService.getVoteCount(destinationId);
                out.printf("{\"success\":true,\"rated\":false,\"avgRating\":%.1f,\"voteCount\":%d}", newAvg, count);
            } else {
                // Submit or update rating
                int score = Integer.parseInt(req.getParameter("score"));
                if (score < 1) score = 1;
                if (score > 5) score = 5;

                double newAvg = voteService.rate(destinationId, user.getId(), score);
                int count = voteService.getVoteCount(destinationId);
                out.printf("{\"success\":true,\"rated\":true,\"userScore\":%d,\"avgRating\":%.1f,\"voteCount\":%d}",
                        score, newAvg, count);
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"message\":\"Invalid parameters\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        resp.setContentType("application/json; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            int destinationId = Integer.parseInt(req.getParameter("destinationId"));
            double avgRating = voteService.getAverageScore(destinationId);
            int voteCount = voteService.getVoteCount(destinationId);
            int userScore = (user != null) ? voteService.getUserScore(user.getId(), destinationId) : 0;
            boolean hasVoted = userScore > 0;

            out.printf("{\"avgRating\":%.1f,\"voteCount\":%d,\"hasVoted\":%b,\"userScore\":%d}",
                    avgRating, voteCount, hasVoted, userScore);
        } catch (NumberFormatException e) {
            out.print("{\"avgRating\":0.0,\"voteCount\":0,\"hasVoted\":false,\"userScore\":0}");
        }
    }
}
