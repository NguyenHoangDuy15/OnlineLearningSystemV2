<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <%@ include file="header.jsp" %>
        <div class="jumbotron jumbotron-fluid page-header position-relative overlay-bottom" style="margin-bottom: 90px;">
            <div class="container text-center py-5">
                <h1 class="text-white display-1">My Enrollments</h1>
            </div>
        </div>
        <div class="container-fluid py-5">
            <div class="container py-5">
                <div class="section-title position-relative mb-4 text-center">
                    <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Enrollments</h6>
                    <h1 class="display-4">Courses You Have Enrolled In</h1>
                </div>
                <div class="row">
                    <div class="col-lg-6 mb-4" id="enrollment-list">
                        <!-- Danh sách khóa học sẽ được hiển thị ở đây -->
                    </div>
                </div>
            </div>
        </div>
        <%@ include file="footer.jsp" %>
        <a href="#" class="btn btn-lg btn-primary rounded-0 btn-lg-square back-to-top"><i class="fa fa-angle-double-up"></i></a>
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="js/main.js"></script>
        <script>
            $(document).ready(function () {
                const enrollments = [
                    { name: "Web Development" },
                    { name: "Data Science" }
                ];
                let html = "";
                enrollments.forEach(course => {
                    html += `<div class='bg-light p-4 mb-3'><h5>${course.name}</h5></div>`;
                });
                $("#enrollment-list").html(html);
            });
        </script>
    </body>
</html>
