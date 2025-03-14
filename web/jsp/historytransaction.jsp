<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>View History</title>
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
                <h1 class="text-white display-1">View History</h1>
            </div>
        </div>
        <div class="container-fluid py-5">
            <div class="container py-5">
                <div class="section-title position-relative mb-4 text-left">
                    <h6 class="d-inline-block position-relative text-secondary text-uppercase pb-2">Transaction History</h6>
                    <h1 class="display-4 text-left">Your Payment History</h1>
                </div>
                <div class="row">
                    <c:choose>
                        <c:when test="${not empty historyList}">
                            <c:forEach var="t" items="${historyList}">
                                <div class="col-lg-12 mb-4">
                                    <div class="card border-0 shadow d-flex flex-row align-items-center p-3">
                                     
                                        <div class="card-body ml-4" style="flex: 1;">
                                            <h5 class="card-title mb-2">${t.courseName}</h5>
                                            <p class="card-text">${t.paidAmount}$</p>
                                              <p class="card-text">${t.paymentMethod}</p>
                                            <p class="text-muted mb-0"><strong>Payment Date:</strong> ${t.createdAt}</p>
                                            <p class="text-${t.status == 1 ? 'success' : 'danger'}">
                                                <strong>Status:</strong> ${t.status == 1 ? "Completed" : "Pending"}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="text-center">Bạn chưa có giao dịch nào.</p>
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
    </body>
</html>
