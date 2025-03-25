<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.TestEX" %>
<%@ page import="Model.CourseEX" %>
<%@ page import="Model.QuestionEX" %>
<%@ page import="dal.TestEXDAO" %>
<%@ page import="dal.CourseEXDAO" %>
<%@ page import="Model.User" %>
<%@ page import="Model.Usernew" %>
<%@ page import="dal.UserDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Test - Online Learning</title>
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
            margin: 0;
        }

        .user-profile img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            border: 2px solid var(--primary);
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
        }

        .dropdown a:hover {
            background-color: var(--secondary);
        }

        .container {
            padding: 32px;
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
            position: relative;
        }

        .delete-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 5px 10px;
            background: var(--gradient-danger);
            color: #FFFFFF;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 12px;
        }

        .form-buttons {
            display: flex;
            gap: 12px;
            margin-top: 24px;
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

        .btn-primary { background: var(--gradient-primary); color: #FFFFFF; }
        .btn-success { background: var(--gradient-success); color: #FFFFFF; }
        .btn-add { background: var(--gradient-primary); color: #FFFFFF; }
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
        <div class="create-test">
            <h2>Create a New Test</h2>
            <% String error = (String) request.getAttribute("error"); %>
            <% String success = (String) request.getAttribute("success"); %>
            <% if (success != null && !success.isEmpty()) { %>
                <div class="notification success"><%= success %></div>
            <% } %>
            <% if (error != null && !error.isEmpty()) { %>
                <div class="notification error"><%= error %></div>
            <% } %>

            <% 
                Integer questionCount = (Integer) request.getAttribute("questionCount");
                if (questionCount == null) {
                    questionCount = 1; // Mặc định 1 câu hỏi
                }
                String testName = (String) request.getAttribute("testName");
                String[] questions = (String[]) request.getAttribute("questions");
                String[] optionsA = (String[]) request.getAttribute("optionsA");
                String[] optionsB = (String[]) request.getAttribute("optionsB");
                String[] optionsC = (String[]) request.getAttribute("optionsC");
                String[] optionsD = (String[]) request.getAttribute("optionsD");
                String[] correctAnswers = (String[]) request.getAttribute("correctAnswers");
            %>

            <form id="testForm" action="QuestionController" method="post">
                <input type="hidden" name="courseId" value="<%= request.getAttribute("courseId") %>">
                <input type="hidden" name="testId" value="-1">
                <input type="hidden" name="questionCount" value="<%= questionCount %>">
                <div class="form-group">
                    <label for="testName">Test Name:</label>
                    <input type="text" id="testName" name="testName" placeholder="Enter test name" 
                           value="<%= testName != null ? testName : "" %>" required>
                </div>
                <p>Fill in the questions and options below (at least one question is required):</p>
                <% for (int i = 0; i < questionCount; i++) { %>
                <div class="question-block">
                    <label for="questions[<%= i %>]">Question <%= i + 1 %>:</label>
                    <textarea id="questions[<%= i %>]" name="questions[<%= i %>]" rows="3" 
                              placeholder="Enter your question"><%= questions != null && i < questions.length && questions[i] != null ? questions[i] : "" %></textarea>
                    <div class="options">
                        <div class="option">
                            <input type="radio" name="correctAnswers[<%= i %>]" value="A" 
                                   <%= correctAnswers != null && i < correctAnswers.length && "A".equals(correctAnswers[i]) ? "checked" : "" %>>
                            <input type="text" name="optionsA[<%= i %>]" placeholder="Option A" 
                                   value="<%= optionsA != null && i < optionsA.length && optionsA[i] != null ? optionsA[i] : "" %>">
                        </div>
                        <div class="option">
                            <input type="radio" name="correctAnswers[<%= i %>]" value="B" 
                                   <%= correctAnswers != null && i < correctAnswers.length && "B".equals(correctAnswers[i]) ? "checked" : "" %>>
                            <input type="text" name="optionsB[<%= i %>]" placeholder="Option B" 
                                   value="<%= optionsB != null && i < optionsB.length && optionsB[i] != null ? optionsB[i] : "" %>">
                        </div>
                        <div class="option">
                            <input type="radio" name="correctAnswers[<%= i %>]" value="C" 
                                   <%= correctAnswers != null && i < correctAnswers.length && "C".equals(correctAnswers[i]) ? "checked" : "" %>>
                            <input type="text" name="optionsC[<%= i %>]" placeholder="Option C" 
                                   value="<%= optionsC != null && i < optionsC.length && optionsC[i] != null ? optionsC[i] : "" %>">
                        </div>
                        <div class="option">
                            <input type="radio" name="correctAnswers[<%= i %>]" value="D" 
                                   <%= correctAnswers != null && i < correctAnswers.length && "D".equals(correctAnswers[i]) ? "checked" : "" %>>
                            <input type="text" name="optionsD[<%= i %>]" placeholder="Option D" 
                                   value="<%= optionsD != null && i < optionsD.length && optionsD[i] != null ? optionsD[i] : "" %>">
                        </div>
                    </div>
                    <% if (questionCount > 1) { %>
                        <button type="submit" name="action" value="deleteQuestion" class="delete-btn" 
                                onclick="this.form.elements['deleteIndex'].value = <%= i %>">Delete Question</button>
                    <% } %>
                </div>
                <% } %>
                <input type="hidden" name="deleteIndex" value="-1">
                <div class="form-buttons">
                    <button type="submit" name="action" value="addQuestion" class="btn btn-add">Add Question</button>
                    <button type="submit" name="action" value="submit" class="btn btn-success">Submit Test</button>
                    <a href="ShowexpertServlet"><button type="button" class="btn btn-primary">Return to Dashboard</button></a>
                </div>
            </form>
        </div>
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
    </script>
</body>
</html>