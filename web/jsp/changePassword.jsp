
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
            <h2>Change Password</h2>
            <form action="ChangePasswordServlet" method="post">
                <input type="password" name="oldpassword" placeholder="Old Password" required>
                <input type="password" name="newpassword" placeholder="New Password" required>
                <input type="password" name="repassword" placeholder="Re-Password" required>
                ${err}
                <button type="submit">Change</button>
            </form>
        </div>
    </body>
</html>
