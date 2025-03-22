<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setLocale value="vi_VN" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Payment</title>
        <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet">
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
                background: #f0f4ff;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                overflow-x: hidden;
            }

            .checkout-panel {
                display: flex;
                flex-direction: column;
                width: 800px;
                max-width: 90%;
                background-color: #ffffff;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
                overflow: hidden;
                height: auto;
                min-height: 400px;
            }

            .panel-body {
                padding: 30px;
                flex: 1;
            }

            .title {
                font-weight: 700;
                font-size: 24px;
                margin: 0 0 20px;
                color: #1A3C80;
            }

            .course-info h3 {
                font-size: 18px;
                color: #1A3C80;
                margin-bottom: 20px;
            }

            .input-fields {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            .input-fields label {
                display: block;
                margin-bottom: 5px;
                color: #666;
                font-size: 14px;
            }

            div[class*='column'] {
                width: 100%;
            }

            input[type='text'] {
                font-size: 16px;
                width: 100%;
                height: 40px;
                padding: 0 12px;
                color: #333;
                border: 1px solid #d6e2ff;
                border-radius: 5px;
                background-color: #f9fbff;
                outline: none;
            }

            input[type='text']:focus {
                border-color: #377AE0;
                box-shadow: 0 0 5px rgba(55, 122, 224, 0.3);
            }

            .small-inputs {
                margin-top: 15px;
            }

            .small-inputs div {
                width: 100%;
            }

            .panel-footer {
                display: flex;
                width: 100%;
                padding: 20px 30px;
                background-color: #eef2ff;
                justify-content: space-between;
                align-items: center;
            }

            .btn {
                font-size: 14px;
                width: 120px;
                height: 40px;
                cursor: pointer;
                transition: all 0.3s ease;
                border: none;
                border-radius: 20px;
                font-weight: 600;
            }

            .back-btn {
                color: #377AE0;
                background: #fff;
                box-shadow: 0 2px 5px rgba(55, 122, 224, 0.2);
            }

            .next-btn {
                color: #fff;
                background: #377AE0;
                box-shadow: 0 2px 5px rgba(55, 122, 224, 0.3);
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(55, 122, 224, 0.4);
            }

            .btn:focus {
                outline: none;
            }

            .success {
                color: green;
                font-weight: bold;
                text-align: center;
            }

            .error {
                color: red;
                font-weight: bold;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="checkout-panel">
            <c:if test="${not empty message}">
                <p class="${message.contains('thành công') ? 'success' : 'error'}">${message}</p>
            </c:if>

            <div class="panel-body">
                <h2 class="title">Checkout</h2>

                <form id="paymentForm" action="VNPAYServlet" method="POST">
                    <div class="course-info">
                        <h3>Course: ${course.name}</h3>
                    </div>

                    <div class="input-fields">
                        <div class="column-1">
                            <label for="cardholder">Price</label>
                            <input type="text" id="cardholder" name="price" value="<fmt:formatNumber value='${course.price}' type='currency' currencySymbol='VND' />" readonly />

                            <div class="small-inputs">
                                <div>
                                    <label for="date">Total Payment</label>
                                    <input type="text" id="date" name="displayAmount" value="<fmt:formatNumber value='${course.price}' type='currency' currencySymbol='VND' />" readonly />
                                    <!-- Gửi giá trị gốc của course.price -->
                                    <input type="hidden" name="amount" value="${course.price}" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Hidden input để gửi courseId -->
                    <input type="hidden" name="courseId" value="${course.courseID}" />
                </form>
            </div>

            <div class="panel-footer">
                <button class="btn back-btn" onclick="window.location.href = 'detail?courseId=${course.courseID}'">Back</button>
                <button class="btn next-btn" onclick="document.getElementById('paymentForm').submit()">Next Step</button>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        <script>
                    $(document).ready(function () {
                        $('.next-btn').on('click', function (e) {
                            e.preventDefault();
                            $('#paymentForm').submit();
                        });

                        $('.back-btn').on('click', function (e) {
                            e.preventDefault();
                            window.location.href = 'detail?courseId=${course.courseID}';
                        });
                    });
        </script>
    </body>
</html>