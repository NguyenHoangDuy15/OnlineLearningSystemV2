<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.CourseEX" %>
<%@ page import="Model.LessonEX" %>
<%@ page import="Model.TestEX" %>
<%@ page import="java.util.List" %>

<%
    CourseEX course = (CourseEX) request.getAttribute("course");
    List<LessonEX> lessons = (List<LessonEX>) request.getAttribute("lessons");
    List<TestEX> tests = (List<TestEX>) request.getAttribute("tests");
    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Course Details - Online Learning</title>
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

            .container {
                display: flex;
                min-height: calc(100vh - 72px);
            }

            .sidebar {
                width: 20%;
                background-color: var(--secondary);
                padding: 24px;
                display: flex;
                flex-direction: column;
                gap: 32px;
                border-right: 1px solid var(--border);
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
                display: flex;
                flex-direction: column;
                gap: 16px;
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

            .main-content {
                width: 80%;
                background-color: var(--background);
                padding: 32px;
                overflow-y: auto;
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
                transition: background-color 0.3s ease;
            }

            .course-info {
                margin-bottom: 24px;
            }

            .course-info p {
                margin: 8px 0;
                font-size: 16px;
            }

            .course-info p strong {
                color: var(--primary);
            }

            .hidden {
                display: none;
            }

            .message {
                padding: 10px;
                margin-bottom: 16px;
                border-radius: 4px;
                font-size: 14px;
            }

            .message.success {
                background-color: #2ECC71;
                color: #FFFFFF;
            }

            .message.error {
                background-color: #E74C3C;
                color: #FFFFFF;
            }

            @media (max-width: 768px) {
                .container {
                    flex-direction: column;
                }
                .sidebar, .main-content {
                    width: 100%;
                }
                .sidebar {
                    border-right: none;
                    border-bottom: 1px solid var(--border);
                }
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

        <div class="container">
            <aside class="sidebar">
                <div class="dashboard-actions">
                    <h2>Dashboard</h2>
                    <div class="button-group">
                        <button class="btn btn-primary" onclick="window.location.href = 'ShowexpertServlet#testList'">View Owner Test</button>
                        <button class="btn btn-primary" onclick="window.location.href = 'ShowexpertServlet#courseList'">View Owner Course</button>
                    </div>
                </div>
                <div class="button-group">
                    <button class="btn btn-danger logout" onclick="window.location.href = 'LogoutServlet'">Logout</button>
                </div>
            </aside>

            <main class="main-content">
                <h2>Course Details</h2>
                <% if (message != null) { %>
                <div class="message success">
                    <%= message %>
                </div>
                <% } %>

                <% if (course != null) { %>
                <div class="course-info">
                    <p><strong>Course ID:</strong> <%= course.getCourseID() %></p>
                    <p><strong>Name:</strong> <%= course.getName() != null ? course.getName() : "N/A" %></p>
                    <p><strong>Description:</strong> <%= course.getDescription() != null ? course.getDescription() : "N/A" %></p>
                    <p><strong>Price:</strong> <%= course.getPrice() %></p>
                    <p><strong>Status:</strong> 
                        <% 
                            String statusText;
                            switch (course.getStatus()) {
                                case 4: statusText = "Activate"; break;
                                case 3: statusText = "Deny"; break;
                                case 2: statusText = "Waiting"; break;
                                case 0: statusText = "Delete"; break;
                                default: statusText = "Draft"; break;
                            }
                        %>
                        <%= statusText %>
                    </p>
                </div>

                <h3>Lessons</h3>
                <div style="margin-bottom: 16px;">
                    <button class="btn btn-primary <%= course.getStatus() == 1 || course.getStatus() == 3 ? "" : "hidden" %>" 
                            onclick="window.location.href = 'LessonServlet?action=add&courseId=<%= course.getCourseID() %>'">
                        Add Lesson
                    </button>
                </div>
                <table id="lessonTable">
                    <thead>
                        <tr>
                            <th>Lesson ID</th>
                            <th>Title</th>
                            <th>Content</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="lessonList">
                        <% if (lessons != null && !lessons.isEmpty()) { %>
                        <% for (LessonEX lesson : lessons) { %>
                        <% 
                            System.out.println("Rendering lesson: ID=" + (lesson != null ? lesson.getLessonID() : "null") + 
                                             ", Status=" + (lesson != null ? lesson.getStatus() : "null"));
                        %>
                        <% if (lesson != null && lesson.getLessonID() > 0 && lesson.getStatus() == 1) { %>
                        <tr>
                            <td><%= lesson.getLessonID() %></td>
                            <td><%= lesson.getTitle() != null ? lesson.getTitle() : "N/A" %></td>
                            <td><%= lesson.getContent() != null ? lesson.getContent() : "N/A" %></td>
                            <td>
                                <a href="LessonServlet?action=edit&lessonId=<%= lesson.getLessonID() %>">
                                    <button class="btn btn-primary <%= course != null && (course.getStatus() == 1 || course.getStatus() == 3) ? "" : "hidden" %>" 
                                            style="padding: 8px 16px; font-size: 12px;">Edit</button>
                                </a>
                                <% 
                                    int lessonId = lesson.getLessonID();
                                    System.out.println("Rendering Delete button with lessonId: " + lessonId);
                                %>
                                <button class="btn btn-danger <%= course != null && (course.getStatus() == 1 || course.getStatus() == 3) ? "" : "hidden" %>" 
                                        style="padding: 8px 16px; font-size: 12px;" 
                                        onclick="deleteLesson(<%= lessonId %>)">
                                    Delete
                                </button>
                            </td>
                        </tr>
                        <% } else { %>
                        <tr>
                            <td colspan="4">Invalid lesson data (Lesson ID: <%= lesson != null ? lesson.getLessonID() : "null" %>, Status: <%= lesson != null ? lesson.getStatus() : "null" %>)</td>
                        </tr>
                        <% } %>
                        <% } %>
                        <% } else { %>
                        <tr>
                            <td colspan="4">No lessons available</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <h3>Tests</h3>
                <table id="testTable">
                    <thead>
                        <tr>
                            <th>Test ID</th>
                            <th>Name</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="testListInCourse">
                        <% if (tests != null && !tests.isEmpty()) { %>
                        <% for (TestEX test : tests) { %>
                        <% if (test != null && test.getTestID() != 0 && test.getStatus() != 0) { %>
                        <tr>
                            <td><%= test.getTestID() %></td>
                            <td>
                                <% if (course != null && course.getStatus() == 4) { %>
                                <a href="QuestionController?action=getQuestions&testId=<%= test.getTestID() %>">
                                    <%= test.getName() != null ? test.getName() : "N/A" %>
                                </a>
                                <% } else { %>
                                <a href="TestServlet?testId=<%= test.getTestID() %>">
                                    <%= test.getName() != null ? test.getName() : "N/A" %>
                                </a>
                                <% } %>
                            </td>
                            <td>
                                <% if (course != null && (course.getStatus() == 1 || course.getStatus() == 3)) { %>
                                <a href="TestServlet?testId=<%= test.getTestID() %>">
                                    <button class="btn btn-primary" style="padding: 8px 16px; font-size: 12px;">Edit</button>
                                </a>
                                <button class="btn btn-danger" style="padding: 8px 16px; font-size: 12px;" 
                                        onclick="deleteTest(<%= test.getTestID() %>)">
                                    Delete
                                </button>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                        <% } %>
                        <% } else { %>
                        <tr>
                            <td colspan="3">No tests available</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <p>Course not found.</p>
                <% } %>

                <button class="btn btn-primary" onclick="window.location.href = 'ShowexpertServlet#courseList'">Return to Course List</button>
            </main>
        </div>

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

            function deleteLesson(lessonId) {
                console.log("Delete button clicked for lessonId: " + lessonId);

                if (!lessonId || lessonId <= 0) {
                    alert("Invalid lesson ID");
                    return;
                }

                if (confirm("Are you sure you want to delete this lesson?")) {
                    fetch('LessonServlet?action=delete&lesson=' + lessonId, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        }
                    })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok ' + response.statusText);
                        }
                        return response.text();
                    })
                    .then(data => {
                        console.log("Server response: " + data);
                        if (data.trim() === "success") {
                            alert("Lesson deleted successfully!");
                            const table = document.getElementById('lessonTable');
                            const rows = table.getElementsByTagName('tr');
                            let rowToDelete = null;
                            for (let i = 0; i < rows.length; i++) {
                                const firstCell = rows[i].getElementsByTagName('td')[0];
                                if (firstCell && firstCell.textContent.trim() === lessonId.toString()) {
                                    rowToDelete = rows[i];
                                    break;
                                }
                            }

                            if (rowToDelete) {
                                rowToDelete.remove();
                                console.log("Lesson row with ID " + lessonId + " removed from table");
                                const lessonList = document.getElementById('lessonList');
                                if (lessonList.children.length === 0) {
                                    lessonList.innerHTML = '<tr><td colspan="4">No lessons available</td></tr>';
                                }
                            } else {
                                console.error("Could not find row with lessonId: " + lessonId);
                            }
                        } else {
                            alert("Failed to delete lesson: " + data);
                        }
                    })
                    .catch(error => {
                        console.error('Error during fetch:', error);
                        alert("An error occurred while deleting the lesson: " + error.message);
                    });
                }
            }

            window.deleteTest = function (testId) {
                if (confirm("Are you sure you want to delete this test?")) {
                    fetch('NoticeServlet?action=deleteTest&testId=' + testId, {
                        method: 'POST'
                    })
                    .then(response => response.text())
                    .then(data => {
                        if (data === "success") {
                            alert("Test marked as deleted successfully!");
                            window.location.reload();
                        } else {
                            alert("Failed to mark test as deleted: " + data);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert("An error occurred while marking the test as deleted: " + error.message);
                    });
                }
            };

            document.addEventListener('DOMContentLoaded', function () {
                const lessonRows = document.querySelectorAll('#lessonList tr');
                console.log('Total lessons displayed: ' + lessonRows.length);
                lessonRows.forEach((row, index) => {
                    const lessonId = row.cells[0].textContent;
                    const title = row.cells[1].textContent;
                    console.log(`Lesson ${index + 1}: ID=${lessonId}, Title=${title}`);
                });

                const testRows = document.querySelectorAll('#testListInCourse tr');
                console.log('Total tests displayed: ' + testRows.length);
                testRows.forEach((row, index) => {
                    const testId = row.cells[0].textContent;
                    const name = row.cells[1].textContent;
                    console.log(`Test ${index + 1}: ID=${testId}, Name=${name}`);
                });
            });
        </script>
        
    </body>
</html>