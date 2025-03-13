<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Test</title>
    <style>
        .correct {
            background-color: lightgreen;
        }
        .option {
            margin-bottom: 10px;
            padding: 5px;
        }
        .option input {
            margin-right: 10px;
        }
        .option label {
            margin-left: 5px;
        }
        .message {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .success {
            color: green;
        }
        .error {
            color: red;
        }
    </style>
    <script>
        function addQuestion() {
            let container = document.getElementById("questionsContainer");
            let questionCount = container.getElementsByClassName("question-block").length + 1;

            let div = document.createElement("div");
            div.className = "question-block";
            div.dataset.questionNumber = questionCount;

            let optionsContainer = document.createElement("div");
            optionsContainer.className = "options";
            optionsContainer.id = `options${questionCount}`;

            div.innerHTML = `
                <p>Question ${questionCount}:</p>
                <input type="text" name="question${questionCount}" placeholder="Enter question" required>
            `;
            div.appendChild(optionsContainer);

            for (let i = 1; i <= 4; i++) {
                let optionDiv = document.createElement("div");
                optionDiv.className = "option";
                optionDiv.innerHTML = `
                    <input type="radio" name="question${questionCount}_correct" value="${i}">
                    <input type="text" name="question${questionCount}_option${i}" placeholder="Option ${i}" required>
                `;
                optionsContainer.appendChild(optionDiv);
            }

            let addOptionButton = document.createElement("button");
            addOptionButton.type = "button";
            addOptionButton.textContent = "+ Add Option";
            addOptionButton.addEventListener("click", function () {
                addOption(questionCount);
            });

            let deleteQuestionButton = document.createElement("button");
            deleteQuestionButton.type = "button";
            deleteQuestionButton.textContent = "Delete Question";
            deleteQuestionButton.addEventListener("click", function () {
                deleteQuestion(div);
            });

            div.appendChild(addOptionButton);
            div.appendChild(deleteQuestionButton);
            div.innerHTML += `<hr>`;

            container.appendChild(div);
        }

        function addOption(questionNumber) {
            let optionsContainer = document.getElementById(`options${questionNumber}`);
            if (!optionsContainer)
                return;

            let optionCount = optionsContainer.getElementsByClassName("option").length + 1;
            let optionDiv = document.createElement("div");
            optionDiv.className = "option";
            optionDiv.innerHTML = `
                <input type="radio" name="question${questionNumber}_correct" value="${optionCount}">
                <input type="text" name="question${questionNumber}_option${optionCount}" placeholder="Option ${optionCount}" required>
            `;
            optionsContainer.appendChild(optionDiv);
        }

        function deleteQuestion(questionDiv) {
            questionDiv.remove();
        }

        window.onload = function () {
            addQuestion();
        };
    </script>
</head>
<body>
    <h2>Create a Test</h2>

 <c:if test="${not empty message}">
    <div class="alert">
        <p>${message}</p>
    </div>
</c:if>


    <form action="TestServlet" method="get">
        <div id="questionsContainer"></div>
        <button type="button" onclick="addQuestion()">+ Add Question</button>
        <br><br>
        <input type="submit" value="Submit Test">
    </form>
</body>
</html>
