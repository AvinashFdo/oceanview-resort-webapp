<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanviewresort.model.Room" %>
<%
  String username = (String) session.getAttribute("username");
  String role = (String) session.getAttribute("role");

  if (username == null || role == null || !"ADMIN".equalsIgnoreCase(role)) {
    response.sendRedirect(request.getContextPath() + "/dashboard");
    return;
  }

  String error = (String) request.getAttribute("error");
  String success = (String) request.getAttribute("success");
  List<Room> rooms = (List<Room>) request.getAttribute("rooms");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Manage Rooms</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/styles.css">
</head>
<body>
<div class="app-shell">

  <header class="site-header">
    <div class="site-header-inner">
      <div class="brand">Ocean View Resort</div>
      <div class="header-right">
        <a class="header-link" href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a class="header-link" href="<%= request.getContextPath() %>/logout">Logout</a>
      </div>
    </div>
  </header>

  <main class="page page-wide">
    <div class="page-head">
      <div>
        <h1 class="page-title">Manage Rooms</h1>
        <p class="page-subtitle">Update room availability and maintenance status.</p>
      </div>
    </div>

    <% if (error != null) { %>
    <div class="msg msg-error"><%= error %></div>
    <% } %>

    <% if (success != null) { %>
    <div class="msg msg-success"><%= success %></div>
    <% } %>

    <div class="card">
      <div class="table-wrap">
        <table class="table">
          <thead>
          <tr>
            <th>Room No</th>
            <th>Type</th>
            <th>Price / Night</th>
            <th>Current Status</th>
            <th>Change Status</th>
          </tr>
          </thead>
          <tbody>
          <% if (rooms == null || rooms.isEmpty()) { %>
          <tr>
            <td colspan="5">No rooms found.</td>
          </tr>
          <% } else {
            for (Room r : rooms) { %>
          <tr>
            <td><%= r.getRoomNumber() %></td>
            <td><%= r.getRoomType() %></td>
            <td>USD <%= r.getPricePerNight() %></td>
            <td>
              <% if ("AVAILABLE".equalsIgnoreCase(r.getStatus())) { %>
              <span class="status-badge status-success"><%= r.getStatus() %></span>
              <% } else { %>
              <span class="status-badge status-danger"><%= r.getStatus() %></span>
              <% } %>
            </td>
            <td>
              <form method="post" action="<%= request.getContextPath() %>/rooms/manage" class="inline-form row">
                <input type="hidden" name="roomId" value="<%= r.getRoomId() %>">
                <select name="status" style="max-width:180px;">
                  <option value="AVAILABLE" <%= "AVAILABLE".equalsIgnoreCase(r.getStatus()) ? "selected" : "" %>>AVAILABLE</option>
                  <option value="MAINTENANCE" <%= "MAINTENANCE".equalsIgnoreCase(r.getStatus()) ? "selected" : "" %>>MAINTENANCE</option>
                </select>
                <button class="btn btn-primary" type="submit">Update</button>
              </form>
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