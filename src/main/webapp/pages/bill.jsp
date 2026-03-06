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
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/styles.css">
    <style>
        @media print {
            .no-print { display:none !important; }
            body { background:white; }
            .page { padding: 0; }
            .card {
                box-shadow:none;
                border:0;
                padding:0;
            }
            .site-header,
            .site-footer {
                display:none;
            }
        }
    </style>
</head>
<body>
<div class="app-shell">

    <header class="site-header no-print">
        <div class="site-header-inner">
            <div class="brand">Ocean View Resort System</div>
            <div class="header-right">
                <a class="header-link" href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
                <a class="header-link" href="<%= request.getContextPath() %>/payments/add">Add Payment</a>
                <a class="header-link" href="<%= request.getContextPath() %>/logout">Logout</a>
            </div>
        </div>
    </header>

    <main class="page page-compact">
        <div class="card">
            <div class="actions no-print" style="justify-content:space-between; margin-bottom:16px;">
                <div class="actions">
                    <a class="btn btn-secondary" href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
                    <a class="btn btn-secondary" href="<%= request.getContextPath() %>/payments/add">Add Another Payment</a>
                </div>
                <button class="btn btn-primary" onclick="window.print()">Print</button>
            </div>

            <% if (success != null) { %>
            <div class="msg msg-success no-print"><%= success %></div>
            <% } %>

            <div style="text-align:center; margin-bottom:20px;">
                <h1 class="page-title" style="font-size:34px; margin-bottom:6px;">OCEAN VIEW RESORT</h1>
                <p class="page-subtitle" style="margin:0;">Payment Receipt / Bill</p>
            </div>

            <% if (billing == null) { %>
            <div class="empty-state">No billing details found.</div>
            <% } else { %>
            <div class="details-card">
                <table class="details-table">
                    <tr><td class="details-label">Reservation No</td><td class="details-value"><%= billing.getReservationNo() %></td></tr>
                    <tr><td class="details-label">Guest Name</td><td class="details-value"><%= billing.getGuestName() %></td></tr>
                    <tr><td class="details-label">Address</td><td class="details-value"><%= billing.getAddress() %></td></tr>
                    <tr><td class="details-label">Contact</td><td class="details-value"><%= billing.getContact() %></td></tr>
                    <tr><td class="details-label">Room</td><td class="details-value"><%= billing.getRoomNo() %> (<%= billing.getRoomType() %>)</td></tr>
                    <tr><td class="details-label">Check-in</td><td class="details-value"><%= billing.getCheckIn() %></td></tr>
                    <tr><td class="details-label">Check-out</td><td class="details-value"><%= billing.getCheckOut() %></td></tr>
                    <tr><td class="details-label">Nights</td><td class="details-value"><%= billing.getNights() %></td></tr>
                    <tr><td class="details-label">Rate / Night</td><td class="details-value"><%= billing.getPricePerNight() %></td></tr>
                    <tr><td class="details-label">Total Amount</td><td class="details-value"><strong><%= billing.getTotalBill() %></strong></td></tr>
                </table>
            </div>

            <p style="margin-top:18px; text-align:center; color:#475569; font-weight:700;">Thank you!</p>
            <% } %>
        </div>
    </main>

    <footer class="site-footer no-print">
        <div class="site-footer-inner">
            Ocean View Resort Reservation System
        </div>
    </footer>

</div>
</body>
</html>