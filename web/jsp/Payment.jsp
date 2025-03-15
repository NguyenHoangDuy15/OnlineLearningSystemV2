<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setLocale value="vi_VN" />
<fmt:setBundle basename="messages" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thanh toán khóa học</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                background-color: #f4f4f4;
            }
            .container {
                width: 50%;
                margin: auto;
                padding: 20px;
                border: 1px solid #ccc;
                border-radius: 5px;
                background-color: white;
            }
            h2 {
                text-align: center;
            }
            .form-group {
                margin-bottom: 15px;
            }
            label {
                font-weight: bold;
            }
            input, select {
                width: 100%;
                padding: 8px;
                margin-top: 5px;
            }
            .btn {
                background-color: green;
                color: white;
                padding: 10px;
                width: 100%;
                border: none;
                cursor: pointer;
            }
            .btn:hover {
                background-color: darkgreen;
            }
            .error {
                color: red;
                font-weight: bold;
                text-align: center;
            }
            .success {
                color: green;
                font-weight: bold;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Thanh toán khóa học</h2>

            <c:if test="${not empty message}">
                <p class="${message.contains('thành công') ? 'success' : 'error'}">${message}</p>
            </c:if>

            <form action="PaymentServlet" method="post">
                <div class="form-group">
                    <label>Tên khóa học:</label>
                    <input name="name" value="${course.name}" readonly />
                </div>

                <div class="form-group">
                    <label>Giá khóa học:</label>
                    <input name="price" value="${course.price}" readonly />
                </div>

                <div class="form-group">
                    <label>Số tiền thanh toán:</label>
                    <input name="amount" type="number" required />
                </div>

                <div class="form-group">
                    <label>Phương thức thanh toán:</label>
                    <select name="paymentMethod" required>
                        <option value="vnpay">VNPay</option>
                        <option value="momo">MoMo</option>
                        <option value="cod">Thanh toán khi nhận hàng</option>
                    </select>
                </div>

                <button type="submit" class="btn">Tiến hành thanh toán</button>
            </form>
            <a href="detail">Quay lại</a>
        </div>
    </body>
</html>
