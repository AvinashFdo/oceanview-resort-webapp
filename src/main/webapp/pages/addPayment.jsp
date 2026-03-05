<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanviewresort.model.ReservationDetails" %>
<%
  String username = (String) session.getAttribute("username");
  if (username == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }

  String error = (String) request.getAttribute("error");
  String reservationNo = (String) request.getAttribute("reservationNo");
  ReservationDetails billing = (ReservationDetails) request.getAttribute("billing");

  if (reservationNo == null) reservationNo = "";
%>
<!DOCTYPE html>
<html>
<head>
  <title>Add Payment</title>
  <style>
    body { font-family: Arial, sans-serif; background:#f5f7fb; margin:0; }
    .header { background:#0ea5e9; color:white; padding:15px; display:flex; justify-content:space-between; align-items:center; }
    .container { padding:30px; max-width: 900px; margin: 0 auto; }
    .card { background:white; padding:16px; border-radius:10px; box-shadow:0 3px 8px rgba(0,0,0,0.08); }
    .row { margin: 10px 0; }
    .input { padding: 8px; width: 220px; }
    .btn { padding: 8px 12px; cursor: pointer; }
    .error { background:#ffe5e5; padding:10px; border:1px solid #ffb3b3; margin-bottom:12px; border-radius:6px; }
    table { width:100%; border-collapse:collapse; margin-top:12px; }
    td { padding:8px; border-bottom:1px solid #eee; }
    .label { font-weight:bold; width:35%; }
    .top-actions { margin-bottom: 12px; }
    a { color:#0ea5e9; text-decoration:none; }
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
  <h2>Add Payment</h2>

  <% if (error != null) { %>
  <div class="error"><%= error %></div>
  <% } %>

  <div class="card">
    <!-- Search / Load billing summary -->
    <form method="get" action="<%= request.getContextPath() %>/payments/add">
      <div class="row">
        <label>Reservation No:</label>
        <input class="input" type="text" name="reservationNo" value="<%= reservationNo %>" placeholder="R0005" required />
        <button class="btn" type="submit">Load</button>
      </div>
    </form>

    <% if (billing != null) { %>

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

    <% } %>
  </div>
</div>

</body>
</html>