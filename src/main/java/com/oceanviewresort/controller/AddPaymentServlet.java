package com.oceanviewresort.controller;

import com.oceanviewresort.dao.ReservationDAO;
import com.oceanviewresort.model.ReservationDetails;
import com.oceanviewresort.service.PaymentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/payments/add")
public class AddPaymentServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final PaymentService paymentService = new PaymentService();

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

        // Optional: if reservationNo is passed as query param, pre-load billing summary
        String reservationNo = req.getParameter("reservationNo");
        if (reservationNo != null && !reservationNo.trim().isEmpty()) {
            reservationNo = reservationNo.trim().toUpperCase();

            try {
                ReservationDetails billing = reservationDAO.findBillingDetailsByReservationNo(reservationNo);
                if (billing != null) {
                    req.setAttribute("billing", billing);
                    req.setAttribute("reservationNo", reservationNo);
                } else {
                    req.setAttribute("error", "Reservation not found: " + reservationNo);
                    req.setAttribute("reservationNo", reservationNo);
                }
            } catch (Exception ex) {
                req.setAttribute("error", "ERROR: " + ex.getMessage());
                req.setAttribute("reservationNo", reservationNo);
            }
        }

        req.getRequestDispatcher("/pages/addPayment.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reservationNo = req.getParameter("reservationNo");
        String paymentMethod = req.getParameter("paymentMethod");

        // Load billing summary again (so page can show it even after POST)
        ReservationDetails billing = null;
        if (reservationNo != null && !reservationNo.trim().isEmpty()) {
            String resNo = reservationNo.trim().toUpperCase();
            try {
                billing = reservationDAO.findBillingDetailsByReservationNo(resNo);
            } catch (Exception ignored) { }
        }

        String result = paymentService.makePayment(reservationNo, paymentMethod);

        req.setAttribute("reservationNo", reservationNo == null ? "" : reservationNo.trim().toUpperCase());
        req.setAttribute("billing", billing);

        if ("OK".equals(result)) {
            // On success, forward to bill page (printable)
            req.setAttribute("success", "Payment saved successfully.");
            req.getRequestDispatcher("/pages/bill.jsp").forward(req, resp);
            return;
        } else {
            req.setAttribute("error", result);
            req.getRequestDispatcher("/pages/addPayment.jsp").forward(req, resp);
        }
    }
}