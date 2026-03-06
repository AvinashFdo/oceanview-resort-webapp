<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanviewresort.model.ReservationSummary" %>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String q = (String) request.getAttribute("q");
    if (q == null) q = "";

    List<ReservationSummary> list = (List<ReservationSummary>) request.getAttribute("list");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reservations</title>
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
                <h1 class="page-title">Reservations</h1>
                <p class="page-subtitle">Search, review and manage reservation records.</p>
            </div>
        </div>

        <div class="card">
            <form method="get" action="<%= request.getContextPath() %>/reservations">
                <div class="row">
                    <input type="text" name="q" value="<%= q %>" placeholder="Search by reservation no or guest name" style="max-width:360px;">
                    <button class="btn btn-primary" type="submit">Search</button>
                    <a class="btn btn-secondary" href="<%= request.getContextPath() %>/reservations">Reset</a>
                </div>
            </form>

            <div class="table-wrap" style="margin-top:16px;">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Reservation No</th>
                        <th>Guest</th>
                        <th>Room</th>
                        <th>Check-in</th>
                        <th>Check-out</th>
                        <th>Status</th>
                        <th>Res Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (list == null || list.isEmpty()) { %>
                    <tr>
                        <td colspan="8" class="wrap">No reservations found.</td>
                    </tr>
                    <% } else {
                        for (ReservationSummary r : list) {
                            String status = r.getPaymentStatus();
                            boolean pending = "PENDING".equalsIgnoreCase(status);
                            boolean isCancelled = "CANCELLED".equalsIgnoreCase(r.getReservationStatus());
                            boolean isPendingPayment = "PENDING".equalsIgnoreCase(r.getPaymentStatus());
                    %>
                    <tr>
                        <td><%= r.getReservationNo() %></td>
                        <td class="wrap"><%= r.getGuestName() %></td>
                        <td class="wrap"><%= r.getRoomNumber() %> (<%= r.getRoomType() %>)</td>
                        <td><%= r.getCheckIn() %></td>
                        <td><%= r.getCheckOut() %></td>
                        <td>
                            <span class="status-badge <%= pending ? "status-warning" : "status-success" %>"><%= status %></span>
                        </td>
                        <td>
                            <span class="status-badge <%= isCancelled ? "status-danger" : "status-success" %>"><%= r.getReservationStatus() %></span>
                        </td>
                        <td class="wrap">
                            <a href="<%= request.getContextPath() %>/viewReservation?reservationNo=<%= r.getReservationNo() %>">View</a>
                            &nbsp;|&nbsp;
                            <% if (isCancelled) { %>
                            <span style="color:#991b1b; font-weight:700;">Cancelled</span>
                            <% } else { %>
                            <% if (isPendingPayment) { %>
                            <a href="<%= request.getContextPath() %>/payments/add?reservationNo=<%= r.getReservationNo() %>">Pay</a>
                            <% } else { %>
                            <span style="color:#64748b; font-weight:700;">Paid</span>
                            <% } %>
                            <% } %>
                        </td>
                    </tr>
                    <% }} %>
                    </tbody>
                </table>
            </div>
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