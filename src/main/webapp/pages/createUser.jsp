<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Create User</title>
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
            max-width:600px;
            margin:30px auto;
            background:white;
            padding:24px;
            border-radius:12px;
            box-shadow:0 3px 8px rgba(0,0,0,0.08);
        }

        label {
            display:block;
            margin:12px 0 6px;
            font-weight:bold;
        }

        input {
            width:100%;
            padding:10px;
            border:1px solid #cbd5e1;
            border-radius:8px;
            box-sizing:border-box;
        }

        .btn {
            margin-top:16px;
            padding:10px 14px;
            border:0;
            border-radius:8px;
            cursor:pointer;
            font-weight:bold;
            background:#0ea5e9;
            color:white;
        }

        .msg {
            padding:10px;
            border-radius:8px;
            margin-bottom:12px;
        }

        .error {
            background:#fee2e2;
            color:#991b1b;
        }

        .success {
            background:#dcfce7;
            color:#166534;
        }

        .top-links a {
            color:white;
            text-decoration:none;
            font-weight:bold;
            margin-left:12px;
        }

        .hint {
            margin-top:8px;
            color:#64748b;
            font-size:13px;
        }
    </style>
</head>
<body>

<div class="header">
    <div><strong>Ocean View Resort System</strong></div>
    <div class="top-links">
        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
</div>

<div class="container">
    <h2>Create Receptionist User</h2>
    <p>Only admin users can access this page.</p>

    <% if (error != null) { %>
    <div class="msg error"><%= error %></div>
    <% } %>

    <% if (success != null) { %>
    <div class="msg success"><%= success %></div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/users/create">
        <label>Username</label>
        <input type="text" name="username" placeholder="Enter username" required>

        <label>Password</label>
        <input type="password" name="password" placeholder="Enter password" required>

        <div class="hint">Role will be created as <strong>RECEPTIONIST</strong>.</div>

        <button class="btn" type="submit">Create User</button>
    </form>
</div>

</body>
</html>