package com.travel.controller;

import com.travel.model.User;
import com.travel.service.CommentService;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 * Handles comment submission (with optional image upload) and deletion.
 */
@WebServlet("/comment")
public class CommentServlet extends HttpServlet {

    private final CommentService commentService = new CommentService();

    // Allowed image types
    private static final String[] ALLOWED_TYPES = {".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"};
    private static final long MAX_SIZE = 5 * 1024 * 1024; // 5MB

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Check if this is a multipart upload (has file) or plain form (delete action)
        boolean isMultipart = ServletFileUpload.isMultipartContent(req);

        if (isMultipart) {
            handleAddWithImage(req, resp, user);
        } else {
            // Plain form: could be delete or old-style add without image
            String action = req.getParameter("action");
            if ("delete".equals(action)) {
                handleDelete(req, resp, user);
            } else {
                handleAdd(req, resp, user);
            }
        }
    }

    /**
     * Handle comment with optional image upload (multipart form).
     */
    private void handleAddWithImage(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");
            upload.setSizeMax(MAX_SIZE);

            List<FileItem> items = upload.parseRequest(req);

            int destinationId = 0;
            String content = "";
            int rating = 5;
            String imagePath = null;

            for (FileItem item : items) {
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    // Use raw bytes + new String to ensure proper UTF-8 decoding
                    String value = new String(item.get(), "UTF-8");
                    switch (fieldName) {
                        case "destinationId": destinationId = Integer.parseInt(value); break;
                        case "content": content = value; break;
                        case "rating":
                            try { rating = Integer.parseInt(value); } catch (NumberFormatException ignored) {}
                            break;
                    }
                } else {
                    // File upload
                    String fileName = item.getName();
                    if (fileName != null && !fileName.isEmpty()) {
                        // Validate file extension
                        String ext = fileName.substring(fileName.lastIndexOf('.')).toLowerCase();
                        boolean allowed = false;
                        for (String t : ALLOWED_TYPES) {
                            if (t.equals(ext)) { allowed = true; break; }
                        }
                        if (allowed && item.getSize() > 0) {
                            // Generate UUID filename
                            String newName = UUID.randomUUID().toString() + ext;
                            String uploadDir = getServletContext().getRealPath("/uploads");
                            File uploadDirFile = new File(uploadDir);
                            if (!uploadDirFile.exists()) {
                                uploadDirFile.mkdirs();
                            }
                            File savedFile = new File(uploadDirFile, newName);
                            item.write(savedFile);
                            imagePath = req.getContextPath() + "/uploads/" + newName;
                        }
                    }
                }
            }

            if (commentService.addComment(destinationId, user.getId(), content, rating, imagePath)) {
                req.getSession().setAttribute("success", "评论发表成功！");
            } else {
                req.getSession().setAttribute("error", "评论内容不能为空。");
            }
            resp.sendRedirect(req.getContextPath() + "/destination/detail.jsp?id=" + destinationId);

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "评论提交失败，请重试。");
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    /**
     * Handle plain text comment (no image, backwards compatible).
     */
    private void handleAdd(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int destinationId = Integer.parseInt(req.getParameter("destinationId"));
        String content = req.getParameter("content");
        int rating = 5;
        try {
            rating = Integer.parseInt(req.getParameter("rating"));
        } catch (NumberFormatException ignored) {}

        if (commentService.addComment(destinationId, user.getId(), content, rating, null)) {
            req.getSession().setAttribute("success", "Comment posted.");
        } else {
            req.getSession().setAttribute("error", "Comment cannot be empty.");
        }
        resp.sendRedirect(req.getContextPath() + "/destination/detail.jsp?id=" + destinationId);
    }

    /**
     * Handle comment deletion.
     */
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        int commentId = Integer.parseInt(req.getParameter("commentId"));
        int destinationId = Integer.parseInt(req.getParameter("destinationId"));

        String error = commentService.deleteComment(commentId, user.getId(), user.isAdmin());
        if (error != null) {
            req.getSession().setAttribute("error", error);
        } else {
            req.getSession().setAttribute("success", "评论已删除。");
        }
        resp.sendRedirect(req.getContextPath() + "/destination/detail.jsp?id=" + destinationId);
    }
}
