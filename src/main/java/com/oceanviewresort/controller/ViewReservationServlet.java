package com.oceanviewresort.controller;

import com.oceanviewresort.model.ReservationDetails;
import com.oceanviewresort.service.ReservationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/viewReservation")
public class ViewReservationServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && session.getAttribute("username") != null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.getRequestDispatcher("/pages/viewReservation.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reservationNo = req.getParameter("reservationNo");

        ReservationDetails details = reservationService.getReservationDetails(reservationNo);

        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            req.setAttribute("error", "Reservation number is required.");
        } else if (details == null) {
            req.setAttribute("error", "No reservation found for: " + reservationNo.trim().toUpperCase());
        } else {
            req.setAttribute("details", details);
        }

        req.getRequestDispatcher("/pages/viewReservation.jsp").forward(req, resp);
    }
}