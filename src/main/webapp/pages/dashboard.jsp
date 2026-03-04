<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String username = (String) session.getAttribute("username");
  String role = (String) session.getAttribute("role");

  if (username == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
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
    }

    .menu {
      margin-top:20px;
    }

    .menu a {
      display:block;
      width:250px;
      padding:12px;
      margin:10px 0;
      background:white;
      border-radius:8px;
      text-decoration:none;
      color:#333;
      box-shadow:0 3px 8px rgba(0,0,0,0.08);
    }

    .menu a:hover {
      background:#e0f2fe;
    }

    .logout {
      color:white;
      text-decoration:none;
      font-weight:bold;
    }
  </style>
</head>

<body>

<div class="header">
  <div>
    <strong>Ocean View Resort System</strong>
  </div>

  <div>
    Welcome, <%= username %> (<%= role %>)
    |
    <a class="logout" href="<%= request.getContextPath() %>/logout">Logout</a>
  </div>
</div>

<div class="container">

  <h2>Dashboard</h2>
  <p>Select an option below:</p>

  <div class="menu">
    <a href="#">Add Reservation</a>
    <a href="#">View Reservations</a>
    <a href="#">Reports</a>
    <a href="#">Help</a>
  </div>

</div>

</body>
</html>