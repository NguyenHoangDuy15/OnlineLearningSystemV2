<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Edukate - Online Education</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">

        <style>
            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                margin: 0;
                font-family: 'Arial', sans-serif;
            }

            .sidebar {
                width: 19%; /* Giảm từ 20% xuống 17% */
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                background: linear-gradient(180deg, #3D85ED 0%, #2B62D1 100%);
                color: white;
                padding: 20px;
                box-shadow: 5px 0 15px rgba(0,0,0,0.1);
                transition: width 0.3s ease;
            }

            .sidebar:hover {
                width: 19%; /* Tăng từ 17% lên 19% khi hover */
            }

            .sidebar h4 {
                cursor: pointer;
                padding: 10px;
                background: rgba(255,255,255,0.1);
                border-radius: 8px;
                transition: all 0.3s;
            }

            .sidebar h4:hover {
                background: rgba(255,255,255,0.2);
                transform: translateX(5px);
            }

            .sidebar a {
                color: #fff;
                text-decoration: none;
                transition: all 0.3s;
                display: block;
                padding: 10px;
                border-radius: 5px;
            }

            .sidebar a:hover {
                background: rgba(255,255,255,0.15);
                padding-left: 15px;
            }

            .sidebar ul li {
                margin: 10px 0;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .content {
                margin-left: 17%; /* Đồng bộ với width của sidebar */
                padding: 40px;
                min-height: 100vh;
                background: #ffffff;
                border-radius: 15px 0 0 15px;
                box-shadow: -5px 0 15px rgba(0,0,0,0.05);
            }

            .video-container {
                background: #fff;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 5px 25px rgba(0,0,0,0.1);
                transition: transform 0.3s;
            }

            .video-container:hover {
                transform: translateY(-5px);
            }

            .video-container iframe {
                width: 100%;
                height: 500px;
                border-radius: 10px;
                border: none;
            }

            #testContainer {
                padding: 20px;
                background: linear-gradient(45deg, #3D85ED, #2B62D1);
                color: white;
                border-radius: 10px;
            }

            #testLink {
                background: #fff;
                color: #3D85ED;
                padding: 12px 25px;
                border-radius: 25px;
                font-weight: bold;
                transition: all 0.3s;
            }

            #testLink:hover {
                background: #3D85ED;
                color: #fff;
                transform: scale(1.05);
            }

            .fa-check-circle {
                color: #28a745;
            }

            .fa-times-circle {
                color: #dc3545;
            }
        </style>
    </head>

    <body>
        <%@ include file="header.jsp" %>

        <div class="sidebar">
            <h4 onclick="toggleCourseContent()">
                <i class="fas fa-chevron-down"></i> Course Content
            </h4>
            <ul id="courseList" class="list-unstyled">
                <c:forEach var="lesson" items="${lessonsAndTests}">
                    <li>
                        <i class="fas ${lesson.type eq 'Lesson' ? 'fa-video' : 'fa-book'}"></i>
                        <a href="#" onclick="changeContent('${lesson.type}', '${lesson.content}', ${lesson.id})">
                            ${lesson.name}
                        </a>
                        <c:if test="${lesson.type eq 'Test'}">
                            <c:set var="status" value="${testStatuses[lesson.id]}" />
                            <c:choose>
                                <c:when test="${status == 1}">
                                    <i class="fas fa-check-circle"></i>
                                </c:when>
                                <c:when test="${status == 0}">
                                    <i class="fas fa-times-circle"></i>
                                </c:when>
                            </c:choose>
                        </c:if>
                    </li>
                </c:forEach>
                <c:if test="${not empty historyId}">
                    <li>
                        <i class="fas fa-history"></i>
                        <a href="ReviewTest?historyId=${historyId}">History of Test</a>
                    </li>
                </c:if>
            </ul>
        </div>

        <div class="content">
            <div class="video-container">
                <iframe id="videoFrame" frameborder="0" allowfullscreen></iframe>
                <div id="testContainer" style="display: none;">
                    <h3 id="testTitle"></h3>
                    <a id="testLink" href="TestAnswer?testId=${firstLesson.id}" class="btn">Take a test</a>
                </div>
            </div>
        </div>

        <script>
            function toggleCourseContent() {
                var courseList = document.getElementById("courseList");
                courseList.style.display = courseList.style.display === "none" ? "block" : "none";
            }

            function changeContent(type, content, testId) {
                let videoFrame = document.getElementById("videoFrame");
                let testContainer = document.getElementById("testContainer");
                let testTitle = document.getElementById("testTitle");
                let testLink = document.getElementById("testLink");

                if (type === "Lesson") {
                    videoFrame.src = content.replace("watch?v=", "embed/");
                    videoFrame.style.display = "block";
                    testContainer.style.display = "none";
                } else if (type === "Test") {
                    videoFrame.src = "";
                    videoFrame.style.display = "none";
                    testTitle.innerText = "Bài kiểm tra";
                    testLink.href = "TestAnswer?testId=" + testId;
                    testContainer.style.display = "block";
                }
            }

            window.onload = function () {
                <c:forEach var="lesson" items="${lessonsAndTests}" begin="0" end="0">
                    changeContent('${lesson.type}', '${lesson.content}', ${lesson.id});
                </c:forEach>
                let firstLesson = document.querySelector("#courseList a");
                if (firstLesson) {
                    firstLesson.click();
                }
            };
        </script>
    </body>
</html>