<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Edukate - Online Education Website Template</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet"> 

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
    </head>

    <body>
        <%@ include file="header.jsp" %>
        <!-- Header Start -->
        <div class="jumbotron jumbotron-fluid page-header position-relative overlay-bottom" style="margin-bottom: 90px;">
            <div class="container text-center py-5">
                <h1 class="text-white display-1">Course Detail</h1>

            </div>
        </div>
        <!-- Header End -->

        <c:if test="${not empty errorMessage}">
            <h1 class="display-4" style="color: red;">${errorMessage}</h1>
        </c:if>
        <!-- Detail Start -->
        <div class="container-fluid py-5">
            <div class="container py-5">
                <div class="row">
                    <div class="col-lg-8">
                        <div class="mb-5">
                            <div class="section-title position-relative mb-5">
                                <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Course Detail</h6>
                                <h1 class="display-4">${course.name}</h1>
                            </div>
                            <img class="img-fluid rounded w-100 mb-4" src="${course.image}"  >    
                            <p>${course.description}</p>

                        </div>


                        <h2 class="mb-3">Related Courses</h2>
                        <div class="owl-carousel related-carousel position-relative" style="padding: 0 30px;">
                            <a class="courses-list-item position-relative d-block overflow-hidden mb-2" href="detail.jsp">
                                <img class="img-fluid" src="../img/courses-1.jpg" alt="">
                                <div class="courses-text">
                                    <h4 class="text-center text-white px-3">Web design & development courses for
                                        beginners</h4>
                                    <div class="border-top w-100 mt-3">
                                        <div class="d-flex justify-content-between p-4">
                                            <span class="text-white"><i class="fa fa-user mr-2"></i>Jhon Doe</span>
                                            <span class="text-white"><i class="fa fa-star mr-2"></i>4.5
                                                <small>(250)</small></span>
                                        </div>
                                    </div>
                                </div>
                            </a>
                            <a class="courses-list-item position-relative d-block overflow-hidden mb-2" href="detail.jsp">
                                <img class="img-fluid" src="img/courses-2.jpg" alt="">
                                <div class="courses-text">
                                    <h4 class="text-center text-white px-3">Web design & development courses for
                                        beginners</h4>
                                    <div class="border-top w-100 mt-3">
                                        <div class="d-flex justify-content-between p-4">
                                            <span class="text-white"><i class="fa fa-user mr-2"></i>Jhon Doe</span>
                                            <span class="text-white"><i class="fa fa-star mr-2"></i>4.5
                                                <small>(250)</small></span>
                                        </div>
                                    </div>
                                </div>
                            </a>
                            <a class="courses-list-item position-relative d-block overflow-hidden mb-2" href="detail.jsp">
                                <img class="img-fluid" src="img/courses-3.jpg" alt="">
                                <div class="courses-text">
                                    <h4 class="text-center text-white px-3">Web design & development courses for
                                        beginners</h4>
                                    <div class="border-top w-100 mt-3">
                                        <div class="d-flex justify-content-between p-4">
                                            <span class="text-white"><i class="fa fa-user mr-2"></i>Jhon Doe</span>
                                            <span class="text-white"><i class="fa fa-star mr-2"></i>4.5
                                                <small>(250)</small></span>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>

                    <div class="col-lg-4 mt-5 mt-lg-0">
                        <div class="bg-primary mb-5 py-3">
                            <h3 class="text-white py-3 px-4 m-0">Course Features</h3>
                            <div class="d-flex justify-content-between border-bottom px-4">
                                <h6 class="text-white my-3">Instructor</h6>
                                <h6 class="text-white my-3">${coursedetails.expertName}</h6>
                            </div>
                            <div class="d-flex justify-content-between border-bottom px-4">
                                <h6 class="text-white my-3">Rating</h6>
                                <h6 class="text-white my-3">${coursedetails.averageRating}</h6>
                            </div>
                            <div class="d-flex justify-content-between border-bottom px-4">
                                <h6 class="text-white my-3">Feedbacks</h6>
                                <h6 class="text-white my-3">${coursedetails.totalReviews}</h6>
                            </div>
                            
                            <h5 class="text-white py-3 px-4 m-0">Course Price: $${coursedetails.price}</h5>
                            <div class="py-3 px-4">
                                <a class="btn btn-block py-3 px-5" href="" style="background-color: red; color: white;">
                                    Enroll Now
                                </a>
                            </div>
                        </div>

                        <div class="mb-5">
                            <h2 class="mb-3">Categories</h2>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                    <a href="" class="text-decoration-none h6 m-0">Web Design</a>
                                    <span class="badge badge-primary badge-pill">150</span>
                                </li>


                            </ul>
                        </div>

                        <div class="mb-5">
                            <h2 class="mb-4">Recent Courses</h2>
                            <a class="d-flex align-items-center text-decoration-none mb-4" href="">
                                <img class="img-fluid rounded" src="img/courses-80x80.jpg" alt="">
                                <div class="pl-3">
                                    <h6>Web design & development courses for beginners</h6>
                                    <div class="d-flex">
                                        <small class="text-body mr-3"><i class="fa fa-user text-primary mr-2"></i>Jhon Doe</small>
                                        <small class="text-body"><i class="fa fa-star text-primary mr-2"></i>4.5 (250)</small>
                                    </div>
                                </div>
                            </a>
                            <a class="d-flex align-items-center text-decoration-none mb-4" href="">
                                <img class="img-fluid rounded" src="img/courses-80x80.jpg" alt="">
                                <div class="pl-3">
                                    <h6>Web design & development courses for beginners</h6>
                                    <div class="d-flex">
                                        <small class="text-body mr-3"><i class="fa fa-user text-primary mr-2"></i>Jhon Doe</small>
                                        <small class="text-body"><i class="fa fa-star text-primary mr-2"></i>4.5 (250)</small>
                                    </div>
                                </div>
                            </a>
                            <a class="d-flex align-items-center text-decoration-none mb-4" href="">
                                <img class="img-fluid rounded" src="img/courses-80x80.jpg" alt="">
                                <div class="pl-3">
                                    <h6>Web design & development courses for beginners</h6>
                                    <div class="d-flex">
                                        <small class="text-body mr-3"><i class="fa fa-user text-primary mr-2"></i>Jhon Doe</small>
                                        <small class="text-body"><i class="fa fa-star text-primary mr-2"></i>4.5 (250)</small>
                                    </div>
                                </div>
                            </a>
                            <a class="d-flex align-items-center text-decoration-none" href="">
                                <img class="img-fluid rounded" src="img/courses-80x80.jpg" alt="">
                                <div class="pl-3">
                                    <h6>Web design & development courses for beginners</h6>
                                    <div class="d-flex">
                                        <small class="text-body mr-3"><i class="fa fa-user text-primary mr-2"></i>Jhon Doe</small>
                                        <small class="text-body"><i class="fa fa-star text-primary mr-2"></i>4.5 (250)</small>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Detail End -->
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