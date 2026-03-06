package com.oceanviewresort.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI();
        String context = req.getContextPath();

        boolean isLoginRequest = path.equals(context + "/login");
        boolean isStaticResource =
                path.contains("/assets/") ||
                        path.endsWith(".css") ||
                        path.endsWith(".js") ||
                        path.endsWith(".png") ||
                        path.endsWith(".jpg") ||
                        path.endsWith(".jpeg") ||
                        path.endsWith(".gif") ||
                        path.endsWith(".svg") ||
                        path.endsWith(".ico");

        HttpSession session = req.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("username") != null;

        // Prevent caching for all pages
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        // Allow static resources
        if (isStaticResource) {
            chain.doFilter(request, response);
            return;
        }

        // If logged in and tries to access login page -> dashboard
        if (loggedIn && isLoginRequest) {
            resp.sendRedirect(context + "/dashboard");
            return;
        }

        // If not logged in and trying to access protected page -> login
        if (!loggedIn && !isLoginRequest) {
            resp.sendRedirect(context + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}