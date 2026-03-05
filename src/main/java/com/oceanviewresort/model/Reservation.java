package com.oceanviewresort.model;

import java.time.LocalDate;

public class Reservation {

    private int resId;
    private String reservationNo;
    private String guestName;
    private String address;
    private String contactNo;
    private int roomId;
    private String roomType;
    private java.math.BigDecimal pricePerNight;
    private LocalDate checkIn;
    private LocalDate checkOut;
    private int createdBy;

    public Reservation() {}

    public int getResId() {
        return resId;
    }

    public void setResId(int resId) {
        this.resId = resId;
    }

    public String getReservationNo() {
        return reservationNo;
    }

    public void setReservationNo(String reservationNo) {
        this.reservationNo = reservationNo;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getContactNo() {
        return contactNo;
    }

    public void setContactNo(String contactNo) {
        this.contactNo = contactNo;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public LocalDate getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(LocalDate checkIn) {
        this.checkIn = checkIn;
    }

    public LocalDate getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(LocalDate checkOut) {
        this.checkOut = checkOut;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public java.math.BigDecimal getPricePerNight() {
        return pricePerNight;
    }

    public void setPricePerNight(java.math.BigDecimal pricePerNight) {
        this.pricePerNight = pricePerNight;
    }
}