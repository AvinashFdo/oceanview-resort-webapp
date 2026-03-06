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

@WebServlet("/bill")
public class BillServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

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

        String reservationNo = req.getParameter("reservationNo");
        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/viewReservation");
            return;
        }

        String resNo = reservationNo.trim().toUpperCase();

        try {
            ReservationDetails billing = reservationDAO.findBillingDetailsByReservationNo(resNo);

            if (billing == null) {
                resp.sendRedirect(req.getContextPath() + "/viewReservation?reservationNo=" + resNo);
                return;
            }

            boolean paid = paymentDAO.paymentExistsForReservation(billing.getResId());
            if (!paid) {
                resp.sendRedirect(req.getContextPath() + "/viewReservation?reservationNo=" + resNo);
                return;
            }

            req.setAttribute("billing", billing);
            req.setAttribute("success", "Bill reprint for: " + resNo);
            req.getRequestDispatcher("/pages/bill.jsp").forward(req, resp);

        } catch (Exception ex) {
            req.setAttribute("success", null);
            req.setAttribute("billing", null);
            req.getRequestDispatcher("/pages/bill.jsp").forward(req, resp);
        }
    }
}