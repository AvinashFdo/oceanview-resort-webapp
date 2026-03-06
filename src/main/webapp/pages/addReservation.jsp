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
                <h1 class="page-title">Add Reservation</h1>
                <p class="page-subtitle">Select a room, review booked dates and create a reservation.</p>
            </div>
            <div class="actions">
                <a class="btn btn-secondary" href="<%= request.getContextPath() %>/dashboard">← Dashboard</a>
            </div>
        </div>

        <% if (error != null) { %>
        <div class="msg msg-error"><%= error %></div>
        <% } %>

        <% if (success != null) { %>
        <div class="msg msg-success"><%= success %></div>
        <% } %>

        <% if (reservationNo != null && !reservationNo.trim().isEmpty()) { %>
        <div class="actions" style="margin-bottom: 16px;">
            <a class="btn btn-primary"
               href="<%= request.getContextPath() %>/payments/add?reservationNo=<%= reservationNo %>">
                Pay Now
            </a>

            <a class="btn btn-secondary"
               href="<%= request.getContextPath() %>/dashboard">
                Pay Later
            </a>
        </div>
        <% } %>

        <div class="card">
            <form method="post" action="<%= request.getContextPath() %>/reservations/add" onsubmit="return validateForm();">

                <div class="form-row">
                    <div class="field">
                        <label>Filter by Type</label>
                        <select id="filterType" onchange="applyFilters()">
                            <option value="ALL">ALL</option>
                            <option value="STANDARD">STANDARD</option>
                            <option value="DELUXE">DELUXE</option>
                            <option value="SUITE">SUITE</option>
                        </select>
                    </div>
                    <div class="field">
                        <label>Filter by Status</label>
                        <select id="filterStatus" onchange="applyFilters()">
                            <option value="ALL">ALL</option>
                            <option value="AVAILABLE">AVAILABLE</option>
                            <option value="MAINTENANCE">MAINTENANCE</option>
                        </select>
                    </div>
                </div>

                <div class="section-title">Select a Room</div>

                <div id="roomGrid" class="room-grid">
                    <% if (rooms != null) {
                        for (Room r : rooms) {
                            String st = r.getStatus();
                            boolean maintenance = "MAINTENANCE".equalsIgnoreCase(st);
                    %>
                    <div class="room-card <%= maintenance ? "is-maintenance" : "" %>"
                         data-room-id="<%= r.getRoomId() %>"
                         data-room-number="<%= r.getRoomNumber() %>"
                         data-room-type="<%= r.getRoomType() %>"
                         data-price="<%= r.getPricePerNight() %>"
                         data-status="<%= st %>"
                         onclick="selectRoom(this)">
                        <div class="room-head">
                            <div class="room-title">Room <%= r.getRoomNumber() %></div>
                            <span class="status-badge <%= maintenance ? "status-danger" : "status-success" %>"><%= st %></span>
                        </div>
                        <div class="room-meta">Type: <strong><%= r.getRoomType() %></strong></div>
                        <div class="room-meta">Price: <strong>USD <%= r.getPricePerNight() %></strong> / night</div>
                        <% if (maintenance) { %>
                        <div class="room-note bad">Not bookable</div>
                        <% } else { %>
                        <div class="room-note ok">Click to book</div>
                        <% } %>
                    </div>
                    <% }} %>
                </div>

                <input type="hidden" id="roomId" name="roomId" value="">

                <div id="drawerOverlay" class="drawer-overlay" onclick="closeDrawer()"></div>

                <div id="drawer" class="drawer">
                    <div class="drawer-header">
                        <h3 class="drawer-title">Create Reservation</h3>
                        <button type="button" class="btn btn-secondary" onclick="closeDrawer()">Close</button>
                    </div>

                    <div class="msg msg-success" id="selectedRoomBox" style="display:none;"></div>

                    <div id="bookedDatesBox" class="booked-box" style="display:none;">
                        <h4>Booked Dates</h4>
                        <p class="booked-help">These date ranges are already reserved for the selected room.</p>
                        <div id="bookedDatesContent"></div>
                    </div>

                    <div class="field">
                        <label>Contact Number</label>
                        <input type="text" id="contactNo" name="contactNo" placeholder="07XXXXXXXX">
                    </div>

                    <div class="field">
                        <label>Guest Name</label>
                        <input type="text" id="guestName" name="guestName" placeholder="Guest full name">
                    </div>

                    <div class="field">
                        <label>Address</label>
                        <textarea id="address" name="address" placeholder="Guest address"></textarea>
                    </div>

                    <div class="form-row">
                        <div class="field">
                            <label>Check-in Date</label>
                            <input type="date" id="checkIn" name="checkIn">
                        </div>
                        <div class="field">
                            <label>Check-out Date</label>
                            <input type="date" id="checkOut" name="checkOut">
                        </div>
                    </div>

                    <div class="actions">
                        <button class="btn btn-primary" type="submit">Create Reservation</button>
                    </div>

                    <p class="small-note">
                        Existing bookings for the selected room are shown above. The system also validates date conflicts before saving the reservation.
                    </p>
                </div>

            </form>
        </div>
    </main>

    <footer class="site-footer">
        <div class="site-footer-inner">
            Ocean View Resort Reservation System
        </div>
    </footer>
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
        d.style.right = "-520px";
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