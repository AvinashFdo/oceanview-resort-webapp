<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanviewresort.model.DashboardSummary" %>
<%
  String username = (String) session.getAttribute("username");
  String role = (String) session.getAttribute("role");

  if (username == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }

  DashboardSummary summary = (DashboardSummary) request.getAttribute("summary");
  boolean isAdmin = role != null && role.equalsIgnoreCase("ADMIN");
%>

<!DOCTYPE html>
<html>
<head>
  <title>Dashboard - Ocean View Resort</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/styles.css">
</head>
<body>
<div class="app-shell">

  <header class="site-header">
    <div class="site-header-inner">
      <div class="brand">Ocean View Resort</div>
      <div class="header-right">
        <span>Welcome, <strong><%= username %></strong></span>
        <span class="role-badge"><%= role %></span>
        <a class="header-link" href="<%= request.getContextPath() %>/logout">Logout</a>
      </div>
    </div>
  </header>

  <main class="page page-wide">
    <div class="page-head">
      <div>
        <h1 class="page-title">Dashboard</h1>
        <% if (isAdmin) { %>
        <p class="page-subtitle">Admin overview and system functions.</p>
        <% } else { %>
        <p class="page-subtitle">Receptionist operations panel.</p>
        <% } %>
      </div>
    </div>

    <% if (isAdmin && summary != null) { %>
    <div class="summary-grid">
      <div class="summary-card">
        <div class="summary-label">Active Reservations</div>
        <div class="summary-value"><%= summary.getActiveReservations() %></div>
      </div>

      <div class="summary-card">
        <div class="summary-label">Pending Payments</div>
        <div class="summary-value"><%= summary.getPendingPayments() %></div>
      </div>

      <div class="summary-card">
        <div class="summary-label">Total Revenue</div>
        <div class="summary-value">USD <%= summary.getTotalRevenue() %></div>
      </div>
    </div>
    <% } %>

    <div class="section-title">Quick Actions</div>

    <div class="menu-grid">
      <a class="menu-card" href="<%= request.getContextPath() %>/reservations/add">
        <div class="menu-card-title">Add Reservation</div>
        <div class="menu-card-text">Create a new room reservation for a guest.</div>
      </a>

      <a class="menu-card" href="<%= request.getContextPath() %>/reservations">
        <div class="menu-card-title">View Reservations</div>
        <div class="menu-card-text">Search, review and manage reservation records.</div>
      </a>

      <a class="menu-card" href="<%= request.getContextPath() %>/payments/add">
        <div class="menu-card-title">Add Payment / Print Bill</div>
        <div class="menu-card-text">Complete pending payments and print bills.</div>
      </a>

      <% if (isAdmin) { %>
      <a class="menu-card" href="<%= request.getContextPath() %>/users/create">
        <div class="menu-card-title">Create Receptionist User</div>
        <div class="menu-card-text">Add and manage receptionist access.</div>
      </a>

      <a class="menu-card" href="<%= request.getContextPath() %>/rooms/manage">
        <div class="menu-card-title">Manage Rooms</div>
        <div class="menu-card-text">Update room status to available or maintenance.</div>
      </a>
      <% } %>
    </div>

    <div class="section-title">Help / User Guide</div>

    <div class="card">
      <p>
        This reservation system helps staff manage guest bookings, payments, and room availability at Ocean View Resort.
        New staff members should review the following guidelines before using the system.
      </p>

      <ol style="margin-top:12px; line-height:1.6; padding-left:20px;">

        <li>
          <strong>Add Reservation</strong> – Use this option to create a new reservation by entering guest information,
          selecting a room, and specifying check-in and check-out dates.
        </li>

        <li>
          <strong>View Reservations</strong> – Allows staff to search and review all reservation records including
          guest details, booking dates, and reservation status.
        </li>

        <li>
          <strong>Add Payment / Print Bill</strong> – Record payments for completed stays and generate a printable
          bill for the guest.
        </li>

        <% if (isAdmin) { %>
        <li>
          <strong>Create Receptionist User</strong> – Administrators can create login accounts for receptionist staff.
        </li>

        <li>
          <strong>Manage Rooms</strong> – Administrators can update room status such as Available or Maintenance.
        </li>
        <% } %>

        <li>
          <strong>Logout</strong> – Always logout after completing work to keep the system secure.
        </li>

      </ol>
    </div>
  </main>

  <footer class="site-footer">
    <div class="site-footer-inner">
      Ocean View Resort Reservation System
    </div>
  </footer>

</div>
</body>
</html>