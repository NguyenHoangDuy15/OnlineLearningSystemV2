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
            /* Jumbotron (Header) */
            .jumbotron {
                position: relative;
                overflow: hidden;
            }

            .jumbotron h1 {
                font-weight: 700;
                transition: transform 0.3s ease, color 0.3s ease;
            }

            .jumbotron h1:hover {
                transform: scale(1.05);
                color: #ffeb3b; /* Vàng sáng khi hover */
            }

            /* Thanh tìm kiếm */
            .input-group {
                position: relative;
                transition: all 0.3s ease;
            }

            .input-group input {
                border-radius: 50px !important;
                padding: 25px 30px;
                font-size: 1rem;
                border: 2px solid #007bff;
                transition: all 0.3s ease;
            }

            .input-group input:focus {
                border-color: #ff6f61;
                box-shadow: 0 0 10px rgba(255, 111, 97, 0.5);
                transform: scale(1.02);
            }

            .input-group .btn-secondary {
                border-radius: 50px;
                background: #007bff;
                border: none;
                padding: 15px 30px;
                font-weight: 600;
                transition: background 0.3s ease, transform 0.3s ease;
            }

            .input-group .btn-secondary:hover {
                background: #ff6f61;
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(255, 111, 97, 0.4);
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
                transition: color 0.3s ease, transform 0.3s ease;
            }

            .section-title h1:hover {
                color: #007bff;
                transform: scale(1.02);
            }

            /* Bộ lọc */
            .form-select {
                border-radius: 10px;
                border: 2px solid #007bff;
                padding: 10px;
                font-size: 0.9rem;
                transition: all 0.3s ease;
            }

            .form-select:focus {
                border-color: #ff6f61;
                box-shadow: 0 0 10px rgba(255, 111, 97, 0.3);
            }

            .form-select:hover {
                background: #f8f9fa;
            }

            .btn-primary {
                border-radius: 10px;
                background: #007bff;
                border: none;
                padding: 10px;
                font-weight: 600;
                transition: background 0.3s ease, transform 0.3s ease;
            }

            .btn-primary:hover {
                background: #ff6f61;
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(255, 111, 97, 0.4);
            }

            /* Courses List Item */
            .courses-list-item {
                position: relative;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .courses-list-item:hover {
                transform: translateY(-10px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
            }

            .courses-list-item img {
                width: 100%;
                height: 320px;
                object-fit: cover;
                transition: transform 0.3s ease;
            }

            .courses-list-item:hover img {
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
                transition: color 0.3s ease;
            }

            .courses-text h4:hover {
                color: #ffeb3b;
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
                color: #ffeb3b;
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

            /* Pagination */
            .pagination .page-item .page-link {
                border-radius: 50px;
                margin: 0 5px;
                color: #007bff;
                border: 2px solid #007bff;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .pagination .page-item.active .page-link {
                background: #007bff;
                color: #fff;
                border-color: #007bff;
            }

            .pagination .page-item .page-link:hover {
                background: #ff6f61;
                color: #fff;
                border-color: #ff6f61;
                transform: scale(1.1);
            }

            /* Back to Top Button */
            .back-to-top {
                background: #007bff;
                transition: background 0.3s ease, transform 0.3s ease;
            }

            .back-to-top:hover {
                background: #ff6f61;
                transform: rotate(360deg);
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
                    <form action="course" method="post">
                        <div class="input-group">
                            <input type="text" class="form-control border-light" name="search" style="padding: 20px;" placeholder="Search for a course..." value="${keyword}">
                            <div class="input-group-append">
                                <button class="btn btn-secondary px-4 px-lg-5" type="submit">Search</button>
                            </div>
                        </div>
                    </form>
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
                            <c:choose>
                                <c:when test="${not empty searchResults}">
                                    <!-- Hiển thị kết quả tìm kiếm nếu có -->
                                    <c:if test="${empty searchResults}">
                                        <div class="col-12 text-center">
                                            <p class="text-danger">No courses found for your search.</p>
                                        </div>
                                    </c:if>
                                    <c:forEach items="${searchResults}" var="c" varStatus="status">
                                        <c:if test="${status.index < 3}">
                                            <div class="col-lg-4 col-md-6 pb-4">
                                                <a class="courses-list-item position-relative d-block overflow-hidden mb-2" href="detail?courseId=${c.courseID}">
                                                    <img class="img-fluid" src="${c.image}" alt="${c.name}">
                                                    <div class="courses-text">
                                                        <h4 class="text-center text-white px-3">${c.name}</h4>
                                                        <div class="border-top w-100 mt-3">
                                                            <div class="d-flex justify-content-between p-4">
                                                                <span class="text-white"><i class="fa fa-user mr-2"></i>${c.expertName}<span class="tooltip-text">Giảng viên</span></span>
                                                                <span class="text-white"><i class="fa fa-money-bill-wave mr-2"></i>${c.price} VNĐ<span class="tooltip-text">Giá khóa học</span></span>
                                                                <span class="text-white"><i class="fa fa-star mr-2"></i>${c.averageRating}<span class="tooltip-text">Đánh giá trung bình</span></span>
                                                                <span class="text-white"><i class="fa fa-users mr-2"></i>${c.totalenrollment} People<span class="tooltip-text">Số người tham gia</span></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </a>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Hiển thị tất cả khóa học nếu không có tìm kiếm -->
                                    <c:if test="${empty courses}">
                                        <div class="col-12 text-center">
                                            <p class="text-danger">No courses available.</p>
                                        </div>
                                    </c:if>
                                    <c:forEach items="${courses}" var="c" varStatus="status">
                                        <c:if test="${status.index < 3}">
                                            <div class="col-lg-4 col-md-6 pb-4">
                                                <a class="courses-list-item position-relative d-block overflow-hidden mb-2" href="detail?courseId=${c.courseID}">
                                                    <img class="img-fluid" src="${c.image}" alt="${c.name}">
                                                    <div class="courses-text">
                                                        <h4 class="text-center text-white px-3">${c.name}</h4>
                                                        <div class="border-top w-100 mt-3">
                                                            <div class="d-flex justify-content-between p-4">
                                                                <span class="text-white"><i class="fa fa-user mr-2"></i>${c.expertName}<span class="tooltip-text">Giảng viên</span></span>
                                                                <span class="text-white"><i class="fa fa-money-bill-wave mr-2"></i>${c.price} VNĐ<span class="tooltip-text">Giá khóa học</span></span>
                                                                <span class="text-white"><i class="fa fa-star mr-2"></i>${c.averageRating}<span class="tooltip-text">Đánh giá trung bình</span></span>
                                                                <span class="text-white"><i class="fa fa-users mr-2"></i>${c.totalenrollment} People<span class="tooltip-text">Số người tham gia</span></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </a>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Các ảnh còn lại hiển thị bên dưới -->
                    <div class="col-12">
                        <div class="row">
                            <c:choose>
                                <c:when test="${not empty searchResults}">
                                    <!-- Hiển thị các khóa học còn lại từ searchResults -->
                                    <c:forEach items="${searchResults}" var="c" varStatus="status">
                                        <c:if test="${status.index >= 3}">
                                            <div class="col-lg-4 col-md-6 pb-4">
                                                <a class="courses-list-item position-relative d-block overflow-hidden mb-2" href="detail?courseId=${c.courseID}">
                                                    <img class="img-fluid" src="${c.image}" alt="${c.name}">
                                                    <div class="courses-text">
                                                        <h4 class="text-center text-white px-3">${c.name}</h4>
                                                        <div class="border-top w-100 mt-3">
                                                            <div class="d-flex justify-content-between p-4">
                                                                <span class="text-white"><i class="fa fa-user mr-2"></i>${c.expertName}<span class="tooltip-text">Giảng viên</span></span>
                                                                <span class="text-white"><i class="fa fa-money-bill-wave mr-2"></i>${c.price} VNĐ<span class="tooltip-text">Giá khóa học</span></span>
                                                                <span class="text-white"><i class="fa fa-star mr-2"></i>${c.averageRating}<span class="tooltip-text">Đánh giá trung bình</span></span>
                                                                <span class="text-white"><i class="fa fa-users mr-2"></i>${c.totalenrollment} People<span class="tooltip-text">Số người tham gia</span></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </a>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Hiển thị các khóa học còn lại từ courses -->
                                    <c:forEach items="${courses}" var="c" varStatus="status">
                                        <c:if test="${status.index >= 3}">
                                            <div class="col-lg-4 col-md-6 pb-4">
                                                <a class="courses-list-item position-relative d-block overflow-hidden mb-2" href="detail?courseId=${c.courseID}">
                                                    <img class="img-fluid" src="${c.image}" alt="${c.name}">
                                                    <div class="courses-text">
                                                        <h4 class="text-center text-white px-3">${c.name}</h4>
                                                        <div class="border-top w-100 mt-3">
                                                            <div class="d-flex justify-content-between p-4">
                                                                <span class="text-white"><i class="fa fa-user mr-2"></i>${c.expertName}<span class="tooltip-text">Giảng viên</span></span>
                                                                <span class="text-white"><i class="fa fa-money-bill-wave mr-2"></i>${c.price} VNĐ<span class="tooltip-text">Giá khóa học</span></span>
                                                                <span class="text-white"><i class="fa fa-star mr-2"></i>${c.averageRating}<span class="tooltip-text">Đánh giá trung bình</span></span>
                                                                <span class="text-white"><i class="fa fa-users mr-2"></i>${c.totalenrollment} People<span class="tooltip-text">Số người tham gia</span></span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </a>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Pagination Start -->
                    <c:if test="${totalPages > 0}">
                        <div class="col-12">
                            <nav aria-label="Page navigation">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <c:choose>
                                                <c:when test="${not empty searchResults}">
                                                    <a class="page-link" href="course?page=${currentPage - 1}&search=${keyword}&searchSubmitted=true" aria-label="Previous">
                                                        <span aria-hidden="true">«</span>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="page-link" href="course?page=${currentPage - 1}&category=${param.category}&priceOrder=${param.priceOrder}&ratingOrder=${param.ratingOrder}" aria-label="Previous">
                                                        <span aria-hidden="true">«</span>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <c:choose>
                                                <c:when test="${not empty searchResults}">
                                                    <a class="page-link" href="course?page=${i}&search=${keyword}&searchSubmitted=true">${i}</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="page-link" href="course?page=${i}&category=${param.category}&priceOrder=${param.priceOrder}&ratingOrder=${param.ratingOrder}">${i}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <c:choose>
                                                <c:when test="${not empty searchResults}">
                                                    <a class="page-link" href="course?page=${currentPage + 1}&search=${keyword}&searchSubmitted=true" aria-label="Next">
                                                        <span aria-hidden="true">»</span>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="page-link" href="course?page=${currentPage + 1}&category=${param.category}&priceOrder=${param.priceOrder}&ratingOrder=${param.ratingOrder}" aria-label="Next">
                                                        <span aria-hidden="true">»</span>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
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
        <script>
            // Hiệu ứng click cho courses-list-item
            document.querySelectorAll('.courses-list-item').forEach(item => {
                item.addEventListener('click', function () {
                    // Xóa class active khỏi tất cả các item
                    document.querySelectorAll('.courses-list-item').forEach(i => i.classList.remove('active'));
                    // Thêm class active cho item được click
                    this.classList.add('active');
                    // Thêm hiệu ứng phóng to nhẹ
                    this.style.transform = 'scale(1.02)';
                });
            });

            // Hiệu ứng hover cho pagination
            document.querySelectorAll('.page-link').forEach(link => {
                link.addEventListener('mouseover', function () {
                    if (!this.parentElement.classList.contains('active')) {
                        this.style.background = '#ff6f61';
                        this.style.color = '#fff';
                    }
                });
                link.addEventListener('mouseout', function () {
                    if (!this.parentElement.classList.contains('active')) {
                        this.style.background = 'transparent';
                        this.style.color = '#007bff';
                    }
                });
            });

            // Hiệu ứng cho nút Apply
            document.querySelector('.btn-primary').addEventListener('click', function () {
                this.style.background = '#ff6f61';
                this.style.transform = 'scale(1.05)';
            });
        </script>
    </body>
</html>