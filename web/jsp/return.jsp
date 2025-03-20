<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="en_US" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Payment Result</title>
        <link href="https://fonts.googleapis.com/css?family=Montserrat:400,600,700|Playfair+Display:400,700" rel="stylesheet">
        <link rel="stylesheet" href="style.css">
        <meta name="robots" content="noindex,follow" />
        <style>
            * {
                box-sizing: border-box;
            }

            html, body {
                font-family: 'Montserrat', sans-serif;
                width: 100%;
                margin: 0;
                padding: 0;
                background: linear-gradient(135deg, #e0e7ff 0%, #f0f4ff 100%);
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                overflow-x: hidden;
            }

            .result-panel {
                display: flex;
                flex-direction: column;
                width: 600px;
                max-width: 90%;
                background-color: #ffffff;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
                border-radius: 15px;
                overflow: hidden;
                height: auto;
                min-height: 400px;
                padding: 40px;
                text-align: center;
                border: 1px solid rgba(55, 122, 224, 0.1);
                animation: fadeIn 0.5s ease-in-out;
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

            .title {
                font-family: 'Playfair Display', serif;
                font-weight: 700;
                font-size: 28px;
                margin: 0 0 25px;
                color: #1A3C80;
                letter-spacing: 1px;
            }

            .success {
                color: #28a745;
                font-weight: 600;
                font-size: 18px;
                margin: 15px 0;
                background: rgba(40, 167, 69, 0.1);
                padding: 10px;
                border-radius: 5px;
            }

            .error {
                color: #dc3545;
                font-weight: 600;
                font-size: 18px;
                margin: 15px 0;
                background: rgba(220, 53, 69, 0.1);
                padding: 10px;
                border-radius: 5px;
            }

            .info-container {
                width: 80%;
                margin: 0 auto;
                text-align: left;
            }

            .info {
                margin: 15px 0;
                font-size: 16px;
                color: #333;
                display: flex;
                justify-content: space-between;
                padding: 8px 0;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            }

            .info strong {
                font-weight: 600;
                color: #1A3C80;
                flex: 0 0 150px;
            }

            .info span {
                flex: 1;
                text-align: right;
            }

            .btn {
                font-size: 14px;
                width: 160px;
                height: 45px;
                cursor: pointer;
                transition: all 0.3s ease;
                border: none;
                border-radius: 25px;
                font-weight: 600;
                margin-top: 30px;
                color: #fff;
                background: linear-gradient(90deg, #377AE0, #5A9CF5);
                box-shadow: 0 4px 10px rgba(55, 122, 224, 0.3);
                letter-spacing: 0.5px;
            }

            .btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 15px rgba(55, 122, 224, 0.4);
                background: linear-gradient(90deg, #5A9CF5, #377AE0);
            }

            .btn:focus {
                outline: none;
            }
        </style>
    </head>
    <body>
        <div class="result-panel">
            <h2 class="title">Transaction Result</h2>

            <c:if test="${not empty message}">
                <p class="${message.contains('success') ? 'success' : 'error'}">${message}</p>
            </c:if>

            <c:if test="${not empty orderId}">
                <div class="info-container">
                    <div class="info"><strong>Order ID:</strong> <span>${orderId}</span></div>
                    <div class="info"><strong>Amount:</strong> <span><fmt:formatNumber value="${amount / 100}" type="number" groupingUsed="true"/> VND</span></div>
                    <div class="info"><strong>Bank:</strong> <span>${bankCode}</span></div>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${message.contains('success')}">
                    <button class="btn" onclick="window.location.href = 'index'">Back to Home</button>
                </c:when>
                <c:when test="${not empty retryUrl}">
                    <button class="btn" onclick="window.location.href = '${retryUrl}'">Try Again</button>
                    <button class="btn" onclick="window.location.href = 'index'" style="background: #ccc; margin-left: 10px;">Cancel</button>
                </c:when>
                <c:otherwise>
                    <button class="btn" onclick="window.location.href = 'index'">Back to Home</button>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>