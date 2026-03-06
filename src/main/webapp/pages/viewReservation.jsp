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
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f7fb;
            margin: 0;
        }

        .header {
            background: #0ea5e9;
            color: white;
            padding: 15px 20px;
            font-weight: bold;
            font-size: 22px;
        }

        .container {
            max-width: 900px;
            margin: 30px auto;
            background: white;
            border-radius: 14px;
            box-shadow: 0 6px 18px rgba(0,0,0,.08);
            padding: 24px;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 18px;
            flex-wrap: wrap;
        }

        .title {
            margin: 0;
            font-size: 34px;
            font-weight: 800;
            color: #0f172a;
        }

        .sub {
            margin: 6px 0 0 0;
            color: #475569;
            font-size: 15px;
        }

        .btn {
            padding: 10px 14px;
            border: 0;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-secondary {
            background: #e2e8f0;
            color: #0f172a;
        }

        .btn-primary {
            background: #0ea5e9;
            color: white;
        }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .msg {
            padding: 10px 12px;
            border-radius: 8px;
            margin-bottom: 14px;
        }

        .msg-ok {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #86efac;
        }

        .msg-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }

        .status-row {
            display: flex;
            gap: 10px;
            align-items: center;
            margin: 14px 0 18px;
            flex-wrap: wrap;
        }

        .badge {
            display: inline-block;
            padding: 8px 12px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 800;
            letter-spacing: .3px;
        }

        .badge-paid {
            background: #dcfce7;
            color: #166534;
        }

        .badge-pending {
            background: #fff7ed;
            color: #c2410c;
        }

        .actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 16px;
        }

        .details-card {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            overflow: hidden;
        }

        .details-head {
            background: #f8fafc;
            padding: 14px 16px;
            border-bottom: 1px solid #e2e8f0;
            font-size: 20px;
            font-weight: 800;
            color: #0f172a;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        td {
            padding: 14px 16px;
            border-bottom: 1px solid #eef2f7;
            vertical-align: top;
        }

        td.label {
            width: 32%;
            font-weight: 700;
            color: #0f172a;
            background: #fcfdff;
        }

        td.value {
            color: #111827;
        }

        .empty {
            padding: 18px;
            color: #64748b;
        }

        form.inline {
            margin: 0;
        }

        @media (max-width: 700px) {
            .container {
                margin: 16px;
                padding: 18px;
            }

            .title {
                font-size: 28px;
            }

            td {
                display: block;
                width: 100%;
                box-sizing: border-box;
            }

            td.label {
                border-bottom: 0;
                padding-bottom: 6px;
            }

            td.value {
                padding-top: 0;
            }
        }
    </style>
</head>
<body>

<div class="header">Ocean View Resort System</div>

<div class="container">

    <div class="topbar">
        <div>
            <h2 class="title">Reservation Details</h2>
            <% if (details != null) { %>
            <p class="sub">Reservation No: <strong><%= details.getReservationNo() %></strong></p>
            <% } else { %>
            <p class="sub">View full details for the selected reservation.</p>
            <% } %>
        </div>

        <a href="<%= request.getContextPath() %>/reservations" class="btn btn-secondary">← Back to Reservations</a>
    </div>

    <% if ("cancel_ok".equals(msg)) { %>
    <div class="msg msg-ok">Reservation cancelled successfully.</div>
    <% } else if ("cancel_fail".equals(msg)) { %>
    <div class="msg msg-error">Failed to cancel reservation. It may already be paid or already cancelled.</div>
    <% } %>

    <% if (error != null) { %>
    <div class="msg msg-error"><%= error %></div>
    <% } %>

    <% if (details != null) { %>

    <div class="status-row">
        <span style="font-weight:700; color:#0f172a;">Payment Status:</span>
        <% if (paid) { %>
        <span class="badge badge-paid">COMPLETED</span>
        <% } else { %>
        <span class="badge badge-pending">PENDING</span>
        <% } %>
    </div>

    <div class="actions">
        <% if (paid) { %>
        <a class="btn btn-primary"
           href="<%= request.getContextPath() %>/bill?reservationNo=<%= details.getReservationNo() %>">
            Print Bill
        </a>
        <% } else { %>
        <form method="post"
              action="<%= request.getContextPath() %>/reservations/cancel"
              class="inline"
              onsubmit="return confirm('Are you sure you want to cancel reservation <%= details.getReservationNo() %>?');">
            <input type="hidden" name="reservationNo" value="<%= details.getReservationNo() %>" />
            <button class="btn btn-danger" type="submit">Cancel Reservation</button>
        </form>
        <% } %>
    </div>

    <div class="details-card">
        <div class="details-head">Reservation Information</div>

        <table>
            <tr>
                <td class="label">Guest Name</td>
                <td class="value"><%= details.getGuestName() %></td>
            </tr>
            <tr>
                <td class="label">Address</td>
                <td class="value"><%= details.getAddress() %></td>
            </tr>
            <tr>
                <td class="label">Contact</td>
                <td class="value"><%= details.getContact() %></td>
            </tr>
            <tr>
                <td class="label">Room Number</td>
                <td class="value"><%= details.getRoomNo() %></td>
            </tr>
            <tr>
                <td class="label">Room Type</td>
                <td class="value"><%= details.getRoomType() %></td>
            </tr>
            <tr>
                <td class="label">Check-in</td>
                <td class="value"><%= details.getCheckIn() %></td>
            </tr>
            <tr>
                <td class="label">Check-out</td>
                <td class="value"><%= details.getCheckOut() %></td>
            </tr>
            <tr>
                <td class="label">Nights</td>
                <td class="value"><%= details.getNights() %></td>
            </tr>
            <tr>
                <td class="label">Price / Night</td>
                <td class="value"><%= details.getPricePerNight() %></td>
            </tr>
            <tr>
                <td class="label">Total Bill</td>
                <td class="value"><strong><%= details.getTotalBill() %></strong></td>
            </tr>
        </table>
    </div>

    <% } else { %>
    <div class="details-card">
        <div class="details-head">Reservation Information</div>
        <div class="empty">No reservation details available.</div>
    </div>
    <% } %>

</div>

</body>
</html>