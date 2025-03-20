
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
        <link href="css/login.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <h2>Forgot Password</h2>
            <form action="ForgotPassword" method="post">
                <input type="email" name="email" value="${email}" placeholder="Email" required>
                <input type="text" name="username" value="${username}" placeholder="User name" required>
                <input type="password" name="newpassword" value="${newpassword}" placeholder="New Password" required>
                <input type="password" name="repassword" value="${repassword}" placeholder="Re-Password" required>
                ${err}
                <button type="submit">Change</button>
            </form>
        </div>
    </body>
</html>
