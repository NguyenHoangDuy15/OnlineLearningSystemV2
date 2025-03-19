<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Edukate - Online Education Website Template</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link href="img/favicon.ico" rel="icon">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">

        <style>
            .courses-list-item img {
                width: 100%; /* Đảm bảo ảnh luôn vừa khít */
                height: 320px; /* Hoặc một giá trị cố định */
                object-fit: cover; /* Cắt ảnh để giữ đúng tỉ lệ */
            }
        </style>
    </head>

    <body>
        <%@ include file="header.jsp" %>

        <!-- Header Start -->
        <div class="jumbotron jumbotron-fluid position-relative overlay-bottom" style="margin-bottom: 90px;">
            <div class="container text-center my-5 py-5">
                <h1 class="text-white display-1 mb-5">Courses</h1>
                <div class="mx-auto mb-5" style="width: 100%; max-width: 800px;">
                    <form action="detail" method="get">
                        <div class="input-group">
                            <input type="text" class="form-control border-light" name="search" style="padding: 20px;" placeholder="Search for a course...">
                            <div class="input-group-append">
                                <button class="btn btn-secondary px-4 px-lg-5" type="submit">Search</button>>
                            </div>
                        </div>
                    </form>

                    <!-- Bộ lọc -->

                </div>
            </div>
        </div>
        <!-- Header End -->

        <!-- Courses Start -->
        <div class="container-fluid py-5">
            <div class="container py-5">
                <div class="row mx-0 justify-content-center">
                    <div class="col-lg-8">
                        <div class="section-title text-center position-relative mb-5">
                            <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Our Courses</h6>
                            <h1 class="display-4">Checkout All Releases Of Our Courses</h1>
                            <form action="course" method="get">
                                <div class="row mt-4">
                                    <!-- Filter Category -->
                                    <div class="col-md-3">
                                        <select class="form-select" name="category">
                                            <option value="">All Categories</option>
                                            <c:forEach items="${categories}" var="c">
                                                <option value="${c.categoryId}" ${selectedCategory eq c.categoryId ? 'selected' : ''}>
                                                    ${c.categoryName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <!-- Filter Giá -->
                                    <div class="col-md-3">
                                        <select class="form-select" name="priceOrder">
                                            <option value="">Sort by Price</option>
                                            <option value="low-high" ${selectedPriceOrder eq 'low-high' ? 'selected' : ''}>Low to High</option>
                                            <option value="high-low" ${selectedPriceOrder eq 'high-low' ? 'selected' : ''}>High to Low</option>
                                        </select>
                                    </div>
                                    <!-- Filter Tỉ lệ đánh giá -->
                                    <div class="col-md-3">
                                        <select class="form-select" name="ratingOrder">
                                            <option value="">Sort by Rating</option>
                                            <option value="high" ${selectedRatingOrder eq 'high' ? 'selected' : ''}>Highest Rated</option>
                                            <option value="low" ${selectedRatingOrder eq 'low' ? 'selected' : ''}>Lowest Rated</option>
                                        </select>
                                    </div>
                                    <!-- Apply Button -->
                                    <div class="col-md-3">
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
                    <!-- Hàng đầu tiên chứa 3 ảnh -->
                    <div class="col-12">
                        <div class="row">
                            <c:forEach items="${courses}" var="c" varStatus="status">
                                <c:if test="${status.index < 3}">
                                    <div class="col-lg-4 col-md-6 pb-4">
                                        <a class="courses-list-item position-relative d-block overflow-hidden mb-2" href="detail?courseId=${c.courseID}">
                                            <img class="img-fluid" src="${c.image}" alt="${c.name}">
                                            <div class="courses-text">
                                                <h4 class="text-center text-white px-3">${c.name}</h4>
                                                <div class="border-top w-100 mt-3">
                                                    <div class="d-flex justify-content-between p-4">
                                                        <span class="text-white"><i class="fa fa-user mr-2"></i>${c.expertName}</span>
                                                        <span class="text-white"><i class="fa fa-money-bill-wave mr-2"></i>${c.price} VNĐ</span>
                                                        <span class="text-white"><i class="fa fa-star mr-2"></i>${c.averageRating} </span>
                                                        <span class="text-white"><i class="fa fa-users mr-2"></i>${c.totalenrollment} People</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Các ảnh còn lại hiển thị bên dưới -->
                    <div class="col-12">
                        <div class="row">
                            <c:forEach items="${courses}" var="c" varStatus="status">
                                <c:if test="${status.index >= 3}">


                                    <div class="col-lg-4 col-md-6 pb-4">
                                        <a class="courses-list-item position-relative d-block overflow-hidden mb-2" href="">
                                            <img class="img-fluid" src="${c.image}" alt="${c.name}">
                                            <div class="courses-text">

                                                <h4 class="text-center text-white px-3">${c.name}  ${c.price}</h4>
                                                <div class="border-top w-100 mt-3">
                                                    <div class="d-flex justify-content-between p-4">
                                                        <span class="text-white"><i class="fa fa-user mr-2"></i>${c.expertName}</span>
                                                        <span class="text-white"><i class="fa fa-star mr-2"></i>${c.averageRating}</span>
                                                        <span class="text-white"><i class="fa fa-dollar-sign mr-2"></i>${c.price} $</span>


                                                    </div>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>



                    <!-- Pagination Start -->
                    <div class="col-12">
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="course?page=${currentPage - 1}&category=${param.category}&priceOrder=${param.priceOrder}&ratingOrder=${param.ratingOrder}" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                </c:if>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="course?page=${i}&category=${param.category}&priceOrder=${param.priceOrder}&ratingOrder=${param.ratingOrder}">${i}</a>
                                    </li>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="course?page=${currentPage + 1}&category=${param.category}&priceOrder=${param.priceOrder}&ratingOrder=${param.ratingOrder}" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>

                    <!-- Pagination End -->
                </div>
            </div>
        </div>
        <!-- Courses End -->

        <%@ include file="footer.jsp" %>

        <a href="#" class="btn btn-lg btn-primary rounded-0 btn-lg-square back-to-top"><i class="fa fa-angle-double-up"></i></a>

        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/counterup/counterup.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="js/main.js"></script>


    </body>
</html>
