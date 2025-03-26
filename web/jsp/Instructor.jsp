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
            .experts-list-item {
                width: 100%;
                max-width: 320px; /* ??m b?o chi?u r?ng c? ??nh */
                height: 500px; /* ??m b?o chi?u cao c? ??nh */
                margin: auto;
                overflow: hidden;
                border-radius: 15px; /* Bo tròn khung */
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15); /* Bóng nh? */
                transition: transform 0.3s ease, box-shadow 0.3s ease; /* Hi?u ?ng m??t mà khi hover */
                background-color: #fff; /* N?n tr?ng cho khung */
            }

            .experts-list-item:hover {
                transform: scale(1.25); /* Phóng to khung khi hover */
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.5); /* Bóng ??m h?n khi hover */
                border: 2px solid #0077b6; /* Vi?n xanh khi hover */
            }

            .experts-list-item img {
                width: 100%;
                height: 280px; /* T?ng chi?u cao ?nh ?? l?p ??y kho?ng tr?ng */
                object-fit: cover;
                border-top-left-radius: 15px;
                border-top-right-radius: 15px;
                margin-top: 10px; /* Di chuy?n ?nh xu?ng d??i m?t chút */
            }

            .experts-text {
                padding: 15px;
                height: 220px; /* Gi?m chi?u cao ph?n n?i dung ?? cân ??i v?i ?nh */
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .experts-text h4 {
                font-size: 1.2rem;
                margin-bottom: 5px;
                color: #333; /* Màu ch? ??m h?n */
            }

            .experts-text h6 {
                font-size: 0.9rem;
                color: #555;
                margin-bottom: 5px;
            }

            .experts-text ul {
                list-style-type: none;
                padding: 0;
                margin: 0;
                max-height: 80px; /* Gi?m chi?u cao danh sách ?? cân ??i */
                overflow-y: auto;
                font-size: 0.85rem;
                color: #666;
            }

            .experts-text ul li {
                margin-bottom: 5px;
            }

            .experts-text .border-top {
                border-top: 1px solid #eee;
                padding-top: 10px;
            }

            .experts-text .d-flex {
                gap: 10px; /* Kho?ng cách gi?a các bi?u t??ng m?ng xã h?i */
            }

            .experts-text .d-flex a {
                color: #555;
                transition: color 0.3s ease;
            }

            .experts-text .d-flex a:hover {
                color: #0077b6; /* Màu xanh khi hover vào bi?u t??ng */
            }

            /* ?i?u ch?nh kho?ng cách gi?a các khung */
            .col-lg-4.col-md-6.pb-4 {
                padding: 10px; /* Gi?m padding ?? các khung g?n nhau h?n */
            }

            /* CSS cho phân trang */
            .pagination {
                display: flex;
                justify-content: center;
                margin-top: 20px;
            }

            .pagination a {
                margin: 0 5px;
                padding: 8px 16px;
                text-decoration: none;
                border: 1px solid #ddd;
                color: #0077b6;
                border-radius: 20px; /* Bo tròn button */
                transition: background-color 0.3s ease, color 0.3s ease;
            }

            .pagination a.active {
                background-color: #0077b6;
                color: white;
                border: 1px solid #0077b6;
            }

            .pagination a:hover:not(.active) {
                background-color: #e6f0fa; /* Màu n?n nh? khi hover */
                color: #005f8b; /* Màu ch? ??m h?n khi hover */
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <!-- Header Start -->
        <div class="jumbotron jumbotron-fluid position-relative overlay-bottom" style="margin-bottom: 90px;">
            <div class="container text-center my-5 py-5">
                <h1 class="text-white display-1 mb-5">Experts</h1>
                <div class="mx-auto mb-5" style="width: 100%; max-width: 800px;">
                    <form action="Expert" method="post">
                        <div class="input-group">
                            <input type="text" class="form-control border-light" name="search" style="padding: 20px;" placeholder="Search for an expert..." value="${keyword}">
                            <div class="input-group-append">
                                <button class="btn btn-secondary px-4 px-lg-5" type="submit">Search</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <!-- Header End -->

        <!-- Experts Start -->
        <div class="container-fluid py-5">
            <div class="container py-5">
                <div class="row mx-0 justify-content-center">
                    <div class="col-lg-8">
                        <div class="section-title text-center position-relative mb-5">
                            <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Our Experts</h6>
                            <h1 class="display-4">Meet Our Top Experts</h1>
                            <form action="Expert" method="get">
                                <div class="row mt-4">
                                    <!-- Filter Category -->
                                    <div class="col-md-4">
                                        <select class="form-select" name="category">
                                            <option value="">All Categories</option>
                                            <c:forEach items="${categories}" var="c">
                                                <option value="${c.categoryId}" ${selectedCategory eq c.categoryId ? 'selected' : ''}>
                                                    ${c.categoryName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <!-- Filter Rating -->
                                    <div class="col-md-4">
                                        <select class="form-select" name="ratingOrder">
                                            <option value="">Sort by Rating</option>
                                            <option value="DESC" ${selectedRatingOrder eq 'DESC' ? 'selected' : ''}>Highest Rated</option>
                                            <option value="ASC" ${selectedRatingOrder eq 'ASC' ? 'selected' : ''}>Lowest Rated</option>
                                        </select>
                                    </div>
                                    <!-- Apply Button -->
                                    <div class="col-md-4">
                                        <button class="btn btn-primary w-100" style="background-color: #377AE0; border-color: #0077b6;">
                                            Apply
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <c:choose>
                        <c:when test="${not empty searchResults}">
                            <!-- Hi?n th? k?t qu? tìm ki?m -->
                            <c:forEach items="${searchResults}" var="e">
                                <div class="col-lg-4 col-md-6 pb-4">
                                    <div class="experts-list-item position-relative d-block overflow-hidden mb-2">
                                        <img class="img-fluid" src="${e.avartar}" alt="${e.fullName}">
                                        <div class="experts-text">
                                            <h4 class="text-center text-dark px-3">${e.fullName}</h4>
                                            <!-- Hi?n th? sao rating -->
                                            <div class="text-center mb-2">
                                                <c:set var="rating" value="${e.avgRating}"/>
                                                <c:set var="fullStars" value="${Math.floor(rating)}"/>
                                                <c:set var="hasHalfStar" value="${rating - fullStars >= 0.5}"/>
                                                <c:set var="emptyStars" value="${5 - Math.ceil(rating)}"/>

                                                <!-- Sao ??y -->
                                                <c:forEach begin="1" end="${fullStars}">
                                                    <i class="fas fa-star" style="color: #f1c40f;"></i>
                                                </c:forEach>
                                                <!-- Sao n?a -->
                                                <c:if test="${hasHalfStar}">
                                                    <i class="fas fa-star-half-alt" style="color: #f1c40f;"></i>
                                                </c:if>
                                                <!-- Sao r?ng -->
                                                <c:forEach begin="1" end="${emptyStars}">
                                                    <i class="far fa-star" style="color: #f1c40f;"></i>
                                                </c:forEach>
                                                <span>(${rating})</span>
                                            </div>
                                            <div class="text-center">
                                                <h6>Courses:</h6>
                                                <ul style="list-style-type: none; padding: 0;">
                                                    <c:forEach items="${e.courseNames}" var="course">
                                                        <li>${course}</li>
                                                        </c:forEach>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- Hi?n th? t?t c? Experts -->
                            <c:forEach items="${experts}" var="e">
                                <div class="col-lg-4 col-md-6 pb-4">
                                    <div class="experts-list-item position-relative d-block overflow-hidden mb-2">
                                        <img class="img-fluid" src="${e.avartar}" alt="${e.fullName}">
                                        <div class="experts-text">
                                            <h4 class="text-center text-dark px-3">${e.fullName}</h4>
                                            <!-- Hi?n th? sao rating -->
                                            <div class="text-center mb-2">
                                                <c:set var="rating" value="${e.avgRating}"/>
                                                <c:set var="fullStars" value="${Math.floor(rating)}"/>
                                                <c:set var="hasHalfStar" value="${rating - fullStars >= 0.5}"/>
                                                <c:set var="emptyStars" value="${5 - Math.ceil(rating)}"/>

                                                <!-- Sao ??y -->
                                                <c:forEach begin="1" end="${fullStars}">
                                                    <i class="fas fa-star" style="color: #f1c40f;"></i>
                                                </c:forEach>
                                                <!-- Sao n?a -->
                                                <c:if test="${hasHalfStar}">
                                                    <i class="fas fa-star-half-alt" style="color: #f1c40f;"></i>
                                                </c:if>
                                                <!-- Sao r?ng -->
                                                <c:forEach begin="1" end="${emptyStars}">
                                                    <i class="far fa-star" style="color: #f1c40f;"></i>
                                                </c:forEach>
                                                <span>(${rating})</span>
                                            </div>
                                            <div class="text-center">
                                                <h6>Courses:</h6>
                                                <ul style="list-style-type: none; padding: 0;">
                                                    <c:forEach items="${e.courseNames}" var="course">
                                                        <li>${course}</li>
                                                        </c:forEach>
                                                </ul>
                                            </div>
                                            <div class="border-top w-100 mt-3">

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${empty searchResults && empty experts}">
                        <div class="text-center">
                            <p>No experts found.</p>
                        </div>
                    </c:if>
                </div>

                <!-- Phân trang -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:if test="${currentPage > 1}">
                            <a href="Expert?page=${currentPage - 1}&category=${selectedCategory}&ratingOrder=${selectedRatingOrder}&search=${keyword}&searchSubmitted=${param.searchSubmitted}">Previous</a>

                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="Expert?page=${i}&category=${selectedCategory}&ratingOrder=${selectedRatingOrder}&search=${keyword}&searchSubmitted=${param.searchSubmitted}" class="${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a href="Expert?page=${currentPage + 1}&category=${selectedCategory}&ratingOrder=${selectedRatingOrder}&search=${keyword}&searchSubmitted=${param.searchSubmitted}">Next</a>

                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
        <!-- Experts End -->

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
        <iframe src="jsp/chatbot-widget.jsp" style="position: fixed; bottom: 0; right: 0; border: none; width: 400px; height: 600px; z-index: 1000;"></iframe>
    </body>
</html>