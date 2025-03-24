<%@ page import="Model.Usernew, Model.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User user = (User) session.getAttribute("account"); // Lấy User từ session
    Usernew userNew = null;
    Integer userId = (Integer) session.getAttribute("userid");

    // Lấy số lượng khóa học từ session
    Integer registeredCourses = (Integer) session.getAttribute("registeredCourses");
    Integer completedCourses = (Integer) session.getAttribute("completedCourses");

    // Gán giá trị mặc định nếu không có dữ liệu trong session
    int enrollmentCount = (registeredCourses != null) ? registeredCourses : 0;
    int completedCoursesCount = (completedCourses != null) ? completedCourses : 0;

    if (user != null) {
        userNew = new Usernew(user);
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Topbar */
            .topbar {
                background: linear-gradient(90deg, #007bff, #00c6ff);
                padding: 10px 0;
            }

            .topbar .text-white {
                color: #fff !important;
                font-size: 0.9rem;
            }

            .topbar a:hover i {
                color: #ffeb3b; /* Vàng sáng khi hover */
                transition: color 0.3s ease;
            }

            /* Navbar */
            .navbar {
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                padding: 15px 0;
            }

            .navbar-brand h3 {
                font-family: 'Jost', sans-serif;
                font-weight: 700;
                color: #007bff;
                transition: color 0.3s ease;
            }

            .navbar-brand h3:hover {
                color: #0056b3;
            }

            .nav-link {
                font-size: 1.1rem;
                color: #333 !important;
                transition: color 0.3s ease;
            }

            .nav-link:hover, .nav-link.active {
                color: #007bff !important;
            }

            /* Avatar */
            .avatar {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                object-fit: cover;
                border: 2px solid #007bff;
                cursor: pointer;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .avatar:hover {
                transform: scale(1.1);
                box-shadow: 0 0 10px rgba(0, 123, 255, 0.5);
            }

            /* Dropdown Menu */
            .dropdown-menu {
                background: #fff;
                border: none;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
                min-width: 300px;
                padding: 0;
                animation: fadeIn 0.3s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Dropdown Header */
            .dropdown-header {
                padding: 15px 20px;
                border-bottom: 1px solid #e9ecef;
                display: flex;
                align-items: center;
                gap: 15px;
                background: linear-gradient(135deg, #f8f9fa, #e9ecef);
                border-top-left-radius: 15px;
                border-top-right-radius: 15px;
            }

            .dropdown-header img {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                border: 2px solid #007bff;
            }

            .dropdown-header .user-info {
                flex: 1;
            }

            .dropdown-header .user-info h6 {
                margin: 0;
                font-size: 1rem;
                font-weight: 600;
                color: #1a1a1a;
            }

            .dropdown-header .user-info p {
                margin: 0;
                font-size: 0.85rem;
                color: #6c757d;
            }

            .dropdown-header .btn-view-profile {
                background: #6f42c1;
                color: #fff;
                font-size: 0.75rem;
                padding: 4px 10px;
                border-radius: 12px;
                text-decoration: none;
                transition: background 0.3s ease, transform 0.3s ease;
            }

            .dropdown-header .btn-view-profile:hover {
                background: #563d7c;
                transform: translateY(-2px);
            }

            /* Stats Section */
            .dropdown-stats {
                padding: 10px 20px;
                display: flex;
                gap: 15px;
                border-bottom: 1px solid #e9ecef;
                background: #f8f9fa;
            }

            .stat-item {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 0.9rem;
                font-weight: 500;
                padding: 8px 12px;
                border-radius: 8px;
                background: #fff;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                cursor: pointer;
            }

            .stat-item:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
            }

            .stat-item i {
                font-size: 1.2rem;
            }

            .stat-item.enrollments i {
                color: #007bff; /* Màu xanh cho My Enrollments */
            }

            .stat-item.completed i {
                color: #28a745; /* Màu xanh lá cho My Courses (hoàn thành) */
            }

            /* Dropdown Items */
            .dropdown-item {
                color: #1a1a1a;
                font-weight: 500;
                padding: 10px 20px;
                transition: background 0.3s ease, color 0.3s ease, padding-left 0.3s ease;
            }

            .dropdown-item:hover {
                background: #007bff;
                color: #fff !important;
                padding-left: 25px;
            }

            .dropdown-item.active {
                background: #007bff;
                color: #fff !important;
            }

            /* Login Button */
            .btn-login {
                background: #007bff;
                color: #fff;
                padding: 8px 20px;
                border-radius: 25px;
                transition: background 0.3s ease;
            }

            .btn-login:hover {
                background: #0056b3;
                color: #fff;
            }

            /* Tooltip */
            .stat-item {
                position: relative;
            }

            .stat-item .tooltip-text {
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

            .stat-item:hover .tooltip-text {
                visibility: visible;
                opacity: 1;
            }
        </style>
    </head>
    <body>
        <!-- Navbar Start -->
        <div class="container-fluid p-0">
            <nav class="navbar navbar-expand-lg bg-white navbar-light py-3 py-lg-0 px-lg-5">
                <a href="index" class="navbar-brand ml-lg-3">
                    <h3 name="logopage" class="m-0 text-uppercase text-primary"><i class="fa fa-book-reader mr-3"></i>Online Learning</h3>
                </a>
                <button type="button" class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse justify-content-between px-lg-3" id="navbarCollapse">
                    <div class="navbar-nav mx-auto py-0">
                        <%
                            if (userId != null) {
                        %>
                        <a href="index" class="nav-item nav-link active">Home</a>
                        <%
                            } else {
                        %>
                        <a href="Landingpage" class="nav-item nav-link active">Home</a>
                        <%
                            }
                        %>
                        <a href="course" class="nav-item nav-link">Courses</a>
                        <div class="nav-item dropdown">
                            <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Pages</a>
                            <div class="dropdown-menu m-0">
                                <a href="Instructor" class="dropdown-item">Instructors</a>
                            </div>
                        </div>
                        <a href="ViewBlog" class="nav-item nav-link">Blog</a>
                        <%
                            Boolean isSale = (Boolean) session.getAttribute("isSale");
                            if (isSale != null && isSale) {
                        %>
                        <a href="viewownerbloglist" class="nav-item nav-link">Manage Blogs</a>
                        <%
                            }
                        %>
                    </div>

                    <%
                        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
                        if (isLoggedIn != null && isLoggedIn) {
                    %>
                    <!-- Avatar Dropdown -->
                    <div class="dropdown">
                        <img name="btnAvar" src="<%= userNew.getAvatar() %>" alt="Avatar" class="avatar" id="avatarDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="avatarDropdown">
                            <!-- Header with User Info -->
                            <li class="dropdown-header">
                                <img src="<%= userNew.getAvatar() %>" alt="Avatar">
                                <div class="user-info">
                                    <h6>Hi, <%= userNew.getUserName() %></h6>
                                    <p><%= userNew.getEmail() %></p>
                                </div>
                                <a href="ViewProfile" class="btn-view-profile">View profile</a>
                            </li>
                            <!-- Stats -->
                            <li class="dropdown-stats">
                                <div class="stat-item enrollments">
                                    <a href="myenrollment" style="text-decoration: none; color: inherit;">
                                        <i class="fas fa-book"></i> My Enrollments: <%= enrollmentCount %>
                                        <span class="tooltip-text">Bạn đã đăng ký <%= enrollmentCount %> khóa học</span>
                                    </a>
                                </div>
                                <div class="stat-item completed">
                                    <a href="Mycourses" style="text-decoration: none; color: inherit;">
                                        <i class="fas fa-check-circle"></i> My Courses: <%= completedCoursesCount %>
                                        <span class="tooltip-text">Bạn đã hoàn thành <%= completedCoursesCount %> khóa học</span>
                                    </a>
                                </div>
                            </li>
                            <!-- Menu Items -->

                            
                            <li>
                                <a name="btncp" class="dropdown-item" href="ChangePasswordServlet">
                                    <i class="fas fa-lock mr-2"></i> Change Password
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="Historytransaction">
                                    <i class="fas fa-history mr-2"></i> History of Transaction
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="Role">
                                    <i class="fas fa-user-tie mr-2"></i> Become Expert or Sale
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="Request">
                                    <i class="fas fa-hourglass-half mr-2"></i> Wait for Approval
                                </a>
                            </li>
                            <li>
                                <a name="btnlg" class="dropdown-item" href="LogoutServlet">
                                    <i class="fas fa-sign-out-alt mr-2"></i> Logout
                                </a>
                            </li>
                        </ul>
                    </div>
                    <%
                        } else {
                    %>
                    <!-- Login Button -->
                    <a name="btnlogin" href="LoginServlet" class="btn btn-login py-2 px-4 d-none d-lg-block">Login</a>
                    <%
                        }
                    %>
                </div>
            </nav>
        </div>
        <!-- Navbar End -->

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Thêm hiệu ứng click cho dropdown items
            document.querySelectorAll('.dropdown-item').forEach(item => {
                item.addEventListener('click', function () {
                    // Xóa class active khỏi tất cả các item
                    document.querySelectorAll('.dropdown-item').forEach(i => i.classList.remove('active'));
                    // Thêm class active cho item được click
                    this.classList.add('active');
                });
            });

            // Thêm hiệu ứng click cho stat items (có thể dùng để làm nổi bật)
            document.querySelectorAll('.stat-item').forEach(item => {
                item.addEventListener('click', function () {
                    // Xóa hiệu ứng nổi bật khỏi tất cả stat items
                    document.querySelectorAll('.stat-item').forEach(i => i.style.background = '#fff');
                    // Thêm hiệu ứng nổi bật cho item được click
                    this.style.background = '#e6f0ff';
                });
            });
        </script>
    </body>
</html>