package com.travel.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Destination entity.
 */
public class Destination {

    private int id;
    private String name;
    private String region;
    private String type;
    private String image;
    private String description;
    private String address;
    private String openTime;
    private BigDecimal ticketPrice;
    private double rating;
    private int popularity;
    private int createdBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Optional joined fields
    private int voteCount;

    public Destination() {}

    // --- Getters & Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getRegion() { return region; }
    public void setRegion(String region) { this.region = region; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getOpenTime() { return openTime; }
    public void setOpenTime(String openTime) { this.openTime = openTime; }

    public BigDecimal getTicketPrice() { return ticketPrice; }
    public void setTicketPrice(BigDecimal ticketPrice) { this.ticketPrice = ticketPrice; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public int getPopularity() { return popularity; }
    public void setPopularity(int popularity) { this.popularity = popularity; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public int getVoteCount() { return voteCount; }
    public void setVoteCount(int voteCount) { this.voteCount = voteCount; }

    /**
     * Format ticket price for display.
     */
    public String getTicketPriceDisplay() {
        if (ticketPrice == null || ticketPrice.compareTo(BigDecimal.ZERO) == 0) {
            return "Free";
        }
        return "¥" + ticketPrice.stripTrailingZeros().toPlainString();
    }
}
