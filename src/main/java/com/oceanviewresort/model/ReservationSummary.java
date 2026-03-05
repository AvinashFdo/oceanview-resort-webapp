package com.oceanviewresort.model;

import java.sql.Date;

public class ReservationSummary {

    private String reservationNo;
    private String guestName;

    private String roomNumber;
    private String roomType;

    private Date checkIn;
    private Date checkOut;

    private String paymentStatus;
    private String reservationStatus; // ACTIVE / CANCELLED

    public ReservationSummary() {}

    public String getReservationNo() { return reservationNo; }
    public void setReservationNo(String reservationNo) { this.reservationNo = reservationNo; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public Date getCheckIn() { return checkIn; }
    public void setCheckIn(Date checkIn) { this.checkIn = checkIn; }

    public Date getCheckOut() { return checkOut; }
    public void setCheckOut(Date checkOut) { this.checkOut = checkOut; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getReservationStatus() { return reservationStatus; }
    public void setReservationStatus(String reservationStatus) { this.reservationStatus = reservationStatus; }
}