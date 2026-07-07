package com.travel.controller;

import com.travel.model.Destination;
import com.travel.model.User;
import com.travel.service.DestinationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * Handles destination CRUD for admin.
 */
@WebServlet("/admin/destination/*")
public class DestinationServlet extends HttpServlet {

    private final DestinationService destinationService = new DestinationService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("create".equals(action)) {
            handleCreate(req, resp);
        } else if ("update".equals(action)) {
            handleUpdate(req, resp);
        } else if ("delete".equals(action)) {
            handleDelete(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/destination_manage.jsp");
        }
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Destination d = new Destination();
        d.setName(req.getParameter("name"));
        d.setRegion(req.getParameter("region"));
        d.setType(req.getParameter("type"));
        d.setImage(req.getParameter("image"));
        d.setDescription(req.getParameter("description"));
        d.setAddress(req.getParameter("address"));
        d.setOpenTime(req.getParameter("openTime"));
        try {
            d.setTicketPrice(new BigDecimal(req.getParameter("ticketPrice")));
        } catch (NumberFormatException e) {
            d.setTicketPrice(BigDecimal.ZERO);
        }
        d.setRating(0);
        d.setPopularity(0);
        d.setCreatedBy(((User) req.getSession().getAttribute("user")).getId());

        if (destinationService.create(d)) {
            req.getSession().setAttribute("success", "Destination added.");
        } else {
            req.getSession().setAttribute("error", "Failed to add destination.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/destination_manage.jsp");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Destination d = destinationService.getById(id);
        if (d == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/destination_manage.jsp");
            return;
        }
        d.setName(req.getParameter("name"));
        d.setRegion(req.getParameter("region"));
        d.setType(req.getParameter("type"));
        d.setImage(req.getParameter("image"));
        d.setDescription(req.getParameter("description"));
        d.setAddress(req.getParameter("address"));
        d.setOpenTime(req.getParameter("openTime"));
        try {
            d.setTicketPrice(new BigDecimal(req.getParameter("ticketPrice")));
        } catch (NumberFormatException e) {
            d.setTicketPrice(BigDecimal.ZERO);
        }

        if (destinationService.update(d)) {
            req.getSession().setAttribute("success", "Destination updated.");
        } else {
            req.getSession().setAttribute("error", "Update failed.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/destination_manage.jsp");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        if (destinationService.delete(id)) {
            req.getSession().setAttribute("success", "Destination deleted.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/destination_manage.jsp");
    }
}
