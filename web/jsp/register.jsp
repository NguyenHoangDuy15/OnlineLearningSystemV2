<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
        <script src="https://accounts.google.com/gsi/client" async defer></script>
        <link href="css/login.css" rel="stylesheet">
        <style>
            .noti{
                color: red;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Register</h2>
            <form action="RegisterServlet" method="post">
                <input type="text" name="name" value="${name}" placeholder="Full Name" required>
                <input type="email" name="email" value="${email}" placeholder="Email" required>
                <input type="text" name="username" value="${username}" placeholder="User name" required>
                <input type="password" name="password" value="${password}" placeholder="Password" required>
                <input type="password" name="repassword" value="${repassword}" placeholder="Re-Password" required>
                <div name="noti" class="noti">${err}</div>
                <button name="btn" type="submit">Register</button>
            </form>
        </div>
    </body>
</html>
