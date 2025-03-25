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
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Expert Dashboard - Online Learning</title>
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

            .btn-warning {
                background: linear-gradient(90deg, #F1C40F, #F39C12);
                color: #FFFFFF;
            }

            .btn-warning:hover {
                background: linear-gradient(90deg, #F39C12, #F1C40F);
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(241, 196, 15, 0.3);
            }

            .btn-small {
                padding: 6px;
                border: none;
                border-radius: 50%;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                width: 28px;
                height: 28px;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 2px 4px var(--shadow);
            }

            .btn-small.remove {
                background: var(--gradient-danger);
                color: #FFFFFF;
            }

            .btn-small.remove:hover {
                background: linear-gradient(90deg, #C0392B, #E74C3C);
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(231, 76, 60, 0.3);
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

            .main-content {
                width: 80%;
                background-color: var(--background);
                padding: 32px;
                overflow-y: auto;
            }

            .main-content > div {
                display: none;
            }

            .main-content > div.active {
                display: block;
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
                text-overflow: unset;
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
                .user-profile {
                    position: relative;
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
                        <button id="viewOwnerTestBtn" class="btn btn-primary">View Owner Test</button>
                        <button id="viewOwnerCourseBtn" class="btn btn-primary">View Owner Course</button>
                    </div>
                </div>
                <div class="button-group">
                    <button class="btn btn-danger logout" onclick="window.location.href = 'LogoutServlet'">Logout</button>
                </div>
            </aside>

            <main class="main-content">
                <% if (success != null && !success.isEmpty()) { %>
                <div class="notification success"><%= success %></div>
                <% } %>
                <% if (error != null && !error.isEmpty()) { %>
                <div class="notification error"><%= error %></div>
                <% } %>

                <div id="welcome" class="welcome active">
                    <h2>Welcome to Expert Dashboard, <%= fullName != null ? fullName : "Expert" %></h2>
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
                                        String statusText;
                                        String statusClass;
                                        switch (status) {
                                            case 4: statusText = "Approved"; statusClass = "status-approved"; break;
                                            case 3: statusText = "Rejected"; statusClass = "status-rejected"; break;
                                            case 2: statusText = "Waiting"; statusClass = "status-waiting"; break;
                                            case 0: statusText = "Delete"; statusClass = "status-delete"; break;
                                            default: statusText = "Draft"; statusClass = ""; break;
                                        }
                                    %>
                                    <span class="<%= statusClass %>" id="status<%= course.getCourseID() %>"><%= statusText %></span>
                                </td>
                                <td>
                                    <button class="btn btn-danger <%= (status == 2 || status == 4) ? "hidden" : "" %>" 
                                            onclick="deleteCourse(<%= course.getCourseID() %>)" 
                                            style="padding: 8px 16px; font-size: 12px;">Delete</button>
                                    <a href="CourseServlet?courseId=<%= course.getCourseID() %>">
                                        <button class="btn btn-primary <%= (status == 2 || status == 4) ? "hidden" : "" %>" 
                                                style="padding: 8px 16px; font-size: 12px;">Update</button>
                                    </a>
                                    <a href="QuestionController?courseId=<%= course.getCourseID() %>">
                                        <button class="btn btn-success <%= (status == 2 || status == 4) ? "hidden" : "" %>" 
                                                style="padding: 8px 16px; font-size: 12px;">Add Test</button>
                                    </a>
                                    <button class="btn btn-warning <%= (status == 2 || status == 4) ? "hidden" : "" %>" 
                                            onclick="requestCourse(<%= course.getCourseID() %>)" 
                                            style="padding: 8px 16px; font-size: 12px;">Request</button>
                                </td>
                            </tr>
                            <% } %>
                            <% } %>
                            <% } else { %>
                            <tr>
                                <td colspan="6">No courses available</td>
                            </tr>
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
                            <% if (testItem.getStatus() != 0) { %>
                            <% 
                                CourseEX course = courseDAO.getCourseByIdEx(testItem.getCourseID());
                                boolean isEditable = (course != null && (course.getStatus() == 1 || course.getStatus() == 3));
                            %>
                            <tr id="testRow<%= testItem.getTestID() %>">
                                <td><%= testItem.getTestID() %></td>
                                <td>
                                    <a href="<%= isEditable ? "TestServlet?testId=" + testItem.getTestID() : "ViewQuestionsServlet?testId=" + testItem.getTestID() + "&mode=view" %>">
                                        <%= testItem.getName() %>
                                    </a>
                                </td>
                                <td class="status-done"><%= testItem.getStatus() == 1 ? "Completed" : "Done" %></td>
                                <td><%= testItem.getCourseID() %></td>
                                <td>
                                    <% if (isEditable) { %>
                                    <a href="TestServlet?testId=<%= testItem.getTestID() %>">
                                        <button class="btn btn-primary" style="padding: 8px 16px; font-size: 12px;">Edit</button>
                                    </a>
                                    <button class="btn btn-danger" onclick="deleteTest(<%= testItem.getTestID() %>)" style="padding: 8px 16px; font-size: 12px;">Delete</button>
                                    <% } else { %>
                                    <a href="ViewQuestionsServlet?testId=<%= testItem.getTestID() %>&mode=view">
                                        <button class="btn btn-primary" style="padding: 8px 16px; font-size: 12px;">View</button>
                                    </a>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                            <% } %>
                            <% } else { %>
                            <tr>
                                <td colspan="5">No tests available</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <button id="returnFromTests" class="btn btn-primary return">Return to Dashboard</button>
                </div>
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
            document.addEventListener('DOMContentLoaded', function () {
                console.log("DOM fully loaded and parsed");
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
                    courseList.style.display = 'none';
                    testList.style.display = 'none';
                }

                viewOwnerTestBtn.addEventListener('click', () => {
                    hideAll();
                    testList.style.display = 'block';
                });

                viewOwnerCourseBtn.addEventListener('click', () => {
                    hideAll();
                    courseList.style.display = 'block';
                });

                createCourseBtn.addEventListener('click', () => {
                    window.location.href = 'createCourse';
                });

                returnFromCourses.addEventListener('click', () => {
                    hideAll();
                    welcome.classList.add('active');
                    welcome.style.display = 'block';
                });

                returnFromTests.addEventListener('click', () => {
                    hideAll();
                    welcome.classList.add('active');
                    welcome.style.display = 'block';
                });

                window.deleteCourse = function (courseId) {
                    if (confirm("Are you sure you want to delete this course?")) {
                        fetch('NoticeServlet?action=deleteCourse&courseId=' + courseId, {
                            method: 'POST'
                        })
                                .then(response => response.text())
                                .then(data => {
                                    if (data === "success") {
                                        alert("Course deleted successfully!");
                                        const courseRow = document.getElementById('courseRow' + courseId);
                                        if (courseRow) {
                                            courseRow.remove();
                                        }
                                    } else {
                                        alert("Failed to delete course: " + data);
                                    }
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    alert("An error occurred while deleting the course: " + error.message);
                                });
                    }
                };

                window.requestCourse = function (courseId) {
                    if (confirm("Are you sure you want to request approval for this course?")) {
                        fetch('NoticeServlet?action=requestCourse&courseId=' + courseId, {
                            method: 'POST'
                        })
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
                                            const requestBtn = row.querySelector('.btn-warning');
                                            if (requestBtn) {
                                                requestBtn.classList.add('hidden');
                                            }
                                        }
                                    } else {
                                        alert("Failed to request course: " + data);
                                    }
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    alert("An error occurred while requesting the course: " + error.message);
                                });
                    }
                };

                window.deleteTest = function (testId) {
                    if (confirm("Are you sure you want to delete this test?")) {
                        fetch('NoticeServlet?action=deleteTest&testId=' + testId, {
                            method: 'POST'
                        })
                                .then(response => response.text())
                                .then(data => {
                                    if (data === "success") {
                                        alert("Test marked as deleted successfully!");
                                        const testRow = document.getElementById('testRow' + testId);
                                        if (testRow) {
                                            testRow.remove();
                                            // Kiểm tra nếu không còn test nào trong bảng
                                            const remainingRows = testListBody.getElementsByTagName('tr');
                                            if (remainingRows.length === 0) {
                                                testListBody.innerHTML = '<tr><td colspan="5">No tests available</td></tr>';
                                            }
                                        }
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
            });
        </script>
    </body>
</html>