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

  // NEW: pending list (set by servlet when no reservationNo is provided)
  List<ReservationSummary> pendingList = (List<ReservationSummary>) request.getAttribute("pendingList");

  if (reservationNo == null) reservationNo = "";
%>

<!DOCTYPE html>
<html>
<head>
  <title>Add Payment</title>
  <style>
    body { font-family: Arial, sans-serif; background:#f5f7fb; margin:0; }
    .header { background:#0ea5e9; color:white; padding:15px; display:flex; justify-content:space-between; align-items:center; }
    .container { padding:30px; max-width: 1000px; margin: 0 auto; }
    .card { background:white; padding:16px; border-radius:10px; box-shadow:0 3px 8px rgba(0,0,0,0.08); margin-bottom: 16px; }
    .row { margin: 10px 0; }
    .input { padding: 8px; width: 220px; }
    .btn { padding: 8px 12px; cursor: pointer; border:1px solid #cbd5e1; border-radius:6px; background:#fff; }
    .error { background:#ffe5e5; padding:10px; border:1px solid #ffb3b3; margin-bottom:12px; border-radius:6px; }
    table { width:100%; border-collapse:collapse; margin-top:12px; }
    th, td { padding:10px; border-bottom:1px solid #eee; text-align:left; }
    th { background:#f8fafc; }
    .label { font-weight:bold; width:35%; }
    a { color:#0ea5e9; text-decoration:none; font-weight:700; }
    .muted { color:#64748b; font-size: 13px; }
  </style>
</head>
<body>

<div class="header">
  <div><strong>Ocean View Resort System</strong></div>
  <div>
    <a style="color:white; font-weight:bold;" href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
    &nbsp;|&nbsp;
    <a style="color:white; font-weight:bold;" href="<%= request.getContextPath() %>/logout">Logout</a>
  </div>
</div>

<div class="container">
  <h2>Add Payment / Print Bill</h2>

  <% if (error != null) { %>
  <div class="error"><%= error %></div>
  <% } %>

  <% if (billing == null) { %>
  <!-- Pending Payments List -->
  <div class="card">
    <h3>Pending Payments</h3>
    <p class="muted">Select a reservation below to proceed with payment.</p>

    <table>
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
        <td colspan="6">No pending payments found.</td>
      </tr>
      <% } else {
        for (ReservationSummary r : pendingList) { %>
      <tr>
        <td><%= r.getReservationNo() %></td>
        <td><%= r.getGuestName() %></td>
        <td><%= r.getRoomNumber() %> (<%= r.getRoomType() %>)</td>
        <td><%= r.getCheckIn() %></td>
        <td><%= r.getCheckOut() %></td>
        <td>
          <a class="btn" href="<%= request.getContextPath() %>/payments/add?reservationNo=<%= r.getReservationNo() %>">Select</a>
        </td>
      </tr>
      <% } } %>
      </tbody>
    </table>
  </div>
  <% } %>

  <!-- Billing Summary + Confirm Payment (only when billing is loaded) -->
  <% if (billing != null) { %>
  <div class="card" >
    <a class="btn" href="<%= request.getContextPath() %>/payments/add">← Back to Pending Payments</a>
    <h3>Billing Summary</h3>
    <table>
      <tr><td class="label">Reservation No</td><td><%= billing.getReservationNo() %></td></tr>
      <tr><td class="label">Guest Name</td><td><%= billing.getGuestName() %></td></tr>
      <tr><td class="label">Room</td><td><%= billing.getRoomNo() %> (<%= billing.getRoomType() %>)</td></tr>
      <tr><td class="label">Check-in</td><td><%= billing.getCheckIn() %></td></tr>
      <tr><td class="label">Check-out</td><td><%= billing.getCheckOut() %></td></tr>
      <tr><td class="label">Nights</td><td><%= billing.getNights() %></td></tr>
      <tr><td class="label">Rate / Night</td><td><%= billing.getPricePerNight() %></td></tr>
      <tr><td class="label">Total</td><td><strong><%= billing.getTotalBill() %></strong></td></tr>
    </table>

    <h3 style="margin-top:16px;">Confirm Payment</h3>
    <form method="post" action="<%= request.getContextPath() %>/payments/add">
      <input type="hidden" name="reservationNo" value="<%= billing.getReservationNo() %>" />

      <div class="row">
        <label>Payment Method:</label>
        <select class="input" name="paymentMethod" required>
          <option value="">-- Select --</option>
          <option value="CASH">CASH</option>
          <option value="CARD">CARD</option>
        </select>
      </div>

      <div class="row">
        <button class="btn" type="submit">Save Payment</button>
      </div>
    </form>
  </div>
  <% } %>

</div>

</body>
</html>