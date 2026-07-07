package com.travel.controller;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.PrintWriter;
import java.util.List;
import java.util.UUID;

/**
 * Handles image file upload via AJAX.
 * Saves to /uploads/ directory and returns the file URL as JSON.
 */
@WebServlet("/admin/upload-image")
public class ImageUploadServlet extends HttpServlet {

    // Max file size: 5MB
    private static final int MAX_FILE_SIZE = 5 * 1024 * 1024;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        resp.setContentType("application/json; charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {

            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                resp.setStatus(401);
                out.print("{\"success\":false,\"error\":\"Login required\"}");
                return;
            }

            // Check it's a multipart upload
            if (!ServletFileUpload.isMultipartContent(req)) {
                out.print("{\"success\":false,\"error\":\"No file uploaded\"}");
                return;
            }

            // Configure upload
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setSizeMax(MAX_FILE_SIZE);
            upload.setHeaderEncoding("UTF-8");

            // Get uploads directory (create if needed)
            String uploadPath = getServletContext().getRealPath("/") + "/uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            List<FileItem> items = upload.parseRequest(req);
            for (FileItem item : items) {
                if (!item.isFormField() && item.getSize() > 0) {
                    // Get original filename and extension
                    String originalName = new File(item.getName()).getName();
                    String ext = "";
                    int dot = originalName.lastIndexOf('.');
                    if (dot > 0) ext = originalName.substring(dot).toLowerCase();

                    // Only allow image types
                    if (!ext.matches("\\.(jpg|jpeg|png|gif|webp|bmp)$")) {
                        out.print("{\"success\":false,\"error\":\"Only JPG/PNG/GIF/WEBP images allowed\"}");
                        return;
                    }

                    // Generate unique filename
                    String newName = UUID.randomUUID().toString().substring(0, 8) + ext;
                    File savedFile = new File(uploadDir, newName);
                    item.write(savedFile);

                    // Return the URL
                    String imageUrl = req.getContextPath() + "/uploads/" + newName;
                    out.print("{\"success\":true,\"url\":\"" + imageUrl + "\"}");
                    return;
                }
            }

            out.print("{\"success\":false,\"error\":\"No file selected\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            try {
                resp.getWriter().print("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
            } catch (Exception ignored) {}
        }
    }
}
