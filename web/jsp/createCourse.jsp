<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.TestEX" %>
<%@ page import="Model.CourseEX" %>
<%@ page import="dal.TestEXDAO" %>
<%@ page import="dal.CourseEXDAO" %>
<%@ page import="Model.User" %>
<%@ page import="Model.Usernew" %>
<%@ page import="dal.UserDAO" %>
<%@ page import="Model.LessonEX" %>

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

        .navbar {
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px 0;
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

        .container {
            max-width: 1000px; /* Tăng chiều rộng container */
            margin: 32px auto;
            padding: 24px;
            background-color: var(--background);
            border-radius: 8px;
            box-shadow: 0 2px 8px var(--shadow);
        }

        h2, h3 {
            color: var(--text-dark);
            font-size: 24px;
            margin-bottom: 24px;
            text-align: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--text-dark);
            font-size: 16px;
        }

        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 16px;
            box-sizing: border-box;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus, .form-group textarea:focus, .form-group select:focus {
            border-color: var(--primary);
            outline: none;
        }

        .form-group textarea {
            min-height: 120px; /* Tăng chiều cao textarea mặc định */
            resize: vertical;
        }

        .lesson-block {
            position: relative;
            border: 1px solid Ver(--border);
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            background-color: var(--secondary);
            box-shadow: 0 2px 4px var(--shadow);
        }

        .lesson-block label {
            font-weight: 500;
            color: var(--text-dark);
            font-size: 16px;
            margin-bottom: 8px;
        }

        .lesson-block input[type="text"] {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            border-radius: 6px;
            border: 1px solid var(--border);
        }

        .lesson-block textarea {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            min-height: 150px; /* Tăng chiều cao textarea trong lesson block */
            border-radius: 6px;
            border: 1px solid var(--border);
        }

        .remove-lesson-btn {
            position: absolute;
            top: 15px;
            right: 15px;
            background: none;
            border: none;
            color: var(--accent-red);
            font-size: 20px;
            cursor: pointer;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        .remove-lesson-btn:hover {
            color: darkred;
        }

        .btn {
            padding: 12px 28px;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px var(--shadow);
            text-transform: uppercase;
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: #FFFFFF;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary:hover {
            background: linear-gradient(90deg, #357ABD, #4A90E2);
            transform: translateY(-2px);
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

        .form-actions {
            display: flex;
            gap: 16px;
            justify-content: flex-end;
            margin-top: 28px;
        }

        .notification {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }

        .notification.success {
            color: var(--accent-green);
            background-color: #e6ffe6;
            border: 1px solid var(--accent-green);
        }

        .notification.error {
            color: var(--accent-red);
            background-color: #ffe6e6;
            border: 1px solid var(--accent-red);
        }

        ul {
            list-style-type: none;
            padding: 0;
        }

        ul li {
            padding: 12px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 16px;
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
                        <li><a name="btncp" class="dropdown-item" href="ChangePasswordServlet"><i class="fas fa-lock mr-2"></i> Change Password</a></li>
                        <li><a class="dropdown-item" href="Historytransaction"><i class="fas fa-history mr-2"></i> History of Transaction</a></li>
                        <li><a class="dropdown-item" href="Role"><i class="fas fa-user-tie mr-2"></i> Become Expert or Sale</a></li>
                        <li><a class="dropdown-item" href="Request"><i class="fas fa-hourglass-half mr-2"></i> Wait for Approval</a></li>
                        <li><a name="btnlg" class="dropdown-item" href="LogoutServlet"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a></li>
                    </ul>
                </div>
                <% } else { %>
                <a name="btnlogin" href="LoginServlet" class="btn btn-login py-2 px-4 d-none d-lg-block">Login</a>
                <% } %>
            </div>
        </nav>
    </div>
    <!-- Navbar End -->

    <div class="container">
        <h2>Create a New Course</h2>
        <% 
           String successMessage = (String) request.getAttribute("success");
           String errorMessage = (String) request.getAttribute("errorMessage");
           if (successMessage != null && !successMessage.isEmpty()) { %>
            <div class="notification success">
                <%= successMessage %>
                <br>
                <button type="button" class="btn btn-primary" onclick="window.location.href = 'ShowexpertServlet?action=viewCourses'" style="margin-top: 10px;">Return to Course List</button>
            </div>
            <script>
                setTimeout(() => {
                    window.location.href = 'ShowexpertServlet?action=viewCourses';
                }, 5000);
            </script>
        <% } else if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="notification error">
                <%= errorMessage %>
                <br>
                <button type="button" class="btn btn-primary" onclick="window.location.href = 'createCourse'" style="margin-top: 10px;">Try Again</button>
            </div>
        <% } %>
        <form id="createCourseForm" action="createCourse" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="createCourse">
            <div class="form-group">
                <label for="courseName">Course Name:</label>
                <input type="text" id="courseName" name="courseName" placeholder="Enter course name" required>
            </div>
            <div class="form-group">
                <label for="description">Description:</label>
                <textarea id="description" name="description" placeholder="Enter course description" required></textarea>
            </div>
            <div class="form-group">
                <label for="price">Price:</label>
                <input type="number" id="price" name="price" placeholder="Enter price" min="1" required>
            </div>
            <div class="form-group">
                <label for="imageFile">Upload Image:</label>
                <input type="file" id="imageFile" name="imageFile" accept="image/*">
            </div>
            <div class="form-group">
                <label for="categoryId">Category:</label>
                <select id="categoryId" name="categoryId" required>
                    <option value="" disabled selected>Select a category</option>
                    <option value="1">Java Programming</option>
                    <option value="2">Python Programming</option>
                    <option value="3">JavaScript Programming</option>
                </select>
            </div>

            <div id="lessonsContainer">
                <div class="lesson-block" id="lesson1">
                    <label for="lessonName1">Lesson Title:</label>
                    <input type="text" id="lessonName1" name="lessonName[]" placeholder="Enter lesson title" required>
                    <label for="lessonContent1">Lesson Content (URL):</label>
                    <textarea id="lessonContent1" name="lessonContent[]" placeholder="Enter YouTube URL (e.g., https://www.youtube.com/watch?v=...)" required></textarea>
                    <button type="button" class="remove-lesson-btn" onclick="removeLesson(this)">X</button>
                </div>
            </div>

            <div class="form-actions">
                <button type="button" class="btn btn-primary" onclick="addLesson()">
                    <span>+</span> More Lesson
                </button>
                <button type="submit" id="submitBtn" class="btn btn-success">Create Course</button>
                <button type="button" class="btn btn-danger" onclick="window.location.href = 'ShowexpertServlet?action=viewCourses'">Cancel</button>
            </div>
        </form>

        <% List<LessonEX> lessons = (List<LessonEX>) request.getAttribute("lessons");
           if (lessons != null && !lessons.isEmpty()) { %>
            <h3>Existing Lessons</h3>
            <ul>
                <% for (LessonEX lesson : lessons) { %>
                <li>
                    <%= lesson.getTitle() %> - <%= lesson.getContent() %>
                    <button type="button" class="btn btn-danger" onclick="deleteLessonFromDB(<%= lesson.getLessonID() %>)">Delete</button>
                </li>
                <% } %>
            </ul>
        <% } %>
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let lessonCount = 1;
    let isSubmitting = false;

    function addLesson() {
        lessonCount++;
        const lessonsContainer = document.getElementById('lessonsContainer');
        const newLessonBlock = document.createElement('div');
        newLessonBlock.classList.add('lesson-block');
        newLessonBlock.id = `lesson${lessonCount}`;
        newLessonBlock.innerHTML = `
            <label for="lessonName${lessonCount}">Lesson Title:</label>
            <input type="text" id="lessonName${lessonCount}" name="lessonName[]" placeholder="Enter lesson title" required>
            <label for="lessonContent${lessonCount}">Lesson Content (URL):</label>
            <textarea id="lessonContent${lessonCount}" name="lessonContent[]" placeholder="Enter YouTube URL (e.g., https://www.youtube.com/watch?v=...)" required></textarea>
            <button type="button" class="remove-lesson-btn" onclick="removeLesson(this)">X</button>
        `;
        lessonsContainer.appendChild(newLessonBlock);
    }

    function removeLesson(button) {
        const lessonBlock = button.parentElement;
        const lessonTitle = lessonBlock.querySelector('input[name="lessonName[]"]').value || "this lesson";
        const confirmRemove = confirm(`Are you sure you want to remove "${lessonTitle}"?`);
        if (confirmRemove) {
            lessonBlock.remove();
        }
    }

    document.getElementById('createCourseForm').addEventListener('submit', function (event) {
        if (isSubmitting) {
            event.preventDefault();
            return;
        }

        // Kiểm tra toàn dấu cách cho courseName
        const courseName = document.getElementById('courseName').value;
        if (!courseName || courseName.trim() === '') {
            alert('Course name cannot be empty or contain only whitespace.');
            event.preventDefault();
            return;
        }

        // Kiểm tra toàn dấu cách cho description
        const description = document.getElementById('description').value;
        if (!description || description.trim() === '') {
            alert('Description cannot be empty or contain only whitespace.');
            event.preventDefault();
            return;
        }

        // Kiểm tra trường Category
        const categorySelect = document.getElementById('categoryId');
        if (!categorySelect.value || categorySelect.value === "") {
            alert('Please select a category before submitting.');
            event.preventDefault();
            return;
        }

        // Kiểm tra toàn dấu cách cho lessonName và lessonContent
        const lessonNames = document.getElementsByName('lessonName[]');
        const lessonContents = document.getElementsByName('lessonContent[]');
        for (let i = 0; i < lessonNames.length; i++) {
            const lessonName = lessonNames[i].value;
            if (!lessonName || lessonName.trim() === '') {
                alert('Lesson Title ' + (i + 1) + ' cannot be empty or contain only whitespace.');
                event.preventDefault();
                return;
            }

            const lessonContent = lessonContents[i].value;
            if (!lessonContent || lessonContent.trim() === '') {
                alert('Lesson Content ' + (i + 1) + ' cannot be empty or contain only whitespace.');
                event.preventDefault();
                return;
            }
        }

        // Kiểm tra các link YouTube
        const youtubeRegex = /^https:\/\/www\.youtube\.com\/watch\?v=[\w-]{11}/;
        const contentValues = []; // Mảng lưu trữ các URL để kiểm tra trùng

        for (let i = 0; i < lessonContents.length; i++) {
            let content = lessonContents[i].value.trim();

            // Kiểm tra định dạng YouTube URL
            if (!youtubeRegex.test(content)) {
                alert('Lesson Content ' + (i + 1) + ' must be a valid YouTube link (e.g., https://www.youtube.com/watch?v=abc123).');
                event.preventDefault();
                return;
            }

            // Kiểm tra trùng lặp
            if (contentValues.includes(content)) {
                alert('Lesson Content ' + (i + 1) + ' is a duplicate. Please use a different YouTube link.');
                event.preventDefault();
                return;
            }
            contentValues.push(content); // Thêm URL vào mảng nếu không trùng
        }

        // Kiểm tra giá
        const priceInput = document.getElementById('price');
        const priceValue = parseFloat(priceInput.value);
        if (isNaN(priceValue) || priceValue <= 0) {
            alert('Price must be a number greater than 0.');
            event.preventDefault();
            return;
        }

        isSubmitting = true;
        document.getElementById('submitBtn').disabled = true;
    });

    function deleteLessonFromDB(lessonId) {
        if (confirm("Do you want to delete this lesson?")) {
            window.location.href = "NoticeServlet?deleteLesson=" + lessonId;
        }
    }

    function toggleSidebar() {
        // Nếu cần thêm logic cho sidebar, bạn có thể thêm vào đây
    }

    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.dropdown-item').forEach(item => {
            item.addEventListener('click', function() {
                document.querySelectorAll('.dropdown-item').forEach(i => i.classList.remove('active'));
                this.classList.add('active');
            });
        });

        document.querySelectorAll('.stat-item').forEach(item => {
            item.addEventListener('click', function() {
                document.querySelectorAll('.stat-item').forEach(i => i.style.background = '#fff');
                this.style.background = '#e6f0ff';
            });
        });
    });
</script>
</body>
</html>