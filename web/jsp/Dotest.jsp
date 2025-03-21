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
        /* Container chính */
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
        }

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
            height: 15px;
            border-radius: 10px;
            background-color: #e9ecef;
        }
        .progress-bar {
            transition: width 0.5s ease-in-out;
            background: linear-gradient(to right, #28a745, #20c997);
        }

        /* Style cho câu hỏi và đáp án */
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

        /* Style cho nút */
        .btn {
            padding: 10px 25px;
            border-radius: 25px;
            transition: all 0.3s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        /* Style cho đánh dấu câu khó */
        .mark-difficult {
            cursor: pointer;
            transition: transform 0.2s;
        }

        .mark-difficult.marked {
            color: #dc3545;
            transform: scale(1.2);
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="card">
            <div class="card-body">
                <!-- Thanh tiến trình -->
                <c:set var="progressPercent" value="${(currentIndex + 1) * 100 / totalQuestions}" />
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
                    <form action="TestAnswer" method="post">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="card-title">Question ${q.questionID}:</h5>
                            <span class="mark-difficult" 
                                  data-question-id="${q.questionID}" 
                                  title="Mark as difficult">
                                ⭐
                            </span>
                        </div>
                        <p class="card-text">${q.questionContent}</p>

                        <c:set var="selectedAnswer" value="${sessionScope.userAnswers[q.questionID]}" />
                        <c:set var="options" value="A,B,C,D" />

                        <c:forEach var="option" items="${fn:split(options, ',')}">
                            <div class="form-check">
                                <input class="form-check-input answer-option" 
                                       type="radio" 
                                       name="answer" 
                                       value="${option}"
                                       id="option${option}${q.questionID}"
                                       ${selectedAnswer == option ? 'checked' : ''} 
                                       required>
                                <label class="form-check-label" for="option${option}${q.questionID}">
                                    ${q['option'.concat(option)]}
                                </label>
                            </div>
                        </c:forEach>

                        <input type="hidden" name="currentIndex" value="${currentIndex}">
                        <input type="hidden" name="questionID" value="${q.questionID}">

                        <div class="mt-4 d-flex justify-content-between">
                            <div>
                                <c:if test="${currentIndex > 0}">
                                    <button type="submit" name="action" value="previous" class="btn btn-secondary me-2">Previous</button>
                                </c:if>
                                <c:if test="${currentIndex < totalQuestions - 1}">
                                    <button type="submit" name="action" value="next" class="btn btn-primary me-2">Next</button>
                                </c:if>
                                <c:if test="${currentIndex == totalQuestions - 1}">
                                    <button type="submit" name="action" value="submit" class="btn btn-success me-2">Submit</button>
                                </c:if>
                            </div>
                            <button type="button" class="btn btn-danger" id="cancelTest">Cancel Test</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            // Hiệu ứng fade-in khi tải trang
            $(".question-container").addClass("show");

            // Âm thanh khi chọn đáp án
            $(".answer-option").on("change", function () {
                let audio = new Audio("https://www.fesliyanstudios.com/play-mp3/387");
                audio.play();
            });

            // Xử lý đánh dấu câu hỏi khó
            const markedQuestions = new Set(
                JSON.parse(localStorage.getItem('difficultQuestions') || '[]')
            );

            // Khôi phục trạng thái đánh dấu nếu có
            if (markedQuestions.has("${q.questionID}")) {
                $('.mark-difficult').addClass('marked');
            }

            $('.mark-difficult').on('click', function () {
                const questionId = $(this).data('question-id');
                $(this).toggleClass('marked');

                if ($(this).hasClass('marked')) {
                    markedQuestions.add(questionId);
                } else {
                    markedQuestions.delete(questionId);
                }
                localStorage.setItem('difficultQuestions', JSON.stringify([...markedQuestions]));
            });

            // Xử lý hủy bài test
            $('#cancelTest').on('click', function () {
                if (confirm('Are you sure you want to cancel this test? Your progress will be lost.')) {
                    // Xóa các dữ liệu trong localStorage
                    localStorage.removeItem('difficultQuestions');
                    // Có thể thêm các xử lý khác như gửi request đến server để reset session
                    window.location.href = '/'; // Chuyển về trang chủ hoặc trang bắt đầu
                }
            });
        });
    </script>
</body>
</html>