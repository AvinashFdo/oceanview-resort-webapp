package com.oceanviewresort.controller;

import com.oceanviewresort.dao.RoomDAO;
import com.oceanviewresort.model.Reservation;
import com.oceanviewresort.service.ReservationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/reservations/add")
public class AddReservationServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();
    private final ReservationService reservationService = new ReservationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("rooms", roomDAO.findAllActiveRooms());
        request.getRequestDispatcher("/pages/addReservation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Reservation r = new Reservation();

        // Session user id (created_by)
        Object userIdObj = request.getSession().getAttribute("userId");
        int userId = (userIdObj == null) ? 0 : (int) userIdObj;
        r.setCreatedBy(userId);

        r.setGuestName(request.getParameter("guestName"));
        r.setAddress(request.getParameter("address"));
        r.setContactNo(request.getParameter("contactNo"));

        String roomIdStr = request.getParameter("roomId");
        if (roomIdStr != null && !roomIdStr.isEmpty()) {
            try {
                r.setRoomId(Integer.parseInt(roomIdStr));
            } catch (NumberFormatException ignored) {}
        }

        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        try {
            if (checkIn != null && !checkIn.isEmpty()) r.setCheckIn(LocalDate.parse(checkIn));
            if (checkOut != null && !checkOut.isEmpty()) r.setCheckOut(LocalDate.parse(checkOut));
        } catch (Exception ignored) {}

        String result = reservationService.createReservation(r);

        if (result != null && !result.startsWith("ERROR:")) {
            request.setAttribute("success", "Reservation created successfully. Reservation No: " + result);
            request.setAttribute("reservationNo", result);
            request.setAttribute("rooms", roomDAO.findAllActiveRooms());
            request.getRequestDispatcher("/pages/addReservation.jsp").forward(request, response);
            return;
        }

        String error = (result == null) ? "Failed to create reservation. Please try again." : result.replace("ERROR: ", "");
        request.setAttribute("error", error);
        request.setAttribute("rooms", roomDAO.findAllActiveRooms());
        request.getRequestDispatcher("/pages/addReservation.jsp").forward(request, response);
    }
}