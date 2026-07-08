package com.travel.service;

import com.travel.dao.CommentDAO;
import com.travel.model.Comment;

import java.util.List;

/**
 * Business logic for comment operations.
 */
public class CommentService {

    private final CommentDAO commentDAO = new CommentDAO();

    public List<Comment> getByDestination(int destinationId) {
        return commentDAO.findByDestinationId(destinationId);
    }

    public boolean addComment(int destinationId, int userId, String content, int rating) {
        if (content == null || content.trim().isEmpty()) {
            return false;
        }
        if (rating < 1 || rating > 5) {
            rating = 5;
        }
        Comment c = new Comment();
        c.setDestinationId(destinationId);
        c.setUserId(userId);
        c.setContent(content.trim());
        c.setRating(rating);

        return commentDAO.create(c);
    }

    public boolean deleteComment(int id) {
        return commentDAO.delete(id);
    }

    public int getCommentCount() {
        return commentDAO.count();
    }

    public double getAvgRating(int destinationId) {
        return commentDAO.getAvgRating(destinationId);
    }
}
