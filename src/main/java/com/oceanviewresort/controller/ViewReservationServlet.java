package com.oceanviewresort.controller;

import com.oceanviewresort.dao.PaymentDAO;
import com.oceanviewresort.dao.ReservationDAO;
import com.oceanviewresort.model.ReservationDetails;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/viewReservation")
public class ViewReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && session.getAttribute("username") != null;
    }

    private void loadReservation(HttpServletRequest req, String reservationNo) {

        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            req.setAttribute("error", "Reservation number is required.");
            return;
        }

        String resNo = reservationNo.trim().toUpperCase();

        try {
            // Use billing method because it includes resId (needed to check payment)
            ReservationDetails details = reservationDAO.findBillingDetailsByReservationNo(resNo);

            if (details == null) {
                req.setAttribute("error", "No reservation found for: " + resNo);
                return;
            }

            boolean paid = paymentDAO.paymentExistsForReservation(details.getResId());

            req.setAttribute("details", details);
            req.setAttribute("paid", paid);

        } catch (Exception ex) {
            String msg = ex.getMessage();
            if (msg == null || msg.trim().isEmpty()) {
                req.setAttribute("error", "ERROR: Failed to load reservation.");
            } else {
                req.setAttribute("error", "ERROR: " + msg);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reservationNo = req.getParameter("reservationNo");
        if (reservationNo != null && !reservationNo.trim().isEmpty()) {
            loadReservation(req, reservationNo);
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
        loadReservation(req, reservationNo);

        req.getRequestDispatcher("/pages/viewReservation.jsp").forward(req, resp);
    }
}