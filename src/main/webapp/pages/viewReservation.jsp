<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanviewresort.model.ReservationDetails" %>
<%
    ReservationDetails details = (ReservationDetails) request.getAttribute("details");
    String error = (String) request.getAttribute("error");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <title>View Reservation Details</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .box { max-width: 800px; margin: 0 auto; }
        .error { background: #ffe5e5; padding: 10px; border: 1px solid #ffb3b3; margin-bottom: 12px; }
        .card { border: 1px solid #ddd; padding: 14px; border-radius: 6px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        td { padding: 8px; border-bottom: 1px solid #eee; }
        .label { width: 35%; font-weight: bold; }
        .topbar { display:flex; justify-content: space-between; align-items:center; margin-bottom: 10px; }
        .btn { padding: 8px 12px; cursor: pointer; }
        .input { padding: 8px; width: 220px; }
    </style>
</head>
<body>
<div class="box">

    <div class="topbar">
        <h2>View Reservation Details</h2>
        <a href="<%= request.getContextPath() %>/dashboard" class="btn">Back to Dashboard</a>
    </div>

    <% if ("cancel_ok".equals(msg)) { %>
    <div style="background:#dcfce7; padding:10px; border:1px solid #86efac; margin-bottom:12px;">
        Reservation cancelled successfully.
    </div>
    <% } else if ("cancel_fail".equals(msg)) { %>
    <div style="background:#ffe5e5; padding:10px; border:1px solid #ffb3b3; margin-bottom:12px;">
        Failed to cancel reservation (it may already be paid or already cancelled).
    </div>
    <% } %>

    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <div class="card">
        <form method="post" action="<%= request.getContextPath() %>/viewReservation">
            <label>Reservation No:</label>
            <input class="input" type="text" name="reservationNo" placeholder="eg: R0001" required />
            <button class="btn" type="submit">Search</button>
        </form>

        <% if (details != null) { %>
        <h3 style="margin-top:16px;">Details for: <%= details.getReservationNo() %></h3>

        <div style="margin-top:10px; display:flex; gap:10px; align-items:center;">
            <a class="btn" href="<%= request.getContextPath() %>/payments/add?reservationNo=<%= details.getReservationNo() %>">
                Pay Now
            </a>

            <form method="post" action="<%= request.getContextPath() %>/reservations/cancel"
                  onsubmit="return confirm('Are you sure you want to cancel reservation <%= details.getReservationNo() %>?');"
                  style="margin:0;">
                <input type="hidden" name="reservationNo" value="<%= details.getReservationNo() %>" />
                <button class="btn" type="submit">Cancel Reservation</button>
            </form>
        </div>

        <table>
            <tr><td class="label">Guest Name</td><td><%= details.getGuestName() %></td></tr>
            <tr><td class="label">Address</td><td><%= details.getAddress() %></td></tr>
            <tr><td class="label">Contact</td><td><%= details.getContact() %></td></tr>

            <tr><td class="label">Room Number</td><td><%= details.getRoomNo() %></td></tr>
            <tr><td class="label">Room Type</td><td><%= details.getRoomType() %></td></tr>

            <tr><td class="label">Check-in</td><td><%= details.getCheckIn() %></td></tr>
            <tr><td class="label">Check-out</td><td><%= details.getCheckOut() %></td></tr>

            <tr><td class="label">Nights</td><td><%= details.getNights() %></td></tr>
            <tr><td class="label">Price / Night</td><td><%= details.getPricePerNight() %></td></tr>
            <tr><td class="label">Total Bill</td><td><%= details.getTotalBill() %></td></tr>
        </table>
        <% } %>
    </div>

</div>
</body>
</html>