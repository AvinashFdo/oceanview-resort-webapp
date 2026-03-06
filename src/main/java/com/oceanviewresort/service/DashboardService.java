package com.oceanviewresort.service;

import com.oceanviewresort.dao.DashboardDAO;
import com.oceanviewresort.model.DashboardSummary;

public class DashboardService {

    private final DashboardDAO dashboardDAO = new DashboardDAO();

    public DashboardSummary getAdminSummary() {
        return dashboardDAO.getAdminSummary();
    }
}