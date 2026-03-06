package com.oceanviewresort.controller;

import com.oceanviewresort.dao.ReservationDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/rooms/booked-dates")
public class RoomAvailabilityServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && session.getAttribute("username") != null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        if (!isLoggedIn(req)) {
            resp.setStatus(401);
            return;
        }

        String roomIdStr = req.getParameter("roomId");
        int roomId;

        try {
            roomId = Integer.parseInt(roomIdStr);
        } catch (Exception ex) {
            resp.setStatus(400);
            return;
        }

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            List<String[]> ranges = reservationDAO.getBookedDateRangesForRoom(roomId);

            StringBuilder json = new StringBuilder();
            json.append("{\"roomId\":").append(roomId).append(",\"ranges\":[");

            for (int i = 0; i < ranges.size(); i++) {
                String[] r = ranges.get(i);
                if (i > 0) json.append(",");
                json.append("{\"checkIn\":\"").append(r[0]).append("\",\"checkOut\":\"").append(r[1]).append("\"}");
            }

            json.append("]}");

            resp.getWriter().write(json.toString());

        } catch (Exception ex) {
            resp.setStatus(500);
            String msg = ex.getMessage();
            if (msg == null) msg = "Server error";
            resp.getWriter().write("{\"error\":\"" + msg.replace("\"", "'") + "\"}");
        }
    }
}