<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanviewresort.model.ReservationDetails" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String success = (String) request.getAttribute("success");
    ReservationDetails billing = (ReservationDetails) request.getAttribute("billing");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Bill</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f5f7fb; margin:0; }
        .container { max-width: 800px; margin: 20px auto; background:white; padding: 20px; border-radius: 10px; box-shadow:0 3px 8px rgba(0,0,0,0.08); }
        .top { display:flex; justify-content:space-between; align-items:center; margin-bottom: 10px; }
        .btn { padding: 8px 12px; cursor:pointer; }
        table { width:100%; border-collapse:collapse; margin-top:12px; }
        td { padding:8px; border-bottom:1px solid #eee; }
        .label { font-weight:bold; width:35%; }
        .ok { background:#e8fff1; padding:10px; border:1px solid #a8f0c6; border-radius:6px; margin-bottom:12px; }
        @media print {
            .no-print { display:none; }
            body { background:white; }
            .container { box-shadow:none; margin:0; border-radius:0; }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="top no-print">
        <div>
            <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
            &nbsp;|&nbsp;
            <a href="<%= request.getContextPath() %>/payments/add">Add Another Payment</a>
        </div>
        <button class="btn" onclick="window.print()">Print</button>
    </div>

    <% if (success != null) { %>
    <div class="ok"><%= success %></div>
    <% } %>

    <h2 style="text-align:center; margin:0;">OCEAN VIEW RESORT</h2>
    <p style="text-align:center; margin-top:6px;">Payment Receipt / Bill</p>

    <% if (billing == null) { %>
    <p>No billing details found.</p>
    <% } else { %>

    <table>
        <tr><td class="label">Reservation No</td><td><%= billing.getReservationNo() %></td></tr>
        <tr><td class="label">Guest Name</td><td><%= billing.getGuestName() %></td></tr>
        <tr><td class="label">Address</td><td><%= billing.getAddress() %></td></tr>
        <tr><td class="label">Contact</td><td><%= billing.getContact() %></td></tr>

        <tr><td class="label">Room</td><td><%= billing.getRoomNo() %> (<%= billing.getRoomType() %>)</td></tr>
        <tr><td class="label">Check-in</td><td><%= billing.getCheckIn() %></td></tr>
        <tr><td class="label">Check-out</td><td><%= billing.getCheckOut() %></td></tr>

        <tr><td class="label">Nights</td><td><%= billing.getNights() %></td></tr>
        <tr><td class="label">Rate / Night</td><td><%= billing.getPricePerNight() %></td></tr>
        <tr><td class="label">Total Amount</td><td><strong><%= billing.getTotalBill() %></strong></td></tr>
    </table>

    <p style="margin-top:14px; text-align:center;">Thank you!</p>

    <% } %>
</div>

</body>
</html>