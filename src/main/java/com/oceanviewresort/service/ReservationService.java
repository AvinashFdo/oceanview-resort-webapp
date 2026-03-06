package com.oceanviewresort.service;

import com.oceanviewresort.dao.ReservationDAO;
import com.oceanviewresort.dao.PaymentDAO;
import com.oceanviewresort.model.Reservation;
import com.oceanviewresort.model.ReservationDetails;

import java.time.LocalDate;

public class ReservationService {

    private final ReservationDAO reservationDAO;
    private final PaymentDAO paymentDAO;

    public ReservationService() {
        this.reservationDAO = new ReservationDAO();
        this.paymentDAO = new PaymentDAO();
    }

    public ReservationService(ReservationDAO reservationDAO, PaymentDAO paymentDAO) {
        this.reservationDAO = reservationDAO;
        this.paymentDAO = paymentDAO;
    }

    public String createReservation(Reservation r) {

        if (r.getGuestName() == null || r.getGuestName().trim().isEmpty()) {
            return "Guest name is required.";
        }
        if (r.getAddress() == null || r.getAddress().trim().isEmpty()) {
            return "Address is required.";
        }

        if (r.getContactNo() == null || r.getContactNo().trim().isEmpty()) {
            return "Contact number is required.";
        }
        if (!r.getContactNo().matches("^[0-9]{9,12}$")) {
            return "Contact number must contain 9 to 12 digits only.";
        }

        if (r.getRoomId() <= 0) {
            return "Please select a room.";
        }

        LocalDate in = r.getCheckIn();
        LocalDate out = r.getCheckOut();
        if (in == null || out == null) {
            return "Check-in and check-out dates are required.";
        }
        if (!out.isAfter(in)) {
            return "Check-out date must be after check-in date.";
        }

        try {
            String newResNo = reservationDAO.createUsingStoredProcedure(r);
            return newResNo;
        } catch (Exception ex) {
            String msg = ex.getMessage();
            if (msg == null || msg.trim().isEmpty()) {
                return "ERROR: Failed to create reservation. Please try again.";
            }
            return "ERROR: " + msg;
        }
    }

    public ReservationDetails getReservationDetails(String reservationNo) {

        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            return null;
        }

        reservationNo = reservationNo.trim().toUpperCase();

        if (!reservationNo.matches("^R\\d{4}$")) {
            return null;
        }

        try {
            return reservationDAO.findReservationDetailsByReservationNo(reservationNo);
        } catch (Exception ex) {
            return null;
        }
    }

    public String cancelReservation(String reservationNo) {

        if (reservationNo == null || reservationNo.trim().isEmpty()) {
            return "ERROR: Reservation number is required.";
        }

        reservationNo = reservationNo.trim().toUpperCase();
        if (!reservationNo.matches("^R\\d{4}$")) {
            return "ERROR: Invalid reservation number format.";
        }

        try {
            ReservationDetails billing = reservationDAO.findBillingDetailsByReservationNo(reservationNo);
            if (billing == null) {
                return "ERROR: Reservation not found.";
            }

            if (paymentDAO.paymentExistsForReservation(billing.getResId())) {
                return "ERROR: Cannot cancel. Payment already completed for this reservation.";
            }

            boolean ok = reservationDAO.cancelReservationByNo(reservationNo);
            return ok ? "OK" : "ERROR: Reservation is already cancelled or cannot be cancelled.";

        } catch (Exception ex) {
            String msg = ex.getMessage();
            if (msg == null || msg.trim().isEmpty()) return "ERROR: Failed to cancel reservation.";
            return "ERROR: " + msg;
        }
    }
}