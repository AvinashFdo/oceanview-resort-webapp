package com.oceanviewresort.service;

import com.oceanviewresort.dao.ReservationDAO;
import com.oceanviewresort.model.Reservation;
import com.oceanviewresort.model.ReservationDetails;

import java.time.LocalDate;
import java.util.Optional;
import java.time.temporal.ChronoUnit;

public class ReservationService {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    public String createReservation(Reservation r) {

        // Server-side validation
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

        // Call stored procedure through DAO
        try {
            String newResNo = reservationDAO.createUsingStoredProcedure(r);
            return newResNo; // success: return reservation number
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

        // Basic format validation: R0001, R0002 etc.
        if (!reservationNo.matches("^R\\d{4}$")) {
            return null;
        }

        try {
            return reservationDAO.findReservationDetailsByReservationNo(reservationNo);
        } catch (Exception ex) {
            // In service layer, return null; servlet will decide what message to show
            return null;
        }
    }
}