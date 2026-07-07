package com.travel.controller;

import com.travel.model.Destination;
import com.travel.service.DestinationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Handles search and filtering.
 */
@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private final DestinationService destinationService = new DestinationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String region = req.getParameter("region");
        String type = req.getParameter("type");
        String sortBy = req.getParameter("sortBy");

        List<Destination> results = destinationService.search(keyword, region, type, sortBy);
        List<String> regions = destinationService.getAllRegions();
        List<String> types = destinationService.getAllTypes();

        req.setAttribute("destinations", results);
        req.setAttribute("regions", regions);
        req.setAttribute("types", types);
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedRegion", region);
        req.setAttribute("selectedType", type);
        req.setAttribute("sortBy", sortBy);

        req.getRequestDispatcher("/destination/list.jsp").forward(req, resp);
    }
}
