package com.travel.model;

import java.sql.Timestamp;

/**
 * Comment entity.
 */
public class Comment {

    private int id;
    private int destinationId;
    private int userId;
    private String content;
    private int rating;   // 1-5
    private Timestamp createdAt;

    // Joined fields
    private String username;

    public Comment() {}

    // --- Getters & Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getDestinationId() { return destinationId; }
    public void setDestinationId(int destinationId) { this.destinationId = destinationId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    /**
     * Get first character of username for avatar placeholder.
     */
    public String getInitial() {
        if (username == null || username.isEmpty()) return "?";
        return username.substring(0, 1).toUpperCase();
    }
}
