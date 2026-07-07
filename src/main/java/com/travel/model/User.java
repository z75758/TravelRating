package com.travel.model;

import java.sql.Timestamp;

/**
 * User entity.
 */
public class User {

    private int id;
    private String username;
    private String email;
    private String password;   // hashed
    private String avatar;
    private String role;       // "user" or "admin"
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public User() {}

    public User(int id, String username, String email, String password, String role) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    // --- Getters & Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isAdmin() { return "admin".equals(role); }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    /**
     * Get the first character of username for avatar placeholder.
     */
    public String getInitial() {
        if (username == null || username.isEmpty()) return "?";
        return username.substring(0, 1).toUpperCase();
    }
}
