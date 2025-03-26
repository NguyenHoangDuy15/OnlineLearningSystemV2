<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.LessonEX" %>
<%@ page import="Model.User" %>
<%@ page import="Model.Usernew" %>

<%
    LessonEX lesson = (LessonEX) request.getAttribute("lesson");
    Integer courseId = (Integer) request.getAttribute("courseId");
    boolean isEdit = lesson != null;

    User user = (User) session.getAttribute("account");
    Usernew userNew = null;
    Integer userId = (Integer) session.getAttribute("userid");
    Boolean isSale = (Boolean) session.getAttribute("isSale");
    Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");

    if (user != null) {
        userNew = new Usernew(user);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Lessons" : "Add Lessons" %> - Online Learning</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
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

        .navbar {
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px 0;
        }

        .navbar-brand h3 {
            font-weight: 700;
            color: #007bff;
            transition: color 0.3s ease;
        }

        .navbar-brand h3:hover {
            color: #0056b3;
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

        .sidebar {
            position: fixed;
            top: 0;
            left: -250px;
            width: 250px;
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

        .main-content {
            width: 100%;
            background-color: var(--background);
            padding: 32px;
            min-height: calc(100vh - 82px);
            transition: margin-left 0.3s ease;
        }

        .main-content.shifted {
            margin-left: 250px;
        }

        .form-container {
            max-width: 80%;
            margin: 0 auto;
            background-color: var(--background);
            padding: 24px;
            border-radius: 8px;
            box-shadow: 0 2px 8px var(--shadow);
            margin-top: 24px;
        }

        .lesson-item {
            border: 1px solid var(--border);
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 4px;
            position: relative;
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
        }

        .btn-primary {
            background: var(--gradient-primary);
            color: #FFFFFF;
        }

        .btn-primary:hover {
            background: linear-gradient(90deg, #357ABD, #4A90E2);
            transform: translateY(-2px);
        }

        .btn-success {
            background: var(--gradient-success);
            color: #FFFFFF;
            margin-bottom: 15px;
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

        .button-group {
            display: flex;
            gap: 16px;
            margin-top: 24px;
        }

        .error-message {
            color: var(--accent-red);
            font-size: 12px;
            margin-top: 4px;
            display: none;
        }

        .form-group {
            margin-bottom: 16px;
        }

        label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 14px;
            color: var(--text-dark);
            box-sizing: border-box;
        }

        textarea {
            height: 150px;
            resize: vertical;
        }
    </style>
</head>
<body>
    <div class="container-fluid p-0">
        <nav class="navbar navbar-expand-lg bg-white navbar-light py-3 py-lg-0 px-lg-5">
            <div class="hamburger" onclick="toggleSidebar()">
                <i class="fas fa-bars"></i>
            </div>
            <a href="index" class="navbar-brand ml-lg-3">
                <h3 class="m-0 text-uppercase text-primary"><i class="fa fa-book-reader mr-3"></i>Online Learning</h3>
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
                    <a href="Instructor" class="nav-item nav-link">Experts</a>
                    <a href="ViewBlog" class="nav-item nav-link">Blog</a>
                    <a href="ShowexpertServlet" class="nav-item nav-link">ExpertPage</a>
                    <% if (isSale != null && isSale) { %>
                    <a href="viewownerbloglist" class="nav-item nav-link">Manage Blogs</a>
                    <% } %>
                </div>
                <% if (isLoggedIn != null && isLoggedIn) { %>
                <div class="dropdown">
                    <img src="<%= userNew.getAvatar() %>" alt="Avatar" class="avatar" id="avatarDropdown" data-bs-toggle="dropdown">
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="myenrollment"><i class="fas fa-book mr-2"></i> My Enrollments</a></li>
                        <li><a class="dropdown-item" href="Mycourses"><i class="fas fa-check-circle mr-2"></i> My Courses</a></li>
                        <li><a class="dropdown-item" href="ChangePasswordServlet"><i class="fas fa-lock mr-2"></i> Change Password</a></li>
                        <li><a class="dropdown-item" href="Historytransaction"><i class="fas fa-history mr-2"></i> History of Transaction</a></li>
                        <li><a class="dropdown-item" href="Role"><i class="fas fa-user-tie mr-2"></i> Become Expert or Sale</a></li>
                        <li><a class="dropdown-item" href="Request"><i class="fas fa-hourglass-half mr-2"></i> Wait for Approval</a></li>
                        <li><a class="dropdown-item" href="LogoutServlet"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a></li>
                    </ul>
                </div>
                <% } else { %>
                <a href="LoginServlet" class="btn btn-login py-2 px-4 d-none d-lg-block">Login</a>
                <% } %>
            </div>
        </nav>
    </div>

    <aside class="sidebar" id="sidebar">
        <div class="dashboard-actions">
            <div class="button-group">
                <button class="btn btn-primary" onclick="window.location.href = 'ShowexpertServlet'">View Owner Test</button>
                <button class="btn btn-primary" onclick="window.location.href = 'ShowexpertServlet'">View Owner Course</button>
            </div>
        </div>
        <div class="button-group">
            <button class="btn btn-danger" onclick="window.location.href = 'LogoutServlet'">Logout</button>
        </div>
    </aside>

    <main class="main-content" id="mainContent">
        <div class="form-container">
            <h2><%= isEdit ? "Edit Lessons" : "Add Lessons" %></h2>
            <form action="LessonServlet" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="<%= isEdit ? "updateLesson" : "addLesson" %>">
                <input type="hidden" name="courseId" value="<%= courseId %>">
                
                <div id="lessons-container">
                    <% if (isEdit && lesson != null) { %>
                    <div class="lesson-item" data-lesson-id="<%= lesson.getLessonID() %>">
                        <input type="hidden" name="lessonId[]" value="<%= lesson.getLessonID() %>">
                        <div class="form-group">
                            <label for="title_0">Title</label>
                            <input type="text" id="title_0" name="title[]" value="<%= lesson.getTitle() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="content_0">Content (YouTube URL)</label>
                            <textarea id="content_0" name="content[]" required oninput="validateYouTubeUrl(this)"><%= lesson.getContent() %></textarea>
                            <div class="error-message" id="content-error_0">Content must be a valid YouTube URL</div>
                        </div>
                        <button type="button" class="btn btn-danger delete-lesson" style="display: none;" onclick="deleteLesson(this)">Delete</button>
                    </div>
                    <% } else { %>
                    <div class="lesson-item">
                        <div class="form-group">
                            <label for="title_0">Title</label>
                            <input type="text" id="title_0" name="title[]" required>
                        </div>
                        <div class="form-group">
                            <label for="content_0">Content (YouTube URL)</label>
                            <textarea id="content_0" name="content[]" required oninput="validateYouTubeUrl(this)"></textarea>
                            <div class="error-message" id="content-error_0">Content must be a valid YouTube URL</div>
                        </div>
                        <button type="button" class="btn btn-danger delete-lesson" style="display: none;" onclick="deleteLesson(this)">Delete</button>
                    </div>
                    <% } %>
                </div>

                <button type="button" class="btn btn-success" onclick="addLesson()">+ Add More Lesson</button>

                <div class="button-group">
                    <button type="submit" class="btn btn-primary">Save</button>
                    <button type="button" class="btn btn-danger" onclick="window.location.href = 'CourseServlet?courseId=<%= courseId %>'">Cancel</button>
                </div>
            </form>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let lessonCount = <%= isEdit && lesson != null ? 1 : 1 %>;

        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('mainContent');
            sidebar.classList.toggle('active');
            mainContent.classList.toggle('shifted');
        }

        function addLesson() {
            const container = document.getElementById('lessons-container');
            const newLesson = document.createElement('div');
            newLesson.className = 'lesson-item';
            newLesson.innerHTML = `
                <div class="form-group">
                    <label for="title_${lessonCount}">Title</label>
                    <input type="text" id="title_${lessonCount}" name="title[]" required>
                </div>
                <div class="form-group">
                    <label for="content_${lessonCount}">Content (YouTube URL)</label>
                    <textarea id="content_${lessonCount}" name="content[]" required oninput="validateYouTubeUrl(this)"></textarea>
                    <div class="error-message" id="content-error_${lessonCount}">Content must be a valid YouTube URL</div>
                </div>
                <button type="button" class="btn btn-danger delete-lesson" onclick="deleteLesson(this)">Delete</button>
            `;
            container.appendChild(newLesson);
            lessonCount++;
            updateDeleteButtons();
        }

        function deleteLesson(button) {
            button.parentElement.remove();
            lessonCount--;
            updateDeleteButtons();
        }

        function updateDeleteButtons() {
            const lessons = document.getElementsByClassName('lesson-item');
            const deleteButtons = document.getElementsByClassName('delete-lesson');
            for (let btn of deleteButtons) {
                btn.style.display = lessons.length > 1 ? 'block' : 'none';
            }
        }

        function validateYouTubeUrl(textarea) {
            const contentError = textarea.nextElementSibling;
            const youtubeUrlPattern = /^https:\/\/www\.youtube\.com\/watch\?v=[A-Za-z0-9_-]+/;
            
            if (!textarea.value.match(youtubeUrlPattern)) {
                contentError.style.display = 'block';
                return false;
            } else {
                contentError.style.display = 'none';
                return true;
            }
        }

        function validateForm() {
            const textareas = document.querySelectorAll('textarea[name="content[]"]');
            let isValid = true;
            
            textareas.forEach(textarea => {
                if (!validateYouTubeUrl(textarea)) {
                    isValid = false;
                }
            });
            
            return isValid;
        }

        document.addEventListener('DOMContentLoaded', updateDeleteButtons);
    </script>
</body>
</html>