<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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
    Boolean isSale = (Boolean) session.getAttribute("isSale");
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");

    int enrollmentCount = (registeredCourses != null) ? registeredCourses : 0;
    int completedCoursesCount = (completedCourses != null) ? completedCourses : 0;

    if (user != null) {
        userNew = new Usernew(user);
    }

    Integer courseId = (Integer) request.getAttribute("courseId");
    Integer questionCount = (Integer) request.getAttribute("questionCount");
    if (questionCount == null) {
        questionCount = 1;
    }

    // Lấy dữ liệu từ session nếu có
    String testName = (String) session.getAttribute("tempTestName_" + courseId);
    List<String> tempQuestions = (List<String>) session.getAttribute("tempQuestions_" + courseId);
    List<String> tempOptionsA = (List<String>) session.getAttribute("tempOptionsA_" + courseId);
    List<String> tempOptionsB = (List<String>) session.getAttribute("tempOptionsB_" + courseId);
    List<String> tempOptionsC = (List<String>) session.getAttribute("tempOptionsC_" + courseId);
    List<String> tempOptionsD = (List<String>) session.getAttribute("tempOptionsD_" + courseId);
    List<String> tempCorrectAnswers = (List<String>) session.getAttribute("tempCorrectAnswers_" + courseId);

    // Nếu không có dữ liệu trong session, sử dụng dữ liệu từ request
    if (testName == null) {
        testName = (String) request.getAttribute("testName");
    }
    if (tempQuestions == null) {
        String[] questions = (String[]) request.getAttribute("questions");
        tempQuestions = new ArrayList<>();
        if (questions != null) {
            for (String q : questions) {
                tempQuestions.add(q != null ? q : "");
            }
        }
    }
    if (tempOptionsA == null) {
        String[] optionsA = (String[]) request.getAttribute("optionsA");
        tempOptionsA = new ArrayList<>();
        if (optionsA != null) {
            for (String a : optionsA) {
                tempOptionsA.add(a != null ? a : "");
            }
        }
    }
    if (tempOptionsB == null) {
        String[] optionsB = (String[]) request.getAttribute("optionsB");
        tempOptionsB = new ArrayList<>();
        if (optionsB != null) {
            for (String b : optionsB) {
                tempOptionsB.add(b != null ? b : "");
            }
        }
    }
    if (tempOptionsC == null) {
        String[] optionsC = (String[]) request.getAttribute("optionsC");
        tempOptionsC = new ArrayList<>();
        if (optionsC != null) {
            for (String c : optionsC) {
                tempOptionsC.add(c != null ? c : "");
            }
        }
    }
    if (tempOptionsD == null) {
        String[] optionsD = (String[]) request.getAttribute("optionsD");
        tempOptionsD = new ArrayList<>();
        if (optionsD != null) {
            for (String d : optionsD) {
                tempOptionsD.add(d != null ? d : "");
            }
        }
    }
    if (tempCorrectAnswers == null) {
        String[] correctAnswers = (String[]) request.getAttribute("correctAnswers");
        tempCorrectAnswers = new ArrayList<>();
        if (correctAnswers != null) {
            for (String ca : correctAnswers) {
                tempCorrectAnswers.add(ca != null ? ca : "");
            }
        }
    }

    // Đảm bảo số lượng câu hỏi trong session khớp với questionCount
    while (tempQuestions.size() < questionCount) {
        tempQuestions.add("");
        tempOptionsA.add("");
        tempOptionsB.add("");
        tempOptionsC.add("");
        tempOptionsD.add("");
        tempCorrectAnswers.add("");
    }

    // Cập nhật lại request attributes để JSTL sử dụng
    request.setAttribute("testName", testName);
    request.setAttribute("questions", tempQuestions.toArray(new String[0]));
    request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
    request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
    request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
    request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
    request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
%>

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
                --text-light: #777777;
                --background: #FFFFFF;
                --border: #E0E0E0;
                --shadow: rgba(0, 0, 0, 0.1);
                --gradient-primary: linear-gradient(90deg, #4A90E2, #357ABD);
                --gradient-success: linear-gradient(90deg, #2ECC71, #27AE60);
                --gradient-danger: linear-gradient(90deg, #E74C3C, #C0392B);
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

            .navbar {
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                padding: 20px 0; /* Tăng padding để header rộng hơn */
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
                color: #007bff;
            }

            .stat-item.completed i {
                color: #28a745;
            }

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

            .sidebar {
                position: fixed;
                top: 0;
                left: -400px;
                width: 400px;
                height: 100%;
                background-color: var(--secondary);
                padding: 24px;
                display: flex;
                flex-direction: column;
                gap: 32px;
                border-right: 1px solid var(--border);
                transition: left 0.3s ease;
                z-index: 1000;
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
                gap: 16px;
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

            .main-content {
                width: 100%;
                background-color: var(--background);
                padding: 32px;
                min-height: calc(100vh - 82px); /* Điều chỉnh chiều cao dựa trên navbar rộng hơn */
                transition: margin-left 0.3s ease;
            }

            .main-content.shifted {
                margin-left: 400px;
            }

            .create-test {
                background-color: var(--background);
                padding: 24px;
                border-radius: 8px;
                box-shadow: 0 2px 8px var(--shadow);
                max-width: 80%;
                margin: 0 auto;
            }

            .form-group {
                margin-bottom: 16px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: var(--text-dark);
            }

            .form-group input, .form-group textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid var(--border);
                border-radius: 4px;
                font-size: 14px;
            }

            .question-block {
                margin-bottom: 24px;
                border: 1px solid var(--border);
                border-radius: 12px;
                padding: 16px;
                background-color: var(--background);
                transition: box-shadow 0.3s ease;
            }

            .question-block:hover {
                box-shadow: 0 4px 12px var(--shadow);
            }

            .options {
                margin-top: 16px;
            }

            .option {
                display: flex;
                align-items: center;
                margin-bottom: 8px;
                gap: 12px;
            }

            .option input[type="radio"] {
                margin-right: 8px;
            }

            .option input[type="text"] {
                flex: 1;
                padding: 8px;
                border: 1px solid var(--border);
                border-radius: 4px;
            }

            .form-actions {
                display: flex;
                gap: 12px;
                margin-top: 16px;
                justify-content: flex-end;
            }

            .form-buttons {
                display: flex;
                gap: 12px;
                justify-content: flex-start;
                margin-top: 24px;
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
                box-shadow: 0 6px 12px rgba(46, 204, 113, 0.3);
            }

            .btn-danger {
                background: var(--gradient-danger);
                color: #FFFFFF;
            }

            .btn-danger:hover {
                background: linear-gradient(90deg, #C0392B, #E74C3C);
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(231, 76, 60, 0.3);
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
                <a href="index" class="navbar-brand ml-lg-3">
                    <h3 name="logopage" class="m-0 text-uppercase text-primary"><i class="fa fa-book-reader mr-3"></i>Online Learning</h3>
                </a>
                <button type="button" class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse justify-content-between px-lg-3" id="navbarCollapse">
                    <div class="navbar-nav mx-auto py-0">
                        <% if (userId != null) { %>
                        <a href="index" class="nav-item nav-link active">Home</a>
                        <% } else { %>
                        <a href="Landingpage" class="nav-item nav-link active">Home</a>
                        <% } %>
                        <a href="course" class="nav-item nav-link">Courses</a>
                        <div class="nav-item dropdown">
                            <a href="Expert" class="nav-item nav-link">Experts</a>
                        </div>
                        <a href="ViewBlog" class="nav-item nav-link">Blog</a>
                        <% if (roleId != null && roleId == 2) { %>
                        <a href="ShowexpertServlet" class="nav-item nav-link">ExpertPage</a>
                        <% } %>
                        <% if (isSale != null && isSale) { %>
                        <a href="viewownerbloglist" class="nav-item nav-link">Manage Blogs</a>
                        <% } %>
                    </div>

                    <% if (isLoggedIn != null && isLoggedIn) { %>
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
                    <% } else { %>
                    <a name="btnlogin" href="LoginServlet" class="btn btn-login py-2 px-4 d-none d-lg-block">Login</a>
                    <% } %>
                </div>
            </nav>
        </div>
        <!-- Navbar End -->

        <aside class="sidebar" id="sidebar">
            <div class="dashboard-actions">
                <div class="button-group">
                    <button id="viewOwnerTestBtn" class="btn btn-primary" onclick="window.location.href = 'ShowexpertServlet'">View Owner Test</button>
                    <button id="viewOwnerCourseBtn" class="btn btn-primary" onclick="window.location.href = 'ShowexpertServlet'">View Owner Course</button>
                </div>
            </div>
            <div class="button-group">
                <button class="btn btn-danger logout" onclick="window.location.href = 'LogoutServlet'">Logout</button>
            </div>
        </aside>

        <main class="main-content" id="mainContent">
            <div class="create-test">
                <h2>Create a New Test</h2>
                <c:if test="${not empty success}">
                    <div class="notification success">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="notification error">${error}</div>
                </c:if>

                <form id="testForm" action="QuestionController" method="post">
                    <input type="hidden" name="courseId" value="${courseId}">
                    <input type="hidden" name="testId" value="-1">
                    <input type="hidden" name="questionCount" value="${questionCount}">
                    <input type="hidden" name="deleteIndex" value="-1">
                    <div class="form-group">
                        <label for="testName">Test Name:</label>
                        <input type="text" id="testName" name="testName" placeholder="Enter test name" 
                               value="${testName != null ? testName : ''}" required>
                    </div>
                    <p>Fill in the questions and options below (at least one question is required):</p>
                    <div id="questionsContainer">
                        <c:forEach var="i" begin="0" end="${questionCount - 1}" varStatus="loop">
                            <div class="question-block">
                                <div class="form-group">
                                    <label>Question ${loop.count}:</label>
                                    <textarea name="questions[]" rows="3" placeholder="Enter your question">${questions[i] != null ? questions[i] : ''}</textarea>
                                </div>
                                <div class="options">
                                    <div class="option">
                                        <input type="radio" name="correctAnswers_${loop.index}" value="A" ${correctAnswers[i] == 'A' ? 'checked' : ''}>
                                        <label>Option A:</label>
                                        <input type="text" name="optionsA[]" placeholder="Option A" value="${optionsA[i] != null ? optionsA[i] : ''}">
                                    </div>
                                    <div class="option">
                                        <input type="radio" name="correctAnswers_${loop.index}" value="B" ${correctAnswers[i] == 'B' ? 'checked' : ''}>
                                        <label>Option B:</label>
                                        <input type="text" name="optionsB[]" placeholder="Option B" value="${optionsB[i] != null ? optionsB[i] : ''}">
                                    </div>
                                    <div class="option">
                                        <input type="radio" name="correctAnswers_${loop.index}" value="C" ${correctAnswers[i] == 'C' ? 'checked' : ''}>
                                        <label>Option C:</label>
                                        <input type="text" name="optionsC[]" placeholder="Option C" value="${optionsC[i] != null ? optionsC[i] : ''}">
                                    </div>
                                    <div class="option">
                                        <input type="radio" name="correctAnswers_${loop.index}" value="D" ${correctAnswers[i] == 'D' ? 'checked' : ''}>
                                        <label>Option D:</label>
                                        <input type="text" name="optionsD[]" placeholder="Option D" value="${optionsD[i] != null ? optionsD[i] : ''}">
                                    </div>
                                </div>
                                <c:if test="${questionCount > 1}">
                                    <div class="form-actions">
                                        <button type="submit" name="action" value="deleteQuestion" class="btn btn-danger" 
                                                onclick="this.form.elements['deleteIndex'].value = ${loop.index}">Delete Question</button>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="form-buttons">
                        <button type="submit" name="action" value="addQuestion" class="btn btn-primary">Add Question</button>
                        <button type="submit" name="action" value="submit" class="btn btn-success">Submit Test</button>
                        <a href="ShowexpertServlet"><button type="button" class="btn btn-primary">Return to Dashboard</button></a>
                    </div>
                </form>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                    // Toggle sidebar
                                                    function toggleSidebar() {
                                                        const sidebar = document.getElementById('sidebar');
                                                        const mainContent = document.getElementById('mainContent');
                                                        sidebar.classList.toggle('active');
                                                        mainContent.classList.toggle('shifted');
                                                    }

                                                    // Save scroll position before form submission
                                                    document.getElementById('testForm').addEventListener('submit', function (event) {
                                                        sessionStorage.setItem('scrollPosition', window.scrollY);
                                                    });

                                                    // Restore scroll position after page load
                                                    window.addEventListener('load', function () {
                                                        const scrollPosition = sessionStorage.getItem('scrollPosition');
                                                        if (scrollPosition) {
                                                            window.scrollTo(0, parseInt(scrollPosition));
                                                            sessionStorage.removeItem('scrollPosition');
                                                        }
                                                    });

                                                    // Dropdown and stat item interactions
                                                    document.addEventListener('DOMContentLoaded', function () {
                                                        document.querySelectorAll('.dropdown-item').forEach(item => {
                                                            item.addEventListener('click', function () {
                                                                document.querySelectorAll('.dropdown-item').forEach(i => i.classList.remove('active'));
                                                                this.classList.add('active');
                                                            });
                                                        });

                                                        document.querySelectorAll('.stat-item').forEach(item => {
                                                            item.addEventListener('click', function () {
                                                                document.querySelectorAll('.stat-item').forEach(i => i.style.background = '#fff');
                                                                this.style.background = '#e6f0ff';
                                                            });
                                                        });
                                                    });
        </script>
    </body>
</html>