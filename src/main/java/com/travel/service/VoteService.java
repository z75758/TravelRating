package com.travel.service;

import com.travel.dao.VoteDAO;

/**
 * Business logic for vote operations.
 */
public class VoteService {

    private final VoteDAO voteDAO = new VoteDAO();

    /**
     * Toggle vote. Returns true if now voted, false if un-voted.
     */
    public boolean toggleVote(int destinationId, int userId) {
        return voteDAO.toggleVote(destinationId, userId);
    }

    public boolean hasVoted(int userId, int destinationId) {
        return voteDAO.hasVoted(userId, destinationId);
    }

    public int getVoteCount(int destinationId) {
        return voteDAO.countByDestination(destinationId);
    }
}
