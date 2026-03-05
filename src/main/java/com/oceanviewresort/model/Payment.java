package com.oceanviewresort.model;

import java.math.BigDecimal;

public class Payment {

    private int paymentId;
    private int resId;
    private int nights;
    private BigDecimal ratePerNight;
    private BigDecimal totalAmount;
    private String paymentMethod; // CASH or CARD

    public Payment() {}

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getResId() { return resId; }
    public void setResId(int resId) { this.resId = resId; }

    public int getNights() { return nights; }
    public void setNights(int nights) { this.nights = nights; }

    public BigDecimal getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(BigDecimal ratePerNight) { this.ratePerNight = ratePerNight; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
}