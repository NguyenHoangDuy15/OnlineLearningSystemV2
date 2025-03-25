
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <script src="https://accounts.google.com/gsi/client" async defer></script>
        <link href="css/login.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>

            /* Google login button style */
            .g_id_signin {
                width: 100%;
                padding: 12px;
                background-color: #e67e22;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                display: flex;
                justify-content: center;
                align-items: center;
                font-size: 16px;
                margin-top: 20px;
            }

            .g_id_signin img {
                margin-right: 10px;
                width: 20px;  /* Điều chỉnh kích thước logo */
                height: 20px;
            }
            i{
                margin-right: 5px;
            }
            .noti{
                color: red;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Login</h2>
            <form action="LoginServlet" method="post">
                <input type="text" name="username" value="${username}" placeholder="User name" required>
                <input type="password" name="password" value="${password}" placeholder="Password" required>
                <table width="100%" style="margin: 10px">
                    <tr>
                        <td align="left"><a href="ForgotPassword">Forgot password</a></td>
                        <td align="right"><a href="RegisterServlet">Sign Up</a></td>
                    </tr>
                </table>
                <div name="noti" class="noti">${err}</div>
                <button name="login" type="submit">Login</button>
            </form>
            <div class="g_id_signin" id="google-sign-in">
                <a href="https://accounts.google.com/o/oauth2/auth?scope=email 
                   profile openid&redirect_uri=http://localhost:8080/LearningOnlineSystem/LoginGoogle&response_type=code
                   &client_id=116207527729-5c9ccgma2m4nttjda1lnrc3qi90cjkmg.apps.googleusercontent.com&approval_prompt=force" 
                   class="btn"style="color: white"><i class="fab fa-google"></i>
                    Đăng nhập bằng Google</a>
            </div>
        </div>
    </body>
</html>
