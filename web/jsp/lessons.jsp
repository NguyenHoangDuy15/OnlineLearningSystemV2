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
                width: 20%;
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                background: linear-gradient(180deg, #3D85ED 0%, #2B62D1 100%);
                color: white;
                padding: 20px;
                box-shadow: 5px 0 15px rgba(0,0,0,0.1);
                transition: width 0.3s ease;
                overflow-y: auto;
            }

            .sidebar:hover {
                width: 20%;
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
                margin-left: 17%;
                padding: 40px;
                min-height: 100vh;
                background: #ffffff;
                border-radius: 15px 0 0 15px;
                box-shadow: -5px 0 15px rgba(0,0,0,0.05);
            }

            .video-container {
                background: #fff;
                margin-left: 20px;
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
                height: 700px;
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

            .course-info-link {
                margin-top: 10px;
            }

            .course-info-link a {
                font-size: 1.1rem;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .course-info-link a i {
                color: #ffd700;
            }
            .certificate-btn {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-top: 20px;
                padding: 12px 20px;
                background: linear-gradient(45deg, #ffd700, #ffaa00);
                color: #fff;
                text-decoration: none;
                border-radius: 25px;
                font-weight: 600;
                box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);
                transition: all 0.3s ease;
            }

            .certificate-btn:hover {
                background: linear-gradient(45deg, #ffaa00, #ffd700);
                transform: translateY(-3px) scale(1.05);
                box-shadow: 0 6px 20px rgba(255, 215, 0, 0.4);
                color: #fff;
            }

            .certificate-btn i {
                font-size: 1.2em;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.1);
                }
                100% {
                    transform: scale(1);
                }
            }
            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                margin: 0;
                font-family: 'Arial', sans-serif;
            }
            .sidebar {
                width: 20%;
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                background: linear-gradient(180deg, #3D85ED 0%, #2B62D1 100%);
                color: white;
                padding: 20px;
                box-shadow: 5px 0 15px rgba(0,0,0,0.1);
                transition: width 0.3s ease;
                overflow-y: auto;
            }
            .sidebar:hover {
                width: 20%;
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
                margin-left: 17%;
                padding: 40px;
                min-height: 100vh;
                background: #ffffff;
                border-radius: 15px 0 0 15px;
                box-shadow: -5px 0 15px rgba(0,0,0,0.05);
            }
            .video-container {
                background: #fff;
                margin-left: 20px;
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
                height: 700px;
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
            .course-info-link {
                margin-top: 10px;
            }
            .course-info-link a {
                font-size: 1.1rem;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .course-info-link a i {
                color: #ffd700;
            }
            .certificate-btn {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-top: 20px;
                padding: 12px 20px;
                background: linear-gradient(45deg, #ffd700, #ffaa00);
                color: #fff;
                text-decoration: none;
                border-radius: 25px;
                font-weight: 600;
                box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);
                transition: all 0.3s ease;
            }
            .certificate-btn:hover {
                background: linear-gradient(45deg, #ffaa00, #ffd700);
                transform: translateY(-3px) scale(1.05);
                box-shadow: 0 6px 20px rgba(255, 215, 0, 0.4);
                color: #fff;
            }
            .certificate-btn i {
                font-size: 1.2em;
                animation: pulse 2s infinite;
            }
            @keyframes pulse {
                0% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.1);
                }
                100% {
                    transform: scale(1);
                }
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
                        <a href="#" onclick="changeContent('${lesson.type}', '${lesson.content}', ${lesson.id}, '${testStatuses[lesson.id]}')">
                            ${lesson.name}
                        </a>
                        <c:if test="${lesson.type eq 'Test'}">
                            <c:set var="status" value="${testStatuses[lesson.id]}" />
                            <c:choose>
                                <c:when test="${status == 1}">
                                    <i class="fas fa-check-circle" title="Passed"></i>
                                </c:when>
                                <c:when test="${status == 0}">
                                    <i class="fas fa-times-circle" title="Failed"></i>
                                </c:when>
                                <%-- Không hiển thị gì nếu status == null --%>
                            </c:choose>
                        </c:if>
                    </li>
                </c:forEach>

                <!-- Test History -->
                <c:if test="${hasTestHistory}">
                    <h4 onclick="toggleTestHistory()">
                        <i class="fas fa-history"></i>
                        Test History
                        <i id="historyArrow" class="fas fa-chevron-down"></i>
                    </h4>
                    <ul id="testHistoryList" class="list-unstyled">
                        <c:forEach var="test" items="${tests}">
                            <li>
                                <a href="ReviewTest?testId=${test.id}">
                                    <i class="fas fa-book"></i>
                                    ${test.name}
                                    <c:set var="status" value="${testStatuses[test.id]}" />
                                    <c:if test="${status != null}">
                                        <span class="badge ${status == 0 ? 'bg-warning' : 'bg-success'}">
                                            ${status == 0 ? 'Failed' : 'Passed'}
                                        </span>
                                    </c:if>
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </c:if>
                <h5 class="course-info-link">
                    <a href="detail?courseId=${sessionScope.courseId}">
                        <i class="fas fa-info-circle"></i> Course Information
                    </a>
                </h5>
                <c:if test="${courseStatus == 1}">
                    <a class="certificate-btn" href="Certificatecontroller?userid=${sessionScope.userid}&courseId=${sessionScope.courseId}">
                        <i class="fas fa-certificate"></i> View Certificate
                    </a>
                </c:if>
        </div>

        <div class="content">
            <div class="video-container">
                <iframe id="videoFrame" frameborder="0" allowfullscreen></iframe>
                <div id="testContainer" style="display: none;">
                    <h3 id="testTitle"></h3>
                    <a id="testLink" href="#" class="btn"></a>
                </div>
            </div>
        </div>

        <script>
            function toggleTestHistory() {
                const list = document.getElementById("testHistoryList");
                const arrow = document.getElementById("historyArrow");

                if (list.style.display === 'none') {
                    list.style.display = 'block';
                    arrow.className = 'fas fa-chevron-up';
                } else {
                    list.style.display = 'none';
                    arrow.className = 'fas fa-chevron-down';
                }
            }

            function toggleTestDetails(testId) {
                const details = document.getElementById('testDetails' + testId);
                const arrow = document.getElementById('testArrow' + testId);

                if (details.style.display === 'none') {
                    details.style.display = 'block';
                    arrow.className = 'fas fa-chevron-up';
                } else {
                    details.style.display = 'none';
                    arrow.className = 'fas fa-chevron-down';
                }
            }
            function toggleCourseContent() {
                var courseList = document.getElementById("courseList");
                courseList.style.display = courseList.style.display === "none" ? "block" : "none";
            }

            function changeContent(type, content, testId, status) {
                let videoFrame = document.getElementById("videoFrame");
                let testContainer = document.getElementById("testContainer");
                let testTitle = document.getElementById("testTitle");
                let testLink = document.getElementById("testLink");

                if (type === "Lesson") {
                    videoFrame.src = content ? content.replace("watch?v=", "embed/") : "";
                    videoFrame.style.display = "block";
                    testContainer.style.display = "none";
                } else if (type === "Test") {
                    videoFrame.src = "";
                    videoFrame.style.display = "none";
                    testTitle.innerText = "Bài kiểm tra";
                    testLink.href = "TestAnswer?testId=" + testId + "&courseId=${sessionScope.courseId}";

                    if (status === null || status === undefined || status === '') {
                        testLink.innerText = "Take Test";
                    } else if (status === '0' || status === '1') {
                        testLink.innerText = "Retry Test";
                    }
                    testContainer.style.display = "block";
                }
            }

            window.onload = function () {
            <c:forEach var="lesson" items="${lessonsAndTests}" begin="0" end="0">
                changeContent('${lesson.type}', '${lesson.content}', ${lesson.id}, '${testStatuses[lesson.id]}');
            </c:forEach>
                let firstLesson = document.querySelector("#courseList a");
                if (firstLesson) {
                    firstLesson.click();
                }
            };
        </script>

        <% 
            userId = (Integer) session.getAttribute("userid");
            if (userId != null) {
        %>
        <iframe 
            src="jsp/chatbot-widget.jsp" 
            style="position: fixed; bottom: 0; right: 0; border: none; width: 400px; height: 600px; z-index: 1000;">
        </iframe>
        <% 
            } 
        %>
    </body>
</html>