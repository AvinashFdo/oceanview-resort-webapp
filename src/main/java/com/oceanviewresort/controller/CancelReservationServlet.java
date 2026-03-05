package com.oceanviewresort.controller;

import com.oceanviewresort.service.ReservationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/reservations/cancel")
public class CancelReservationServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && session.getAttribute("username") != null;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reservationNo = req.getParameter("reservationNo");
        String result = reservationService.cancelReservation(reservationNo);

        // Redirect back to view page with message (simple and practical)
        if ("OK".equals(result)) {
            resp.sendRedirect(req.getContextPath() + "/viewReservation?reservationNo=" +
                    reservationNo.trim().toUpperCase() + "&msg=cancel_ok");
        } else {
            // URL-safe basic handling
            resp.sendRedirect(req.getContextPath() + "/viewReservation?reservationNo=" +
                    (reservationNo == null ? "" : reservationNo.trim().toUpperCase()) + "&msg=cancel_fail");
        }
    }
}