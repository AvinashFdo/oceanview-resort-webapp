package com.oceanviewresort.dao;

import com.oceanviewresort.model.Reservation;
import com.oceanviewresort.model.ReservationDetails;
import com.oceanviewresort.util.DBConnection;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ReservationDAO {

    public String createUsingStoredProcedure(Reservation r) throws Exception {

        String sql = "{CALL sp_create_reservation(?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection con = DBConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setString(1, r.getGuestName());
            cs.setString(2, r.getAddress());
            cs.setString(3, r.getContactNo());
            cs.setInt(4, r.getRoomId());
            cs.setDate(5, java.sql.Date.valueOf(r.getCheckIn()));
            cs.setDate(6, java.sql.Date.valueOf(r.getCheckOut()));
            cs.setInt(7, r.getCreatedBy());

            // OUT param
            cs.registerOutParameter(8, java.sql.Types.VARCHAR);

            cs.execute();

            return cs.getString(8); // generated reservation number e.g., R0007
        }
    }

    // Fetch reservation details by reservation number
    public ReservationDetails findReservationDetailsByReservationNo(String reservationNo) throws Exception {

        String sql =
                "SELECT " +
                        " r.reservation_no, r.guest_name, r.address, r.contact_no, " +
                        " rm.room_number, rm.room_type, r.check_in, r.check_out, " +
                        " fn_nights(r.check_in, r.check_out) AS nights, " +
                        " rm.price_per_night, " +
                        " (fn_nights(r.check_in, r.check_out) * rm.price_per_night) AS total_bill " +
                        "FROM reservations r " +
                        "JOIN rooms rm ON r.room_id = rm.room_id " +
                        "WHERE r.reservation_no = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, reservationNo);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    return null; // not found
                }

                ReservationDetails d = new ReservationDetails();
                d.setReservationNo(rs.getString("reservation_no"));
                d.setGuestName(rs.getString("guest_name"));
                d.setAddress(rs.getString("address"));
                d.setContact(rs.getString("contact_no"));

                d.setRoomNo(rs.getString("room_number"));
                d.setRoomType(rs.getString("room_type"));

                d.setCheckIn(rs.getDate("check_in"));
                d.setCheckOut(rs.getDate("check_out"));

                d.setNights(rs.getInt("nights"));

                BigDecimal ppn = rs.getBigDecimal("price_per_night");
                BigDecimal total = rs.getBigDecimal("total_bill");

                d.setPricePerNight(ppn);
                d.setTotalBill(total);

                return d;
            }
        }
    }

    public ReservationDetails findBillingDetailsByReservationNo(String reservationNo) throws Exception {

        String sql =
                "SELECT " +
                        " r.res_id, r.reservation_no, r.guest_name, r.address, r.contact_no, " +
                        " rm.room_number, rm.room_type, r.check_in, r.check_out, " +
                        " fn_nights(r.check_in, r.check_out) AS nights, " +
                        " rm.price_per_night, " +
                        " (fn_nights(r.check_in, r.check_out) * rm.price_per_night) AS total_bill " +
                        "FROM reservations r " +
                        "JOIN rooms rm ON r.room_id = rm.room_id " +
                        "WHERE r.reservation_no = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, reservationNo);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    return null;
                }

                ReservationDetails d = new ReservationDetails();

                d.setResId(rs.getInt("res_id"));
                d.setReservationNo(rs.getString("reservation_no"));
                d.setGuestName(rs.getString("guest_name"));
                d.setAddress(rs.getString("address"));
                d.setContact(rs.getString("contact_no"));

                d.setRoomNo(rs.getString("room_number"));
                d.setRoomType(rs.getString("room_type"));

                d.setCheckIn(rs.getDate("check_in"));
                d.setCheckOut(rs.getDate("check_out"));

                d.setNights(rs.getInt("nights"));
                d.setPricePerNight(rs.getBigDecimal("price_per_night"));
                d.setTotalBill(rs.getBigDecimal("total_bill"));

                return d;
            }
        }
    }
}