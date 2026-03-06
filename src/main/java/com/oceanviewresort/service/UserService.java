package com.oceanviewresort.service;

import com.oceanviewresort.dao.UserDAO;
import com.oceanviewresort.model.User;

public class UserService {

    private final UserDAO userDAO = new UserDAO();

    public String createReceptionist(String username, String password) {

        if (username == null || username.trim().isEmpty()) {
            return "Username is required.";
        }

        if (password == null || password.trim().isEmpty()) {
            return "Password is required.";
        }

        username = username.trim();
        password = password.trim();

        if (username.length() < 4) {
            return "Username must be at least 4 characters.";
        }

        if (password.length() < 4) {
            return "Password must be at least 4 characters.";
        }

        User existing = userDAO.findByUsername(username);
        if (existing != null) {
            return "Username already exists.";
        }

        User user = new User();
        user.setUsername(username);
        user.setPasswordHash(password); // keeping same plain-text style as your current login
        user.setRole("RECEPTIONIST");
        user.setActive(true);

        boolean created = userDAO.createUser(user);

        if (created) {
            return "SUCCESS";
        }

        return "Failed to create user.";
    }
}