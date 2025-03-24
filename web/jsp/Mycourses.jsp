<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>My Enrollments</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="img/favicon.ico" rel="icon">
    <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet"> 
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Thêm nội dung tĩnh để kiểm tra -->
  

    <%@ include file="header.jsp" %>

    <div class="jumbotron jumbotron-fluid page-header position-relative overlay-bottom" style="margin-bottom: 90px;">
        <div class="container text-center py-5">
            <h1 class="text-white display-1">Accomplishment</h1>
        </div>
    </div>
    <div class="container-fluid py-5">
        <div class="container py-5">
            <div class="section-title position-relative mb-4 text-left">
                <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Accomplishment</h6>
                <h1 class="display-4 text-left">Courses Finished</h1>
            </div>
            <div class="row">
                <c:choose>
                    <c:when test="${not empty courses}">
                        <c:forEach var="e" items="${courses}">
                            <div class="col-lg-12 mb-4">
                                <div class="card border-0 shadow d-flex flex-row align-items-center p-3">
                                    <div style="flex: 0 0 30%;">
                                        <img class="img-fluid rounded" src="${e.imageCourses}" alt="${e.name}" style="width: 100%; height: 250px; object-fit: cover;">
                                    </div>
                                    <div class="card-body ml-4" style="flex: 1;">
                                        <h5 class="card-title mb-2">${e.name}</h5>
                                        <p class="card-text">${e.description}</p>   
                                        <a class="btn btn-primary text-white" href="Certificatecontroller?userid=${userid}&courseId=${e.courseId}" style="background-color: #007bff; border-color: #007bff;">View certificate</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="text-center">You do not have any completed courses.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <%@ include file="footer.jsp" %>
    <a href="#" class="btn btn-lg btn-primary rounded-0 btn-lg-square back-to-top"><i class="fa fa-angle-double-up"></i></a>
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="js/main.js"></script>
      <iframe src="jsp/chatbot-widget.jsp" style="position: fixed; bottom: 0; right: 0; border: none; width: 400px; height: 600px; z-index: 1000;"></iframe>
</body>
</html>