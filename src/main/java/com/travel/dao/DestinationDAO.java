package com.travel.dao;

import com.travel.model.Destination;
import com.travel.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for destinations table.
 * All queries use PreparedStatement to prevent SQL injection.
 */
public class DestinationDAO {

    public Destination findById(int id) {
        String sql = "SELECT d.*, (SELECT COUNT(*) FROM votes WHERE destination_id = d.id) AS vote_count "
                   + "FROM destinations d WHERE d.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Destination> findAll() {
        List<Destination> list = new ArrayList<>();
        String sql = "SELECT d.*, (SELECT COUNT(*) FROM votes WHERE destination_id = d.id) AS vote_count "
                   + "FROM destinations d ORDER BY d.popularity DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Destination> search(String keyword, String region, String type, String sortBy) {
        StringBuilder sql = new StringBuilder(
            "SELECT d.*, (SELECT COUNT(*) FROM votes WHERE destination_id = d.id) AS vote_count "
            + "FROM destinations d WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (d.name LIKE ? OR d.description LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }
        if (region != null && !region.trim().isEmpty()) {
            sql.append("AND d.region = ? ");
            params.add(region.trim());
        }
        if (type != null && !type.trim().isEmpty()) {
            sql.append("AND d.type = ? ");
            params.add(type.trim());
        }

        // Sort
        if ("rating".equals(sortBy)) {
            sql.append("ORDER BY d.rating DESC");
        } else if ("popularity".equals(sortBy)) {
            sql.append("ORDER BY d.popularity DESC");
        } else if ("newest".equals(sortBy)) {
            sql.append("ORDER BY d.created_at DESC");
        } else {
            sql.append("ORDER BY d.popularity DESC");
        }

        List<Destination> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Destination> findTopByPopularity(int limit) {
        List<Destination> list = new ArrayList<>();
        String sql = "SELECT d.*, (SELECT COUNT(*) FROM votes WHERE destination_id = d.id) AS vote_count "
                   + "FROM destinations d ORDER BY d.popularity DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean create(Destination d) {
        String sql = "INSERT INTO destinations (name, region, type, image, description, address, "
                   + "open_time, ticket_price, rating, popularity, created_by) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, d.getName());
            stmt.setString(2, d.getRegion());
            stmt.setString(3, d.getType());
            stmt.setString(4, d.getImage());
            stmt.setString(5, d.getDescription());
            stmt.setString(6, d.getAddress());
            stmt.setString(7, d.getOpenTime());
            stmt.setBigDecimal(8, d.getTicketPrice());
            stmt.setDouble(9, d.getRating());
            stmt.setInt(10, d.getPopularity());
            stmt.setInt(11, d.getCreatedBy());
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = stmt.getGeneratedKeys()) {
                    if (keys.next()) d.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Destination d) {
        String sql = "UPDATE destinations SET name=?, region=?, type=?, image=?, description=?, "
                   + "address=?, open_time=?, ticket_price=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, d.getName());
            stmt.setString(2, d.getRegion());
            stmt.setString(3, d.getType());
            stmt.setString(4, d.getImage());
            stmt.setString(5, d.getDescription());
            stmt.setString(6, d.getAddress());
            stmt.setString(7, d.getOpenTime());
            stmt.setBigDecimal(8, d.getTicketPrice());
            stmt.setInt(9, d.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM destinations WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void incrementPopularity(int id) {
        String sql = "UPDATE destinations SET popularity = popularity + 1 WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateRating(int destinationId) {
        String sql = "UPDATE destinations d SET d.rating = "
                   + "(SELECT COALESCE(AVG(v.score), 0) FROM votes v WHERE v.destination_id = ?) "
                   + "WHERE d.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, destinationId);
            stmt.setInt(2, destinationId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int count() {
        String sql = "SELECT COUNT(*) FROM destinations";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<String> getAllRegions() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT region FROM destinations ORDER BY region";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) list.add(rs.getString("region"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getAllTypes() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT type FROM destinations ORDER BY type";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) list.add(rs.getString("type"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Destination mapRow(ResultSet rs) throws SQLException {
        Destination d = new Destination();
        d.setId(rs.getInt("id"));
        d.setName(rs.getString("name"));
        d.setRegion(rs.getString("region"));
        d.setType(rs.getString("type"));
        d.setImage(rs.getString("image"));
        d.setDescription(rs.getString("description"));
        d.setAddress(rs.getString("address"));
        d.setOpenTime(rs.getString("open_time"));
        d.setTicketPrice(rs.getBigDecimal("ticket_price"));
        d.setRating(rs.getDouble("rating"));
        d.setPopularity(rs.getInt("popularity"));
        d.setCreatedBy(rs.getInt("created_by"));
        d.setCreatedAt(rs.getTimestamp("created_at"));
        d.setUpdatedAt(rs.getTimestamp("updated_at"));
        try {
            d.setVoteCount(rs.getInt("vote_count"));
        } catch (SQLException ignored) {}
        return d;
    }
}
