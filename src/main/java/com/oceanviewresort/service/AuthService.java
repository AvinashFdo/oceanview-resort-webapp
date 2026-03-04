package com.oceanviewresort.service;

import com.oceanviewresort.dao.UserDAO;
import com.oceanviewresort.model.User;

public class AuthService {

    private final UserDAO userDAO = new UserDAO();

    public User login(String username, String password) {

        if (username == null || username.trim().isEmpty()) return null;
        if (password == null || password.trim().isEmpty()) return null;

        User user = userDAO.findByUsername(username.trim());

        if (user == null) {
            System.out.println("LOGIN DEBUG: user not found for username=" + username);
            return null;
        }

        System.out.println("LOGIN DEBUG: found user=" + user.getUsername() + " hash=" + user.getPasswordHash());

        if (password.equals(user.getPasswordHash())) {
            return user;
        }

        System.out.println("LOGIN DEBUG: password mismatch");
        return null;
    }
}