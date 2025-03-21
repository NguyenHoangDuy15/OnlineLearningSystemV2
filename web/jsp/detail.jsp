<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
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

            /* Course Detail Image */
            .course-detail-image {
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .course-detail-image:hover {
                transform: scale(1.02);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
            }

            /* Course Description */
            .mb-5 p {
                font-size: 1.1rem;
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

            /* Related Courses (Top 5 Courses) */
            .related-carousel h2 {
                font-weight: 600;
                transition: transform 0.3s ease;
            }

            .related-carousel h2:hover {
                transform: scale(1.02);
            }

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

            .related-course-image {
                width: 100%;
                height: 300px;
                object-fit: cover;
                transition: transform 0.3s ease;
            }

            .courses-list-item:hover .related-course-image {
                transform: scale(1.1);
            }

            .courses-text {
                padding: 15px;
            }

            .courses-text h4 {
                font-size: 1.5rem;
                font-weight: 600;
                margin-bottom: 10px;
                transition: transform 0.3s ease;
            }

            .courses-text h4:hover {
                transform: translateX(5px);
            }

            .courses-text .border-top {
                border-top: 1px solid rgba(255, 255, 255, 0.3) !important;
            }

            .courses-text span, .courses-text small {
                position: relative;
                font-size: 0.9rem;
                transition: transform 0.3s ease;
            }

            .courses-text span:hover, .courses-text small:hover {
                transform: translateX(5px);
            }

            /* Tooltip cho thông tin khóa học */
            .courses-text span .tooltip-text, .courses-text small .tooltip-text {
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

            .courses-text span:hover .tooltip-text, .courses-text small:hover .tooltip-text {
                visibility: visible;
                opacity: 1;
            }

            /* Course Features */
            .bg-primary {
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                transition: transform 0.3s ease;
            }

            .bg-primary:hover {
                transform: translateY(-5px);
            }

            .bg-primary h3 {
                font-weight: 600;
                transition: transform 0.3s ease;
            }

            .bg-primary h3:hover {
                transform: scale(1.02);
            }

            .bg-primary .d-flex {
                transition: background 0.3s ease;
            }

            .bg-primary .d-flex:hover {
                background: rgba(255, 255, 255, 0.1);
            }

            .bg-primary h6 {
                font-size: 1rem;
                transition: transform 0.3s ease;
            }

            .bg-primary h6 i {
                margin-right: 10px;
                transition: transform 0.3s ease;
            }

            .bg-primary .d-flex:hover h6 {
                transform: translateX(5px);
            }

            .bg-primary .d-flex:hover h6 i {
                transform: scale(1.2);
            }

            .bg-primary h5 {
                font-weight: 600;
                transition: transform 0.3s ease;
            }

            .bg-primary h5:hover {
                transform: scale(1.02);
            }

            /* Nút Enroll Now */
            .bg-primary .btn {
                border: none;
                border-radius: 25px;
                font-weight: 600;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .bg-primary .btn:hover {
                transform: scale(1.05);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            }

            /* Back to Top Button */
            .back-to-top {
                transition: transform 0.3s ease;
            }

            .back-to-top:hover {
                transform: rotate(360deg);
            }

            /* Comment Section */
            .comment-section {
                margin-top: 50px;
            }

            .comment-section h2 {
                font-weight: 600;
                transition: transform 0.3s ease;
            }

            .comment-section h2:hover {
                transform: scale(1.02);
            }

            .comment-box {
                border: 1px solid #ddd;
                border-radius: 10px;
                padding: 15px;
                margin-bottom: 20px;
                background-color: #f9f9f9;
            }

            .comment-box .source {
                font-size: 0.9rem;
                color: #555;
                margin-bottom: 5px;
            }

            .comment-box .rating {
                color: #ff4d4f; /* Màu đỏ giống Shopee */
                margin-bottom: 5px;
            }

            .comment-box .rating .fa-star {
                font-size: 1rem;
            }

            .comment-box .rating .fa-star.empty {
                color: #ddd; /* Màu xám cho sao rỗng */
            }

            .comment-box .timestamp {
                font-size: 0.85rem;
                color: #888;
                margin-bottom: 10px;
            }

            .comment-box .content {
                font-size: 0.95rem;
                color: #333;
                line-height: 1.5;
            }

            .comment-form, .edit-form {
                margin-top: 30px;
            }

            .comment-form textarea, .edit-form textarea {
                width: 100%;
                border-radius: 10px;
                border: 1px solid #ddd;
                padding: 10px;
                font-size: 1rem;
                resize: none;
                transition: border-color 0.3s ease;
            }

            .comment-form textarea:focus, .edit-form textarea:focus {
                border-color: #007bff;
                outline: none;
            }

            .comment-form .rating-input, .edit-form .rating-input {
                margin: 10px 0;
            }

            .comment-form .rating-input label, .edit-form .rating-input label {
                margin-right: 10px;
                font-weight: 600;
            }

            .comment-form .star-rating, .edit-form .star-rating {
                display: inline-block;
                font-size: 1.2rem;
            }

            .comment-form .star-rating input, .edit-form .star-rating input {
                display: none;
            }

            .comment-form .star-rating label, .edit-form .star-rating label {
                color: #ddd;
                cursor: pointer;
                margin-right: 5px;
            }

            .comment-form .star-rating label:hover,
            .comment-form .star-rating label:hover ~ label,
            .comment-form .star-rating input:checked ~ label,
            .edit-form .star-rating label:hover,
            .edit-form .star-rating label:hover ~ label,
            .edit-form .star-rating input:checked ~ label {
                color: #ff4d4f;
            }

            .comment-form button, .edit-form button {
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 25px;
                padding: 10px 20px;
                font-weight: 600;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .comment-form button:hover, .edit-form button:hover {
                transform: scale(1.05);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            }

            /* Thêm style cho avatar và user info */
            .comment-box .avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                margin-right: 10px;
                vertical-align: middle;
            }
            .comment-box .user-info {
                display: flex;
                align-items: center;
                margin-bottom: 5px;
            }
            .comment-box .user-name {
                font-size: 0.9rem;
                color: #555;
                font-weight: 600;
            }

            /* Style cho nút Edit và Delete */
            .comment-actions {
                margin-top: 10px;
            }
            .comment-actions .btn {
                margin-right: 5px;
            }
        </style>
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
                            <img class="img-fluid rounded w-100 mb-4 course-detail-image" src="${course.image}" alt="${course.name}">

                            <p>${course.description}</p>
                        </div>

                        <h2 class="mb-3">Top 5 Courses</h2>
                        <div class="owl-carousel related-carousel position-relative" style="padding: 0 30px;">
                            <c:forEach items="${courses}" var="c">
                                <a class="courses-list-item position-relative d-block overflow-hidden mb-2" href="detail?courseId=${c.courseID}">
                                    <img class="img-fluid related-course-image" src="${c.image}" alt="${c.name}" style="width: 100%; height: 300px; object-fit: cover;">
                                    <div class="courses-text">
                                        <h4 class="text-center text-white px-3">${c.name}</h4>
                                        <div class="border-top w-100 mt-3">
                                            <div class="d-flex justify-content-between p-4">
                                                <span class="text-white"><i class="fa fa-user mr-2"></i>${c.expertName}<span class="tooltip-text">Giảng viên</span></span>
                                                <span class="text-white"><i class="fa fa-money-bill-wave mr-2"></i>${c.price} VNĐ<span class="tooltip-text">Giá khóa học</span></span>
                                                <span class="text-white"><i class="fa fa-star mr-2"></i>${c.averageRating}<span class="tooltip-text">Đánh giá trung bình</span></span>
                                                <small class="text-white">(${c.totalenrollment})<span class="tooltip-text">Số người tham gia</span></small>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>

                        <!-- Comment Section Start -->
                        <<div class="comment-section">
                            <h2 class="mb-4">Comments</h2>
                            <!-- Display existing comments for all users -->
                            <c:if test="${empty feedbacks}">
                                <p>No comments yet.</p>
                            </c:if>
                            <c:forEach items="${feedbacks}" var="feedback">
                                <div class="comment-box" id="comment-${feedback.feedbackid}">
                                    <div class="user-info">
                                        <img src="${feedback.avartar != null ? feedback.avartar : 'img/default-avatar.png'}" alt="Avatar" class="avatar">
                                        <span class="user-name">${feedback.name}</span>
                                    </div>
                                    <div class="rating">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fa fa-star ${i <= feedback.rating ? '' : 'empty'}"></i>
                                        </c:forEach>
                                    </div>
                                    <div class="content">${feedback.comment}</div>
                                    <div class="timestamp">
                                        <fmt:formatDate value="${feedback.createdAt}" pattern="dd-MM-yyyy HH:mm"/>
                                    </div>

                                    <!-- Hiển thị nút Edit và Delete nếu bình luận thuộc về người dùng hiện tại -->
                                    <c:if test="${sessionScope.userid != null && sessionScope.userid == feedback.userId}">
                                        <div class="comment-actions">
                                            <button class="btn btn-sm btn-primary edit-comment" data-feedback-id="${feedback.feedbackid}">Edit</button>
                                            <form action="Feedbackcontroller" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this comment?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="feedbackId" value="${feedback.feedbackid}">
                                                <input type="hidden" name="courseId" value="${course.courseID}">
                                                <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                            </form>
                                        </div>

                                        <!-- Form chỉnh sửa bình luận (ẩn ban đầu) -->
                                        <div class="edit-form" id="edit-form-${feedback.feedbackid}" style="display:none;">
                                            <h4>Edit Comment</h4>
                                            <form action="Feedbackcontroller" method="POST">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="feedbackId" value="${feedback.feedbackid}">
                                                <input type="hidden" name="courseId" value="${course.courseID}">
                                                <div class="rating-input">
                                                    <label for="rating-${feedback.feedbackid}">Rating:</label>
                                                    <div class="star-rating">
                                                        <input type="radio" id="star5-${feedback.feedbackid}" name="rating" value="5" ${feedback.rating == 5 ? 'checked' : ''} required>
                                                        <label for="star5-${feedback.feedbackid}"><i class="fa fa-star"></i></label>
                                                        <input type="radio" id="star4-${feedback.feedbackid}" name="rating" value="4" ${feedback.rating == 4 ? 'checked' : ''}>
                                                        <label for="star4-${feedback.feedbackid}"><i class="fa fa-star"></i></label>
                                                        <input type="radio" id="star3-${feedback.feedbackid}" name="rating" value="3" ${feedback.rating == 3 ? 'checked' : ''}>
                                                        <label for="star3-${feedback.feedbackid}"><i class="fa fa-star"></i></label>
                                                        <input type="radio" id="star2-${feedback.feedbackid}" name="rating" value="2" ${feedback.rating == 2 ? 'checked' : ''}>
                                                        <label for="star2-${feedback.feedbackid}"><i class="fa fa-star"></i></label>
                                                        <input type="radio" id="star1-${feedback.feedbackid}" name="rating" value="1" ${feedback.rating == 1 ? 'checked' : ''}>
                                                        <label for="star1-${feedback.feedbackid}"><i class="fa fa-star"></i></label>
                                                    </div>
                                                </div>
                                                <textarea name="comment" rows="4" placeholder="Write your comment here..." required>${feedback.comment}</textarea>
                                                <button type="submit" class="btn btn-sm btn-success">Update Comment</button>
                                                <button type="button" class="btn btn-sm btn-secondary cancel-edit" data-feedback-id="${feedback.feedbackid}">Cancel</button>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>

                            <!-- Comment Form: Only show for logged-in users who have purchased the course -->
                            <c:if test="${sessionScope.userid != null && enrollment != null && enrollment.paymentStatus == 1}">
                                <div class="comment-form">
                                    <h4>Leave a Comment</h4>
                                    <form action="Feedbackcontroller" method="POST">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="courseId" value="${course.courseID}">
                                        <div class="rating-input">
                                            <label for="rating">Rating:</label>
                                            <div class="star-rating">
                                                <input type="radio" id="star5" name="rating" value="5" required>
                                                <label for="star5"><i class="fa fa-star"></i></label>
                                                <input type="radio" id="star4" name="rating" value="4">
                                                <label for="star4"><i class="fa fa-star"></i></label>
                                                <input type="radio" id="star3" name="rating" value="3">
                                                <label for="star3"><i class="fa fa-star"></i></label>
                                                <input type="radio" id="star2" name="rating" value="2">
                                                <label for="star2"><i class="fa fa-star"></i></label>
                                                <input type="radio" id="star1" name="rating" value="1">
                                                <label for="star1"><i class="fa fa-star"></i></label>
                                            </div>
                                        </div>
                                        <textarea name="comment" rows="4" placeholder="Write your comment here..." required></textarea>
                                        <button type="submit">Submit Comment</button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <div class="col-lg-4 mt-5 mt-lg-0">
                        <div class="bg-primary mb-5 py-3">
                            <h3 class="text-white py-3 px-4 m-0">Course Features</h3>
                            <div class="d-flex justify-content-between border-bottom px-4">
                                <h6 class="text-white my-3"><i class="fa fa-user"></i> Instructor</h6>
                                <h6 class="text-white my-3">${coursedetails.expertName}</h6>
                            </div>
                            <div class="d-flex justify-content-between border-bottom px-4">
                                <h6 class="text-white my-3"><i class="fa fa-star"></i> Rating</h6>
                                <h6 class="text-white my-3">${coursedetails.averageRating}</h6>
                            </div>
                            <div class="d-flex justify-content-between border-bottom px-4">
                                <h6 class="text-white my-3"><i class="fa fa-users"></i> Enrollments</h6>
                                <h6 class="text-white my-3">${coursedetails.totalenrollment}</h6>
                            </div>
                            <h5 class="text-white py-3 px-4 m-0">
                                <i class="fa fa-money-bill-wave"></i> ${coursedetails.price} VND
                            </h5>
                            <div class="py-3 px-4">
                                <c:choose>
                                    <c:when test="${enrollment != null && enrollment.paymentStatus == 1}">
                                        <a class="btn btn-block py-3 px-5" href="Lessonservlet?courseId=${enrollment.courseId}&userid=${userid}" style="background-color: green; color: white;">
                                            Go to Course
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${sessionScope.userid != null}">
                                                <!-- Người dùng đã đăng nhập -->
                                                <a class="btn btn-block py-3 px-5" href="VNPAYServlet" style="background-color: red; color: white;">
                                                    Enroll Now
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Guest: Chuyển hướng đến trang đăng nhập -->
                                                <a class="btn btn-block py-3 px-5" href="LoginServlet?redirect=VNPAYServlet" style="background-color: red; color: white;">
                                                    Enroll Now
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </div>
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

                                                // Hiệu ứng click cho nút Enroll Now
                                                document.querySelector('.bg-primary .btn').addEventListener('click', function () {
                                                    this.style.transform = 'scale(1.1)';
                                                });

                                                // Hiệu ứng hover cho course detail image
                                                document.querySelector('.course-detail-image').addEventListener('mouseover', function () {
                                                    this.style.transform = 'scale(1.02)';
                                                });

                                                // Xử lý sự kiện nhấn nút Edit

                                                document.querySelectorAll('.edit-comment').forEach(button => {
                                                    button.addEventListener('click', function () {
                                                        const feedbackId = this.getAttribute('data-feedback-id');
                                                        document.querySelector(`#comment-${feedbackId} .content`).style.display = 'none';
                                                        document.querySelector(`#comment-${feedbackId} .rating`).style.display = 'none';
                                                        document.querySelector(`#comment-${feedbackId} .comment-actions`).style.display = 'none';
                                                        document.getElementById(`edit-form-${feedbackId}`).style.display = 'block';
                                                    });
                                                });

                                                document.querySelectorAll('.cancel-edit').forEach(button => {
                                                    button.addEventListener('click', function () {
                                                        const feedbackId = this.getAttribute('data-feedback-id');
                                                        document.querySelector(`#comment-${feedbackId} .content`).style.display = 'block';
                                                        document.querySelector(`#comment-${feedbackId} .rating`).style.display = 'block';
                                                        document.querySelector(`#comment-${feedbackId} .comment-actions`).style.display = 'block';
                                                        document.getElementById(`edit-form-${feedbackId}`).style.display = 'none';
                                                    });
                                                });
        </script>
    </body>
</html>