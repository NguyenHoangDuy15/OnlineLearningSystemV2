<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dal.QuestionEXDAO" %>
<%@ page import="Model.TestEX" %>
<%@ page import="Model.QuestionEX" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Test - Online Learning</title>
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

        .user-profile {
            position: relative; /* Để dropdown định vị tương đối với user-profile */
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
            display: none; /* Ẩn mặc định */
            position: absolute;
            right: 0;
            top: 50px; /* Khoảng cách từ ảnh đại diện */
            background-color: var(--background);
            box-shadow: 0 4px 8px var(--shadow);
            border-radius: 8px;
            z-index: 1000;
            min-width: 150px; /* Đảm bảo dropdown có chiều rộng tối thiểu */
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

        .main-content {
            width: 80%;
            background-color: var(--background);
            padding: 32px;
            overflow-y: auto;
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
                    <button class="btn btn-primary" onclick="window.location.href='ShowexpertServlet#testList'">View Owner Test</button>
                    <button class="btn btn-primary" onclick="window.location.href='ShowexpertServlet#courseList'">View Owner Course</button>
                </div>
            </div>
            <div class="button-group">
                <button class="btn btn-danger logout" onclick="window.location.href='LogoutServlet'">Logout</button>
            </div>
        </aside>

        <main class="main-content">
            <h2>Edit Test</h2>
            <c:if test="${not empty success}">
                <div class="notification success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="notification error">${error}</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty test}">
                    <form action="TestServlet" method="post" id="updateTestForm">
                        <input type="hidden" name="testId" value="${test.testID}">
                        <input type="hidden" name="questionCount" value="${questions.size()}">
                        <input type="hidden" name="deleteIndex" value="-1">
                        <div class="form-group">
                            <label for="testName">Test Name:</label>
                            <input type="text" id="testName" name="testName" value="${test.name}" required>
                        </div>
                        <div id="questionsContainer">
                            <c:forEach var="question" items="${questions}" varStatus="loop">
                                <jsp:useBean id="questionDAO" class="dal.QuestionEXDAO" scope="page"/>
                                <c:set var="correctAnswer" value="${questionDAO.getCorrectAnswerByQuestionId(question.questionID)}"/>
                                <div class="question-block">
                                    <input type="hidden" name="questionId[]" value="${question.questionID != -1 ? question.questionID : ''}">
                                    <div class="form-group">
                                        <label>Question ${loop.count}:</label>
                                        <textarea name="question[]" latexit="false" rows="3">${question.questionContent != null ? question.questionContent : ''}</textarea>
                                    </div>
                                    <div class="options">
                                        <div class="option">
                                            <input type="radio" name="correctAnswer_${loop.index}" value="A" ${correctAnswer == 'A' ? 'checked' : ''}>
                                            <label>Option A:</label>
                                            <input type="text" name="optionA[]" value="${question.optionA != null ? question.optionA : ''}">
                                        </div>
                                        <div class="option">
                                            <input type="radio" name="correctAnswer_${loop.index}" value="B" ${correctAnswer == 'B' ? 'checked' : ''}>
                                            <label>Option B:</label>
                                            <input type="text" name="optionB[]" value="${question.optionB != null ? question.optionB : ''}">
                                        </div>
                                        <div class="option">
                                            <input type="radio" name="correctAnswer_${loop.index}" value="C" ${correctAnswer == 'C' ? 'checked' : ''}>
                                            <label>Option C:</label>
                                            <input type="text" name="optionC[]" value="${question.optionC != null ? question.optionC : ''}">
                                        </div>
                                        <div class="option">
                                            <input type="radio" name="correctAnswer_${loop.index}" value="D" ${correctAnswer == 'D' ? 'checked' : ''}>
                                            <label>Option D:</label>
                                            <input type="text" name="optionD[]" value="${question.optionD != null ? question.optionD : ''}">
                                        </div>
                                    </div>
                                    <div class="form-actions">
                                        <button type="submit" name="action" value="deleteQuestion" class="btn btn-danger" 
                                                onclick="this.form.elements['deleteIndex'].value = ${loop.index}">Delete Question</button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="form-buttons">
                            <button type="submit" name="action" value="addQuestion" class="btn btn-primary">Add Question</button>
                            <button type="submit" name="action" value="updateTest" class="btn btn-success">Save Changes</button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <p>Test not found.</p>
                </c:otherwise>
            </c:choose>
                    
            <button class="btn btn-primary" onclick="window.location.href='CourseServlet?courseId=${test != null ? test.courseID : 0}'">Return to Course Details</button>
        </main>
    </div>

    <script>
        function toggleDropdown() {
            const dropdown = document.getElementById('dropdownMenu');
            // Chuyển đổi giữa hiển thị và ẩn
            dropdown.style.display = (dropdown.style.display === 'block') ? 'none' : 'block';
        }

        // Đóng dropdown khi nhấp ra ngoài
        document.addEventListener('click', function(event) {
            const userProfile = document.querySelector('.user-profile');
            const dropdown = document.getElementById('dropdownMenu');
            
            // Nếu nhấp ra ngoài user-profile và dropdown đang mở, thì đóng nó
            if (!userProfile.contains(event.target) && dropdown.style.display === 'block') {
                dropdown.style.display = 'none';
            }
        });
    </script>
</body>
</html>