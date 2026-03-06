package com.oceanviewresort.controller;

import com.oceanviewresort.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/users/create")
public class CreateUserServlet extends HttpServlet {

    private final UserService userService = new UserService();

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        String role = (String) session.getAttribute("role");
        return role != null && role.equalsIgnoreCase("ADMIN");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        request.getRequestDispatcher("/pages/createUser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String result = userService.createReceptionist(username, password);

        if ("SUCCESS".equals(result)) {
            request.setAttribute("success", "Receptionist user created successfully.");
        } else {
            request.setAttribute("error", result);
        }

        request.getRequestDispatcher("/pages/createUser.jsp").forward(request, response);
    }
}