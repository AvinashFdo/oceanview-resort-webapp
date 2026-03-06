<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanviewresort.model.ReservationDetails" %>
<%@ page import="com.oceanviewresort.model.ReservationSummary" %>
<%@ page import="java.util.List" %>

<%
  String username = (String) session.getAttribute("username");
  if (username == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }

  String error = (String) request.getAttribute("error");
  String reservationNo = (String) request.getAttribute("reservationNo");
  ReservationDetails billing = (ReservationDetails) request.getAttribute("billing");
  List<ReservationSummary> pendingList = (List<ReservationSummary>) request.getAttribute("pendingList");

  if (reservationNo == null) reservationNo = "";
%>

<!DOCTYPE html>
<html>
<head>
  <title>Add Payment</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/styles.css">
</head>
<body>
<div class="app-shell">

  <header class="site-header">
    <div class="site-header-inner">
      <div class="brand">Ocean View Resort System</div>
      <div class="header-right">
        <a class="header-link" href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a class="header-link" href="<%= request.getContextPath() %>/logout">Logout</a>
      </div>
    </div>
  </header>

  <main class="page page-wide">
    <div class="page-head">
      <div>
        <h1 class="page-title">Add Payment / Print Bill</h1>
        <p class="page-subtitle">Process pending payments and print reservation bills.</p>
      </div>
    </div>

    <% if (error != null) { %>
    <div class="msg msg-error"><%= error %></div>
    <% } %>

    <% if (billing == null) { %>
    <div class="card">
      <div class="card-header">
        <h2 class="card-title">Pending Payments</h2>
        <p class="card-subtitle">Select a reservation below to proceed with payment.</p>
      </div>

      <div class="table-wrap">
        <table class="table">
          <thead>
          <tr>
            <th>Reservation No</th>
            <th>Guest</th>
            <th>Room</th>
            <th>Check-in</th>
            <th>Check-out</th>
            <th>Action</th>
          </tr>
          </thead>
          <tbody>
          <% if (pendingList == null || pendingList.isEmpty()) { %>
          <tr>
            <td colspan="6" class="wrap">No pending payments found.</td>
          </tr>
          <% } else {
            for (ReservationSummary r : pendingList) { %>
          <tr>
            <td><%= r.getReservationNo() %></td>
            <td class="wrap"><%= r.getGuestName() %></td>
            <td class="wrap"><%= r.getRoomNumber() %> (<%= r.getRoomType() %>)</td>
            <td><%= r.getCheckIn() %></td>
            <td><%= r.getCheckOut() %></td>
            <td>
              <a class="btn btn-secondary" href="<%= request.getContextPath() %>/payments/add?reservationNo=<%= r.getReservationNo() %>">Select</a>
            </td>
          </tr>
          <% } } %>
          </tbody>
        </table>
      </div>
    </div>
    <% } %>

    <% if (billing != null) { %>
    <div class="card">
      <div class="actions" style="margin-bottom:16px;">
        <a class="btn btn-secondary" href="<%= request.getContextPath() %>/payments/add">← Back to Pending Payments</a>
      </div>

      <div class="card-header">
        <h2 class="card-title">Billing Summary</h2>
        <p class="card-subtitle">Confirm payment for the selected reservation.</p>
      </div>

      <div class="details-card" style="margin-bottom:16px;">
        <table class="details-table">
          <tr><td class="details-label">Reservation No</td><td class="details-value"><%= billing.getReservationNo() %></td></tr>
          <tr><td class="details-label">Guest Name</td><td class="details-value"><%= billing.getGuestName() %></td></tr>
          <tr><td class="details-label">Room</td><td class="details-value"><%= billing.getRoomNo() %> (<%= billing.getRoomType() %>)</td></tr>
          <tr><td class="details-label">Check-in</td><td class="details-value"><%= billing.getCheckIn() %></td></tr>
          <tr><td class="details-label">Check-out</td><td class="details-value"><%= billing.getCheckOut() %></td></tr>
          <tr><td class="details-label">Nights</td><td class="details-value"><%= billing.getNights() %></td></tr>
          <tr><td class="details-label">Rate / Night</td><td class="details-value"><%= billing.getPricePerNight() %></td></tr>
          <tr><td class="details-label">Total</td><td class="details-value"><strong><%= billing.getTotalBill() %></strong></td></tr>
        </table>
      </div>

      <form method="post" action="<%= request.getContextPath() %>/payments/add">
        <input type="hidden" name="reservationNo" value="<%= billing.getReservationNo() %>" />

        <div class="field" style="max-width:320px;">
          <label>Payment Method</label>
          <select name="paymentMethod" required>
            <option value="">-- Select --</option>
            <option value="CASH">CASH</option>
            <option value="CARD">CARD</option>
          </select>
        </div>

        <div class="actions">
          <button class="btn btn-primary" type="submit">Save Payment</button>
        </div>
      </form>
    </div>
    <% } %>
  </main>

  <footer class="site-footer">
    <div class="site-footer-inner">
      Ocean View Resort Reservation System
    </div>
  </footer>

</div>
</body>
</html>