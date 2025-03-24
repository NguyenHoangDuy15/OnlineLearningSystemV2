<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>My Enrollments</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="img/favicon.ico" rel="icon">
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

        /* Section Title */
        .section-title h6 {
            font-weight: 600;
            letter-spacing: 1px;
        }

        .section-title h1 {
            font-weight: 700;
            transition: transform 0.3s ease;
        }

        .section-title h1:hover {
            transform: scale(1.02);
        }

        /* Card (Enrollment Item) */
        .card {
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        .card img {
            transition: transform 0.3s ease;
        }

        .card:hover img {
            transform: scale(1.1);
        }

        .card-body {
            padding: 20px;
        }

        .card-title {
            font-size: 1.5rem;
            font-weight: 600;
            position: relative;
            transition: transform 0.3s ease;
        }

        .card-title:hover {
            transform: translateX(5px);
        }

        .card-text {
            font-size: 1rem;
            line-height: 1.6;
            position: relative;
            transition: transform 0.3s ease;
        }

        .card-text:hover {
            transform: translateX(5px);
        }

        /* Tooltip cho tiêu đề và mô tả */
        .card-title .tooltip-text, .card-text .tooltip-text {
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

        .card-title:hover .tooltip-text, .card-text:hover .tooltip-text {
            visibility: visible;
            opacity: 1;
        }

        /* Nút Go to Course */
        .btn-primary {
            border-radius: 25px;
            font-weight: 600;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .btn-primary:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }

        /* Thông báo khi không có khóa học */
        .text-center {
            font-size: 1.2rem;
            line-height: 1.8;
            color: #4a4a4a;
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

        /* Back to Top Button */
        .back-to-top {
            transition: transform 0.3s ease;
        }

        .back-to-top:hover {
            transform: rotate(360deg);
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="jumbotron jumbotron-fluid page-header position-relative overlay-bottom" style="margin-bottom: 90px;">
        <div class="container text-center py-5">
            <h1 class="text-white display-1">My Enrollments</h1>
        </div>
    </div>
    <div class="container-fluid py-5">
        <div class="container py-5">
            <div class="section-title position-relative mb-4 text-left">
                <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Enrollments</h6>
                <h1 class="display-4 text-left">Courses You Have Enrolled In</h1>
            </div>
            <div class="row">
                <c:choose>
                    <c:when test="${not empty enrollments}">
                        <c:forEach var="e" items="${enrollments}">
                            <div class="col-lg-12 mb-4">
                                <div class="card border-0 shadow d-flex flex-row align-items-center p-3">
                                    <!-- Ảnh bên trái -->
                                    <div style="flex: 0 0 30%;">
                                        <img class="img-fluid rounded" src="${e.imageCourses}" alt="${e.courseName}" style="width: 100%; height: 250px; object-fit: cover;">
                                    </div>
                                    <!-- Nội dung bên phải -->
                                    <div class="card-body ml-4" style="flex: 1;">
                                        <h5 class="card-title mb-2">${e.courseName}<span class="tooltip-text">Tên khóa học</span></h5>
                                        <p class="card-text">${e.description}<span class="tooltip-text">Mô tả khóa học</span></p>
                                        <a href="Lessonservlet?courseId=${e.courseId}" class="btn btn-primary text-white" style="background-color: #007bff; border-color: #007bff;">Go to Course</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="text-center">You do not enroll in course.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
    <a href="#" class="btn btn-lg btn-primary rounded-0 btn-lg-square back-to-top"><i class="fa fa-angle-double-up"></i></a>
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="js/main.js"></script>
    <script>
        // Hiệu ứng click cho card
        document.querySelectorAll('.card').forEach(card => {
            card.addEventListener('click', function() {
                // Xóa class active khỏi tất cả các card
                document.querySelectorAll('.card').forEach(c => c.classList.remove('active'));
                // Thêm class active cho card được click
                this.classList.add('active');
                // Thêm hiệu ứng phóng to nhẹ
                this.style.transform = 'scale(1.02)';
            });
        });

        // Hiệu ứng click cho nút Go to Course
        document.querySelectorAll('.btn-primary').forEach(button => {
            button.addEventListener('click', function() {
                this.style.transform = 'scale(1.1)';
            });
        });

        // Đoạn JavaScript gốc (giữ nguyên nhưng không sử dụng vì không có #enrollment-list)
        $(document).ready(function () {
            const enrollments = [
                {name: "Web Development"},
                {name: "Data Science"}
            ];
            let html = "";
            enrollments.forEach(course => {
                html += `<div class='bg-light p-4 mb-3'><h5>${course.name}</h5></div>`;
            });
            $("#enrollment-list").html(html);
        });
    </script>
            <iframe src="jsp/chatbot-widget.jsp" style="position: fixed; bottom: 0; right: 0; border: none; width: 400px; height: 600px; z-index: 1000;"></iframe>
</body>
</html>