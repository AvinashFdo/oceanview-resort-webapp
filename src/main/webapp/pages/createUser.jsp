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

    <main class="page page-compact">
        <div class="page-head">
            <div>
                <h1 class="page-title">Create Receptionist User</h1>
                <p class="page-subtitle">Only admin users can access this page.</p>
            </div>
        </div>

        <div class="card">
            <% if (error != null) { %>
            <div class="msg msg-error"><%= error %></div>
            <% } %>

            <% if (success != null) { %>
            <div class="msg msg-success"><%= success %></div>
            <% } %>

            <form method="post" action="<%= request.getContextPath() %>/users/create">
                <div class="field">
                    <label>Username</label>
                    <input type="text" name="username" placeholder="Enter username" required>
                </div>

                <div class="field">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Enter password" required>
                </div>

                <p class="small-note">Role will be created as <strong>RECEPTIONIST</strong>.</p>

                <div class="actions" style="margin-top:16px;">
                    <button class="btn btn-primary" type="submit">Create User</button>
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
</body>
</html>