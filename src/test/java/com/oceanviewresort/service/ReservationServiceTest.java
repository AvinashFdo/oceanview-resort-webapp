package com.oceanviewresort.service;

import com.oceanviewresort.dao.PaymentDAO;
import com.oceanviewresort.dao.ReservationDAO;
import com.oceanviewresort.model.Reservation;
import com.oceanviewresort.model.ReservationDetails;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class ReservationServiceTest {

    private ReservationDAO reservationDAO;
    private PaymentDAO paymentDAO;
    private ReservationService reservationService;

    @BeforeEach
    void setUp() {
        reservationDAO = mock(ReservationDAO.class);
        paymentDAO = mock(PaymentDAO.class);
        reservationService = new ReservationService(reservationDAO, paymentDAO);
    }

    @Test
    void shouldRejectReservationWhenCheckoutDateIsBeforeCheckinDate() {
        Reservation reservation = new Reservation();
        reservation.setGuestName("John Silva");
        reservation.setAddress("Colombo");
        reservation.setContactNo("0712345678");
        reservation.setRoomId(1);
        reservation.setCheckIn(LocalDate.of(2026, 4, 20));
        reservation.setCheckOut(LocalDate.of(2026, 4, 19));

        String result = reservationService.createReservation(reservation);

        assertEquals("Check-out date must be after check-in date.", result);
    }

    @Test
    void shouldCreateReservationSuccessfullyWhenDataIsValid() throws Exception {
        Reservation reservation = new Reservation();
        reservation.setGuestName("John Silva");
        reservation.setAddress("Colombo");
        reservation.setContactNo("0712345678");
        reservation.setRoomId(1);
        reservation.setCheckIn(LocalDate.of(2026, 4, 20));
        reservation.setCheckOut(LocalDate.of(2026, 4, 22));

        when(reservationDAO.createUsingStoredProcedure(reservation)).thenReturn("R0001");

        String result = reservationService.createReservation(reservation);

        assertEquals("R0001", result);
    }

    @Test
    void shouldReturnNullForInvalidReservationNumberFormatWhenGettingDetails() {
        ReservationDetails result = reservationService.getReservationDetails("1234");
        assertNull(result);
    }

    @Test
    void shouldRejectCancellationWhenPaymentAlreadyExists() throws Exception {
        ReservationDetails details = new ReservationDetails();
        details.setResId(10);

        when(reservationDAO.findBillingDetailsByReservationNo("R0001")).thenReturn(details);
        when(paymentDAO.paymentExistsForReservation(10)).thenReturn(true);

        String result = reservationService.cancelReservation("R0001");

        assertEquals("ERROR: Cannot cancel. Payment already completed for this reservation.", result);
    }

    @Test
    void shouldCancelReservationSuccessfullyWhenUnpaid() throws Exception {
        ReservationDetails details = new ReservationDetails();
        details.setResId(10);

        when(reservationDAO.findBillingDetailsByReservationNo("R0002")).thenReturn(details);
        when(paymentDAO.paymentExistsForReservation(10)).thenReturn(false);
        when(reservationDAO.cancelReservationByNo("R0002")).thenReturn(true);

        String result = reservationService.cancelReservation("R0002");

        assertEquals("OK", result);
    }
}