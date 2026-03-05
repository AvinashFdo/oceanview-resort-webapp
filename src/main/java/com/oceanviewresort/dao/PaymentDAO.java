package com.oceanviewresort.dao;

import com.oceanviewresort.model.Payment;
import com.oceanviewresort.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class PaymentDAO {

    public boolean createPayment(Payment p) throws Exception {

        String sql = "INSERT INTO payments (res_id, nights, rate_per_night, total_amount, payment_method) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, p.getResId());
            ps.setInt(2, p.getNights());
            ps.setBigDecimal(3, p.getRatePerNight());
            ps.setBigDecimal(4, p.getTotalAmount());
            ps.setString(5, p.getPaymentMethod());

            return ps.executeUpdate() == 1;
        }
    }

    public boolean paymentExistsForReservation(int resId) throws Exception {

        String sql = "SELECT 1 FROM payments WHERE res_id = ? LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, resId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}