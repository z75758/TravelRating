package com.travel.util;

/**
 * Security utility: XSS sanitisation and SQL injection prevention.
 * Note: SQL injection is primarily prevented by using PreparedStatement in DAO layer.
 */
public class SecurityUtil {

    /**
     * Strip HTML tags to prevent XSS.
     * Converts < > & " to safe HTML entities.
     */
    public static String sanitize(String input) {
        if (input == null) return null;
        return input
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;")
                .replace("/", "&#x2F;");
    }

    /**
     * Strip all HTML tags completely (for plain-text fields).
     */
    public static String stripHtml(String input) {
        if (input == null) return null;
        return input.replaceAll("<[^>]*>", "");
    }

    /**
     * Trim + sanitize for display safety.
     */
    public static String clean(String input) {
        if (input == null) return "";
        return sanitize(input.trim());
    }
}
