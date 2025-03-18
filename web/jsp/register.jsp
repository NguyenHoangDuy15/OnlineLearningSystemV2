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
                <button type="submit">Register</button>
            </form>
        </div>
    </body>
</html>
