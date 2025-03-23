<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.TestEX" %>
<%@ page import="Model.CourseEX" %>
<%@ page import="Model.QuestionEX" %>
<%@ page import="dal.TestEXDAO" %>
<%@ page import="dal.CourseEXDAO" %>

<%
    List<TestEX> tests = (List<TestEX>) request.getAttribute("tests");
    List<CourseEX> courses = (List<CourseEX>) request.getAttribute("courses");
    String fullName = (String) session.getAttribute("Fullname");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    Boolean showQuestions = (Boolean) request.getAttribute("showQuestions");
    List<QuestionEX> questions = (List<QuestionEX>) request.getAttribute("questions");
    TestEX test = (TestEX) request.getAttribute("test");
    TestEXDAO testDAO = new TestEXDAO();
    CourseEXDAO courseDAO = new CourseEXDAO();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Expert Dashboard - Online Learning</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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

            /* Điều chỉnh navbar */
            .navbar-header {
                background-color: var(--background);
                box-shadow: 0 2px 8px var(--shadow);
                border-bottom: 2px solid var(--primary);
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .navbar-header .navbar-nav {
                margin-left: auto;
            }

            .navbar-header .avatar-sm {
                width: 40px;
                height: 40px;
            }

            .navbar-header .avatar-img {
                width: 100%;
                height: 100%;
                border: 2px solid var(--primary);
                transition: transform 0.3s ease;
            }

            .navbar-header .avatar-img:hover {
                transform: scale(1.1);
            }

            .navbar-header .profile-username {
                color: var(--text-dark);
                margin-left: 10px;
                font-size: 14px;
            }

            .navbar-header .profile-username .op-7 {
                color: var(--text-light);
            }

            .navbar-header .profile-username .fw-bold {
                color: var(--text-dark);
            }

            .navbar-header .dropdown-menu {
                background-color: var(--background);
                box-shadow: 0 4px 8px var(--shadow);
                border-radius: 8px;
                border: 1px solid var(--border);
            }

            .navbar-header .dropdown-item {
                color: var(--text-dark);
                padding: 10px 20px;
                transition: background-color 0.3s ease;
            }

            .navbar-header .dropdown-item:hover {
                background-color: var(--secondary);
            }

            .navbar-header .user-box {
                display: flex;
                align-items: center;
                padding: 10px 20px;
            }

            .navbar-header .avatar-lg {
                width: 50px;
                height: 50px;
                margin-right: 15px;
            }

            .navbar-header .u-text h4 {
                margin: 0;
                font-size: 16px;
                color: var(--text-dark);
            }

            .navbar-header .u-text p {
                margin: 5px 0 0;
                font-size: 14px;
                color: var(--text-light);
            }

            .navbar-header .u-text a {
                margin-top: 5px;
                display: inline-block;
                padding: 5px 10px;
                background-color: var(--primary);
                color: #FFFFFF;
                border-radius: 4px;
                text-decoration: none;
                font-size: 12px;
            }

            .navbar-header .u-text a:hover {
                background-color: #357ABD;
            }

            .navbar-header .dropdown-divider {
                border-top: 1px solid var(--border);
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

            .btn-small.add {
                background: var(--gradient-success);
                color: #FFFFFF;
            }

            .btn-small.add:hover {
                background: linear-gradient(90deg, #27AE60, #2ECC71);
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(46, 204, 113, 0.3);
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

            .create-test {
                background-color: var(--background);
                padding: 24px;
                border-radius: 8px;
                box-shadow: 0 2px 8px var(--shadow);
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

            .form-actions {
                display: flex;
                gap: 12px;
                margin-top: 16px;
                justify-content: space-between;
                align-items: center;
            }

            .form-buttons {
                display: flex;
                gap: 12px;
                justify-content: flex-start;
                margin-top: 24px;
            }

            .form-group textarea {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid var(--border);
                border-radius: 8px;
                font-size: 14px;
                font-family: 'Roboto', sans-serif;
                color: var(--text-dark);
                background-color: #F9FAFB;
                resize: vertical;
                min-height: 80px;
                transition: all 0.3s ease;
                box-shadow: inset 0 1px 3px var(--shadow);
            }

            .form-group textarea:focus {
                border-color: var(--primary);
                outline: none;
                box-shadow: 0 0 6px rgba(74, 144, 226, 0.4);
                background-color: #FFFFFF;
            }

            .form-group textarea:hover:not(:focus) {
                border-color: #B0B0B0;
            }

            .form-group textarea::placeholder {
                color: var(--text-light);
                font-style: italic;
            }

            .status-activate {
                color: #2ECC71;
            }
            .status-deny {
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

            .question-list {
                background-color: var(--background);
                padding: 24px;
                border-radius: 8px;
                box-shadow: 0 2px 8px var(--shadow);
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
        <!-- Navbar Header -->
        <nav class="navbar navbar-header navbar-header-transparent navbar-expand-lg border-bottom">
            <div class="container-fluid">
                <a class="navbar-brand" href="#">
                    <h1 style="color: var(--primary); font-size: 24px; font-weight: 700; letter-spacing: 1px; margin: 0; transition: transform 0.3s ease;" onmouseover="this.style.transform='scale(1.05)'" onmouseout="this.style.transform='scale(1)'">Online Learning</h1>
                </a>
                <ul class="navbar-nav topbar-nav ms-md-auto align-items-center">
                    <li class="nav-item topbar-user dropdown hidden-caret">
                        <a class="dropdown-toggle profile-pic" data-bs-toggle="dropdown" href="#" aria-expanded="false">
                            <div class="avatar-sm">
                                <img src="assets/img/profile.jpg" alt="User Avatar" class="avatar-img rounded-circle"/>
                            </div>
                            <span class="profile-username">
                                <span class="op-7">Hi,</span>
                                <span class="fw-bold">
                                    <%= fullName != null ? fullName : "Expert" %>
                                </span>
                            </span>
                        </a>
                        <ul class="dropdown-menu dropdown-user animated fadeIn">
                            <div class="dropdown-user-scroll scrollbar-outer">
                                <li>
                                    <div class="user-box">
                                        <div class="avatar-lg">
                                            <img src="assets/img/profile.jpg" alt="image profile" class="avatar-img rounded"/>
                                        </div>
                                        <div class="u-text">
                                            <h4><%= fullName != null ? fullName : "Expert" %></h4>
                                            <p class="text-muted">${sessionScope.user != null ? sessionScope.user.email : "expert@example.com"}</p>
                                            <a href="ViewProfileServlet?userId=${sessionScope.user != null ? sessionScope.user.userID : ''}" class="btn btn-xs btn-secondary btn-sm">View Profile</a>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item" href="ViewProfileServlet?userId=${sessionScope.user != null ? sessionScope.user.userID : ''}">My Profile</a>
                                    <a class="dropdown-item" href="ChangePasswordServlet">Change Password</a>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item" href="LogoutServlet">Logout</a>
                                </li>
                            </div>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>
        <!-- End Navbar -->

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
                <div id="courseList" class="course-list">
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
                                            case 4: statusText = "Activate"; statusClass = "status-activate"; break;
                                            case 3: statusText = "Deny"; statusClass = "status-deny"; break;
                                            case 2: statusText = "Waiting"; statusClass = "status-waiting"; break;
                                            case 0: statusText = "Delete"; statusClass = "status-delete"; break;
                                            default: statusText = "Draft"; statusClass = ""; break;
                                        }
                                    %>
                                    <span class="<%= statusClass %>" id="status<%= course.getCourseID() %>"><%= statusText %></span>
                                </td>
                                <td>
                                    <button class="btn btn-danger <%= status == 4 ? "hidden" : "" %>" 
                                            onclick="deleteCourse(<%= course.getCourseID() %>)" 
                                            style="padding: 8px 16px; font-size: 12px;">Delete</button>
                                    <a href="CourseServlet?courseId=<%= course.getCourseID() %>">
                                        <button class="btn btn-primary <%= status == 4 ? "hidden" : "" %>" 
                                                style="padding: 8px 16px; font-size: 12px;">Update</button>
                                    </a>
                                    <button class="btn btn-success <%= status == 4 ? "hidden" : "" %>" 
                                            onclick="addTest(<%= course.getCourseID() %>)" 
                                            style="padding: 8px 16px; font-size: 12px;">Add Test</button>
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
                <div id="testList" class="test-list">
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
                        <tbody>
                            <% if (tests != null && !tests.isEmpty()) { %>
                            <% for (TestEX testItem : tests) { %>
                            <% if (testItem.getStatus() != 0) { %>
                            <tr id="testRow<%= testItem.getTestID() %>">
                                <td><%= testItem.getTestID() %></td>
                                <td><a href="QuestionController?action=getQuestions&testId=<%= testItem.getTestID() %>"><%= testItem.getName() %></a></td>
                                <td class="status-done"><%= testItem.getStatus() == 1 ? "Completed" : "Done" %></td>
                                <td><%= testItem.getCourseID() %></td>
                                <td>
                                    <button class="btn btn-primary" onclick="updateTest(<%= testItem.getTestID() %>)" style="padding: 8px 16px; font-size: 12px;">Update</button>
                                    <button class="btn btn-danger" onclick="deleteTest(<%= testItem.getTestID() %>)" style="padding: 8px 16px; font-size: 12px;">Delete</button>
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
                <div id="questionList" class="question-list" style="display: <%= (showQuestions != null && showQuestions) ? "block" : "none" %>;">
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
                    <button id="returnFromQuestions" class="btn btn-primary return">Return to Test List</button>
                </div>
                <div id="createTest" class="create-test">
                    <h2>Create a New Test</h2>
                    <div id="testNotification" class="notification" style="display: none;"></div>
                    <form id="testForm" action="QuestionController" method="post">
                        <input type="hidden" name="courseId" id="courseId" value="">
                        <input type="hidden" name="testId" value="-1">
                        <div class="form-group">
                            <label for="testName">Test Name:</label>
                            <input type="text" id="testName" name="testName" placeholder="Enter test name" required>
                        </div>
                        <p>Add questions and options to create your test</p>
                        <div id="questionsContainer">
                            <div class="question-block" id="question1">
                                <label for="question1">Question:</label>
                                <textarea id="question1" name="question1" rows="3" placeholder="Enter your question" required></textarea>
                                <div class="options" id="options1">
                                    <div class="option">
                                        <input type="radio" name="correct-answer-1" value="optionA1" required>
                                        <input type="text" name="optionA1" placeholder="Option A" required>
                                        <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                                    </div>
                                    <div class="option">
                                        <input type="radio" name="correct-answer-1" value="optionB1">
                                        <input type="text" name="optionB1" placeholder="Option B" required>
                                        <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                                    </div>
                                    <div class="option">
                                        <input type="radio" name="correct-answer-1" value="optionC1">
                                        <input type="text" name="optionC1" placeholder="Option C" required>
                                        <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                                    </div>
                                    <div class="option">
                                        <input type="radio" name="correct-answer-1" value="optionD1">
                                        <input type="text" name="optionD1" placeholder="Option D" required>
                                        <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                                    </div>
                                </div>
                                <div class="form-actions">
                                    <div>
                                        <button type="button" class="btn-small add" onclick="addOption('options1')">+</button>
                                        <span style="font-size: 14px; color: var(--text-light); margin-left: 8px;">Add Option</span>
                                    </div>
                                    <button type="button" class="btn btn-danger" onclick="removeQuestion(this)">Delete Question</button>
                                </div>
                            </div>
                        </div>
                        <div class="form-buttons">
                            <button type="button" class="btn btn-primary add-question" onclick="addQuestion()">Add Question</button>
                            <button type="submit" class="btn btn-success">Submit Test</button>
                        </div>
                    </form>
                    <button id="returnFromCreateTest" class="btn btn-primary return">Return to Dashboard</button>
                </div>
            </main>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                console.log("DOM fully loaded and parsed");

                // Lấy các phần tử DOM
                const viewOwnerTestBtn = document.getElementById('viewOwnerTestBtn');
                const viewOwnerCourseBtn = document.getElementById('viewOwnerCourseBtn');
                const createCourseBtn = document.getElementById('createCourseBtn');
                const returnFromCourses = document.getElementById('returnFromCourses');
                const returnFromTests = document.getElementById('returnFromTests');
                const returnFromCreateTest = document.getElementById('returnFromCreateTest');
                const returnFromQuestions = document.getElementById('returnFromQuestions');
                const welcome = document.getElementById('welcome');
                const courseList = document.getElementById('courseList');
                const testList = document.getElementById('testList');
                const createTest = document.getElementById('createTest');
                const questionList = document.getElementById('questionList');

                // Hàm ẩn tất cả các section
                function hideAll() {
                    welcome.classList.remove('active');
                    courseList.style.display = 'none';
                    testList.style.display = 'none';
                    createTest.style.display = 'none';
                    questionList.style.display = 'none';
                }

                // Ban đầu ẩn tất cả và hiển thị welcome
                hideAll();
                welcome.classList.add('active');

                // Gán sự kiện cho các nút điều hướng
                viewOwnerTestBtn.addEventListener('click', () => {
                    hideAll();
                    testList.style.display = 'block';
                });

                viewOwnerCourseBtn.addEventListener('click', () => {
                    hideAll();
                    courseList.style.display = 'block';
                });

                createCourseBtn.addEventListener('click', () => {
                    window.location.href = 'createCourse.jsp'; // Chuyển hướng đến trang tạo course nếu có
                });

                returnFromCourses.addEventListener('click', () => {
                    hideAll();
                    welcome.classList.add('active');
                });

                returnFromTests.addEventListener('click', () => {
                    hideAll();
                    welcome.classList.add('active');
                });

                returnFromCreateTest.addEventListener('click', () => {
                    hideAll();
                    welcome.classList.add('active');
                });

                returnFromQuestions.addEventListener('click', () => {
                    hideAll();
                    testList.style.display = 'block';
                });

                window.deleteCourse = function (courseId) {
                    console.log("Delete Course button clicked for course ID:", courseId);
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
                    console.log("Request Course button clicked for course ID:", courseId);
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
                                        const deleteBtn = row.querySelector('.btn-danger');
                                        const updateBtn = row.querySelector('.btn-primary');
                                        const addTestBtn = row.querySelector('.btn-success');
                                        const requestBtn = row.querySelector('.btn-warning');

                                        if (deleteBtn) deleteBtn.classList.add('hidden');
                                        if (updateBtn) updateBtn.classList.add('hidden');
                                        if (addTestBtn) addTestBtn.classList.add('hidden');
                                        if (requestBtn) requestBtn.classList.add('hidden');
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

                window.addTest = function (courseId) {
                    console.log("Add Test button clicked for course ID:", courseId);
                    if (!courseId || courseId <= 0) {
                        alert("Invalid Course ID. Please select a valid course.");
                        return;
                    }
                    const courseIdInput = document.getElementById('courseId');
                    if (!courseIdInput) {
                        console.error("Course ID input not found!");
                        return;
                    }
                    courseIdInput.value = courseId;
                    console.log("Course ID set in input:", courseIdInput.value);
                    hideAll();
                    const createTestSection = document.getElementById('createTest');
                    if (createTestSection) {
                        createTestSection.style.display = 'block';
                    } else {
                        console.error("Create Test section not found!");
                    }
                };

                window.updateTest = function (testId) {
                    console.log("Update Test button clicked for test ID:", testId);
                    window.location.href = `TestServlet?testId=${testId}`;
                };

                window.deleteTest = function (testId) {
                    console.log("Delete Test button clicked for test ID:", testId);
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

                let questionCount = 1;

                window.addOption = function (optionsId) {
                    const optionsContainer = document.getElementById(optionsId);
                    const optionCount = optionsContainer.children.length;
                    const newOption = document.createElement('div');
                    newOption.classList.add('option');
                    const optionLetter = String.fromCharCode(65 + optionCount);
                    newOption.innerHTML = `
                        <input type="radio" name="correct-answer-${questionCount}" value="option${optionLetter}${questionCount}">
                        <input type="text" name="option${optionLetter}${questionCount}" placeholder="Option" required>
                        <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                    `;
                    optionsContainer.appendChild(newOption);
                };

                window.removeOption = function (button) {
                    const optionDiv = button.parentElement;
                    if (optionDiv.parentElement.children.length > 2) {
                        optionDiv.remove();
                    } else {
                        alert("A question must have at least two options.");
                    }
                };

                window.addQuestion = function () {
                    questionCount++;
                    const questionsContainer = document.getElementById('questionsContainer');
                    const newQuestionBlock = document.createElement('div');
                    newQuestionBlock.classList.add('question-block');
                    newQuestionBlock.id = `question${questionCount}`;
                    newQuestionBlock.innerHTML = `
                        <label for="question${questionCount}">Question:</label>
                        <textarea id="question${questionCount}" name="question${questionCount}" rows="3" placeholder="Enter your question" required></textarea>
                        <div class="options" id="options${questionCount}">
                            <div class="option">
                                <input type="radio" name="correct-answer-${questionCount}" value="optionA${questionCount}" required>
                                <input type="text" name="optionA${questionCount}" placeholder="Option A" required>
                                <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                            </div>
                            <div class="option">
                                <input type="radio" name="correct-answer-${questionCount}" value="optionB${questionCount}">
                                <input type="text" name="optionB${questionCount}" placeholder="Option B" required>
                                <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                            </div>
                            <div class="option">
                                <input type="radio" name="correct-answer-${questionCount}" value="optionC${questionCount}">
                                <input type="text" name="optionC${questionCount}" placeholder="Option C" required>
                                <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                            </div>
                            <div class="option">
                                <input type="radio" name="correct-answer-${questionCount}" value="optionD${questionCount}">
                                <input type="text" name="optionD${questionCount}" placeholder="Option D" required>
                                <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                            </div>
                        </div>
                        <div class="form-actions">
                            <div>
                                <button type="button" class="btn-small add" onclick="addOption('options${questionCount}')">+</button>
                                <span style="font-size: 14px; color: var(--text-light); margin-left: 8px;">Add Option</span>
                            </div>
                            <button type="button" class="btn btn-danger" onclick="removeQuestion(this)">Delete Question</button>
                        </div>
                    `;
                    questionsContainer.appendChild(newQuestionBlock);
                };

                window.removeQuestion = function (button) {
                    const questionBlock = button.parentElement.parentElement;
                    const questionsContainer = document.getElementById('questionsContainer');
                    if (questionsContainer.children.length > 1) {
                        if (confirm("Are you sure you want to delete this question?")) {
                            questionBlock.remove();
                            questionCount--;
                        }
                    } else {
                        alert("You must keep at least one question in the test.");
                    }
                };

                // Xử lý submit form
                document.getElementById('testForm').addEventListener('submit', function (event) {
                    event.preventDefault();
                    const courseIdInput = document.getElementById('courseId');
                    const courseId = courseIdInput.value;
                    const notification = document.getElementById('testNotification');
                    if (!courseId || courseId.trim() === '') {
                        notification.textContent = "Course ID is required! Please select a course first.";
                        notification.className = "notification error";
                        notification.style.display = "block";
                        setTimeout(() => notification.style.display = "none", 3000);
                        return;
                    }

                    let questionCounter = 1;
                    while (document.getElementsByName('question' + questionCounter)[0]) {
                        let radios = document.getElementsByName('correct-answer-' + questionCounter);
                        let isChecked = false;
                        for (let radio of radios) {
                            if (radio.checked) {
                                isChecked = true;
                                break;
                            }
                        }
                        if (!isChecked) {
                            notification.textContent = 'Please select a correct answer for question ' + questionCounter;
                            notification.className = "notification error";
                            notification.style.display = "block";
                            setTimeout(() => notification.style.display = "none", 3000);
                            return;
                        }
                        questionCounter++;
                    }

                    const form = this;
                    form.submit();
                });

                // Kiểm tra nếu cần hiển thị danh sách câu hỏi
                const showQuestionsFlag = <%= showQuestions != null && showQuestions ? "true" : "false" %>;
                if (showQuestionsFlag) {
                    hideAll();
                    questionList.style.display = 'block';
                }
            });
        </script>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>