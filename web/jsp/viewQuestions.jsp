<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.QuestionEX" %>
<%@ page import="Model.TestEX" %>
<%@ page import="dal.TestEXDAO" %>

<%
    List<QuestionEX> questions = (List<QuestionEX>) request.getAttribute("questions");
    TestEX test = (TestEX) request.getAttribute("test");
    TestEXDAO testDAO = new TestEXDAO();
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Questions - Online Learning</title>
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

            .notification {
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: center;
                display: none;
            }

            .notification.error {
                color: var(--accent-red);
                background-color: #ffe6e6;
                border: 1px solid var(--accent-red);
                display: block;
            }

            .main-content {
                width: 80%;
                margin: 0 auto;
                background-color: var(--background);
                padding: 32px;
                min-height: calc(100vh - 72px);
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
        </style>
    </head>
    <body>
       <header class="header">
        <a href="ShowexpertServlet" class="logo">
            <h1>Online Learning</h1>
        </a>
            </div>
        </div>
    </header>

        <main class="main-content">
            <% if (error != null && !error.isEmpty()) { %>
            <div class="notification error"><%= error %></div>
            <% } %>

            <div class="question-list">
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
                <button class="btn btn-primary" onclick="window.location.href='ShowexpertServlet'">Return to Dashboard</button>
            </div>
        </main>
    </body>
</html>