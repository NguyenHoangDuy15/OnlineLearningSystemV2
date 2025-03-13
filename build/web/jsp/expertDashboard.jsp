<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Test" %>
<%@ page import="Model.Courses" %>

<%
    List<Test> tests = (List<Test>) request.getAttribute("tests");
    String fullName = (String) session.getAttribute("Fullname");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Expert Dashboard</title>
        <style>
            /* Định nghĩa biến màu sắc */
            :root {
                --primary: #4A90E2;      /* Màu xanh mềm */
                --secondary: #F5F5F5;    /* Màu xám nhạt */
                --accent-green: #2ECC71; /* Màu xanh lá */
                --accent-red: #E74C3C;   /* Màu đỏ */
                --text-dark: #333333;    /* Màu chữ tối */
                --text-light: #777777;   /* Màu chữ nhạt */
                --background: #FFFFFF;   /* Màu nền trắng */
                --border: #E0E0E0;       /* Màu viền */
                --shadow: rgba(0, 0, 0, 0.1); /* Màu bóng */
                --gradient-primary: linear-gradient(90deg, #4A90E2, #357ABD); /* Gradient xanh */
                --gradient-success: linear-gradient(90deg, #2ECC71, #27AE60); /* Gradient xanh lá */
                --gradient-danger: linear-gradient(90deg, #E74C3C, #C0392B); /* Gradient đỏ */
            }

            /* Thiết lập cơ bản cho body */
            body {
                font-family: 'Roboto', sans-serif;
                background-color: var(--secondary);
                margin: 0;
                padding: 0;
            }

            /* Header */
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

            .navigation ul {
                list-style: none;
                display: flex;
                gap: 24px;
                margin: 0;
                padding: 0;
            }

            .navigation a {
                color: var(--text-dark);
                text-decoration: none;
                font-size: 16px;
                font-weight: 500;
                transition: color 0.3s, transform 0.3s ease;
            }

            .navigation a:hover {
                color: var(--primary);
                transform: translateY(-2px);
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

            /* Container chính */
            .container {
                display: flex;
                min-height: calc(100vh - 72px); /* Trừ chiều cao header */
            }

            /* Sidebar */
            .sidebar {
                width: 20%;
                background-color: var(--secondary);
                padding: 24px;
                display: flex;
                flex-direction: column;
                gap: 32px; /* Tăng khoảng cách giữa các section */
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

            /* Nhóm nút trong sidebar */
            .sidebar .button-group {
                display: flex;
                flex-direction: column;
                gap: 12px;
            }

            /* Nút chung */
            .btn {
                padding: 10px 24px;
                border: none;
                border-radius: 12px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
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

            /* Nút nhỏ cho Add/Delete Option */
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

            /* Bảng */
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

            tr:last-child td {
                border-bottom: none;
            }

            tr:hover {
                background-color: #E6F0FA;
                transition: background-color 0.3s ease;
            }

            /* Khu vực nội dung chính */
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

            .welcome h2 {
                font-size: 28px;
                font-weight: 600;
                color: var(--text-dark);
                text-align: center;
                margin-top: 48px;
                animation: fadeIn 0.5s ease-in-out;
            }

            /* Các màn hình con */
            .view-tests h2, .view-courses h2, .create-test h2 {
                font-size: 24px;
                font-weight: 600;
                color: var(--text-dark);
                margin-bottom: 8px;
            }

            .view-tests p, .view-courses p, .create-test p {
                font-size: 16px;
                color: var(--text-light);
                font-style: italic;
                margin-bottom: 24px;
            }

            /* Tinh chỉnh bảng cho View Tests và View Courses */
            .status-done {
                color: var(--accent-green);
                font-weight: 500;
            }

            .price {
                color: var(--accent-green);
                font-weight: 500;
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

            /* Căn chỉnh nút trong View Tests và View Courses */
            .view-tests .button-group,
            .view-courses .button-group {
                display: flex;
                justify-content: flex-start;
                gap: 12px;
                margin-top: 24px;
            }

            /* Form tạo bài kiểm tra */
            .create-test form {
                background-color: var(--secondary);
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 4px 12px var(--shadow);
                margin-bottom: 24px;
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

            .question-block label {
                display: block;
                font-size: 16px;
                font-weight: 500;
                color: var(--text-dark);
                margin-bottom: 8px;
            }

            .question-block textarea,
            .question-block input[type="text"] {
                width: 100%;
                padding: 12px;
                border: 1px solid var(--border);
                border-radius: 8px;
                font-size: 14px;
                margin-bottom: 12px;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }

            .question-block textarea:focus,
            .question-block input[type="text"]:focus {
                border-color: var(--primary);
                outline: none;
                box-shadow: 0 0 8px rgba(74, 144, 226, 0.5);
            }

            .option {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 8px;
            }

            .option input[type="radio"] {
                accent-color: var(--primary);
                transform: scale(1.2);
                margin: 0;
            }

            .option input[type="text"] {
                flex-grow: 1;
            }

            .form-actions {
                display: flex;
                gap: 12px;
                margin-top: 16px;
                justify-content: space-between; /* Căn chỉnh nút Add và Delete Question */
                align-items: center;
            }

            .form-buttons {
                display: flex;
                gap: 12px;
                justify-content: flex-start;
                margin-top: 24px;
            }

            .return {
                margin-top: 24px;
            }

            /* Animation */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Responsive design */
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
                .sidebar .button-group {
                    flex-direction: row;
                    flex-wrap: wrap;
                    gap: 8px;
                }
                .form-actions {
                    flex-direction: column;
                    align-items: flex-start;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="logo">
                <h1>EDUKATE</h1>
            </div>
            <nav class="navigation">
                <ul>
                    <li><a href="#">Home</a></li>
                    <li><a href="#">About</a></li>
                    <li><a href="#">Courses</a></li>
                    <li><a href="#">Pages</a></li>
                    <li><a href="#">Blog</a></li>
                </ul>
            </nav>
            <div class="user-profile">
                <img src="avatar.png" alt="User Avatar">
            </div>
        </header>

        <!-- Container chứa sidebar và main content -->
        <div class="container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="view-section">
                    <h2>View Courses & Tests</h2>
                    <div class="button-group">
                        <button id="viewCoursesBtn" class="btn btn-primary">View My Courses</button>
                        <button id="viewTestsBtn" class="btn btn-primary">View My Tests</button>
                    </div>
                </div>
                <div class="manage-courses">
                    <h2>Manage Courses</h2>
                    <div class="button-group">
                        <button class="btn btn-success">Add Course</button>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Dữ liệu khóa học sẽ được thêm ở đây -->
                        </tbody>
                    </table>
                </div>
                <div class="manage-tests">
                    <h2>Manage Tests</h2>
                    <div class="button-group">
                        <button class="btn btn-success">Manage Tests</button>
                        <button id="createTestBtn" class="btn btn-success">Create Test</button>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Dữ liệu bài kiểm tra sẽ được thêm ở đây -->
                        </tbody>
                    </table>
                </div>
                <div class="button-group">
                    <button class="btn btn-danger logout" onclick="window.location.href = 'LogoutServlet'">Logout</button>
                </div>

            </aside>

            <!-- Nội dung chính -->
            <main class="main-content">
                <div id="welcome" class="welcome active">
                    <h2>Welcome to Your Expert Dashboard</h2>
                </div>
                <div id="viewTests" class="view-tests">
                    <h2>List of Tests of <%=fullName%></h2>
                    <p>Manage and view all your tests below</p>
                    <table>
                        <thead>
                            <tr>
                                <th>TestID</th>
                                <th>Name of Test</th>
                                <th>Status</th>
                                <th>Course ID</th>
                            </tr>
                        </thead>
                        <tbody>
                            </tr>
                            <% if (tests != null && !tests.isEmpty()) { %>
                            <% for (Test test : tests) { %>
                            <tr>
                                <td><%= test.getTestID() %></td>
                                <td><%= test.getName() %></td>
                                <td class="status-done"><%= test.getStatus() == 1 ? "Not done" : "Done" %></td>
                                <td><%= test.getCourseID() %></td>
                            </tr>
                            <% } %>
                            <% } else { %>
                            <tr>
                                <td colspan="5">Don't have any test</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <div class="button-group">
                        <button id="returnFromTests" class="btn btn-primary return">Return to Dashboard</button>
                    </div>
                </div>
                <div id="viewCourses" class="view-courses">
                    <h2>List of Courses of <%= fullName%></h2>
                    <p>Explore and manage your courses below</p>
                    <table>
                        <thead>
                            <tr>
                                <th>CourseID</th>
                                <th>Name of Course</th>
                                <th>Description</th>
                                <th>Price</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (request.getAttribute("courses") != null) { 
      List<Courses> courses = (List<Courses>) request.getAttribute("courses");
      if (!courses.isEmpty()) {
          for (Courses course : courses) { %>
                            <tr>
                                <td><%= course.getCourseID() %></td>
                                <td><%= course.getName() %></td>
                                <td class="description"><%= course.getDescription() %></td>
                                <td class="price"><%= course.getPrice() %></td>
                            </tr>
                            <% } 
    } else { %>
                            <tr>
                                <td colspan="5">Don't have any course</td>
                            </tr>
                            <% } 
} else { %>
                            <tr>
                                <td colspan="5">Courses data not found</td>
                            </tr>
                            <% } %>

                        </tbody>
                    </table>
                    <div class="button-group">
                        <button id="returnFromCourses" class="btn btn-primary return">Return to Dashboard</button>
                    </div>
                </div>
                <div id="createTest" class="create-test">
                    <h2>Create a New Test</h2>
                    <form id="testForm" action="QuestionController" method="post">
                        <div class="form-group">
                            <label for="testName">Test Name:</label>
                            <input type="text" id="testName" name="testName" placeholder="Enter test name" required>
                        </div>
                        <p>Add questions and options to create your test</p>
                        <input type="hidden" name="testId" value="-1">
                        <div class="question-block">
                            <label for="question1">Question:</label>
                            <textarea id="question1" name="question1" rows="3" placeholder="Enter your question" required></textarea>
                            <div class="options" id="options1">
                                <div class="option">
                                    <input type="radio" name="correct-answer-1" value="optionA1" required>
                                    <input type="text" name="optionA1" placeholder="Option" required>
                                    <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                                </div>
                                <div class="option">
                                    <input type="radio" name="correct-answer-1" value="optionB1">
                                    <input type="text" name="optionB1" placeholder="Option" required>
                                    <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                                </div>
                                <div class="option">
                                    <input type="radio" name="correct-answer-1" value="optionC1">
                                    <input type="text" name="optionC1" placeholder="Option" required>
                                    <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                                </div>
                                <div class="option">
                                    <input type="radio" name="correct-answer-1" value="optionD1">
                                    <input type="text" name="optionD1" placeholder="Option" required>
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
                        <div class="form-buttons">
                            <button type="button" class="btn btn-primary" onclick="addQuestion()">Add Question</button>
                            <button type="submit" class="btn btn-success">Submit Test</button>
                        </div>
                    </form>
                    <div class="button-group">
                        <button id="returnFromCreateTest" class="btn btn-primary return">Return to Dashboard</button>
                    </div>
                </div>
            </main>
        </div>

        <script>
    document.getElementById('testForm').addEventListener('submit', function(event) {
        let questionCount = 1;
        while (document.getElementsByName('question' + questionCount)[0]) {
            let radios = document.getElementsByName('correct-answer-' + questionCount);
            let isChecked = false;
            for (let radio of radios) {
                if (radio.checked) {
                    isChecked = true;
                    break;
                }
            }
            if (!isChecked) {
                alert('Please select a correct answer for question ' + questionCount);
                event.preventDefault();
                return;
            }
            questionCount++;
        }
    });
            // Lấy các phần tử nút và nội dung
            const viewTestsBtn = document.getElementById('viewTestsBtn');
            const viewCoursesBtn = document.getElementById('viewCoursesBtn');
            const createTestBtn = document.getElementById('createTestBtn');

            const welcome = document.getElementById('welcome');
            const viewTests = document.getElementById('viewTests');
            const viewCourses = document.getElementById('viewCourses');
            const createTest = document.getElementById('createTest');

            const returnFromTests = document.getElementById('returnFromTests');
            const returnFromCourses = document.getElementById('returnFromCourses');
            const returnFromCreateTest = document.getElementById('returnFromCreateTest');

            // Hàm ẩn tất cả các phần nội dung
            function hideAll() {
                welcome.classList.remove('active');
                viewTests.classList.remove('active');
                viewCourses.classList.remove('active');
                createTest.classList.remove('active');
            }

            // Sự kiện nhấp chuột cho "View My Tests"
            viewTestsBtn.addEventListener('click', () => {
                hideAll();
                viewTests.classList.add('active');
            });

            // Sự kiện nhấp chuột cho "View My Courses"
            viewCoursesBtn.addEventListener('click', () => {
                hideAll();
                viewCourses.classList.add('active');
            });

            // Sự kiện nhấp chuột cho "Create Test"
            createTestBtn.addEventListener('click', () => {
                hideAll();
                createTest.classList.add('active');
            });

            // Sự kiện nhấp chuột cho các nút "Return to Dashboard"
            returnFromTests.addEventListener('click', () => {
                hideAll();
                welcome.classList.add('active');
            });

            returnFromCourses.addEventListener('click', () => {
                hideAll();
                welcome.classList.add('active');
            });

            returnFromCreateTest.addEventListener('click', () => {
                hideAll();
                welcome.classList.add('active');
            });

            // Chức năng cho Create Test
            let questionCount = 1;

            function addOption(optionsId) {
                const optionsContainer = document.getElementById(optionsId);
                const optionDiv = document.createElement('div');
                optionDiv.className = 'option';
                optionDiv.innerHTML = `
                    <input type="radio" name="correct-answer-${questionCount}">
                    <input type="text" placeholder="Option" required>
                    <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
                `;
                optionsContainer.appendChild(optionDiv);
            }

            function removeOption(button) {
                const optionDiv = button.parentElement;
                if (optionDiv.parentElement.children.length > 1) {
                    optionDiv.remove();
                }
            }

            function addQuestion() {
                questionCount++;
                const form = document.getElementById('testForm');
                const questionBlock = document.createElement('div');
                questionBlock.className = 'question-block';
                questionBlock.innerHTML = `
        <label for="question${questionCount}">Question:</label>
        <textarea id="question${questionCount}" name="question${questionCount}" rows="3" placeholder="Enter your question" required></textarea>
        <div class="options" id="options${questionCount}">
            <div class="option">
                <input type="radio" name="correct-answer-${questionCount}" value="optionA${questionCount}" required>
                <input type="text" name="optionA${questionCount}" placeholder="Option" required>
                <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
            </div>
            <div class="option">
                <input type="radio" name="correct-answer-${questionCount}" value="optionB${questionCount}">
                <input type="text" name="optionB${questionCount}" placeholder="Option" required>
                <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
            </div>
            <div class="option">
                <input type="radio" name="correct-answer-${questionCount}" value="optionC${questionCount}">
                <input type="text" name="optionC${questionCount}" placeholder="Option" required>
                <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
            </div>
            <div class="option">
                <input type="radio" name="correct-answer-${questionCount}" value="optionD${questionCount}">
                <input type="text" name="optionD${questionCount}" placeholder="Option" required>
                <button type="button" class="btn-small remove" onclick="removeOption(this)">x</button>
            </div>
        </div>
        <!-- ... -->
    `;
                form.insertBefore(questionBlock, form.lastElementChild);
            }
            function removeQuestion(button) {
                const questionBlock = button.parentElement.parentElement;
                if (questionBlock.parentElement.children.length > 1) {
                    questionBlock.remove();
                }
            }
        </script>
    </body>
</html>