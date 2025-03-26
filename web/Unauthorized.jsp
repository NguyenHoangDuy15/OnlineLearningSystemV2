<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>401 - Unauthorized</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', sans-serif;
            }

            body {
                background: linear-gradient(135deg, #276FD7, #1A4F9A);
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                color: #ffffff;
            }

            .container {
                text-align: center;
                padding: 40px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 20px;
                backdrop-filter: blur(10px);
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
                animation: fadeIn 1s ease-in;
            }

            h1 {
                font-size: 120px;
                color: #ffffff;
                text-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
                margin-bottom: 20px;
            }

            h2 {
                font-size: 36px;
                margin-bottom: 15px;
                font-weight: 500;
            }

            p {
                font-size: 18px;
                margin-bottom: 30px;
                opacity: 0.9;
            }

            .btn {
                display: inline-block;
                padding: 12px 30px;
                background: #ffffff;
                color: #276FD7;
                text-decoration: none;
                border-radius: 25px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn:hover {
                background: #f0f0f0;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .error-code {
                font-size: 180px;
                font-weight: 700;
                background: -webkit-linear-gradient(#ffffff, #a0c0ff);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1 class="error-code">401</h1>
            <h2>Unauthorized Access</h2>
            <p>Sorry, you don't have permission to access this page. Please log in or contact the administrator.</p>
            <c:choose>
                <c:when test="${not empty sessionScope.userid}">
                    <!-- Nếu userId tồn tại trong session, chuyển hướng về training index -->
                    <a href="index" class="btn">Back to Home</a>
                </c:when>
                <c:otherwise>
                    <!-- Nếu không có userId hoặc session, chuyển hướng về landing page -->
                    <a href="Langdingpage" class="btn">Back to Home</a>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>