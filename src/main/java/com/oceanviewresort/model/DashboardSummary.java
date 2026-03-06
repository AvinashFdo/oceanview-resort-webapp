package com.oceanviewresort.model;

import java.math.BigDecimal;

public class DashboardSummary {

    private int activeReservations;
    private int pendingPayments;
    private BigDecimal totalRevenue;

    public DashboardSummary() {
        this.totalRevenue = BigDecimal.ZERO;
    }

    public int getActiveReservations() {
        return activeReservations;
    }

    public void setActiveReservations(int activeReservations) {
        this.activeReservations = activeReservations;
    }

    public int getPendingPayments() {
        return pendingPayments;
    }

    public void setPendingPayments(int pendingPayments) {
        this.pendingPayments = pendingPayments;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}