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
            .sidebar {
                width: 15%;
                height: 100vh;
                position: fixed;
                left: 0;
                top: 0;
                background: #3D85ED;
                color: white;
                padding: 15px;
                overflow-y: auto;
            }
            .sidebar h4 {
                cursor: pointer;
            }
            .sidebar a {
                color: #d1ecf1;
                text-decoration: none;
            }
            .content {
                margin-left: 20%;
                padding: 20px;
                text-align: center;
                background-color: #f8f9fa;
                min-height: 100vh;
            }
            .video-container iframe {
                width: 80%;
                height: 500px;
                border-radius: 10px;
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
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
                                    <i class="fas fa-check-circle text-success"></i> <!-- ✅ Đã hoàn thành -->
                                </c:when>
                                <c:when test="${status == 0}">
                                    <i class="fas fa-times-circle text-danger"></i> <!-- ❌ Chưa hoàn thành -->
                                </c:when>
                                <c:otherwise>
                                    <!-- Không hiển thị gì nếu status là null -->
                                </c:otherwise>
                            </c:choose>

                        </c:if>

                    </li>
                </c:forEach>
                <c:if test="${not empty historyId}">
                    <li>
                        <i class="fas fa-history"></i>
                        <a href="ReviewTest?historyId=${historyId}" >History of Test</a>
                    </li>
                </c:if>
            </ul>
        </div>


        <div class="content">
            <div class="video-container">
                <iframe id="videoFrame" frameborder="0" allowfullscreen></iframe>
                <div id="testContainer" style="display: none;">
                    <h3 id="testTitle"></h3>
                    <a id="testLink"  href="TestAnswer?testId=${firstLesson.id}" class="btn btn-primary">Làm bài kiểm tra</a>
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
                    // Chuyển sang video
                    videoFrame.src = content.replace("watch?v=", "embed/");
                    videoFrame.style.display = "block";
                    testContainer.style.display = "none";
                } else if (type === "Test") {
                    // Chuyển sang bài kiểm tra
                    videoFrame.src = ""; // Tắt video
                    videoFrame.style.display = "none";

                    testTitle.innerText = "Bài kiểm tra";
                    testLink.href = "TestAnswer?testId=" + testId; // Cập nhật link làm bài
                    testContainer.style.display = "block";
                }
            }


            // Hiển thị bài học đầu tiên ngay khi trang tải lên
            window.onload = function () {
                // Chạy đoạn JSTL để lấy bài học đầu tiên
            <c:forEach var="lesson" items="${lessonsAndTests}" begin="0" end="0">
                changeContent('${lesson.type}', '${lesson.content}', ${lesson.id});
            </c:forEach>

                // Tự động chọn bài học đầu tiên từ danh sách
                let firstLesson = document.querySelector("#courseList a");
                if (firstLesson) {
                    firstLesson.click(); // Giả lập click vào bài học đầu tiên
                }
            };

        </script>
    </body>
</html>
