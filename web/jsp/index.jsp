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
            .course-img-container {
                width: 100%; /* Ảnh chiếm toàn bộ khung */
                height: 300px; /* Đặt chiều cao cố định để ảnh không bị lệch */
                display: flex;
                align-items: center;
                justify-content: center;
                overflow: hidden; /* Cắt phần ảnh dư */
            }

            .course-img {
                width: 100%; /* Chiếm toàn bộ khung */
                height: 100%; /* Giữ chiều cao đồng đều */
                object-fit: cover; /* Đảm bảo ảnh lấp đầy khung mà không bị méo */
            }

        </style>


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




    <!-- Feature Start -->

    <!-- Feature Start -->


    <!-- Courses Start -->
    <div class="container-fluid px-0 py-5">
        <div class="row mx-0 justify-content-center pt-5">
            <div class="col-lg-6">
                <div class="section-title text-center position-relative mb-4">
                    <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Our Courses</h6>
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
                                    <span class="text-white"><i class="fa fa-user mr-2"></i>${course.expertName}</span>
                                    <span class="text-white"><i class="fa fa-money-bill-wave mr-2"></i>${course.price} VNĐ</span>
                                    <span class="text-white"><i class="fa fa-star mr-2"></i>${course.averageRating} </span>
                                    <span class="text-white"><i class="fa fa-users mr-2"></i>${course.totalenrollment} People</span>
                                </div>
                            </div>
                            <div class="w-100 bg-white text-center p-4">
                                <c:choose>
                                    <c:when test="${course.statusss == 1}">
                                        <a class="btn btn-success" href="myenrollment?courseId=${course.courseID}">Go to Course</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="btn btn-primary" href="detail?courseId=${course.courseID}">Course Detail</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>

    </div>
</div>



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


<!-- Testimonial Start -->
<div class="container-fluid bg-image py-5" style="margin: 90px 0;">
    <div class="container py-5">
        <div class="row align-items-center">
            <div class="col-lg-5 mb-5 mb-lg-0">
                <div class="section-title position-relative mb-4">
                    <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Testimonial</h6>
                    <h1 class="display-4">What Say Our Students</h1>
                </div>

            </div>
            <div class="col-lg-7">
                <div class="owl-carousel testimonial-carousel">

                    <div class="bg-white p-5">
                        <c:forEach items="${feedbacks}" var="f">
                            <i class="fa fa-3x fa-quote-left text-primary mb-4"></i>


                            <p>${f.comment}</p>
                            <div class="d-flex flex-shrink-0 align-items-center mt-4">
                                <img class="img-fluid mr-4" src="img/testimonial-2.jpg" alt="">
                                <div>
                                    <h5>${f.customername}</h5>
                                    <span>${f.course}</span>
                                </div>
                            </div>
                        </c:forEach>

                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
<!-- Testimonial Start -->


<!-- Contact Start -->
<div class="container-fluid py-5">
    <div class="container py-5">
        <div class="row align-items-center">
            <div class="col-lg-5 mb-5 mb-lg-0">
                <div class="bg-light d-flex flex-column justify-content-center px-5" style="height: 450px;">
                    <div class="d-flex align-items-center mb-5">
                        <div class="btn-icon bg-primary mr-4">
                            <i class="fa fa-2x fa-map-marker-alt text-white"></i>
                        </div>
                        <div class="mt-n1">
                            <h4>Our Location</h4>
                            <p class="m-0">123 Street, New York, USA</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center mb-5">
                        <div class="btn-icon bg-secondary mr-4">
                            <i class="fa fa-2x fa-phone-alt text-white"></i>
                        </div>
                        <div class="mt-n1">
                            <h4>Call Us</h4>
                            <p class="m-0">+012 345 6789</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center">
                        <div class="btn-icon bg-warning mr-4">
                            <i class="fa fa-2x fa-envelope text-white"></i>
                        </div>
                        <div class="mt-n1">
                            <h4>Email Us</h4>
                            <p class="m-0">info@example.com</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-7">
                <div class="section-title position-relative mb-4">
                    <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Need Help?</h6>
                    <h1 class="display-4">Send Us A Message</h1>
                </div>
                <div class="contact-form">
                    <form action="Feedbackcontroller" method="get">
                        <div class="row">
                            <div class="col-6 form-group">
                                <input type="text" name="name" class="form-control border-top-0 border-right-0 border-left-0 p-0" placeholder="Your Name" required="required">
                            </div>
                            <div class="col-6 form-group">
                                <input type="email" name="email" class="form-control border-top-0 border-right-0 border-left-0 p-0" placeholder="Your Email" required="required">
                            </div>
                        </div>

                        <div class="form-group">
                            <select name="courseId" class="form-control border-top-0 border-right-0 border-left-0 p-0 bg-white text-body" required>
                                <option value="">Select a Course</option>
                                <c:forEach var="course" items="${courses}">
                                    <option value="${course.courseID}">${course.name}</option>
                                </c:forEach>

                            </select>
                        </div>

                        <div class="form-group">
                            <textarea name="comment" class="form-control border-top-0 border-right-0 border-left-0 p-0" rows="5" placeholder="Message" required="required"></textarea>
                        </div>

                        <!-- Rating Section -->
                        <div class="form-group">
                            <label for="rating">Rate Us:</label>
                            <div id="rating" class="d-flex">
                                <span class="star" data-value="1">&#9733;</span>
                                <span class="star" data-value="2">&#9733;</span>
                                <span class="star" data-value="3">&#9733;</span>
                                <span class="star" data-value="4">&#9733;</span>
                                <span class="star" data-value="5">&#9733;</span>
                            </div>
                            <input type="hidden" name="rating" id="ratingValue" value="0">
                        </div>

                        <div>
                            <button class="btn btn-primary py-3 px-5" type="submit">Send Message</button>
                        </div>
                    </form>

                    <c:if test="${not empty message}">
                        <p class="text-success">${message}</p>
                    </c:if>
                </div>
            </div>

        </div>
    </div>
</div>
<script>
    document.querySelectorAll('.star').forEach(star => {
        star.addEventListener('click', function () {
            let rating = this.getAttribute('data-value');
            document.getElementById('ratingValue').value = rating;
            // Highlight the stars based on the selected rating
            document.querySelectorAll('.star').forEach(star => {
                star.style.color = star.getAttribute('data-value') <= rating ? 'gold' : 'gray';
            });
        });
    });
</script>
<!-- Contact End -->
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
</body>

</html>
