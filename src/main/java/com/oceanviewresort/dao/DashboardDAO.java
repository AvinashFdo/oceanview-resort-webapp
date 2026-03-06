package com.oceanviewresort.dao;

import com.oceanviewresort.model.DashboardSummary;
import com.oceanviewresort.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DashboardDAO {

    public DashboardSummary getAdminSummary() {

        DashboardSummary summary = new DashboardSummary();

        String activeSql = "SELECT COUNT(*) FROM reservations WHERE status = 'ACTIVE'";

        String pendingSql =
                "SELECT COUNT(*) " +
                        "FROM reservations r " +
                        "LEFT JOIN payments p ON p.res_id = r.res_id " +
                        "WHERE r.status = 'ACTIVE' AND p.payment_id IS NULL";

        String revenueSql = "SELECT COALESCE(SUM(total_amount), 0) FROM payments";

        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement(activeSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    summary.setActiveReservations(rs.getInt(1));
                }
            }

            try (PreparedStatement ps = con.prepareStatement(pendingSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    summary.setPendingPayments(rs.getInt(1));
                }
            }

            try (PreparedStatement ps = con.prepareStatement(revenueSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal revenue = rs.getBigDecimal(1);
                    summary.setTotalRevenue(revenue == null ? BigDecimal.ZERO : revenue);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return summary;
    }
}