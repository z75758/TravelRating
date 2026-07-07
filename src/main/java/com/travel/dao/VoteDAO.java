package com.travel.dao;

import com.travel.model.Vote;
import com.travel.util.DBUtil;

import java.sql.*;

/**
 * Data Access Object for votes table.
 */
public class VoteDAO {

    /**
     * Toggle vote. If user already voted on this destination, remove it.
     * Otherwise add a new vote. Returns true if now voted, false if now un-voted.
     */
    public boolean toggleVote(int destinationId, int userId) {
        Vote existing = findByUserAndDestination(userId, destinationId);
        if (existing != null) {
            delete(existing.getId());
            return false; // un-voted
        } else {
            Vote v = new Vote();
            v.setDestinationId(destinationId);
            v.setUserId(userId);
            v.setVoteType("like");
            create(v);
            return true; // voted
        }
    }

    public boolean hasVoted(int userId, int destinationId) {
        return findByUserAndDestination(userId, destinationId) != null;
    }

    public Vote findByUserAndDestination(int userId, int destinationId) {
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

    private void create(Vote vote) {
        String sql = "INSERT INTO votes (destination_id, user_id, vote_type) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, vote.getDestinationId());
            stmt.setInt(2, vote.getUserId());
            stmt.setString(3, vote.getVoteType());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void delete(int id) {
        String sql = "DELETE FROM votes WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Vote mapRow(ResultSet rs) throws SQLException {
        Vote v = new Vote();
        v.setId(rs.getInt("id"));
        v.setDestinationId(rs.getInt("destination_id"));
        v.setUserId(rs.getInt("user_id"));
        v.setVoteType(rs.getString("vote_type"));
        v.setCreatedAt(rs.getTimestamp("created_at"));
        return v;
    }
}
