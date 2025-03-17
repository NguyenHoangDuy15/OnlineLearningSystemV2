<%-- 
    Document   : dashboard
    Created on : Mar 7, 2025, 8:13:45 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <title>Dashboard for manager</title>
        <meta
            content="width=device-width, initial-scale=1.0, shrink-to-fit=no"
            name="viewport"
            />

        <style>
            .notifications-container{
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
            }
        </style>

        <!-- Fonts and icons -->
        <script src="assets/js/plugin/webfont/webfont.min.js"></script>
        <script>
            WebFont.load({
                google: {families: ["Public Sans:300,400,500,600,700"]},
                custom: {
                    families: [
                        "Font Awesome 5 Solid",
                        "Font Awesome 5 Regular",
                        "Font Awesome 5 Brands",
                        "simple-line-icons",
                    ],
                    urls: ["assets/css/fonts.min.css"],
                },
                active: function () {
                    sessionStorage.fonts = true;
                },
            });
        </script>

        <!-- CSS Files -->
        <link rel="stylesheet" href="assets/css/bootstrap.min.css" />
        <link rel="stylesheet" href="assets/css/plugins.min.css" />
        <link rel="stylesheet" href="assets/css/kaiadmin.min.css" />

    </head>
    <body>
        <%--<jsp:include page="header.jsp"/>--%>
        <div class="wrapper">
            <!-- Sidebar -->
            <jsp:include page="sidebarManager.jsp"/>
            <!-- End Sidebar -->

            <div class="main-panel">
                <div class="main-header">
                    <div class="main-header-logo">
                        <!-- Logo Header -->
                        <div class="logo-header" data-background-color="dark">

                            <div class="nav-toggle">
                                <button class="btn btn-toggle toggle-sidebar">
                                    <i class="gg-menu-right"></i>
                                </button>
                                <button class="btn btn-toggle sidenav-toggler">
                                    <i class="gg-menu-left"></i>
                                </button>
                            </div>
                            <button class="topbar-toggler more">
                                <i class="gg-more-vertical-alt"></i>
                            </button>
                        </div>
                        <!-- End Logo Header -->
                    </div>
                    <jsp:include page="navbar-header.jsp"/>
                </div>

                <div class="container">
                    <div class="page-inner">
                        <div
                            class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4"
                            >
                            <div>
                                <h3 class="fw-bold mb-3">DASHBOARD</h3>
                            </div>
                        </div>
                        <div class="row">

                            <div class="col-sm-6 col-md-3">
                                <a href="ListOfCourseByAdminServlet">
                                    <div class="card card-stats card-round">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-icon">
                                                    <div
                                                        class="icon-big text-center icon-primary bubble-shadow-small"
                                                        >
                                                        <i class="fa fa-book" aria-hidden="true"></i>
                                                    </div>
                                                </div>
                                                <div class="col col-stats ms-3 ms-sm-0">
                                                    <div class="numbers">
                                                        <p class="card-category">Course</p>
                                                        <h4 class="card-title">${sessionScope.numberOfCourse}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <a href="ListBlogByAdminServlet">
                                    <div class="card card-stats card-round">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-icon">
                                                    <div
                                                        class="icon-big text-center icon-info bubble-shadow-small"
                                                        >
                                                        <i class="fa fa-newspaper" aria-hidden="true"></i>
                                                    </div>
                                                </div>
                                                <div class="col col-stats ms-3 ms-sm-0">
                                                    <div class="numbers">
                                                        <p class="card-category">Blogs</p>
                                                        <h4 class="card-title">${sessionScope.numberOfBlog}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div>

                            <div class="col-sm-6 col-md-3">
                                <a href="ListTranscriptByAdminServlet">
                                    <div class="card card-stats card-round">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-icon">
                                                    <div
                                                        class="icon-big text-center icon-success bubble-shadow-small"
                                                        >
                                                        <i class="fas fa-file-invoice-dollar"></i>
                                                    </div>
                                                </div>
                                                <div class="col col-stats ms-3 ms-sm-0">
                                                    <div class="numbers">
                                                        <p class="card-category">Total Amount</p>
                                                        <h4 class="card-title price-vnd">${sessionScope.TotalMoney*1000}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div> 
                            <div class="col-sm-6 col-md-3">
                                <a href="ListOfExpertServlet">
                                    <div class="card card-stats card-round">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-icon">
                                                    <div
                                                        class="icon-big text-center icon-secondary bubble-shadow-small" 
                                                        >
                                                        <i class="fa fa-user" aria-hidden="true"></i>
                                                    </div>
                                                </div>
                                                <div class="col col-stats ms-3 ms-sm-0">
                                                    <div class="numbers">
                                                        <p class="card-category">Expert</p>
                                                        <h4 class="card-title">${sessionScope.numberOfExpert}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <a href="ListOfSellerServlet">
                                    <div class="card card-stats card-round">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-icon">
                                                    <div
                                                        class="icon-big text-center icon-info bubble-shadow-small"style="background-color: orange"
                                                        >
                                                        <i class="fa fa-users" aria-hidden="true"></i>
                                                    </div>
                                                </div>
                                                <div class="col col-stats ms-3 ms-sm-0">
                                                    <div class="numbers">
                                                        <p class="card-category">Saler</p>
                                                        <h4 class="card-title">${sessionScope.numberOfSale}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div>

                            <div class="col-sm-6 col-md-3">
                                <a href="ListOfFeedbackByAdminServlet">
                                    <div class="card card-stats card-round">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-icon">
                                                    <div
                                                        class="icon-big text-center icon-success bubble-shadow-small"style="background-color: greenyellow"
                                                        >
                                                        <i class="fa fa-comment" aria-hidden="true"></i>
                                                    </div>
                                                </div>
                                                <div class="col col-stats ms-3 ms-sm-0">
                                                    <div class="numbers">
                                                        <p class="card-category">Feedback</p>
                                                        <h4 class="card-title">${sessionScope.numberOfFeedback}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <a href="ListOfRequestByAdminServlet">
                                    <div class="card card-stats card-round">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-icon">
                                                    <div
                                                        class="icon-big text-center icon-secondary bubble-shadow-small"style="background-color:#286090 "
                                                        >
                                                        <i class="fas fa-user-check"></i>
                                                    </div>
                                                </div>
                                                <div class="col col-stats ms-3 ms-sm-0">
                                                    <div class="numbers">
                                                        <p class="card-category">Request</p>
                                                        <h4 class="card-title">${sessionScope.numberOfRequest}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div>

                            <div class="col-sm-6 col-md-3">
                                <a href="ListOfUserByAdminServlet">
                                    <div class="card card-stats card-round">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-icon">
                                                    <div
                                                        class="icon-big text-center icon-success bubble-shadow-small"style="background-color: #20c997"
                                                        >
                                                        <i class="fas fa-user-friends"></i>
                                                    </div>
                                                </div>
                                                <div class="col col-stats ms-3 ms-sm-0">
                                                    <div class="numbers">
                                                        <p class="card-category">User</p>
                                                        <h4 class="card-title">${sessionScope.numberOfUsers}</h4>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                <!--   Core JS Files   -->
                <script src="assets/js/core/jquery-3.7.1.min.js"></script>
                <script src="assets/js/core/popper.min.js"></script>
                <script src="assets/js/core/bootstrap.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


                <!-- jQuery Scrollbar -->
                <script src="assets/js/plugin/jquery-scrollbar/jquery.scrollbar.min.js"></script>

                <!-- Chart JS -->
                <script src="assets/js/plugin/chart.js/chart.min.js"></script>

                <!-- jQuery Sparkline -->
                <script src="assets/js/plugin/jquery.sparkline/jquery.sparkline.min.js"></script>

                <!-- Chart Circle -->
                <script src="assets/js/plugin/chart-circle/circles.min.js"></script>

                <!-- Datatables -->
                <script src="assets/js/plugin/datatables/datatables.min.js"></script>


                <!-- jQuery Vector Maps -->
                <script src="assets/js/plugin/jsvectormap/jsvectormap.min.js"></script>
                <script src="assets/js/plugin/jsvectormap/world.js"></script>


                <!-- Kaiadmin JS -->
                <script src="assets/js/kaiadmin.min.js"></script>

                <!-- Kaiadmin DEMO methods, don't include it in your project! -->
                <script src="assets/js/setting-demo.js"></script>
                <script src="assets/js/demo.js"></script>
                <script>
            $("#lineChart").sparkline([102, 109, 120, 99, 110, 105, 115], {
                type: "line",
                height: "70",
                width: "100%",
                lineWidth: "2",
                lineColor: "#177dff",
                fillColor: "rgba(23, 125, 255, 0.14)",
            });
            $("#lineChart2").sparkline([99, 125, 122, 105, 110, 124, 115], {
                type: "line",
                height: "70",
                width: "100%",
                lineWidth: "2",
                lineColor: "#f3545d",
                fillColor: "rgba(243, 84, 93, .14)",
            });
            $("#lineChart3").sparkline([105, 103, 123, 100, 95, 105, 115], {
                type: "line",
                height: "70",
                width: "100%",
                lineWidth: "2",
                lineColor: "#ffa534",
                fillColor: "rgba(255, 165, 52, .14)",
            });
                </script>

                <script>
                    // Format price to VND
                    function formatCurrencyVND(value) {
                        return new Intl.NumberFormat('vi-VN', {
                            style: 'currency',
                            currency: 'VND'
                        }).format(value);
                    }

                    // Apply the format to all prices
                    $(document).ready(function () {
                        $('.price-vnd').each(function () {
                            let price = parseFloat($(this).text());
                            $(this).text(formatCurrencyVND(price));
                        });
                    });
                    function doClose() {
                        $('#addUserModal').modal('hide');
                    }
                </script>

                </body>
                </html>
