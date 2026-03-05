package com.oceanviewresort.service;

import com.oceanviewresort.dao.PaymentDAO;
import com.oceanviewresort.dao.ReservationDAO;
import com.oceanviewresort.model.Payment;
import com.oceanviewresort.model.ReservationDetails;

public class PaymentService {

    private final ReservationDAO reservationDAO = new ReservationDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    // Returns:
    // - "OK" on success
    // - "ERROR: ..." on failure
    public String makePayment(String reservationNo, String paymentMethod) {

        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            return "ERROR: Reservation number is required.";
        }

        reservationNo = reservationNo.trim().toUpperCase();
        if (!reservationNo.matches("^R\\d{4}$")) {
            return "ERROR: Invalid reservation number format (example: R0005).";
        }

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            return "ERROR: Payment method is required.";
        }

        paymentMethod = paymentMethod.trim().toUpperCase();
        if (!paymentMethod.equals("CASH") && !paymentMethod.equals("CARD")) {
            return "ERROR: Invalid payment method.";
        }

        try {
            ReservationDetails billing = reservationDAO.findBillingDetailsByReservationNo(reservationNo);

            if (billing == null) {
                return "ERROR: Reservation not found: " + reservationNo;
            }

            // Basic sanity checks
            if (billing.getResId() <= 0) {
                return "ERROR: Internal error (invalid resId).";
            }
            if (billing.getNights() <= 0) {
                return "ERROR: Invalid number of nights for billing.";
            }
            if (billing.getPricePerNight() == null || billing.getTotalBill() == null) {
                return "ERROR: Billing values are missing.";
            }

            // Prevent double payment
            if (paymentDAO.paymentExistsForReservation(billing.getResId())) {
                return "ERROR: Payment already exists for this reservation.";
            }

            Payment p = new Payment();
            p.setResId(billing.getResId());
            p.setNights(billing.getNights());
            p.setRatePerNight(billing.getPricePerNight());
            p.setTotalAmount(billing.getTotalBill());
            p.setPaymentMethod(paymentMethod);

            boolean ok = paymentDAO.createPayment(p);
            if (!ok) {
                return "ERROR: Failed to save payment.";
            }

            return "OK";

        } catch (Exception ex) {
            String msg = ex.getMessage();
            if (msg == null || msg.trim().isEmpty()) {
                return "ERROR: Payment failed. Please try again.";
            }
            return "ERROR: " + msg;
        }
    }
}