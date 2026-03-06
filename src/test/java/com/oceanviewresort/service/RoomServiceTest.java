package com.oceanviewresort.service;

import com.oceanviewresort.dao.RoomDAO;
import com.oceanviewresort.model.Room;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class RoomServiceTest {

    private RoomDAO roomDAO;
    private RoomService roomService;

    @BeforeEach
    void setUp() {
        roomDAO = mock(RoomDAO.class);
        roomService = new RoomService(roomDAO);
    }

    @Test
    void shouldReturnAllActiveRooms() {
        Room room1 = new Room();
        Room room2 = new Room();

        when(roomDAO.findAllActiveRooms()).thenReturn(List.of(room1, room2));

        List<Room> result = roomService.getAllRooms();

        assertNotNull(result);
        assertEquals(2, result.size());
    }

    @Test
    void shouldReturnInvalidRoomIdWhenRoomIdIsNotNumeric() {
        String result = roomService.updateRoomStatus("abc", "AVAILABLE");

        assertEquals("Invalid room ID.", result);
    }

    @Test
    void shouldReturnRoomStatusRequiredWhenStatusIsEmpty() {
        String result = roomService.updateRoomStatus("1", "");

        assertEquals("Room status is required.", result);
    }

    @Test
    void shouldReturnInvalidRoomStatusWhenStatusIsUnsupported() {
        String result = roomService.updateRoomStatus("1", "BUSY");

        assertEquals("Invalid room status.", result);
    }

    @Test
    void shouldUpdateRoomStatusSuccessfully() {
        when(roomDAO.updateRoomStatus(1, "MAINTENANCE")).thenReturn(true);

        String result = roomService.updateRoomStatus("1", "maintenance");

        assertEquals("SUCCESS", result);
    }

    @Test
    void shouldReturnFailureWhenRoomStatusUpdateFails() {
        when(roomDAO.updateRoomStatus(1, "AVAILABLE")).thenReturn(false);

        String result = roomService.updateRoomStatus("1", "available");

        assertEquals("Failed to update room status.", result);
    }
}