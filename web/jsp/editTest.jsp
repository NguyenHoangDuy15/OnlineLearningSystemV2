<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.TestEX" %>
<%@ page import="Model.QuestionEX" %>
<%@ page import="dal.QuestionEXDAO" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    TestEX test = (TestEX) request.getAttribute("test");
    List<QuestionEX> questions = (List<QuestionEX>) request.getAttribute("questions");
    QuestionEXDAO questionDAO = new QuestionEXDAO();
%>

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

        .question-block.error {
            border-color: var(--accent-red);
            background-color: rgba(231, 76, 60, 0.1);
        }

        .question-block.new {
            border-color: var(--accent-green);
            background-color: rgba(46, 204, 113, 0.1);
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
            justify-content: space-between;
            align-items: center;
        }

        .form-buttons {
            display: flex;
            gap: 12px;
            justify-content: flex-start;
            margin-top: 24px;
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
        <div class="logo">
            <h1>Online Learning</h1>
        </div>
        <div class="user-profile">
            <img src="avatar.png" alt="User Avatar" onclick="toggleDropdown()">
            <div class="dropdown" id="dropdownMenu">
                <a href="#">View Profile</a>
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
            <% 
                String message = request.getParameter("message");
                if (message != null && !message.isEmpty()) { 
            %>
                <p style="color: var(--accent-green); font-weight: bold;"><%= message %></p>
            <% } %>
            <% if (test != null) { %>
                <form id="editTestForm" action="TestServlet" method="post">
                    <input type="hidden" name="action" value="updateTest">
                    <input type="hidden" name="testId" id="editTestId" value="<%= test.getTestID() %>">
                    <div class="form-group">
                        <label for="editTestName">Test Name:</label>
                        <input type="text" id="editTestName" name="testName" value="<%= test.getName() != null ? test.getName() : "" %>" required>
                    </div>
                    <div id="editQuestionsContainer">
                        <% if (questions != null && !questions.isEmpty()) { %>
                            <% for (int i = 0; i < questions.size(); i++) { 
                                QuestionEX question = questions.get(i);
                                String correctAnswer = questionDAO.getCorrectAnswerByQuestionId(question.getQuestionID());
                                boolean noCorrectAnswer = (correctAnswer == null);
                                if (noCorrectAnswer) {
                                    correctAnswer = "A"; // Mặc định chọn A nếu không có đáp án đúng
                                }
                            %>
                                <div class="question-block" data-index="<%= i %>">
                                    <!-- Thêm trường ẩn để lưu QuestionID -->
                                    <input type="hidden" name="questionId[]" value="<%= question.getQuestionID() %>">
                                    <div class="form-group">
                                        <label for="editQuestion<%= i %>">Question:</label>
                                        <textarea id="editQuestion<%= i %>" name="question[]" rows="3" required><%= question.getQuestionContent() != null ? question.getQuestionContent() : "" %></textarea>
                                    </div>
                                    <% if (noCorrectAnswer) { %>
                                        <p style="color: var(--accent-red);">No correct answer found for this question. Defaulting to A. Please confirm.</p>
                                    <% } %>
                                    <div class="options">
                                        <div class="option">
                                            <input type="radio" name="correctAnswer[<%= i %>]" value="A" <%= "A".equals(correctAnswer) ? "checked" : "" %>>
                                            <label>Option</label>
                                            <label>A:</label>
                                            <input type="text" name="optionA[]" value="<%= question.getOptionA() != null ? question.getOptionA() : "" %>" required>
                                        </div>
                                        <div class="option">
                                            <input type="radio" name="correctAnswer[<%= i %>]" value="B" <%= "B".equals(correctAnswer) ? "checked" : "" %>>
                                            <label>Option</label>
                                            <label>B:</label>
                                            <input type="text" name="optionB[]" value="<%= question.getOptionB() != null ? question.getOptionB() : "" %>" required>
                                        </div>
                                        <div class="option">
                                            <input type="radio" name="correctAnswer[<%= i %>]" value="C" <%= "C".equals(correctAnswer) ? "checked" : "" %>>
                                            <label>Option</label>
                                            <label>C:</label>
                                            <input type="text" name="optionC[]" value="<%= question.getOptionC() != null ? question.getOptionC() : "" %>" required>
                                        </div>
                                        <div class="option">
                                            <input type="radio" name="correctAnswer[<%= i %>]" value="D" <%= "D".equals(correctAnswer) ? "checked" : "" %>>
                                            <label>Option</label>
                                            <label>D:</label>
                                            <input type="text" name="optionD[]" value="<%= question.getOptionD() != null ? question.getOptionD() : "" %>" required>
                                        </div>
                                    </div>
                                    <div class="form-actions">
                                        <button type="button" class="btn btn-danger" onclick="deactivateQuestion(<%= question.getQuestionID() %>, <%= test.getTestID() %>)">Delete Question</button>
                                    </div>
                                </div>
                            <% } %>
                        <% } else { %>
                            <p>No questions available. You can add new questions below.</p>
                        <% } %>
                    </div>
                    <div class="form-buttons">
                        <button type="button" class="btn btn-primary add-question" onclick="addEditQuestion()">Add Question</button>
                        <button type="submit" class="btn btn-success">Save Changes</button>
                    </div>
                </form>
            <% } else { %>
                <p>Test not found.</p>
            <% } %>
            <button class="btn btn-primary" onclick="window.location.href='CourseServlet?courseId=<%= test != null ? test.getCourseID() : 0 %>'">Return to Course Details</button>
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

        function updateQuestionIndices() {
            const editQuestionsContainer = document.getElementById('editQuestionsContainer');
            const questionBlocks = editQuestionsContainer.getElementsByClassName('question-block');
            for (let i = 0; i < questionBlocks.length; i++) {
                const block = questionBlocks[i];
                block.setAttribute('data-index', i);

                // Cập nhật name của các trường
                const correctAnswerRadios = block.querySelectorAll(`input[name^="correctAnswer"]`);
                correctAnswerRadios.forEach(radio => {
                    const currentValue = radio.value;
                    radio.name = `correctAnswer[${i}]`;
                    if (radio.checked) {
                        radio.checked = true; // Giữ trạng thái checked
                    }
                });

                const questionTextarea = block.querySelector('textarea[name="question[]"]');
                questionTextarea.name = `question[]`;

                const optionAInput = block.querySelector('input[name="optionA[]"]');
                optionAInput.name = `optionA[]`;

                const optionBInput = block.querySelector('input[name="optionB[]"]');
                optionBInput.name = `optionB[]`;

                const optionCInput = block.querySelector('input[name="optionC[]"]');
                optionCInput.name = `optionC[]`;

                const optionDInput = block.querySelector('input[name="optionD[]"]');
                optionDInput.name = `optionD[]`;

                const questionIdInput = block.querySelector('input[name="questionId[]"]');
                questionIdInput.name = `questionId[]`;
            }
        }

        function addEditQuestion() {
            const editQuestionsContainer = document.getElementById('editQuestionsContainer');
            const qCount = editQuestionsContainer.getElementsByClassName('question-block').length;
            const newQuestionBlock = document.createElement('div');
            newQuestionBlock.classList.add('question-block', 'new'); // Thêm class 'new' để phân biệt
            newQuestionBlock.setAttribute('data-index', qCount);
            newQuestionBlock.innerHTML = `
                <!-- Trường ẩn cho câu hỏi mới (không có QuestionID) -->
                <input type="hidden" name="questionId[]" value="">
                <div class="form-group">
                    <label for="editQuestion${qCount}">Question (New):</label>
                    <textarea id="editQuestion${qCount}" name="question[]" rows="3" placeholder="Enter your question" required></textarea>
                </div>
                <div class="options">
                    <div class="option">
                        <input type="radio" name="correctAnswer[${qCount}]" value="A" checked>
                        <label>Option</label>
                        <label>A:</label>
                        <input type="text" name="optionA[]" placeholder="Option A" required>
                    </div>
                    <div class="option">
                        <input type="radio" name="correctAnswer[${qCount}]" value="B">
                        <label>Option</label>
                        <label>B:</label>
                        <input type="text" name="optionB[]" placeholder="Option B" required>
                    </div>
                    <div class="option">
                        <input type="radio" name="correctAnswer[${qCount}]" value="C">
                        <label>Option</label>
                        <label>C:</label>
                        <input type="text" name="optionC[]" placeholder="Option C" required>
                    </div>
                    <div class="option">
                        <input type="radio" name="correctAnswer[${qCount}]" value="D">
                        <label>Option</label>
                        <label>D:</label>
                        <input type="text" name="optionD[]" placeholder="Option D" required>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-danger" onclick="removeEditQuestion(this)">Delete Question</button>
                </div>
            `;
            editQuestionsContainer.appendChild(newQuestionBlock);
            updateQuestionIndices();
        }

        function removeEditQuestion(button) {
            const questionBlock = button.parentElement.parentElement;
            questionBlock.remove();
            updateQuestionIndices();
        }

        function deactivateQuestion(questionId, testId) {
            if (confirm("Are you sure you want to delete this question?")) {
                fetch(`TestServlet?action=deactivateQuestion&questionId=${questionId}&testId=${testId}`, {
                    method: 'POST'
                })
                .then(response => {
                    if (response.ok) {
                        alert("Question deactivated successfully!");
                        window.location.reload();
                    } else {
                        alert("Failed to deactivate question.");
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert("An error occurred while deactivating the question.");
                });
            }
        }

        document.getElementById('editTestForm').addEventListener('submit', function (event) {
            event.preventDefault();
            let isValid = true;
            const questions = document.getElementsByName('question[]');
            const questionBlocks = document.getElementsByClassName('question-block');

            // Xóa trạng thái lỗi trước đó
            for (let block of questionBlocks) {
                block.classList.remove('error');
            }

            // Kiểm tra tính hợp lệ của dữ liệu (nếu có câu hỏi)
            if (questions.length > 0) {
                for (let i = 0; i < questions.length; i++) {
                    const questionContent = questions[i].value.trim();
                    const radios = document.getElementsByName(`correctAnswer[${i}]`);
                    const optionA = document.getElementsByName(`optionA[]`)[i].value.trim();
                    const optionB = document.getElementsByName(`optionB[]`)[i].value.trim();
                    const optionC = document.getElementsByName(`optionC[]`)[i].value.trim();
                    const optionD = document.getElementsByName(`optionD[]`)[i].value.trim();
                    const questionBlock = questionBlocks[i];

                    // Kiểm tra nội dung câu hỏi
                    if (!questionContent) {
                        alert(`Question ${i + 1} content cannot be empty`);
                        questionBlock.classList.add('error');
                        isValid = false;
                        break;
                    }

                    // Kiểm tra các lựa chọn A, B, C, D
                    if (!optionA || !optionB || !optionC || !optionD) {
                        alert(`All options for Question ${i + 1} must be filled`);
                        questionBlock.classList.add('error');
                        isValid = false;
                        break;
                    }

                    // Kiểm tra đáp án đúng
                    let isChecked = false;
                    for (let radio of radios) {
                        if (radio.checked) {
                            isChecked = true;
                            break;
                        }
                    }
                    if (!isChecked) {
                        alert(`Please select a correct answer for Question ${i + 1}`);
                        questionBlock.classList.add('error');
                        isValid = false;
                        break;
                    }
                }
            }

            // Nếu hợp lệ, gửi form
            if (isValid) {
                alert("Saving changes...");
                this.submit();
            }
        });
    </script>
</body>
</html>