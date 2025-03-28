<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Review Test</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                font-family: 'Arial', sans-serif;
            }

            .container {
                max-width: 900px;
            }

            .card {
                border: none;
                border-radius: 15px;
                box-shadow: 0 5px 25px rgba(0, 0, 0, 0.1);
                background: #ffffff;
                padding: 20px;
            }

            .card-body {
                padding: 30px;
            }

            h3.text-center {
                color: #2B62D1;
                font-weight: 700;
                margin-bottom: 30px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .card-title {
                color: #3D85ED;
                font-weight: 600;
                margin-bottom: 15px;
            }

            .card-text {
                color: #555;
                font-size: 1.1rem;
                margin-bottom: 20px;
            }

            .form-check {
                padding: 10px 20px;
                border-radius: 8px;
                margin: 5px 0;
                transition: all 0.3s ease;
            }

            .form-check:hover {
                background: #f8f9fa;
            }

            .form-check-input {
                margin-right: 10px;
            }

            .form-check-label {
                color: #333;
                font-size: 1rem;
            }

            .text-success {
                font-weight: 600;
                margin-left: 10px;
                color: #28a745 !important;
            }

            .text-danger {
                font-weight: 600;
                margin-left: 10px;
                color: #dc3545 !important;
            }

            .btn {
                padding: 10px 25px;
                border-radius: 25px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn-primary {
                background: linear-gradient(45deg, #3D85ED, #2B62D1);
                border: none;
            }

            .btn-primary:hover {
                background: linear-gradient(45deg, #2B62D1, #3D85ED);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(61, 133, 237, 0.3);
            }

            .btn-secondary {
                background: linear-gradient(45deg, #6c757d, #495057);
                border: none;
            }

            .btn-secondary:hover {
                background: linear-gradient(45deg, #495057, #6c757d);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
            }

            .mb-4 {
                background: #fff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                transition: transform 0.3s ease;
            }

            .mb-4:hover {
                transform: translateY(-5px);
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            }
            .score-display {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
            }
            .question-number {
                color: #2B62D1;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
            <div class="card">
                <div class="card-body">
                    <h3 class="text-center">Review Test</h3>

                    <!-- Hiển thị điểm số -->
                    <div class="score-display text-center">
                        <h5>Your Score: <span class="text-primary">${score}</span></h5>
                    </div>

                    <c:forEach var="answer" items="${userAnswers}" varStatus="loop">
                        <div class="mb-4">
                            <h5 class="card-title">
                                <span class="question-number">Question ${((currentPage - 1) * 5) + loop.index + 1}</span>: 
                                ${fn:escapeXml(answer.questionContent)}
                            </h5>

                            <c:forEach var="option" items="${fn:split('A,B,C,D', ',')}">
                                <c:set var="key" value="option${option}" />
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" disabled
                                           ${answer.answerOption == option ? 'checked' : ''}>
                                    <label class="form-check-label">
                                        ${fn:escapeXml(answer[key])}
                                        <c:if test="${answer.answerOption == option}">
                                            <span class="${answer.isCorrectAnswer ? 'text-success' : 'text-danger'}">
                                                ${answer.isCorrectAnswer ? '(Correct)' : '(Incorrect)'}
                                            </span>
                                        </c:if>
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </c:forEach>

                    <!-- Pagination -->
                    <div class="d-flex justify-content-between mt-4">
                        <c:if test="${currentPage > 1}">
                            <a href="ReviewTest?testId=${testId}&page=${currentPage - 1}&courseId=${courseId}" 
                               class="btn btn-secondary">Previous</a>
                        </c:if>
                        <div class="text-center flex-grow-1">
                            Page ${currentPage} of ${totalPages}
                        </div>
                        <c:if test="${currentPage < totalPages}">
                            <a href="ReviewTest?testId=${testId}&page=${currentPage + 1}&courseId=${courseId}" 
                               class="btn btn-primary">Next</a>
                        </c:if>
                    </div>

                    <div class="text-center mt-4">
                        <a href="Lessonservlet?userid=${sessionScope.userid}&courseId=${courseId}&historyId=${historyId}&testId=${testId}" 
                           class="btn btn-primary">Back to Course</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>