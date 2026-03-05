package com.oceanviewresort.controller;

import com.oceanviewresort.model.ReservationSummary;
import com.oceanviewresort.service.ReservationListService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/reservations")
public class ReservationListServlet extends HttpServlet {

    private final ReservationListService service = new ReservationListService();

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && session.getAttribute("username") != null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String q = req.getParameter("q");
        List<ReservationSummary> list = service.search(q);

        req.setAttribute("q", q == null ? "" : q);
        req.setAttribute("list", list);

        req.getRequestDispatcher("/pages/reservations.jsp").forward(req, resp);
    }
}