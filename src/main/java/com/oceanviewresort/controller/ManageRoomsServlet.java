package com.oceanviewresort.controller;

import com.oceanviewresort.model.Room;
import com.oceanviewresort.service.RoomService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/rooms/manage")
public class ManageRoomsServlet extends HttpServlet {

    private final RoomService roomService = new RoomService();

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        String role = (String) session.getAttribute("role");
        return role != null && role.equalsIgnoreCase("ADMIN");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        List<Room> rooms = roomService.getAllRooms();
        request.setAttribute("rooms", rooms);

        request.getRequestDispatcher("/pages/manageRooms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String roomId = request.getParameter("roomId");
        String status = request.getParameter("status");

        String result = roomService.updateRoomStatus(roomId, status);

        if ("SUCCESS".equals(result)) {
            request.setAttribute("success", "Room status updated successfully.");
        } else {
            request.setAttribute("error", result);
        }

        List<Room> rooms = roomService.getAllRooms();
        request.setAttribute("rooms", rooms);

        request.getRequestDispatcher("/pages/manageRooms.jsp").forward(request, response);
    }
}