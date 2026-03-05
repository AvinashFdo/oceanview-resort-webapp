package com.oceanviewresort.service;

import com.oceanviewresort.dao.ReservationDAO;
import com.oceanviewresort.model.ReservationSummary;

import java.util.Collections;
import java.util.List;

public class ReservationListService {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    public List<ReservationSummary> search(String keyword) {
        try {
            return reservationDAO.searchReservationSummaries(keyword);
        } catch (Exception ex) {
            return Collections.emptyList();
        }
    }
}