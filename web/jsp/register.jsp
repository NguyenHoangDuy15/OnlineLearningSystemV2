<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
        <script src="https://accounts.google.com/gsi/client" async defer></script>
        <link href="css/login.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <h2>Register</h2>
            <form action="RegisterServlet" method="post">
                <input type="text" name="name" placeholder="Full Name" required>
                <input type="email" name="email" placeholder="Email" required>
                <input type="text" name="username" placeholder="User name" required>
                <input type="password" name="password" placeholder="Password" required>
                <input type="password" name="repassword" placeholder="Re-Password" required>
                ${err}
                <div id="g_id_onload"
                     data-client_id="YOUR_GOOGLE_CLIENT_ID"
                     data-context="signin"
                     data-ux_mode="redirect"
                     data-login_uri="http://localhost:8080/your_project/LoginGoogleServlet"
                     data-auto_prompt="false">
                </div>
                <div class="g_id_signin" data-type="standard"></div>

                <button type="submit">Register</button>
            </form>
        </div>
    </body>
</html>
