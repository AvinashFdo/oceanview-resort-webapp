<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanviewresort.model.ReservationDetails" %>
<%
    ReservationDetails details = (ReservationDetails) request.getAttribute("details");
    String error = (String) request.getAttribute("error");
    String msg = request.getParameter("msg");

    Boolean paidObj = (Boolean) request.getAttribute("paid");
    boolean paid = (paidObj != null && paidObj);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reservation Details</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/styles.css">
</head>
<body>
<div class="app-shell">

    <header class="site-header">
        <div class="site-header-inner">
            <div class="brand">Ocean View Resort System</div>
            <div class="header-right">
                <a class="header-link" href="<%= request.getContextPath() %>/reservations">Reservations</a>
                <a class="header-link" href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
                <a class="header-link" href="<%= request.getContextPath() %>/logout">Logout</a>
            </div>
        </div>
    </header>

    <main class="page page-compact">
        <div class="page-head">
            <div>
                <h1 class="page-title">Reservation Details</h1>
                <% if (details != null) { %>
                <p class="page-subtitle">Reservation No: <strong><%= details.getReservationNo() %></strong></p>
                <% } else { %>
                <p class="page-subtitle">View full details for the selected reservation.</p>
                <% } %>
            </div>

            <a href="<%= request.getContextPath() %>/reservations" class="btn btn-secondary">← Back to Reservations</a>
        </div>

        <% if ("cancel_ok".equals(msg)) { %>
        <div class="msg msg-success">Reservation cancelled successfully.</div>
        <% } else if ("cancel_fail".equals(msg)) { %>
        <div class="msg msg-error">Failed to cancel reservation. It may already be paid or already cancelled.</div>
        <% } %>

        <% if (error != null) { %>
        <div class="msg msg-error"><%= error %></div>
        <% } %>

        <% if (details != null) { %>

        <div class="row" style="margin-bottom:16px;">
            <span style="font-weight:700; color:#0f172a;">Payment Status:</span>
            <% if (paid) { %>
            <span class="status-badge status-success">COMPLETED</span>
            <% } else { %>
            <span class="status-badge status-warning">PENDING</span>
            <% } %>
        </div>

        <div class="actions" style="margin-bottom:16px;">
            <% if (paid) { %>
            <a class="btn btn-primary"
               href="<%= request.getContextPath() %>/bill?reservationNo=<%= details.getReservationNo() %>">
                Print Bill
            </a>
            <% } else { %>
            <form method="post"
                  action="<%= request.getContextPath() %>/reservations/cancel"
                  class="inline-form"
                  onsubmit="return confirm('Are you sure you want to cancel reservation <%= details.getReservationNo() %>?');">
                <input type="hidden" name="reservationNo" value="<%= details.getReservationNo() %>" />
                <button class="btn btn-danger" type="submit">Cancel Reservation</button>
            </form>
            <% } %>
        </div>

        <div class="details-card">
            <div class="details-head">Reservation Information</div>

            <table class="details-table">
                <tr>
                    <td class="details-label">Guest Name</td>
                    <td class="details-value"><%= details.getGuestName() %></td>
                </tr>
                <tr>
                    <td class="details-label">Address</td>
                    <td class="details-value"><%= details.getAddress() %></td>
                </tr>
                <tr>
                    <td class="details-label">Contact</td>
                    <td class="details-value"><%= details.getContact() %></td>
                </tr>
                <tr>
                    <td class="details-label">Room Number</td>
                    <td class="details-value"><%= details.getRoomNo() %></td>
                </tr>
                <tr>
                    <td class="details-label">Room Type</td>
                    <td class="details-value"><%= details.getRoomType() %></td>
                </tr>
                <tr>
                    <td class="details-label">Check-in</td>
                    <td class="details-value"><%= details.getCheckIn() %></td>
                </tr>
                <tr>
                    <td class="details-label">Check-out</td>
                    <td class="details-value"><%= details.getCheckOut() %></td>
                </tr>
                <tr>
                    <td class="details-label">Nights</td>
                    <td class="details-value"><%= details.getNights() %></td>
                </tr>
                <tr>
                    <td class="details-label">Price / Night</td>
                    <td class="details-value"><%= details.getPricePerNight() %></td>
                </tr>
                <tr>
                    <td class="details-label">Total Bill</td>
                    <td class="details-value"><strong><%= details.getTotalBill() %></strong></td>
                </tr>
            </table>
        </div>

        <% } else { %>
        <div class="details-card">
            <div class="details-head">Reservation Information</div>
            <div class="empty-state">No reservation details available.</div>
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