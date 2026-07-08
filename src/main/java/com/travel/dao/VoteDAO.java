package com.travel.dao;

import com.travel.model.Vote;
import com.travel.util.DBUtil;

import java.sql.*;

/**
 * Data Access Object for votes (star ratings) table.
 */
public class VoteDAO {

    /**
     * Submit or update a star rating. If the user already rated this destination,
     * update their score. Otherwise insert a new rating.
     * Returns the new average score, or -1 on error.
     */
    public double rate(int destinationId, int userId, int score) {
        Vote existing = findByUserAndDestination(userId, destinationId);
        if (existing != null) {
            // Update existing rating
            String sql = "UPDATE votes SET score = ? WHERE id = ?";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, score);
                stmt.setInt(2, existing.getId());
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
                return -1;
            }
        } else {
            // Insert new rating
            String sql = "INSERT INTO votes (destination_id, user_id, score) VALUES (?, ?, ?)";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, destinationId);
                stmt.setInt(2, userId);
                stmt.setInt(3, score);
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
                return -1;
            }
        }
        return getAverageScore(destinationId);
    }

    /**
     * Remove a user's rating for a destination.
     * Returns the new average score, or -1 on error.
     */
    public double removeRating(int destinationId, int userId) {
        String sql = "DELETE FROM votes WHERE destination_id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, destinationId);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
        return getAverageScore(destinationId);
    }

    /**
     * Check if a user has already rated a destination.
     */
    public boolean hasVoted(int userId, int destinationId) {
        return findByUserAndDestination(userId, destinationId) != null;
    }

    /**
     * Get a user's score for a destination, or 0 if not rated.
     */
    public int getUserScore(int userId, int destinationId) {
        Vote v = findByUserAndDestination(userId, destinationId);
        return v != null ? v.getScore() : 0;
    }

    /**
     * Get the average star rating for a destination.
     */
    public double getAverageScore(int destinationId) {
        String sql = "SELECT COALESCE(AVG(score), 0) FROM votes WHERE destination_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, destinationId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return Math.round(rs.getDouble(1) * 10.0) / 10.0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Count the number of ratings for a destination.
     */
    public int countByDestination(int destinationId) {
        String sql = "SELECT COUNT(*) FROM votes WHERE destination_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, destinationId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Total number of votes across all destinations.
     */
    public int totalCount() {
        String sql = "SELECT COUNT(*) FROM votes";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── private helpers ──

    private Vote findByUserAndDestination(int userId, int destinationId) {
        String sql = "SELECT * FROM votes WHERE user_id = ? AND destination_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, destinationId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Vote mapRow(ResultSet rs) throws SQLException {
        Vote v = new Vote();
        v.setId(rs.getInt("id"));
        v.setDestinationId(rs.getInt("destination_id"));
        v.setUserId(rs.getInt("user_id"));
        v.setScore(rs.getInt("score"));
        v.setCreatedAt(rs.getTimestamp("created_at"));
        return v;
    }
}
