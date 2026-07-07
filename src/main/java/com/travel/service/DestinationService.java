package com.travel.service;

import com.travel.dao.DestinationDAO;
import com.travel.model.Destination;

import java.util.List;

/**
 * Business logic for destination operations.
 */
public class DestinationService {

    private final DestinationDAO destinationDAO = new DestinationDAO();

    public Destination getById(int id) {
        return destinationDAO.findById(id);
    }

    public List<Destination> getAll() {
        return destinationDAO.findAll();
    }

    public List<Destination> search(String keyword, String region, String type, String sortBy) {
        return destinationDAO.search(keyword, region, type, sortBy);
    }

    public List<Destination> getTop(int limit) {
        return destinationDAO.findTopByPopularity(limit);
    }

    public boolean create(Destination d) {
        return destinationDAO.create(d);
    }

    public boolean update(Destination d) {
        return destinationDAO.update(d);
    }

    public boolean delete(int id) {
        return destinationDAO.delete(id);
    }

    public void incrementPopularity(int id) {
        destinationDAO.incrementPopularity(id);
    }

    public void refreshRating(int destinationId) {
        destinationDAO.updateRating(destinationId);
    }

    public int getCount() {
        return destinationDAO.count();
    }

    public List<String> getAllRegions() {
        return destinationDAO.getAllRegions();
    }

    public List<String> getAllTypes() {
        return destinationDAO.getAllTypes();
    }
}
