
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Verify</title>
        <script src="https://accounts.google.com/gsi/client" async defer></script>
        <link href="css/login.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <h2>Verify Email</h2>
            <form action="VerifyServlet" method="get">
                <!-- Verification code input -->
                <input type="text" name="verificationCode" placeholder="Enter 6-digit code" required pattern="\d{6}" title="Please enter a 6-digit code">
                <input type="hidden" name="name" value="${name}">
                <input type="hidden" name="email" value="${email}">
                <input type="hidden" name="username" value="${username}">
                <input type="hidden" name="password" value="${password}">
                ${err}
                <button type="submit">Verify</button>
            </form>
        </div>
    </body>
</html>
