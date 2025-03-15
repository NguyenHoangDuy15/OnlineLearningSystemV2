<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Wait for Application Approval</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link href="img/favicon.ico" rel="icon">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <div class="jumbotron jumbotron-fluid position-relative overlay-bottom" style="margin-bottom: 90px;">
            <div class="container text-center my-5 py-5">
                <h1 class="text-white display-1 mb-5">Wait for Application Approval</h1>
            </div>
        </div>

        <div class="container my-5">
            <div class="card p-4 shadow-sm">
                <h3 class="text-center mb-4">Your Role Requests</h3>

                <table class="table table-bordered text-center">
                    <thead>
                        <tr>
                            <th class="bg-primary text-white">Request ID</th>
                            <th class="bg-primary text-white">Requested Role</th>
                            <th class="bg-primary text-white">Status</th>
                        </tr>
                    </thead>



                    <tbody>
                        <c:choose>
                            <c:when test="${empty roleRequests}">
                                <tr>
                                    <td colspan="3" class="text-center text-warning fw-bold">You have no role requests.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="request" items="${roleRequests}">
                                    <tr>
                                        <td class="text-primary fw-bold">${request.getRequestID()}</td>  
                                        <td>${request.rolename}</td>
                                        <td>${request.statustext}</td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

            </div>
        </div>




        <%@ include file="footer.jsp" %>

        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/counterup/counterup.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="js/main.js"></script>
    </body>
</html>
