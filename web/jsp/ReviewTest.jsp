<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Review Test</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>
        <div class="container mt-5">
            <div class="card">
                <div class="card-body">
                    <h3 class="text-center">Review Test</h3>

                    <c:forEach var="answer" items="${userAnswers}">
                        <div class="mb-4">
                            <h5 class="card-title">Question ${answer.questionID}:</h5>
                            <p class="card-text">${answer.questionContent}</p>

                            <c:set var="options" value="A,B,C,D" />
                            <c:forEach var="option" items="${fn:split(options, ',')}">
                                <c:set var="key" value="option${option}" />
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" disabled
                                           ${answer.answerOption == option ? 'checked' : ''}>
                                    <label class="form-check-label">
                                        ${answer[key]}
                                    </label>
                                    <c:if test="${answer.answerOption == option}">
                                        <span class="${answer.isCorrectAnswer ? 'text-success' : 'text-danger'}">
                                            ${answer.isCorrectAnswer ? '(Correct)' : '(Wrong)'}
                                        </span>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:forEach>

                    <!-- Navigation buttons -->
                    <div class="d-flex justify-content-between mt-4">
                        <c:if test="${currentPage > 1}">
                            <a href="ReviewTest?historyId=${historyId}&page=${currentPage - 1}" class="btn btn-secondary">Previous</a>
                        </c:if>

                        <c:if test="${currentPage < totalPages}">
                            <a href="ReviewTest?historyId=${historyId}&page=${currentPage + 1}" class="btn btn-primary">Next</a>
                        </c:if>
                    </div>

                    <div class="text-center mt-3">
                        <a href="Lessonservlet?userid=${userid}&courseId=${courseId}&historyId=${historyId}&testId=${testId}" class="btn btn-primary">Back to Course</a>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
