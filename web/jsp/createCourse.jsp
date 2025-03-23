<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.LessonEX" %>
<%@ page import="Model.CourseEX" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Course - Online Learning</title>
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
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: var(--secondary);
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
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
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--text-dark);
        }

        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }

        .lesson-block {
            position: relative;
            border: 1px solid var(--border);
            padding: 16px;
            margin-bottom: 16px;
            border-radius: 8px;
            background-color: var(--secondary);
        }

        .lesson-block label {
            font-weight: 500;
            color: var(--text-dark);
        }

        .remove-lesson-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: none;
            border: none;
            color: var(--accent-red);
            font-size: 16px;
            cursor: pointer;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        .remove-lesson-btn:hover {
            color: darkred;
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
            background: linear-gradient(90deg, #E74C3C, #C0392B);
            color: #FFFFFF;
        }

        .btn-danger:hover {
            background: linear-gradient(90deg, #C0392B, #E74C3C);
            transform: translateY(-2px);
        }

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 24px;
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

        ul {
            list-style-type: none;
            padding: 0;
        }

        ul li {
            padding: 10px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Create a New Course</h2>
        <% 
           String successMessage = (String) request.getAttribute("success");
           String errorMessage = (String) request.getAttribute("errorMessage");
           if (successMessage != null && !successMessage.isEmpty()) { %>
            <div class="notification success">
                <%= successMessage %>
                <br>
                <button type="button" class="btn btn-primary" onclick="window.location.href = 'ShowexpertServlet'" style="margin-top: 10px;">Return to Dashboard</button>
            </div>
            <script>
                setTimeout(() => {
                    window.location.href = 'ShowexpertServlet';
                }, 3000);
            </script>
        <% } else if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="notification error">
                <%= errorMessage %>
                <br>
                <button type="button" class="btn btn-primary" onclick="window.location.href = 'ShowexpertServlet'" style="margin-top: 10px;">Return to Dashboard</button>
            </div>
            <script>
                setTimeout(() => {
                    window.location.href = 'ShowexpertServlet';
                }, 3000);
            </script>
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
                <input type="number" id="price" name="price" step="10000" placeholder="Enter price" required>
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
                    <textarea id="lessonContent1" name="lessonContent[]" placeholder="Enter URL" required></textarea>
                    <button type="button" class="remove-lesson-btn" onclick="removeLesson(this)">X</button>
                </div>
            </div>

            <div class="form-actions">
                <button type="button" class="btn btn-primary" onclick="addLesson()">
                    <span>+</span> More Lesson
                </button>
                <button type="submit" id="submitBtn" class="btn btn-success">Create Course</button>
                <button type="button" class="btn btn-danger" onclick="window.location.href = 'ShowexpertServlet'">Cancel</button>
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
                <textarea id="lessonContent${lessonCount}" name="lessonContent[]" placeholder="Enter URL" required></textarea>
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

            const lessonContents = document.getElementsByName('lessonContent[]');
            for (let i = 0; i < lessonContents.length; i++) {
                let content = lessonContents[i].value;
                if (!content.match(/^https:\/\/www\.youtube\.com\/watch\?v=/)) {
                    alert('Lesson Content ' + (i + 1) + ' must be a valid YouTube link (starting with https://www.youtube.com/watch?v=...)');
                    event.preventDefault();
                    return;
                }
            }

            isSubmitting = true;
            document.getElementById('submitBtn').disabled = true;
        });

        function deleteLessonFromDB(lessonId) {
            if (confirm("Do you want delete this lesson?")) {
                window.location.href = "NoticeServlet?deleteLesson=" + lessonId;
            }
        }
    </script>
</body>
</html>