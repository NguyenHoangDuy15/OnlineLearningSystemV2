<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.QuestionEX" %>
<%@ page import="Model.TestEX" %>
<%@ page import="dal.TestEXDAO" %>
<%@ page import="Model.User" %>
<%@ page import="Model.Usernew" %>
<%@page import="Model.Usernew, Model.User" %>

<%
    List<QuestionEX> questions = (List<QuestionEX>) request.getAttribute("questions");
    TestEX test = (TestEX) request.getAttribute("test");
    TestEXDAO testDAO = new TestEXDAO();
    String error = (String) request.getAttribute("error");

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
            min-height: calc(100vh - 72px);
            transition: margin-left 0.3s ease;
        }

        .main-content.shifted {
            margin-left: 250px;
        }

        .question-list {
            background-color: var(--background);
            padding: 24px;
            border-radius: 8px;
            box-shadow: 0 2px 8px var(--shadow);
            max-width: 80%;
            margin: 0 auto;
        }

        .question-item {
            margin-bottom: 16px;
            padding: 16px;
            border: 1px solid var(--border);
            border-radius: 8px;
        }

        .question-item h4 {
            margin: 0 0 8px 0;
            color: var(--text-dark);
        }

        .question-item p {
            margin: 4px 0;
            color: var(--text-light);
        }

        .question-item .correct {
            color: var(--accent-green);
            font-weight: 500;
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

        .btn-danger {
            background: var(--gradient-danger);
            color: #FFFFFF;
        }

        .btn-danger:hover {
            background: linear-gradient(90deg, #C0392B, #E74C3C);
            transform: translateY(-2px);
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
                                <i class="fas fa-sign-out-alt mr-2"></i>Logout
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
        <% if (error != null && !error.isEmpty()) { %>
        <div class="notification error"><%= error %></div>
        <% } %>

        <div class="question-list">
            <h2>Questions for Test <%= test != null ? test.getName() : "" %></h2>
            <div id="questionsContainer">
                <% if (questions != null && !questions.isEmpty()) { %>
                <% int index = 1; %>
                <% for (QuestionEX question : questions) { %>
                <div class="question-item">
                    <h4>Question <%= index %>: <%= question.getQuestionContent() %></h4>
                    <p <%= testDAO.isCorrectAnswer(question.getQuestionID(), "A") ? "class=\"correct\"" : "" %>>A. <%= question.getOptionA() %> <%= testDAO.isCorrectAnswer(question.getQuestionID(), "A") ? "(Correct)" : "" %></p>
                    <p <%= testDAO.isCorrectAnswer(question.getQuestionID(), "B") ? "class=\"correct\"" : "" %>>B. <%= question.getOptionB() %> <%= testDAO.isCorrectAnswer(question.getQuestionID(), "B") ? "(Correct)" : "" %></p>
                    <p <%= testDAO.isCorrectAnswer(question.getQuestionID(), "C") ? "class=\"correct\"" : "" %>>C. <%= question.getOptionC() %> <%= testDAO.isCorrectAnswer(question.getQuestionID(), "C") ? "(Correct)" : "" %></p>
                    <p <%= testDAO.isCorrectAnswer(question.getQuestionID(), "D") ? "class=\"correct\"" : "" %>>D. <%= question.getOptionD() %> <%= testDAO.isCorrectAnswer(question.getQuestionID(), "D") ? "(Correct)" : "" %></p>
                </div>
                <% index++; %>
                <% } %>
                <% } else { %>
                <p>No questions available for this test.</p>
                <% } %>
            </div>
            <button class="btn btn-primary" onclick="history.back()">Cancel</button>
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
    </script>
</body>
</html>