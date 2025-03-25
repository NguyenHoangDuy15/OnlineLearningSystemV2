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
            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                position: relative;
            }

            .card {
                border: none;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s;
                height: 100%;
            }

            .card:hover {
                transform: translateY(-5px);
            }

            .question-container {
                opacity: 0;
                transform: translateY(10px);
                transition: opacity 0.5s ease, transform 0.5s ease;
            }
            .question-container.show {
                opacity: 1;
                transform: translateY(0);
            }

            .progress {
                height: 15px;
                border-radius: 10px;
                background-color: #e9ecef;
            }
            .progress-bar {
                transition: width 0.5s ease-in-out;
                background: linear-gradient(to right, #28a745, #20c997);
            }

            .card-title {
                color: #2c3e50;
                font-weight: 600;
            }

            .form-check {
                padding: 15px;
                margin: 5px 0;
                border-radius: 8px;
                transition: background-color 0.3s;
            }

            .form-check:hover {
                background-color: #f8f9fa;
            }

            .form-check.selected {
                background-color: #d4edda;
            }

            .btn, .btn-link {
                padding: 10px 25px;
                border-radius: 25px;
                transition: all 0.3s;
            }

            .btn:hover, .btn-link:hover {
                transform: translateY(-2px);
                text-decoration: none;
            }

            .btn-danger {
                background-color: #dc3545;
                border-color: #dc3545;
                border-radius: 25px;
            }

            .btn-danger:hover {
                background-color: #c82333;
                border-color: #bd2130;
            }

            .mark-uncertain {
                cursor: pointer;
                transition: transform 0.2s;
                font-size: 24px;
            }

            .mark-uncertain.marked {
                color: #dc3545;
                transform: scale(1.2);
            }

            .question-list {
                max-height: 400px;
                overflow-y: auto;
                padding: 10px;
            }

            .question-item {
                width: 40px;
                height: 40px;
                line-height: 40px;
                text-align: center;
                border-radius: 50%;
                margin: 5px;
                color: white;
                font-weight: bold;
                display: inline-block;
                cursor: pointer;
            }

            .answered {
                background-color: #28a745;
            }

            .uncertain {
                background-color: #ffca2c;
            }

            .default {
                background-color: #6c757d;
            }

            .row.equal-height {
                display: flex;
                flex-wrap: wrap;
            }

            .row.equal-height > [class*='col-'] {
                display: flex;
                flex-direction: column;
            }

            .row.equal-height > [class*='col-'] > .card {
                flex: 1;
            }

            .card-body {
                position: relative;
                min-height: 400px;
            }

            .mark-uncertain {
                display: block;
                text-align: right;
            }

            .cancel-test-container {
                position: absolute;
                bottom: 20px;
                right: 20px;
            }

            /* Modal Styling */
            .modal-content {
                border-radius: 15px;
            }

            .modal-header {
                background-color: #f8d7da;
                color: #721c24;
                border-top-left-radius: 15px;
                border-top-right-radius: 15px;
            }

            .modal-footer {
                justify-content: space-between;
            }

            .countdown-timer {
                font-weight: bold;
                color: #dc3545;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <div class="row equal-height">
                <!-- Cột hiển thị danh sách câu hỏi -->
                <div class="col-md-3">
                    <div class="card">
                        <div class="card-body">
                            <h6 class="text-center">Question List</h6>
                            <div class="question-list">
                                <c:choose>
                                    <c:when test="${not empty questions}">
                                        <c:forEach var="i" begin="0" end="${questions.size() - 1}">
                                            <c:set var="qItem" value="${questions[i]}" />
                                            <c:set var="isAnswered" value="${sessionScope.userAnswers[qItem.questionID] != null}" />
                                            <c:set var="isUncertain" value="${sessionScope.uncertainQuestions[qItem.questionID] != null}" />
                                            <div class="question-item ${isUncertain ? 'uncertain' : isAnswered ? 'answered' : 'default'}" 
                                                 data-question-id="${qItem.questionID}"
                                                 onclick="navigateToQuestion(${qItem.questionID})">
                                                ${i + 1}
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p>No questions available.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Nội dung câu hỏi -->
                <div class="col-md-9">
                    <div class="card">
                        <div class="card-body">
                            <c:set var="progressPercent" value="${(currentIndex + 1) * 100 / questions.size()}" />
                            <div class="progress mb-4">
                                <div class="progress-bar bg-success" role="progressbar" 
                                     style="width: ${progressPercent}%;" 
                                     aria-valuenow="${progressPercent}" 
                                     aria-valuemin="0" 
                                     aria-valuemax="100">
                                </div>
                            </div>

                            <c:set var="currentIndex" value="${sessionScope.currentIndex != null ? sessionScope.currentIndex : 0}" />
                            <c:set var="totalQuestions" value="${questions.size()}" />
                            <c:set var="q" value="${questions[currentIndex]}" />

                            <div class="question-container">
                                <form action="TestAnswer" method="post" id="testForm">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <h5 class="card-title">Question ${currentIndex + 1}:</h5>
                                        <span class="mark-uncertain ${sessionScope.uncertainQuestions[q.questionID] != null ? 'marked' : ''}" 
                                              data-question-id="${q.questionID}" 
                                              title="Mark as uncertain"
                                              onclick="markAsUncertain(${q.questionID})">
                                            ⭐
                                        </span>
                                    </div>
                                    <p class="card-text">${q.questionContent}</p>

                                    <c:set var="selectedAnswer" value="${sessionScope.userAnswers[q.questionID]}" />
                                    <c:set var="options" value="A,B,C,D" />

                                    <c:forEach var="option" items="${fn:split(options, ',')}">
                                        <div class="form-check ${selectedAnswer == option ? 'selected' : ''}">
                                            <input class="form-check-input answer-option" 
                                                   type="radio" 
                                                   name="answer" 
                                                   value="${option}"
                                                   id="option${option}${q.questionID}"
                                                   ${selectedAnswer == option ? 'checked' : ''}>
                                            <label class="form-check-label" for="option${option}${q.questionID}">
                                                ${q['option'.concat(option)]}
                                            </label>
                                        </div>
                                    </c:forEach>

                                    <input type="hidden" name="currentIndex" value="${currentIndex}">
                                    <input type="hidden" name="questionID" value="${q.questionID}">
                                    <input type="hidden" name="navigate" id="navigateQuestionId">
                                    <input type="hidden" name="markUncertain" id="markUncertainId">
                                    <input type="hidden" name="action" id="formAction" value="">

                                    <div class="mt-4">
                                        <c:if test="${currentIndex == questions.size() - 1}">
                                            <button type="button" class="btn btn-success me-2" onclick="checkSubmission()">Submit</button>
                                        </c:if>
                                    </div>
                                </form>
                            </div>

                            <!-- Nút Cancel Test ở góc dưới bên phải -->
                            <div class="cancel-test-container">
                                <a href="Lessonservlet?courseId=${courseId}&userId=${sessionScope.userid}" class="btn btn-danger" id="cancelTest">Cancel Test</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for Submission Confirmation -->
        <div class="modal fade" id="submissionModal" tabindex="-1" aria-labelledby="submissionModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="submissionModalLabel">Incomplete Test Submission</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>You have answered <span id="answeredCount"></span> out of ${questions.size()} questions.</p>
                        <p>Are you sure you want to submit the test now?</p>
                        <p>This modal will automatically close in <span class="countdown-timer" id="countdownTimer">10</span> seconds.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Continue Test</button>
                        <button type="button" class="btn btn-primary" onclick="submitTest()">Submit Now</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                            $(document).ready(function () {
                                $(".question-container").addClass("show");

                                $(".answer-option").on("change", function () {
                                    let audio = new Audio("https://www.fesliyanstudios.com/play-mp3/387");
                                    audio.play();
                                    $(this).closest('.question-container').find('.form-check').removeClass('selected');
                                    $(this).closest('.form-check').addClass('selected');
                                });
                            });

                            function navigateToQuestion(questionID) {
                                $('#navigateQuestionId').val(questionID);
                                $('#markUncertainId').val('');
                                $('#testForm').submit();
                            }

                            function markAsUncertain(questionID) {
                                $('#markUncertainId').val(questionID);
                                $('#navigateQuestionId').val('');
                                $('#testForm').submit();

                                let $star = $(`.mark-uncertain[data-question-id="${questionID}"]`);
                                let $questionItem = $(`.question-item[data-question-id="${questionID}"]`);

                                if ($star.hasClass('marked')) {
                                    $star.removeClass('marked');
                                    if ($questionItem.hasClass('answered')) {
                                        $questionItem.removeClass('uncertain').addClass('answered');
                                    } else {
                                        $questionItem.removeClass('uncertain').addClass('default');
                                    }
                                } else {
                                    $star.addClass('marked');
                                    $questionItem.removeClass('answered default').addClass('uncertain');
                                }
                            }

                            $('#cancelTest').on('click', function (e) {
                                e.preventDefault();
                                if (confirm('Are you sure you want to cancel this test? Your progress will be lost.')) {
                                    window.location.href = $(this).attr('href');
                                }
                            });

                            let countdownInterval;

                            function checkSubmission() {
                                // Count answered questions by checking the number of question items with the 'answered' class
                                let answeredCount = $('.question-item.answered').length;
                                let totalQuestions = ${questions.size()};

                                if (answeredCount < totalQuestions) {
                                    // Show the modal if not all questions are answered
                                    $('#answeredCount').text(answeredCount);
                                    $('#submissionModal').modal('show');

                                    // Start countdown timer
                                    let timeLeft = 10;
                                    $('#countdownTimer').text(timeLeft);
                                    countdownInterval = setInterval(function () {
                                        timeLeft--;
                                        $('#countdownTimer').text(timeLeft);
                                        if (timeLeft <= 0) {
                                            clearInterval(countdownInterval);
                                            $('#submissionModal').modal('hide');
                                        }
                                    }, 1000);
                                } else {
                                    // If all questions are answered, submit the form directly
                                    submitTest();
                                }
                            }

                            function submitTest() {
                                clearInterval(countdownInterval);
                                $('#formAction').val('submit');
                                $('#testForm').submit();
                            }
        </script>
    </body>
</html>