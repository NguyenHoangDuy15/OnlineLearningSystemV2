<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quiz Test</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* Hiệu ứng fade-in cho câu hỏi */
        .question-container {
            opacity: 0;
            transform: translateY(10px);
            transition: opacity 0.5s ease, transform 0.5s ease;
        }
        .question-container.show {
            opacity: 1;
            transform: translateY(0);
        }

        /* Thanh tiến trình */
        .progress {
            height: 10px;
        }
        .progress-bar {
            transition: width 0.5s ease-in-out;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="card">
            <div class="card-body">

                <!-- Thanh tiến trình -->
                <c:set var="progressPercent" value="${(currentIndex + 1) * 100 / totalQuestions}" />
                <div class="progress mb-3">
                    <div class="progress-bar bg-success" role="progressbar" style="width: ${progressPercent}%;">
                    </div>
                </div>

                <c:set var="currentIndex" value="${sessionScope.currentIndex != null ? sessionScope.currentIndex : 0}" />
                <c:set var="totalQuestions" value="${questions.size()}" />
                <c:set var="q" value="${questions[currentIndex]}" />

                <div class="question-container">
                    <form action="TestAnswer" method="post">
                        <h5 class="card-title">Question ${q.questionID}:</h5>
                        <p class="card-text">${q.questionContent}</p>

                        <c:set var="selectedAnswer" value="${sessionScope.userAnswers[q.questionID]}" />
                        <c:set var="options" value="A,B,C,D" />

                        <c:forEach var="option" items="${fn:split(options, ',')}">
                            <div class="form-check">
                                <input class="form-check-input answer-option" type="radio" name="answer" value="${option}"
                                       ${selectedAnswer == option ? 'checked' : ''} required>
                                <label class="form-check-label">${q['option'.concat(option)]}</label>
                            </div>
                        </c:forEach>

                        <input type="hidden" name="currentIndex" value="${currentIndex}">
                        <input type="hidden" name="questionID" value="${q.questionID}">

                        <div class="mt-3">
                            <c:if test="${currentIndex > 0}">
                                <button type="submit" name="action" value="previous" class="btn btn-secondary">Previous</button>
                            </c:if>
                            <c:if test="${currentIndex < totalQuestions - 1}">
                                <button type="submit" name="action" value="next" class="btn btn-primary">Next</button>
                            </c:if>
                            <c:if test="${currentIndex == totalQuestions - 1}">
                                <button type="submit" name="action" value="submit" class="btn btn-success">Submit</button>
                            </c:if>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <!-- Hiệu ứng jQuery -->
    <script>
        $(document).ready(function () {
            // Hiệu ứng fade-in khi tải trang
            $(".question-container").addClass("show");

            // Âm thanh khi chọn đáp án
            $(".answer-option").on("change", function () {
                let audio = new Audio("https://www.fesliyanstudios.com/play-mp3/387");
                audio.play();
            });
        });
    </script>

</body>
</html>
