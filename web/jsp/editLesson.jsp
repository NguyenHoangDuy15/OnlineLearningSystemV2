<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.LessonEX" %>

<%
    LessonEX lesson = (LessonEX) request.getAttribute("lesson");
    Integer courseId = (Integer) request.getAttribute("courseId");
    boolean isEdit = lesson != null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Lesson" : "Add Lesson" %> - Online Learning</title>
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
        }

        .header {
            background-color: var(--background);
            box-shadow: 0 2px 8px var(--shadow);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 32px;
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 2px solid var(--primary);
        }

        .logo h1 {
            color: var(--primary);
            font-size: 24px;
            font-weight: 700;
            letter-spacing: 1px;
            margin: 0;
            transition: transform 0.3s ease;
        }

        .logo h1:hover {
            transform: scale(1.05);
        }

        .user-profile img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            transition: transform 0.3s ease;
            border: 2px solid var(--primary);
        }

        .user-profile img:hover {
            transform: scale(1.1);
        }

        .dropdown {
            display: none;
            position: absolute;
            right: 0;
            top: 50px;
            background-color: var(--background);
            box-shadow: 0 4px 8px var(--shadow);
            border-radius: 8px;
            z-index: 1000;
        }

        .dropdown a {
            display: block;
            padding: 10px 20px;
            color: var(--text-dark);
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        .dropdown a:hover {
            background-color: var(--secondary);
        }

        .main-content {
            width: 80%;
            margin: 0 auto;
            background-color: var(--background);
            padding: 32px;
            border-radius: 8px;
            box-shadow: 0 2px 8px var(--shadow);
            margin-top: 24px;
        }

        h2 {
            font-size: 24px;
            color: var(--text-dark);
            margin-bottom: 24px;
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
            box-shadow: 0 6px 12px rgba(231, 76, 60, 0.3);
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
    </style>
</head>
<body>
    <header class="header">
        <a href="ShowexpertServlet" class="logo">
            <h1>Online Learning</h1>
        </a>
        <div class="user-profile">
            <img src="./img/logo/logo.JPG" alt="User Avatar" onclick="toggleDropdown()">
            <div class="dropdown" id="dropdownMenu">
                <a href="ViewProfile">View Profile</a>
                <a href="ChangePasswordServlet">Change Password</a>
                <a href="LogoutServlet">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <h2><%= isEdit ? "Edit Lesson" : "Add Lesson" %></h2>
        <form action="LessonServlet" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="<%= isEdit ? "updateLesson" : "addLesson" %>">
            <input type="hidden" name="courseId" value="<%= courseId %>">
            <% if (isEdit) { %>
                <input type="hidden" name="lessonId" value="<%= lesson.getLessonID() %>">
            <% } %>

            <div class="form-group">
                <label for="title">Title</label>
                <input type="text" id="title" name="title" value="<%= isEdit ? lesson.getTitle() : "" %>" required>
            </div>

            <div class="form-group">
                <label for="content">Content (YouTube URL)</label>
                <textarea id="content" name="content" required oninput="validateYouTubeUrl()"><%= isEdit ? lesson.getContent() : "" %></textarea>
                <div id="content-error" class="error-message">Content must be a valid YouTube URL starting with 'https://www.youtube.com/watch?v='</div>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-primary">Save</button>
                <button type="button" class="btn btn-danger" onclick="window.location.href='CourseServlet?courseId=<%= courseId %>'">Cancel</button>
            </div>
        </form>
    </main>

    <script>
        function toggleDropdown() {
            const dropdown = document.getElementById('dropdownMenu');
            dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
        }

        window.onclick = function (event) {
            if (!event.target.matches('.user-profile img')) {
                const dropdown = document.getElementById('dropdownMenu');
                if (dropdown.style.display === 'block') {
                    dropdown.style.display = 'none';
                }
            }
        };

        function validateYouTubeUrl() {
            const contentInput = document.getElementById('content');
            const contentError = document.getElementById('content-error');
            const youtubeUrlPattern = /^https:\/\/www\.youtube\.com\/watch\?v=[A-Za-z0-9_-]+/;

            if (!contentInput.value.match(youtubeUrlPattern)) {
                contentError.style.display = 'block';
                return false;
            } else {
                contentError.style.display = 'none';
                return true;
            }
        }

        function validateForm() {
            const isYouTubeUrlValid = validateYouTubeUrl();
            if (!isYouTubeUrlValid) {
                return false; // Ngăn gửi form nếu URL không hợp lệ
            }
            return true; // Cho phép gửi form nếu tất cả hợp lệ
        }
    </script>
</body>
</html>