<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String lastUsername = "";
    if (request.getCookies() != null) {
        for (Cookie c : request.getCookies()) {
            if ("lastUsername".equals(c.getName())) {
                lastUsername = c.getValue();
                break;
            }
        }
    }

    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View Resort - Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/styles.css">
</head>
<body>
<div class="app-shell">

    <header class="site-header">
        <div class="site-header-inner">
            <div class="brand">Ocean View Resort</div>
        </div>
    </header>

    <main class="page page-compact" style="display:flex; justify-content:center; align-items:center; min-height: calc(100vh - 150px);">
        <div class="card" style="width:100%; max-width:520px;">
            <div class="card-header">
                <h1 class="card-title">Staff Login</h1>
                <p class="card-subtitle">Sign in to access the reservation system.</p>
            </div>

            <% if (error != null) { %>
            <div class="msg msg-error"><%= error %></div>
            <% } %>

            <form method="post" action="<%= request.getContextPath() %>/login" onsubmit="return validateForm();">
                <div class="field">
                    <label for="username">Username</label>
                    <input id="username" name="username" type="text" value="<%= lastUsername %>" placeholder="Enter username">
                </div>

                <div class="field">
                    <label for="password">Password</label>
                    <input id="password" name="password" type="password" placeholder="Enter password">
                </div>

                <div class="actions" style="margin-top:16px;">
                    <button class="btn btn-primary" type="submit" style="width:100%;">Login</button>
                </div>

                <p class="small-note" style="margin-top:14px;">
                    Demo: username <strong>admin</strong>, password <strong>admin123</strong>
                </p>
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
    function validateForm() {
        const u = document.getElementById("username").value.trim();
        const p = document.getElementById("password").value.trim();

        if (u.length === 0) {
            alert("Please enter your username.");
            return false;
        }
        if (p.length === 0) {
            alert("Please enter your password.");
            return false;
        }
        return true;
    }
</script>
</body>
</html>