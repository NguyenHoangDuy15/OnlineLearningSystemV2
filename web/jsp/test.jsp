<!DOCTYPE html>
<html lang="en">
<head>
     <head>
        <meta charset="utf-8">
        <title>Edukate - Online Education Website Template</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">

        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet"> 
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
    </head>
    <head>
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
