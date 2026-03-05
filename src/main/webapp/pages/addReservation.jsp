<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanviewresort.model.Room" %>

<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String reservationNo = (String) request.getAttribute("reservationNo");
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Reservation</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <style>
        body { font-family: Arial, sans-serif; background:#f5f7fb; margin:0; }
        .header { background:#0ea5e9; color:#fff; padding:14px 16px; }
        .container { max-width: 760px; margin: 22px auto; background:#fff; padding: 18px; border-radius: 10px; box-shadow: 0 6px 18px rgba(0,0,0,.08); }
        .row { display:flex; gap:12px; }
        .col { flex:1; }
        label { display:block; margin: 10px 0 6px; font-weight:600; }
        input, select, textarea { width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:8px; box-sizing:border-box; }
        textarea { min-height: 70px; resize: vertical; }
        .msg { padding:10px; border-radius:8px; margin: 10px 0; }
        .error { background:#fee2e2; color:#991b1b; }
        .success { background:#dcfce7; color:#166534; }
        .actions { margin-top: 14px; display:flex; gap:10px; }
        .btn { padding:10px 14px; border:0; border-radius:8px; cursor:pointer; font-weight:700; }
        .primary { background:#0ea5e9; color:#fff; }
        .secondary { background:#e2e8f0; color:#0f172a; text-decoration:none; display:inline-flex; align-items:center; }
    </style>
</head>
<body>

<div class="header">
    <strong>Ocean View Resort</strong> — Add Reservation
</div>

<div class="container">

    <div class="actions">
        <a class="btn secondary" href="<%= request.getContextPath() %>/dashboard">← Dashboard</a>
    </div>

    <% if (error != null) { %>
    <div class="msg error"><%= error %></div>
    <% } %>

    <% if (success != null) { %>
    <div class="msg success"><%= success %></div>
    <% } %>

    <% if (reservationNo != null && !reservationNo.trim().isEmpty()) { %>
    <div class="actions">
        <a class="btn secondary"
           href="<%= request.getContextPath() %>/payments/add?reservationNo=<%= reservationNo %>">
            Pay Now
        </a>
    </div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/reservations/add" onsubmit="return validateForm();">

        <div class="row">

            <div class="col">
                <label>Contact Number</label>
                <input type="text" id="contactNo" name="contactNo" placeholder="07XXXXXXXX">
            </div>
        </div>

        <label>Guest Name</label>
        <input type="text" id="guestName" name="guestName" placeholder="Guest full name">

        <label>Address</label>
        <textarea id="address" name="address" placeholder="Guest address"></textarea>

        <label>Select Room</label>
        <select id="roomId" name="roomId">
            <option value="">-- Select --</option>
            <% if (rooms != null) {
                for (Room r : rooms) { %>
            <option value="<%= r.getRoomId() %>">
                Room <%= r.getRoomNumber() %> - <%= r.getRoomType() %> (USD <%= r.getPricePerNight() %>/night)
            </option>
            <%  }
            } %>
        </select>

        <div class="row">
            <div class="col">
                <label>Check-in Date</label>
                <input type="date" id="checkIn" name="checkIn">
            </div>
            <div class="col">
                <label>Check-out Date</label>
                <input type="date" id="checkOut" name="checkOut">
            </div>
        </div>

        <div class="actions">
            <button class="btn primary" type="submit">Create Reservation</button>
        </div>

    </form>

</div>

<script>
    function validateForm() {
        const guest = document.getElementById("guestName").value.trim();
        const addr = document.getElementById("address").value.trim();
        const contact = document.getElementById("contactNo").value.trim();
        const roomId = document.getElementById("roomId").value;
        const inDate = document.getElementById("checkIn").value;
        const outDate = document.getElementById("checkOut").value;

        if (guest.length === 0) {
            alert("Please enter guest name.");
            return false;
        }
        if (addr.length === 0) {
            alert("Please enter address.");
            return false;
        }
        if (!/^[0-9]{9,12}$/.test(contact)) {
            alert("Contact number must contain 9 to 12 digits only.");
            return false;
        }
        if (roomId === "") {
            alert("Please select a room.");
            return false;
        }
        if (!inDate || !outDate) {
            alert("Please select check-in and check-out dates.");
            return false;
        }
        if (outDate <= inDate) {
            alert("Check-out date must be after check-in date.");
            return false;
        }
        return true;
    }
</script>

</body>
</html>