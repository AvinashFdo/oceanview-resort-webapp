package com.oceanviewresort.service;

import com.oceanviewresort.dao.RoomDAO;
import com.oceanviewresort.model.Room;

import java.util.List;

public class RoomService {

    private final RoomDAO roomDAO;

    public RoomService() {
        this.roomDAO = new RoomDAO();
    }

    public RoomService(RoomDAO roomDAO) {
        this.roomDAO = roomDAO;
    }

    public List<Room> getAllRooms() {
        return roomDAO.findAllActiveRooms();
    }

    public String updateRoomStatus(String roomIdStr, String status) {

        int roomId;

        try {
            roomId = Integer.parseInt(roomIdStr);
        } catch (Exception e) {
            return "Invalid room ID.";
        }

        if (status == null || status.trim().isEmpty()) {
            return "Room status is required.";
        }

        status = status.trim().toUpperCase();

        if (!status.equals("AVAILABLE") && !status.equals("MAINTENANCE")) {
            return "Invalid room status.";
        }

        boolean updated = roomDAO.updateRoomStatus(roomId, status);

        if (updated) {
            return "SUCCESS";
        }

        return "Failed to update room status.";
    }
}