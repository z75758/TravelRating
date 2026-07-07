package com.travel.service;

import com.travel.dao.UserDAO;
import com.travel.model.User;
import com.travel.util.PasswordUtil;

import java.util.List;

/**
 * Business logic for user operations.
 */
public class UserService {

    private final UserDAO userDAO = new UserDAO();

    /**
     * Register a new user.
     * @return error message, or null if success.
     */
    public String register(String username, String email, String password, String confirmPassword) {
        if (username == null || username.trim().length() < 2) {
            return "Username must be at least 2 characters.";
        }
        if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            return "Please enter a valid email address.";
        }
        if (password == null || password.length() < 6) {
            return "Password must be at least 6 characters.";
        }
        if (!password.equals(confirmPassword)) {
            return "Passwords do not match.";
        }
        if (userDAO.findByUsername(username.trim()) != null) {
            return "Username already taken.";
        }
        if (userDAO.findByEmail(email.trim()) != null) {
            return "Email already registered.";
        }

        User user = new User();
        user.setUsername(username.trim());
        user.setEmail(email.trim());
        user.setPassword(PasswordUtil.hash(password));
        user.setRole("user");

        if (userDAO.create(user)) {
            return null; // success
        }
        return "Registration failed. Please try again.";
    }

    /**
     * Login user. Returns User object if success, null if failed.
     */
    public User login(String login, String password) {
        User user = userDAO.findByUsernameOrEmail(login);
        if (user == null) return null;
        if (PasswordUtil.verify(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public User getById(int id) {
        return userDAO.findById(id);
    }

    public boolean updateProfile(User user) {
        return userDAO.update(user);
    }

    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        User user = userDAO.findById(userId);
        if (user == null) return false;
        if (!PasswordUtil.verify(oldPassword, user.getPassword())) return false;
        return userDAO.updatePassword(userId, PasswordUtil.hash(newPassword));
    }

    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    public boolean deleteUser(int id) {
        return userDAO.delete(id);
    }

    public int getUserCount() {
        return userDAO.count();
    }
}
