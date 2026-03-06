<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oceanviewresort.model.DashboardSummary" %>
<%
  String username = (String) session.getAttribute("username");
  String role = (String) session.getAttribute("role");

  if (username == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }

  DashboardSummary summary = (DashboardSummary) request.getAttribute("summary");
  boolean isAdmin = role != null && role.equalsIgnoreCase("ADMIN");
%>

<!DOCTYPE html>
<html>
<head>
  <title>Dashboard - Ocean View Resort</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background:#f5f7fb;
      margin:0;
    }

    .header {
      background:#0ea5e9;
      color:white;
      padding:15px;
      display:flex;
      justify-content:space-between;
      align-items:center;
    }

    .container {
      padding:30px;
      max-width: 1200px;
      margin: 0 auto;
    }

    .welcome {
      margin-bottom: 20px;
    }

    .welcome h2 {
      margin: 0 0 6px 0;
      font-size: 32px;
      color:#0f172a;
    }

    .welcome p {
      margin:0;
      color:#475569;
      font-size:15px;
    }

    .summary-grid {
      display:grid;
      grid-template-columns: repeat(3, 1fr);
      gap:16px;
      margin: 24px 0 30px;
    }

    .summary-card {
      background:white;
      border-radius:14px;
      padding:20px;
      box-shadow:0 4px 12px rgba(0,0,0,0.08);
    }

    .summary-label {
      color:#64748b;
      font-size:14px;
      font-weight:700;
      margin-bottom:8px;
    }

    .summary-value {
      color:#0f172a;
      font-size:32px;
      font-weight:800;
    }

    .section-title {
      font-size:20px;
      font-weight:800;
      color:#0f172a;
      margin: 6px 0 12px;
    }

    .menu {
      margin-top:10px;
      display:grid;
      grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
      gap:14px;
    }

    .menu a {
      display:block;
      padding:14px 16px;
      background:white;
      border-radius:10px;
      text-decoration:none;
      color:#333;
      box-shadow:0 3px 8px rgba(0,0,0,0.08);
      font-weight:700;
      transition: transform .15s ease, background .15s ease;
    }

    .menu a:hover {
      background:#e0f2fe;
      transform: translateY(-2px);
    }

    .logout {
      color:white;
      text-decoration:none;
      font-weight:bold;
    }

    .role-badge {
      display:inline-block;
      padding:6px 10px;
      border-radius:999px;
      background:rgba(255,255,255,0.18);
      font-size:12px;
      font-weight:800;
      margin-left:8px;
    }

    @media (max-width: 900px) {
      .summary-grid {
        grid-template-columns: 1fr;
      }

      .welcome h2 {
        font-size: 28px;
      }
    }
  </style>
</head>

<body>

<div class="header">
  <div>
    <strong>Ocean View Resort System</strong>
  </div>

  <div>
    Welcome, <%= username %>
    <span class="role-badge"><%= role %></span>
    |
    <a class="logout" href="<%= request.getContextPath() %>/logout">Logout</a>
  </div>
</div>

<div class="container">

  <div class="welcome">
    <h2>Dashboard</h2>
    <% if (isAdmin) { %>
    <p>Admin overview and system functions.</p>
    <% } else { %>
    <p>Receptionist operations panel.</p>
    <% } %>
  </div>

  <% if (isAdmin && summary != null) { %>
  <div class="summary-grid">
    <div class="summary-card">
      <div class="summary-label">Active Reservations</div>
      <div class="summary-value"><%= summary.getActiveReservations() %></div>
    </div>

    <div class="summary-card">
      <div class="summary-label">Pending Payments</div>
      <div class="summary-value"><%= summary.getPendingPayments() %></div>
    </div>

    <div class="summary-card">
      <div class="summary-label">Total Revenue</div>
      <div class="summary-value">USD <%= summary.getTotalRevenue() %></div>
    </div>
  </div>
  <% } %>

  <div class="section-title">Functions</div>

  <div class="menu">
    <a href="<%= request.getContextPath() %>/reservations/add">Add Reservation</a>
    <a href="<%= request.getContextPath() %>/reservations">View Reservations</a>
    <a href="<%= request.getContextPath() %>/payments/add">Add Payment / Print Bill</a>

    <% if (isAdmin) { %>
    <a href="<%= request.getContextPath() %>/users/create">Create Receptionist User</a>
    <% } %>
  </div>

</div>

</body>
</html>