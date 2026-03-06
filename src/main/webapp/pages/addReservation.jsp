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
        html, body { overflow-x: hidden; }
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
        .actions { margin-top: 14px; display:flex; gap:10px; flex-wrap:wrap; }
        .btn { padding:10px 14px; border:0; border-radius:8px; cursor:pointer; font-weight:700; }
        .primary { background:#0ea5e9; color:#fff; }
        .secondary { background:#e2e8f0; color:#0f172a; text-decoration:none; display:inline-flex; align-items:center; }
        .booked-box {
            margin-top: 12px;
            padding: 12px;
            border: 1px solid #fed7aa;
            background: #fff7ed;
            border-radius: 10px;
        }

        .booked-box h4 {
            margin: 0 0 6px 0;
            color: #9a3412;
            font-size: 15px;
        }

        .booked-help {
            margin: 0 0 10px 0;
            color: #7c2d12;
            font-size: 13px;
        }

        .booked-list {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .booked-item {
            background: #ffffff;
            border: 1px solid #fdba74;
            border-radius: 8px;
            padding: 10px;
        }

        .booked-item-title {
            font-size: 13px;
            color: #9a3412;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .booked-item-dates {
            font-size: 14px;
            color: #431407;
            font-weight: 600;
        }

        .booked-empty {
            background: #f0fdf4;
            border: 1px solid #86efac;
            color: #166534;
            border-radius: 8px;
            padding: 10px;
            font-size: 14px;
            font-weight: 600;
        }
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
    <div class="actions" style="margin:12px 0;">
        <a class="btn secondary"
           href="<%= request.getContextPath() %>/payments/add?reservationNo=<%= reservationNo %>">
            Pay Now
        </a>

        <a class="btn secondary"
           href="<%= request.getContextPath() %>/dashboard">
            Pay Later
        </a>
    </div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/reservations/add" onsubmit="return validateForm();">

        <div class="row" style="margin-top:10px;">
            <div class="col">
                <label>Filter by Type</label>
                <select id="filterType" onchange="applyFilters()">
                    <option value="ALL">ALL</option>
                    <option value="STANDARD">STANDARD</option>
                    <option value="DELUXE">DELUXE</option>
                    <option value="SUITE">SUITE</option>
                </select>
            </div>
            <div class="col">
                <label>Filter by Status</label>
                <select id="filterStatus" onchange="applyFilters()">
                    <option value="ALL">ALL</option>
                    <option value="AVAILABLE">AVAILABLE</option>
                    <option value="MAINTENANCE">MAINTENANCE</option>
                </select>
            </div>
        </div>

        <label style="margin-top:14px;">Select a Room</label>

        <div id="roomGrid" style="display:grid; grid-template-columns: repeat(2, 1fr); gap: 12px; margin-top: 10px;">
            <% if (rooms != null) {
                for (Room r : rooms) {
                    String st = r.getStatus();
            %>
            <div class="room-card"
                 data-room-id="<%= r.getRoomId() %>"
                 data-room-number="<%= r.getRoomNumber() %>"
                 data-room-type="<%= r.getRoomType() %>"
                 data-price="<%= r.getPricePerNight() %>"
                 data-status="<%= st %>"
                 onclick="selectRoom(this)"
                 style="
                         border:1px solid #cbd5e1;
                         border-radius:12px;
                         padding:12px;
                         cursor:pointer;
                         background:<%= "MAINTENANCE".equalsIgnoreCase(st) ? "#f8fafc" : "#ffffff" %>;
                         opacity:<%= "MAINTENANCE".equalsIgnoreCase(st) ? "0.6" : "1" %>;
                         ">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <strong>Room <%= r.getRoomNumber() %></strong>
                    <span style="font-weight:800; font-size:12px;">
                        <%= st %>
                    </span>
                </div>
                <div style="margin-top:6px;">Type: <strong><%= r.getRoomType() %></strong></div>
                <div style="margin-top:6px;">Price: <strong>USD <%= r.getPricePerNight() %></strong> / night</div>
                <% if ("MAINTENANCE".equalsIgnoreCase(st)) { %>
                <div style="margin-top:8px; color:#991b1b; font-weight:700;">Not bookable</div>
                <% } else { %>
                <div style="margin-top:8px; color:#166534; font-weight:700;">Click to book</div>
                <% } %>
            </div>
            <% }} %>
        </div>

        <input type="hidden" id="roomId" name="roomId" value="">

        <div id="drawerOverlay"
             onclick="closeDrawer()"
             style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.35);"></div>

        <div id="drawer"
             style="position:fixed; top:0; right:-460px; width:420px; max-width:92vw; height:100vh;
                    background:#fff; box-shadow:-10px 0 30px rgba(0,0,0,.15);
                    transition:right .25s ease; padding:16px; overflow:auto;
                    z-index:10000; visibility:hidden;">

            <div style="display:flex; justify-content:space-between; align-items:center;">
                <h3 style="margin:0;">Create Reservation</h3>
                <button type="button" class="btn secondary" onclick="closeDrawer()">Close</button>
            </div>

            <div class="msg success" id="selectedRoomBox" style="display:none; margin-top:12px;"></div>

            <!-- Booked dates display -->
            <div id="bookedDatesBox" class="booked-box" style="display:none;">
                <h4>Booked Dates</h4>
                <p class="booked-help">These date ranges are already reserved for the selected room.</p>
                <div id="bookedDatesContent"></div>
            </div>

            <label style="margin-top:12px;">Contact Number</label>
            <input type="text" id="contactNo" name="contactNo" placeholder="07XXXXXXXX">

            <label>Guest Name</label>
            <input type="text" id="guestName" name="guestName" placeholder="Guest full name">

            <label>Address</label>
            <textarea id="address" name="address" placeholder="Guest address"></textarea>

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

            <p style="color:#64748b; font-size:12px; margin-top:10px;">
                Note: Existing bookings for the selected room are shown above. The system also validates date conflicts before saving the reservation.
            </p>
        </div>

    </form>
</div>

<script>
    function openDrawer() {
        document.getElementById("drawerOverlay").style.display = "block";
        const d = document.getElementById("drawer");
        d.style.visibility = "visible";
        d.style.right = "0";
    }

    function closeDrawer() {
        document.getElementById("drawerOverlay").style.display = "none";
        const d = document.getElementById("drawer");
        d.style.right = "-460px";
        setTimeout(() => { d.style.visibility = "hidden"; }, 260);
    }

    async function loadBookedDateRanges(roomId) {
        const url = "<%= request.getContextPath() %>/rooms/booked-dates?roomId=" + encodeURIComponent(roomId);
        const res = await fetch(url);

        if (!res.ok) {
            console.warn("Booked dates fetch failed:", res.status);
            return [];
        }

        const data = await res.json();
        console.log("Booked ranges for drawer:", data.ranges);
        return data.ranges || [];
    }

    function renderBookedDates(ranges) {
        const box = document.getElementById("bookedDatesBox");
        const content = document.getElementById("bookedDatesContent");

        box.style.display = "block";
        content.innerHTML = "";

        if (!ranges || ranges.length === 0) {
            const empty = document.createElement("div");
            empty.className = "booked-empty";
            empty.textContent = "No existing bookings for this room.";
            content.appendChild(empty);
            return;
        }

        const list = document.createElement("div");
        list.className = "booked-list";

        for (let i = 0; i < ranges.length; i++) {
            const r = ranges[i];

            console.log("Booked range item:", r, "keys:", Object.keys(r));

            const checkIn = r.checkIn || r.check_in || "";
            const checkOut = r.checkOut || r.check_out || "";

            const item = document.createElement("div");
            item.className = "booked-item";

            const title = document.createElement("div");
            title.className = "booked-item-title";
            title.textContent = "Booking " + (i + 1);

            const dates = document.createElement("div");
            dates.className = "booked-item-dates";
            dates.textContent = checkIn + " → " + checkOut;

            item.appendChild(title);
            item.appendChild(dates);
            list.appendChild(item);
        }

        content.appendChild(list);
    }

    async function selectRoom(card) {
        const status = (card.dataset.status || "").toUpperCase();
        if (status === "MAINTENANCE") {
            alert("This room is under maintenance and cannot be booked.");
            return;
        }

        const roomId = card.dataset.roomId;
        const roomNumber = card.dataset.roomNumber;
        const roomType = card.dataset.roomType;
        const price = card.dataset.price;

        document.getElementById("roomId").value = roomId;

        const box = document.getElementById("selectedRoomBox");
        box.style.display = "block";
        box.innerHTML = "Selected: <strong>Room " + roomNumber + "</strong> (" + roomType + ") — USD " + price + " / night";

        document.getElementById("checkIn").value = "";
        document.getElementById("checkOut").value = "";

        try {
            const ranges = await loadBookedDateRanges(roomId);
            renderBookedDates(ranges);
        } catch (e) {
            console.warn("Could not load booked dates", e);
            renderBookedDates([]);
        }

        openDrawer();
    }

    function applyFilters() {
        const t = document.getElementById("filterType").value;
        const s = document.getElementById("filterStatus").value;

        document.querySelectorAll(".room-card").forEach(card => {
            const ct = (card.dataset.roomType || "").toUpperCase();
            const cs = (card.dataset.status || "").toUpperCase();

            const typeOk = (t === "ALL") || (ct === t);
            const statusOk = (s === "ALL") || (cs === s);

            card.style.display = (typeOk && statusOk) ? "block" : "none";
        });
    }

    function validateForm() {
        const guest = document.getElementById("guestName").value.trim();
        const addr = document.getElementById("address").value.trim();
        const contact = document.getElementById("contactNo").value.trim();
        const roomId = document.getElementById("roomId").value;
        const inDate = document.getElementById("checkIn").value;
        const outDate = document.getElementById("checkOut").value;

        if (roomId === "") {
            alert("Please select a room.");
            return false;
        }
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

    window.addEventListener("load", () => {
        const reservationNo = "<%= (reservationNo == null ? "" : reservationNo) %>";
        if (reservationNo && reservationNo.trim().length > 0) {
            closeDrawer();
            window.scrollTo(0, 0);
        }
    });

    window.selectRoom = selectRoom;
    window.applyFilters = applyFilters;
    window.validateForm = validateForm;
</script>

</body>
</html>