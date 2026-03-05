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
    <style>
        body { font-family: Arial, sans-serif; background:#f5f7fb; margin:0; }
        .header { background:#0ea5e9; color:white; padding:15px; display:flex; justify-content:space-between; align-items:center; }
        .container { padding:30px; max-width: 1100px; margin: 0 auto; }
        .card { background:white; padding:16px; border-radius:10px; box-shadow:0 3px 8px rgba(0,0,0,0.08); }
        .row { display:flex; gap:10px; align-items:center; flex-wrap:wrap; }
        .input { padding:10px; border:1px solid #cbd5e1; border-radius:8px; width:260px; }
        .btn { padding:10px 14px; border:0; border-radius:8px; cursor:pointer; font-weight:700; }
        .primary { background:#0ea5e9; color:#fff; }
        .secondary { background:#e2e8f0; color:#0f172a; text-decoration:none; display:inline-flex; align-items:center; }
        table { width:100%; border-collapse:collapse; margin-top:14px; }
        th, td { text-align:left; padding:10px; border-bottom:1px solid #eee; }
        th { background:#f8fafc; }
        .status { font-weight:800; }
        .pending { color:#b45309; }
        .completed { color:#166534; }
        a { color:#0ea5e9; text-decoration:none; font-weight:700; }
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
    <h2>Reservations</h2>

    <div class="card">
        <form method="get" action="<%= request.getContextPath() %>/reservations">
            <div class="row">
                <input class="input" type="text" name="q" value="<%= q %>" placeholder="Search by reservation no or guest name" />
                <button class="btn primary" type="submit">Search</button>
                <a class="btn secondary" href="<%= request.getContextPath() %>/reservations">Reset</a>
            </div>
        </form>

        <table>
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
                <td colspan="7">No reservations found.</td>
            </tr>
            <% } else {
                for (ReservationSummary r : list) {
                    String status = r.getPaymentStatus();
                    boolean pending = "PENDING".equalsIgnoreCase(status);
            %>
            <tr>
                <td><%= r.getReservationNo() %></td>
                <td><%= r.getGuestName() %></td>
                <td><%= r.getRoomNumber() %> (<%= r.getRoomType() %>)</td>
                <td><%= r.getCheckIn() %></td>
                <td><%= r.getCheckOut() %></td>
                <td class="status <%= pending ? "pending" : "completed" %>"><%= status %></td>
                <td class="status <%= "CANCELLED".equalsIgnoreCase(r.getReservationStatus()) ? "pending" : "completed" %>">
                    <%= r.getReservationStatus() %>
                </td>
                <td>
                    <a href="<%= request.getContextPath() %>/viewReservation?reservationNo=<%= r.getReservationNo() %>">View</a>
                    &nbsp;|&nbsp;

                    <%
                        boolean isCancelled = "CANCELLED".equalsIgnoreCase(r.getReservationStatus());
                        boolean isPendingPayment = "PENDING".equalsIgnoreCase(r.getPaymentStatus());
                    %>

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

</body>
</html>