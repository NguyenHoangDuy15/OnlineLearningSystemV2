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
            /* Giữ nguyên phần CSS của bạn */
            .experts-list-item {
                width: 100%;
                max-width: 320px;
                height: 500px;
                margin: auto;
                overflow: hidden;
                border-radius: 15px;
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                background-color: #fff;
            }

            .experts-list-item:hover {
                transform: scale(1.25);
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.5);
                border: 2px solid #0077b6;
            }

            /* ... (Các phần CSS khác giữ nguyên) ... */
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
                            <!-- Hiển thị kết quả tìm kiếm -->
                            <c:forEach items="${searchResults}" var="e">
                                <div class="col-lg-4 col-md-6 pb-4">
                                    <div class="experts-list-item position-relative d-block overflow-hidden mb-2">
                                        <img class="img-fluid" src="${e.avartar}" alt="${e.fullName}">
                                        <div class="experts-text">
                                            <h4 class="text-center text-dark px-3">${e.fullName}</h4>
                                            <!-- Hiển thị sao rating -->
                                            <div class="text-center mb-2">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${e.avgRating >= i}">
                                                            <i class="fas fa-star" style="color: #f1c40f;"></i>
                                                        </c:when>
                                                        <c:when test="${e.avgRating >= i - 0.5}">
                                                            <i class="fas fa-star-half-alt" style="color: #f1c40f;"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="far fa-star" style="color: #f1c40f;"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                <span>(${e.avgRating})</span>
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
                            <!-- Hiển thị tất cả Experts -->
                            <c:forEach items="${experts}" var="e">
                                <div class="col-lg-4 col-md-6 pb-4">
                                    <div class="experts-list-item position-relative d-block overflow-hidden mb-2">
                                        <img class="img-fluid" src="${e.avartar}" alt="${e.fullName}">
                                        <div class="experts-text">
                                            <h4 class="text-center text-dark px-3">${e.fullName}</h4>
                                            <!-- Hiển thị sao rating -->
                                            <div class="text-center mb-2">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${e.avgRating >= i}">
                                                            <i class="fas fa-star" style="color: #f1c40f;"></i>
                                                        </c:when>
                                                        <c:when test="${e.avgRating >= i - 0.5}">
                                                            <i class="fas fa-star-half-alt" style="color: #f1c40f;"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="far fa-star" style="color: #f1c40f;"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                <span>(${e.avgRating})</span>
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

        <!-- Chatbot Widget -->
        <c:if test="${not empty sessionScope.userid}">
            <iframe 
                src="jsp/chatbot-widget.jsp" 
                style="position: fixed; bottom: 0; right: 0; border: none; width: 400px; height: 600px; z-index: 1000;">
            </iframe>
        </c:if>
    </body>
</html>