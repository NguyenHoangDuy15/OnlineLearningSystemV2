<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Online Education Website</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">

        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet"> 
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
        <style>
            /* Course Image Container */
            .course-img-container {
                width: 100%;
                height: 300px;
                display: flex;
                align-items: center;
                justify-content: center;
                overflow: hidden;
                transition: transform 0.3s ease;
            }

            .course-img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.3s ease;
            }

            /* Courses Item */
            .courses-item {
                position: relative;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .courses-item:hover {
                transform: translateY(-10px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
            }

            .courses-item:hover .course-img {
                transform: scale(1.1);
            }

            .courses-text {
                background: linear-gradient(135deg, #007bff, #00c6ff);
                color: #fff;
                padding: 15px;
            }

            .courses-text h4 {
                font-size: 1.5rem;
                font-weight: 600;
                margin-bottom: 10px;
            }

            .courses-text .border-top {
                border-top: 1px solid rgba(255, 255, 255, 0.3) !important;
            }

            .courses-text span {
                position: relative;
                font-size: 0.9rem;
                transition: color 0.3s ease;
            }

            .courses-text span:hover {
                color: #ffeb3b; /* Vàng sáng khi hover */
            }

            /* Tooltip cho thông tin khóa học */
            .courses-text span .tooltip-text {
                visibility: hidden;
                width: 120px;
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

            .courses-text span:hover .tooltip-text {
                visibility: visible;
                opacity: 1;
            }

            /* Nút Course Detail */
            .courses-text .btn-primary {
                background: #007bff;
                border: none;
                padding: 10px 20px;
                border-radius: 25px;
                font-weight: 500;
                transition: background 0.3s ease, transform 0.3s ease;
            }

            .courses-text .btn-primary:hover {
                background: #0056b3;
                transform: scale(1.05);
            }

            /* Section Title */
            .section-title h6 {
                color: #ff6f61;
                font-weight: 600;
                letter-spacing: 1px;
            }

            .section-title h1 {
                font-weight: 700;
                color: #1a1a1a;
                transition: color 0.3s ease;
            }

            .section-title h1:hover {
                color: #007bff;
            }

            /* Team Item (Instructors) */
            .team-item {
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .team-item:hover {
                transform: translateY(-10px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
            }

            .team-item img {
                width: 100%;
                height: 300px;
                object-fit: cover;
                transition: transform 0.3s ease;
            }

            .team-item:hover img {
                transform: scale(1.1);
            }

            .team-item .bg-light {
                background: #fff !important;
                border-bottom-left-radius: 15px;
                border-bottom-right-radius: 15px;
            }

            .team-item h5 {
                font-weight: 600;
                color: #1a1a1a;
                transition: color 0.3s ease;
            }

            .team-item h5:hover {
                color: #007bff;
                animation: bounce 0.5s ease;
            }

            @keyframes bounce {
                0%, 20%, 50%, 80%, 100% {
                    transform: translateY(0);
                }
                40% {
                    transform: translateY(-5px);
                }
                60% {
                    transform: translateY(-3px);
                }
            }

            .team-item p {
                color: #6c757d;
                font-size: 0.9rem;
            }

            /* Social Icons */
            .team-item a {
                color: #6c757d;
                font-size: 1.2rem;
                transition: color 0.3s ease, transform 0.3s ease;
            }

            .team-item a:hover {
                color: #007bff;
                transform: scale(1.2);
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jsp" %>
        <!-- Header Start -->
        <div class="jumbotron jumbotron-fluid position-relative overlay-bottom" style="margin-bottom: 90px;">
            <div class="container text-center my-5 py-5">
                <h1 class="text-white mt-4 mb-4">Learn From Home</h1>
                <h1 class="text-white display-1 mb-5">Education Courses</h1>
                <div class="mx-auto mb-5" style="width: 100%; max-width: 600px;">
                </div>
            </div>
        </div>
        <!-- Header End -->

        <!-- Courses Start -->
        <div class="container-fluid px-0 py-5">
            <div class="row mx-0 justify-content-center pt-5">
                <div class="col-lg-6">
                    <div class="section-title text-center position-relative mb-4">
                        <h6 name="coursesprint" class="d-inline-block position-relative text-secondary text-uppercase pb-2">Our Courses</h6>
                        <h1 class="display-4">Checkout New Releases Of Our Courses</h1>
                    </div>
                </div>
            </div>

            <c:if test="${empty courses}">
                <p>Không có khóa học nào được tìm thấy!</p>
            </c:if>

            <div class="owl-carousel courses-carousel">
                <c:forEach var="course" items="${courses}">
                    <!-- Chỉ hiển thị khóa học nếu status == 4 -->
                    <c:if test="${course.courseStatus == 4}">
                        <div class="courses-item position-relative">
                            <!-- Thêm div chứa ảnh để đảm bảo kích thước đồng đều -->
                            <div class="course-img-container">
                                <img class="img-fluid course-img" src="${course.image}" alt="${course.name}">
                            </div>

                            <div class="courses-text">
                                <h4 class="text-center text-white px-3">${course.name}</h4>
                                <div class="border-top w-100 mt-3">
                                    <div class="d-flex justify-content-between p-4">
                                        <span class="text-white"><i class="fa fa-user mr-2"></i>${course.expertName}<span class="tooltip-text">Giảng viên</span></span>
                                        <span class="text-white"><i class="fa fa-money-bill-wave mr-2"></i>${course.price} VNĐ<span class="tooltip-text">Giá khóa học</span></span>
                                        <span class="text-white"><i class="fa fa-star mr-2"></i>${course.averageRating}<span class="tooltip-text">Đánh giá trung bình</span></span>
                                        <span class="text-white"><i class="fa fa-users mr-2"></i>${course.totalenrollment} People<span class="tooltip-text">Số người tham gia</span></span>
                                    </div>
                                </div>
                                <div class="w-100 bg-white text-center p-4">
                                    <a class="btn btn-primary" href="detail?courseId=${course.courseID}">Course Detail</a>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
        <!-- Courses End -->

        <!-- Team Start -->
        <div class="container-fluid py-5">
            <div class="container py-5">
                <div class="section-title text-center position-relative mb-5">
                    <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Instructors</h6>
                    <h1 class="display-4">Meet Our Instructors</h1>
                </div>
                <div class="owl-carousel team-carousel position-relative" style="padding: 0 30px;">
                    <c:forEach items="${coursedao}" var="course">
                        <div class="team-item">
                            <img class="img-fluid w-100" src="${course.avatar}" alt="Instructor">
                            <div class="bg-light text-center p-4">
                                <h5 class="mb-3">${course.username}</h5> <!-- Hiển thị tên giảng viên -->
                                <p class="mb-2">${course.courseName}</p> <!-- Hiển thị tên khóa học -->
                                <div class="d-flex justify-content-center">
                                    <a class="mx-1 p-1" href="#"><i class="fab fa-twitter"></i></a>
                                    <a class="mx-1 p-1" href="#"><i class="fab fa-facebook-f"></i></a>
                                    <a class="mx-1 p-1" href="#"><i class="fab fa-linkedin-in"></i></a>
                                    <a class="mx-1 p-1" href="#"><i class="fab fa-instagram"></i></a>
                                    <a class="mx-1 p-1" href="#"><i class="fab fa-youtube"></i></a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <!-- Team End -->

        <%@ include file="footer.jsp" %>
        <!-- Back to Top -->
        <a href="#" class="btn btn-lg btn-primary rounded-0 btn-lg-square back-to-top"><i class="fa fa-angle-double-up"></i></a>

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/counterup/counterup.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>
        <script>
            // Thêm hiệu ứng click cho nút Course Detail
            document.querySelectorAll('.courses-item .btn-primary').forEach(button => {
                button.addEventListener('click', function () {
                    this.style.background = '#ff6f61'; // Đổi màu khi click
                    this.style.transform = 'scale(1.1)';
                });
            });

            // Thêm hiệu ứng hover cho team item
            document.querySelectorAll('.team-item').forEach(item => {
                item.addEventListener('mouseover', function () {
                    this.querySelector('h5').style.color = '#007bff';
                });
                item.addEventListener('mouseout', function () {
                    this.querySelector('h5').style.color = '#1a1a1a';
                });
            });
        </script>
    </body>
</html>