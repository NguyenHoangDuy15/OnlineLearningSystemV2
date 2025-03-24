<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Edukate - Online Education Website Template</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">

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
        <style>
            .team-item {
                width: 100%;
                max-width: 300px; /* ?i?u ch?nh kích th??c t?i ?a c?a khung ?nh */
                margin: auto;
                overflow: hidden;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .team-item img {
                width: 100%;
                height: 250px; /* ??m b?o t?t c? ?nh có cùng chi?u cao */
                object-fit: cover; /* C?t ?nh ?? v?a khung mà không b? méo */
                border-top-left-radius: 10px;
                border-top-right-radius: 10px;
            }
        </style>
    </head>

    <body>

        <%@ include file="header.jsp" %>



        <!-- Header Start -->
        <div class="jumbotron jumbotron-fluid page-header position-relative overlay-bottom" style="margin-bottom: 90px;">
            <div class="container text-center py-5">
                <h1 class="text-white display-1">Experts</h1>
                <div class="d-inline-flex text-white mb-5">
                    <p class="m-0 text-uppercase"><a class="text-white" href="">Home</a></p>
                    <i class="fa fa-angle-double-right pt-1 px-3"></i>
                    <p class="m-0 text-uppercase">Experts</p>
                </div>

            </div>
        </div>
        <!-- Header End -->


        <!-- Team Start -->
        <div class="container-fluid py-5">
            <div class="container py-5">
                <div class="section-title text-center position-relative mb-5">
                    <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Experts</h6>
                    <h1 class="display-4">Meet Our Experts</h1>
                </div>
                <div class="owl-carousel team-carousel position-relative" style="padding: 0 30px;">
                    <c:forEach items="${experts}" var="i">
                        <div class="team-item">
                            <img class="img-fluid w-100" src="${i.avatar}" alt="">
                            <div class="bg-light text-center p-4">
                                <h5 class="mb-3">${i.fullname}</h5>

                                <p class="mb-2">${i.courseName}</p>
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
        <%@ include file="chatbot-widget.jsp" %>
    </body>

</html>