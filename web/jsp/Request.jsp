<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Wait for Application Approval</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="img/favicon.ico" rel="icon">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        /* Jumbotron (Header) */
        .jumbotron {
            position: relative;
            overflow: hidden;
        }

        .jumbotron h1 {
            font-weight: 700;
            transition: transform 0.3s ease;
        }

        .jumbotron h1:hover {
            transform: scale(1.05);
        }

        /* Card (chứa bảng) */
        .card {
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        .card h3 {
            font-weight: 600;
            transition: transform 0.3s ease;
        }

        .card h3:hover {
            transform: scale(1.02);
        }

        /* Bảng */
        .table {
            border-radius: 10px;
            overflow: hidden;
        }

        .table thead th {
            font-weight: 600;
            padding: 15px;
        }

        .table tbody tr {
            transition: background 0.3s ease, transform 0.3s ease;
        }

        .table tbody tr:hover {
            background: rgba(0, 0, 0, 0.05);
            transform: translateX(5px);
        }

        .table tbody td {
            position: relative;
            padding: 15px;
            transition: transform 0.3s ease;
        }

        .table tbody td:hover {
            transform: translateX(5px);
        }

        /* Tooltip cho các cột */
        .table tbody td .tooltip-text {
            visibility: hidden;
            width: 150px;
            background-color: #333;
            color: #fff;
            text-align: center;
            border-radius: 6px;
            padding: 5px;
            position: absolute;
            z-index: 1;
            bottom: 125%;
            left: 50%;
            transform: translateX(-50%);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .table tbody td:hover .tooltip-text {
            visibility: visible;
            opacity: 1;
        }

        /* Thông báo khi không có yêu cầu */
        .text-warning {
            font-size: 1.2rem;
            line-height: 1.8;
            animation: fadeIn 1s ease-in-out;
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
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="jumbotron jumbotron-fluid position-relative overlay-bottom" style="margin-bottom: 90px;">
        <div class="container text-center my-5 py-5">
            <h1 class="text-white display-1 mb-5">Wait for Application Approval</h1>
        </div>
    </div>

    <div class="container my-5">
        <div class="card p-4 shadow-sm">
            <h3 class="text-center mb-4">Your Role Requests</h3>

            <table class="table table-bordered text-center">
                <thead>
                    <tr>
                        <th class="bg-primary text-white">Request ID</th>
                        <th class="bg-primary text-white">Requested Role</th>
                        <th class="bg-primary text-white">Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty roleRequests}">
                            <tr>
                                <td colspan="3" class="text-center text-warning fw-bold">You have no role requests.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="request" items="${roleRequests}">
                                <tr>
                                    <td class="text-primary fw-bold">${request.getRequestID()}<span class="tooltip-text">ID yêu cầu</span></td>  
                                    <td>${request.rolename}<span class="tooltip-text">Vai trò yêu cầu</span></td>
                                    <td>${request.statustext}<span class="tooltip-text">Trạng thái</span></td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="lib/easing/easing.min.js"></script>
    <script src="lib/waypoints/waypoints.min.js"></script>
    <script src="lib/counterup/counterup.min.js"></script>
    <script src="lib/owlcarousel/owl.carousel.min.js"></script>
    <script src="js/main.js"></script>
    <script>
        // Hiệu ứng click cho hàng trong bảng
        document.querySelectorAll('.table tbody tr').forEach(row => {
            row.addEventListener('click', function() {
                // Xóa class active khỏi tất cả các hàng
                document.querySelectorAll('.table tbody tr').forEach(r => r.classList.remove('active'));
                // Thêm class active cho hàng được click
                this.classList.add('active');
                // Thêm hiệu ứng phóng to nhẹ
                this.style.transform = 'scale(1.01)';
            });
        });
    </script>
</body>
</html>