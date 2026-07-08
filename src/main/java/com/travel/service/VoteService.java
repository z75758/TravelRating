package com.travel.service;

import com.travel.dao.VoteDAO;

/**
 * Business logic for star-rating operations.
 */
public class VoteService {

    private final VoteDAO voteDAO = new VoteDAO();
    private final DestinationService destinationService = new DestinationService();

    /**
     * Submit a star rating (1-5). Updates the destination's average rating.
     * Returns the new average score, or -1 on error.
     */
    public double rate(int destinationId, int userId, int score) {
        if (score < 1) score = 1;
        if (score > 5) score = 5;
        double avg = voteDAO.rate(destinationId, userId, score);
        if (avg >= 0) {
            destinationService.refreshRating(destinationId);
        }
        return avg;
    }

    /**
     * Remove a user's rating for a destination.
     */
    public double removeRating(int destinationId, int userId) {
        double avg = voteDAO.removeRating(destinationId, userId);
        if (avg >= 0) {
            destinationService.refreshRating(destinationId);
        }
        return avg;
    }

    public boolean hasVoted(int userId, int destinationId) {
        return voteDAO.hasVoted(userId, destinationId);
    }

    public int getUserScore(int userId, int destinationId) {
        return voteDAO.getUserScore(userId, destinationId);
    }

    public int getVoteCount(int destinationId) {
        return voteDAO.countByDestination(destinationId);
    }

    public double getAverageScore(int destinationId) {
        return voteDAO.getAverageScore(destinationId);
    }

    public int getTotalVotes() {
        return voteDAO.totalCount();
    }
}
