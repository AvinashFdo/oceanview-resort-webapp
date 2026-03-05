package com.oceanviewresort.dao;

import com.oceanviewresort.model.Room;
import com.oceanviewresort.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public List<Room> findAllActiveRooms() {

        List<Room> rooms = new ArrayList<>();

        String sql = "SELECT room_id, room_number, room_type, price_per_night " +
                "FROM rooms WHERE status = 'AVAILABLE' ORDER BY room_number";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomNumber(rs.getString("room_number"));
                r.setRoomType(rs.getString("room_type"));
                r.setPricePerNight(rs.getBigDecimal("price_per_night"));
                rooms.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rooms;
    }
}