package com.travel.model;

import java.sql.Timestamp;

/**
 * Vote entity — represents a user's star rating for a destination.
 * Each user can rate each destination exactly once (1–5 stars).
 */
public class Vote {

    private int id;
    private int destinationId;
    private int userId;
    private int score;       // 1–5 star rating
    private Timestamp createdAt;

    public Vote() {}

    // --- Getters & Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getDestinationId() { return destinationId; }
    public void setDestinationId(int destinationId) { this.destinationId = destinationId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
