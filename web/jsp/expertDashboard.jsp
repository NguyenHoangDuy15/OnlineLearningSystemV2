<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.TestEX" %>
<%@ page import="Model.CourseEX" %>
<%@ page import="dal.TestEXDAO" %>
<%@ page import="dal.CourseEXDAO" %>
<%@ page import="Model.User" %>
<%@ page import="Model.Usernew" %>
<%@ page import="dal.UserDAO" %>

<%
    List<TestEX> tests = (List<TestEX>) request.getAttribute("tests");
    List<CourseEX> courses = (List<CourseEX>) request.getAttribute("courses");
    String fullName = (String) session.getAttribute("Fullname");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    TestEXDAO testDAO = new TestEXDAO();
    CourseEXDAO courseDAO = new CourseEXDAO();
    User user = (User) session.getAttribute("account");
    Usernew userNew = null;
    Integer userId = (Integer) session.getAttribute("userid");
    Integer roleId = (Integer) session.getAttribute("rollID");
    Integer registeredCourses = (Integer) session.getAttribute("registeredCourses");
    Integer completedCourses = (Integer) session.getAttribute("completedCourses");
    int enrollmentCount = (registeredCourses != null) ? registeredCourses : 0;
    int completedCoursesCount = (completedCourses != null) ? completedCourses : 0;

    Boolean showCourseList = (Boolean) request.getAttribute("showCourseList");
    if (showCourseList == null) {
        showCourseList = false;
    }

    if (user != null) {
        userNew = new Usernew(user);
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Online learning system</title>
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
    </head>
    <head>
        <style>
            :root {
                --primary: #4A90E2;
                --secondary: #F5F5F5;
                --accent-green: #2ECC71;
                --accent-red: #E74C3C;
                --text-dark: #333333;
                --text-light: #6c757d;
                --background: #FFFFFF;
                --border: #E0E0E0;
                --shadow: rgba(0, 0, 0, 0.1);
                --gradient-primary: linear-gradient(90deg, #4A90E2, #357ABD);
                --gradient-success: linear-gradient(90deg, #2ECC71, #27AE60);
                --gradient-danger: linear-gradient(90deg, #E74C3C, #C0392B);
            }

            * {
                box-sizing: border-box;
            }

            body {
                font-family: 'Roboto', sans-serif;
                background-color: var(--secondary);
                margin: 0;
                padding: 0;
                overflow-x: hidden;
            }

            .container-fluid {
                padding: 0;
            }

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
                color: #ffeb3b;
                transition: color 0.3s ease;
            }

            /* Navbar */
            .navbar {
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                padding: 15px 0;
                position: relative;
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

            .hamburger {
                font-size: 24px;
                color: #333;
                cursor: pointer;
                padding: 10px;
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                z-index: 1001;
            }

            .hamburger:hover {
                color: var(--primary);
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
                position: relative;
            }

            .stat-item:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
            }

            .stat-item i {
                font-size: 1.2rem;
            }

            .stat-item.enrollments i {
                color: #007bff;
            }

            .stat-item.completed i {
                color: #28a745;
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

            .dropdown-item i {
                margin-right: 8px;
            }

            .dropdown-item.logout i {
                color: #E74C3C;
            }

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

            /* Sidebar */
            .sidebar {
                position: fixed;
                top: 0;
                left: -400px;
                width: 400px;
                height: 100%;
                background-color: var(--secondary);
                padding: 16px;
                display: flex;
                flex-direction: column;
                gap: 16px;
                border-right: 1px solid var(--border);
                transition: left 0.3s ease;
                z-index: 1000;
                overflow-y: auto;
            }

            .sidebar.active {
                left: 0;
            }

            .sidebar h2 {
                font-size: 18px;
                font-weight: 500;
                color: var(--text-dark);
                margin-bottom: 16px;
                border-bottom: 2px solid var(--primary);
                padding-bottom: 8px;
            }

            .button-group {
                padding-top: 50px;
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .button-group .btn {
                padding-top: 20px;
                padding: 8px 16px;
                font-size: 14px;
                text-align: center;
                width: 100%;
                box-sizing: border-box;
            }

            .main-content {
                width: 100%;
                background-color: var(--background);
                padding: 32px;
                overflow-y: auto;
                min-height: calc(100vh - 72px);
                transition: margin-left 0.3s ease;
            }

            .main-content.shifted {
                margin-left: 400px;
            }

            .welcome {
                display: flex;
                flex-direction: column;
                height: 100%;
            }

            .welcome h2 {
                text-align: center;
                margin-bottom: 20px;
            }

            .welcome-image {
                width: 100%;
                height: calc(100vh - 72px - 32px - 20px - 40px);
                object-fit: cover;
                border-radius: 8px;
                box-shadow: 0 2px 8px var(--shadow);
                display: block;
            }

            .notification {
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: center;
                display: none;
            }

            .notification.success {
                color: var(--accent-green);
                background-color: #e6ffe6;
                border: 1px solid var(--accent-green);
                display: block;
            }

            .notification.error {
                color: var(--accent-red);
                background-color: #ffe6e6;
                border: 1px solid var(--accent-red);
                display: block;
            }

            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                margin-top: 16px;
                background-color: var(--background);
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 8px var(--shadow);
            }

            th, td {
                padding: 12px 16px;
                text-align: left;
                border-bottom: 1px solid var(--border);
            }

            th {
                font-weight: 600;
                color: var(--text-dark);
                background-color: var(--secondary);
                font-size: 14px;
                text-transform: uppercase;
            }

            td {
                font-size: 14px;
                color: var(--text-dark);
            }

            tr:hover {
                background-color: #E6F0FA;
            }

            .description {
                max-width: 400px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .description:hover {
                white-space: normal;
                overflow: visible;
            }

            .price {
                color: var(--accent-green);
                font-weight: 500;
            }

            .status-approved {
                color: #2ECC71;
            }
            .status-rejected {
                color: #E74C3C;
            }
            .status-waiting {
                color: brown;
            }
            .status-delete {
                color: #000000;
            }
            .hidden {
                display: none;
            }

            .btn {
                padding: 10px 24px;
                border: none;
                border-radius: 12px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 6px var(--shadow);
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .btn-primary {
                background: var(--gradient-primary);
                color: #FFFFFF;
            }

            .btn-primary:hover {
                background: linear-gradient(90deg, #357ABD, #4A90E2);
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(74, 144, 226, 0.3);
            }

            .btn-success {
                background: var(--gradient-success);
                color: #FFFFFF;
            }

            .btn-success:hover {
                background: linear-gradient(90deg, #27AE60, #2ECC71);
                transform: translateY(-2px);
            }

            .btn-danger {
                background: var(--gradient-danger);
                color: #FFFFFF;
            }

            .btn-danger:hover {
                background: linear-gradient(90deg, #C0392B, #E74C3C);
                transform: translateY(-2px);
            }

            .btn-warning {
                background: linear-gradient(90deg, #F1C40F, #F39C12);
                color: #FFFFFF;
            }

            .btn-warning:hover {
                background: linear-gradient(90deg, #F39C12, #F1C40F);
                transform: translateY(-2px);
            }

            @media (max-width: 768px) {
                .sidebar {
                    width: 250px;
                    left: -250px;
                }

                .sidebar.active {
                    left: 0;
                }

                .main-content.shifted {
                    margin-left: 250px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Navbar Start -->
        <div class="container-fluid p-0">
            <nav class="navbar navbar-expand-lg bg-white navbar-light py-3 py-lg-0 px-lg-5">
                <div class="hamburger" onclick="toggleSidebar()">
                    <i class="fas fa-bars"></i>
                </div>
                <%
                    if (userId != null) {
                %>
                <a href="index" class="navbar-brand ml-lg-3">
                    <h3 name="logopage" class="m-0 text-uppercase text-primary"><i class="fa fa-book-reader mr-3"></i>Online Learning</h3>
                </a>
                <%
                    } else {
                %>
                <a href="Landingpage" class="navbar-brand ml-lg-3">
                    <h3 name="logopage" class="m-0 text-uppercase text-primary"><i class="fa fa-book-reader mr-3"></i>Online Learning</h3>
                </a>
                <%
                    }
                %>
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
                            <a href="Expert" class="nav-item nav-link">Experts</a>
                        </div>
                        <a href="ViewBlog" class="nav-item nav-link">Blog</a>
                        <%
                            if (roleId != null && roleId == 2) {
                        %>
                        <a href="ShowexpertServlet" class="nav-item nav-link">ExpertPage</a>
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
                                <a href="ViewProfile" class="btn-view-profile" name="btn-view-profile">View profile</a>
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
                                    <i class="fas fa-lock"></i> Change Password
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="Historytransaction">
                                    <i class="fas fa-history"></i> History of Transaction
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="Role">
                                    <i class="fas fa-user-tie"></i> Become Expert or Sale
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item" href="Request">
                                    <i class="fas fa-hourglass-half"></i> Wait for Approval
                                </a>
                            </li>
                            <li>
                                <a name="btnlg" class="dropdown-item logout" href="LogoutServlet">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a>
                            </li>
                        </ul>
                    </div>
                    <%
                        } else {
                    %>
                    <a name="btnlogin" href="LoginServlet" class="btn btn-login py-2 px-4 d-none d-lg-block">Login</a>
                    <%
                        }
                    %>
                </div>
            </nav>
        </div>
        <!-- Navbar End -->

        <aside class="sidebar" id="sidebar">
            <div class="dashboard-actions">
                <div class="button-group">
                    <button id="viewOwnerTestBtn" class="btn btn-primary">View Owner Test</button>
                    <button id="viewOwnerCourseBtn" class="btn btn-primary">View Owner Course</button>
                </div>
            </div>
            <div class="button-group">
                <button class="btn btn-danger logout" onclick="window.location.href = 'LogoutServlet'">Logout</button>
            </div>
        </aside>

        <main class="main-content" id="mainContent">
            <% if (success != null && !success.isEmpty()) { %>
            <div class="notification success"><%= success %></div>
            <% } %>
            <% if (error != null && !error.isEmpty()) { %>
            <div class="notification error"><%= error %></div>
            <% } %>

            <div id="welcome" class="welcome active">
                <h2>Welcome to Expert Dashboard, <%= fullName != null ? fullName : "Expert" %></h2>
                <img src="https://i.pinimg.com/736x/88/96/07/889607b6dd0ad7b32fa56d3ad75b393a.jpg" 
                     alt="Welcome Image" class="welcome-image">
            </div>

            <div id="courseList" class="course-list" style="display: none;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                    <h2>List of Owner Courses</h2>
                    <button id="createCourseBtn" class="btn btn-success">Create Course</button>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>CourseID</th>
                            <th>Name of Course</th>
                            <th>Description</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (courses != null && !courses.isEmpty()) { %>
                        <% for (CourseEX course : courses) { %>
                        <% if (course.getStatus() != 0) { %>
                        <tr id="courseRow<%= course.getCourseID() %>">
                            <td><%= course.getCourseID() %></td>
                            <td><a href="CourseServlet?courseId=<%= course.getCourseID() %>"><%= course.getName() %></a></td>
                            <td class="description"><%= course.getDescription() %></td>
                            <td class="price"><%= course.getPrice() %></td>
                            <td class="status">
                                <% 
                                    int status = course.getStatus();
                                    String statusText = status == 4 ? "Approved" : status == 3 ? "Rejected" : status == 2 ? "Waiting" : "Draft";
                                    String statusClass = status == 4 ? "status-approved" : status == 3 ? "status-rejected" : status == 2 ? "status-waiting" : "";
                                %>
                                <span class="<%= statusClass %>" id="status<%= course.getCourseID() %>"><%= statusText %></span>
                            </td>
                            <td>
                                <% if (status != 2 && status != 4) { %>
                                <button class="btn btn-danger" 
                                        onclick="deleteCourse(<%= course.getCourseID() %>)" 
                                        style="padding: 8px 16px; font-size: 12px;">Delete</button>
                                <a href="CourseServlet?courseId=<%= course.getCourseID() %>">
                                    <button class="btn btn-primary" 
                                            style="padding: 8px 16px; font-size: 12px;">Update</button>
                                </a>
                                <a href="QuestionController?courseId=<%= course.getCourseID() %>">
                                    <button class="btn btn-success" 
                                            style="padding: 8px 16px; font-size: 12px;">Add Test</button>
                                </a>
                                <button class="btn btn-warning" 
                                        onclick="requestCourse(<%= course.getCourseID() %>)" 
                                        style="padding: 8px 16px; font-size: 12px;">Request</button>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                        <% } %>
                        <% } else { %>
                        <tr><td colspan="6">No courses available</td></tr>
                        <% } %>
                    </tbody>
                </table>
                <button id="returnFromCourses" class="btn btn-primary return">Return to Dashboard</button>
            </div>

            <div id="testList" class="test-list" style="display: none;">
                <h2>List of Owner Tests</h2>
                <table>
                    <thead>
                        <tr>
                            <th>TestID</th>
                            <th>Name of Test</th>
                            <th>Status</th>
                            <th>Course ID</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="testListBody">
                        <% if (tests != null && !tests.isEmpty()) { %>
                        <% for (TestEX testItem : tests) { %>
                        <% 
                            CourseEX course = courseDAO.getCourseByIdEx(testItem.getCourseID());
                            if (course != null && course.getStatus() != 0 && testItem.getStatus() != 0) { 
                                boolean isEditable = (course.getStatus() == 1 || course.getStatus() == 3);
                                boolean isViewOnly = (course.getStatus() == 2 || course.getStatus() == 4);
                        %>
                        <tr id="testRow<%= testItem.getTestID() %>">
                            <td><%= testItem.getTestID() %></td>
                            <td>
                                <a href="<%= isEditable ? "TestServlet?testId=" + testItem.getTestID() : 
                                              (isViewOnly ? "ViewQuestionsServlet?testId=" + testItem.getTestID() + "&mode=view" : 
                                              "#") %>">
                                    <%= testItem.getName() %>
                                </a>
                            </td>
                            <td><%= testItem.getStatus() == 1 ? "Completed" : "Done" %></td>
                            <td><%= testItem.getCourseID() %></td>
                            <td>
                                <% if (isEditable) { %>
                                <a href="TestServlet?testId=<%= testItem.getTestID() %>">
                                    <button class="btn btn-primary" style="padding: 8px 16px; font-size: 12px;">Edit</button>
                                </a>
                                <button class="btn btn-danger" onclick="deleteTest(<%= testItem.getTestID() %>)" style="padding: 8px 16px; font-size: 12px;">Delete</button>
                                <% } else if (isViewOnly) { %>
                                <a href="ViewQuestionsServlet?testId=<%= testItem.getTestID() %>&mode=view">
                                    <button class="btn btn-primary" style="padding: 8px 16px; font-size: 12px;">View</button>
                                </a>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                        <% } %>
                        <% } else { %>
                        <tr><td colspan="5">No tests available</td></tr>
                        <% } %>
                    </tbody>
                </table>
                <button id="returnFromTests" class="btn btn-primary return">Return to Dashboard</button>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('sidebar');
                const mainContent = document.getElementById('mainContent');
                sidebar.classList.toggle('active');
                mainContent.classList.toggle('shifted');
            }

            document.addEventListener('DOMContentLoaded', function () {
                const viewOwnerTestBtn = document.getElementById('viewOwnerTestBtn');
                const viewOwnerCourseBtn = document.getElementById('viewOwnerCourseBtn');
                const createCourseBtn = document.getElementById('createCourseBtn');
                const returnFromCourses = document.getElementById('returnFromCourses');
                const returnFromTests = document.getElementById('returnFromTests');
                const welcome = document.getElementById('welcome');
                const courseList = document.getElementById('courseList');
                const testList = document.getElementById('testList');
                const testListBody = document.getElementById('testListBody');

                function hideAll() {
                    welcome.classList.remove('active');
                    welcome.style.display = 'none';
                    courseList.style.display = 'none';
                    testList.style.display = 'none';
                }

                function showWelcome() {
                    hideAll();
                    welcome.classList.add('active');
                    welcome.style.display = 'block';
                }

                // Kiểm tra nếu cần hiển thị danh sách khóa học ngay khi tải trang
                const showCourseList = <%= showCourseList %>;
                if (showCourseList) {
                    hideAll();
                    courseList.style.display = 'block';
                }

                viewOwnerTestBtn.addEventListener('click', () => {
                    hideAll();
                    testList.style.display = 'block';
                    toggleSidebar();
                });

                viewOwnerCourseBtn.addEventListener('click', () => {
                    hideAll();
                    courseList.style.display = 'block';
                    toggleSidebar();
                });

                createCourseBtn.addEventListener('click', () => {
                    window.location.href = 'createCourse';
                });

                returnFromCourses.addEventListener('click', () => {
                    showWelcome();
                });

                returnFromTests.addEventListener('click', () => {
                    showWelcome();
                });

                // Thêm hiệu ứng click cho dropdown items
                document.querySelectorAll('.dropdown-item').forEach(item => {
                    item.addEventListener('click', function () {
                        document.querySelectorAll('.dropdown-item').forEach(i => i.classList.remove('active'));
                        this.classList.add('active');
                    });
                });

                // Thêm hiệu ứng click cho stat items
                document.querySelectorAll('.stat-item').forEach(item => {
                    item.addEventListener('click', function () {
                        document.querySelectorAll('.stat-item').forEach(i => i.style.background = '#fff');
                        this.style.background = '#e6f0ff';
                    });
                });

                window.deleteCourse = function (courseId) {
                    if (confirm("Are you sure you want to delete this course?")) {
                        fetch('NoticeServlet?action=deleteCourse&courseId=' + courseId, {method: 'POST'})
                            .then(response => response.text())
                            .then(data => {
                                if (data === "success") {
                                    alert("Course deleted successfully!");
                                    document.getElementById('courseRow' + courseId)?.remove();
                                    document.querySelectorAll(`#testListBody tr`).forEach(row => {
                                        const courseIdCell = row.cells[3]; // Cột Course ID
                                        if (courseIdCell && parseInt(courseIdCell.textContent) === courseId) {
                                            row.remove();
                                        }
                                    });

                                    if (testListBody.getElementsByTagName('tr').length === 0) {
                                        testListBody.innerHTML = '<tr><td colspan="5">No tests available</td></tr>';
                                    }
                                } else {
                                    alert("Failed to delete course: " + data);
                                }
                            })
                            .catch(error => alert("An error occurred: " + error.message));
                    }
                };

                window.requestCourse = function (courseId) {
                    if (confirm("Are you sure you want to request approval for this course?")) {
                        fetch('NoticeServlet?action=requestCourse&courseId=' + courseId, {method: 'POST'})
                            .then(response => response.text())
                            .then(data => {
                                if (data === "success") {
                                    alert("Course request submitted successfully!");
                                    const statusSpan = document.getElementById('status' + courseId);
                                    if (statusSpan) {
                                        statusSpan.textContent = "Waiting";
                                        statusSpan.className = "status-waiting";
                                    }
                                    const row = document.getElementById('courseRow' + courseId);
                                    if (row) {
                                        row.querySelector('td:last-child').innerHTML = '';
                                    }
                                } else {
                                    alert("Failed to request course: " + data);
                                }
                            })
                            .catch(error => alert("An error occurred: " + error.message));
                    }
                };

                window.deleteTest = function (testId) {
                    if (confirm("Are you sure you want to delete this test?")) {
                        fetch('NoticeServlet?action=deleteTest&testId=' + testId, {method: 'POST'})
                            .then(response => response.text())
                            .then(data => {
                                if (data === "success") {
                                    alert("Test marked as deleted successfully!");
                                    const testRow = document.getElementById('testRow' + testId);
                                    if (testRow) {
                                        testRow.remove();
                                        if (testListBody.getElementsByTagName('tr').length === 0) {
                                            testListBody.innerHTML = '<tr><td colspan="5">No tests available</td></tr>';
                                        }
                                    }
                                } else {
                                    alert("Failed to mark test as deleted: " + data);
                                }
                            })
                            .catch(error => alert("An error occurred: " + error.message));
                    }
                };
            });
        </script>
    </body>
</html>