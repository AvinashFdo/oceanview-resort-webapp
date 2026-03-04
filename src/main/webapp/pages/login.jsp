<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Read lastUsername cookie (if exists)
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

    <style>
        body { font-family: Arial, sans-serif; background: #f5f7fb; margin: 0; }
        .wrap { max-width: 420px; margin: 60px auto; padding: 24px; background: #fff; border-radius: 10px; box-shadow: 0 6px 18px rgba(0,0,0,.08); }
        h1 { margin: 0 0 8px; font-size: 22px; }
        p { margin: 0 0 18px; color: #555; }
        label { display:block; margin: 12px 0 6px; font-weight: 600; }
        input { width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 8px; }
        button { width: 100%; margin-top: 16px; padding: 10px; border: 0; border-radius: 8px; cursor: pointer; }
        button { background: #0ea5e9; color: #fff; font-weight: 700; }
        .error { background: #fee2e2; color: #991b1b; padding: 10px; border-radius: 8px; margin: 10px 0; }
        .hint { font-size: 12px; color: #64748b; margin-top: 10px; }
    </style>
</head>
<body>
<div class="wrap">
    <h1>Ocean View Resort</h1>
    <p>Staff Login</p>

    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/login" onsubmit="return validateForm();">
        <label for="username">Username</label>
        <input id="username" name="username" type="text" value="<%= lastUsername %>" placeholder="Enter username">

        <label for="password">Password</label>
        <input id="password" name="password" type="password" placeholder="Enter password">

        <button type="submit">Login</button>

        <div class="hint">
            Demo: username <b>admin</b>, password <b>admin123</b>
        </div>
    </form>
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