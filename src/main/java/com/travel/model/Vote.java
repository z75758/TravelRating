package com.travel.model;

import java.sql.Timestamp;

/**
 * Vote entity.
 */
public class Vote {

    private int id;
    private int destinationId;
    private int userId;
    private String voteType;   // "like" or "recommend"
    private Timestamp createdAt;

    public Vote() {}

    // --- Getters & Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getDestinationId() { return destinationId; }
    public void setDestinationId(int destinationId) { this.destinationId = destinationId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getVoteType() { return voteType; }
    public void setVoteType(String voteType) { this.voteType = voteType; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
