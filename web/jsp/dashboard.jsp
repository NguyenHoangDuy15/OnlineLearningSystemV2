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

        <!-- CSS Just for demo purpose, don't include it in your project -->
        <!--<link rel="stylesheet" href="assets/css/demo.css" />-->
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
                            </div>
                            <div class="col-sm-6 col-md-3">
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
                            </div>
                            <div class="col-sm-6 col-md-3">
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
                            </div>
                            <div class="col-sm-6 col-md-3">
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
                            </div>
                            <div class="col-sm-6 col-md-3">
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
                            </div>

                            <div class="col-sm-6 col-md-3">

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
                            </div>
                            <div class="col-sm-6 col-md-3">
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
                            </div>

                            <div class="col-sm-6 col-md-3">

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

                            </div>

                            <div class="row notifications-container">
                                <!-- Newest Notifications Section -->
                                <div class="container">
                                    <!-- Tabs Navigation -->
                                    <ul class="nav nav-tabs" id="myTab" role="tablist">
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link active" id="notifications-tab" data-bs-toggle="tab" data-bs-target="#notifications" type="button" role="tab" aria-controls="notifications" aria-selected="true">Newest Notifications</button>
                                        </li>
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link" id="room-stats-tab" data-bs-toggle="tab" data-bs-target="#room-stats" type="button" role="tab" aria-controls="room-stats" aria-selected="false">Room Statistics</button>
                                        </li>
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link" id="transaction-history-tab" data-bs-toggle="tab" data-bs-target="#transaction-history" type="button" role="tab" aria-controls="transaction-history" aria-selected="false">Transaction History</button>
                                        </li>
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link" id="room-types-tab" data-bs-toggle="tab" data-bs-target="#room-types" type="button" role="tab" aria-controls="room-types" aria-selected="false">Number of Room Types</button>
                                        </li>
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link" id="revenue-stats-tab" data-bs-toggle="tab" data-bs-target="#revenue-stats" type="button" role="tab" aria-controls="revenue-stats" aria-selected="false">Invoice Statistics by Month</button>
                                        </li>
                                    </ul>

                                    <!-- Tabs Content -->
                                    <div class="tab-content" id="myTabContent">
                                        <!-- Newest Notifications Section -->
                                        <div class="tab-pane fade show active" id="notifications" role="tabpanel" aria-labelledby="notifications-tab">
                                            <div class="card">
                                                <div class="card-header">
                                                    <div class="card-title">Newest Notifications</div>
                                                </div>
                                                <div class="card-body">
                                                    <ul>
                                                        <c:forEach var="news" items="${sessionScope.newsList}">
                                                            <li>
                                                                <span style="font-size: 21px" class="date">${news.publishDate}</span>
                                                                <a style="font-size: 22px" href="NewsServlet?action=view&id=${news.newsID}">${news.title}</a>
                                                                <p style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-size:16px;">
                                                                    ${news.content}
                                                                </p>
                                                            </li>
                                                        </c:forEach>
                                                        <li><a href="viewNotification">View all notifications</a></li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Room Statistics Section -->
                                        <div class="tab-pane fade" id="room-stats" role="tabpanel" aria-labelledby="room-stats-tab">
                                            <div class="card">
                                                <div class="card-header">
                                                    <div class="card-title">Room Statistics</div>
                                                </div>
                                                <div class="card-body" style="padding: 0; display: flex; justify-content: center; align-items: center;">
                                                    <div class="chart-container" style="width: 800px; height: 600px;"> 
                                                        <canvas id="myChart" style="width: 100%; height: 100%;"></canvas> 
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Transaction History Section -->
                                        <div class="tab-pane fade" id="transaction-history" role="tabpanel" aria-labelledby="transaction-history-tab">
                                            <div class="card card-round">
                                                <div class="card-header">
                                                    <div class="card-head-row card-tools-still-right">
                                                        <div class="card-title">Transaction History</div>
                                                    </div>
                                                </div>
                                                <div class="card-body p-0">
                                                    <div class="table-responsive">
                                                        <table class="table align-items-center mb-0">
                                                            <thead class="thead-light">
                                                                <tr>
                                                                    <th scope="col">Invoice Number</th>
                                                                    <th scope="col" class="text-end">Date & Time</th>
                                                                    <th scope="col" class="text-end">Amount</th>
                                                                    <th scope="col" class="text-end">Status</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                            <c:forEach items="${sessionScope.listInvoice}" var="i">
                                                                <tr>
                                                                    <th scope="row">
                                                                        <button class="btn btn-icon btn-round btn-success btn-sm me-2">
                                                                            <i class="fa fa-check"></i>
                                                                        </button>
                                                                        Payment No ${i.invoiceNo}
                                                                    </th>
                                                                    <td class="text-end">${i.paymentDate}</td>
                                                                    <td class="text-end price-vnd">${i.finalAmount} VND</td>
                                                                    <td class="text-end">
                                                                        <span class="badge badge-success">Completed</span>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Number of Room Types Section -->
                                        <div class="tab-pane fade" id="room-types" role="tabpanel" aria-labelledby="room-types-tab">
                                            <div class="card">
                                                <div class="card-header">
                                                    <div class="card-title">Number of room types</div>
                                                </div>
                                                <div class="card-body" style=" display: flex; justify-content: center;">
                                                    <div class="chart-container" style="width: 800px; height: 600px;">
                                                        <canvas id="roomChart" style="width: 100%; height: 100%;"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>


                                        <div class="tab-pane fade" id="revenue-stats" role="tabpanel" aria-labelledby="revenue-stats-tab">
                                            <div class="card">
                                                <div class="card-header">
                                                    <div class="card-title">Invoice Statistics by Month</div>
                                                </div>
                                                <div class="card-body" >
                                                    <div class="chart-container" style="display: flex; justify-content: center;">
                                                        <canvas id="revenueChart" style="width: 100%; height: 100%;"></canvas>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <script>
            var maintenanceData = {
                labels: ["Under Maintenance", "Available", "Occupied"],
                datasets: [{
                        label: 'Room Status',
                        data: [<%= session.getAttribute("maintaince") %>, <%= session.getAttribute("available") %>, <%= session.getAttribute("occupied") %>],
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.2)',
                            'rgba(54, 162, 235, 0.2)',
                            'rgba(255, 206, 86, 0.2)'
                        ],
                        borderColor: [
                            'rgba(255, 99, 132, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)'
                        ],
                        borderWidth: 1
                    }]
            };
            var maintenanceCtx = document.getElementById('maintenanceChart').getContext('2d');
            var maintenanceChart = new Chart(maintenanceCtx, {
                type: 'bar',
                data: maintenanceData,
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
                </script>
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
                    const underMaintenance = ${sessionScope.maintaince};
                    const available = ${sessionScope.available};
                    const occupied = ${sessionScope.occupied};
                    console.log(available);
                    var ctx = document.getElementById('myChart').getContext('2d');
                    const data_chart = {
                        labels: [
                            'Under Maintenance',
                            'Available',
                            'Occupied'
                        ],
                        datasets: [{
                                data: [underMaintenance, available, occupied],
                                backgroundColor: [
                                    'orange',
                                    'greenyellow',
                                    '#286090'
                                ],
                                borderWidth: 1
                            }]
                    };
                    var myChart = new Chart(ctx, {
                        type: 'doughnut',
                        data: data_chart
                    });
                </script>
                <!--                
                                <script>
                
                                    // Extract the labels (room types) and data (booking times)
                                    const labels_type = roomStats.map(room => room.typeName);  // Room types on the x-axis
                                    const datatype = roomStats.map(room => room.bookTimes);   // Booking times on the y-axis
                                    console.log(datatype);
                                    // Render the chart
                                    var roomChart = document.getElementById('roomChart').getContext('2d');
                                    const data_chartss = {
                                        labels: labels_type,
                                        datasets: [{
                                                label: 'Room Booking Statistics',
                                                data: datatype,
                                                backgroundColor: [
                                                    'rgba(255, 99, 132, 0.2)',
                                                    'rgba(255, 159, 64, 0.2)',
                                                    'rgba(255, 205, 86, 0.2)',
                                                    'rgba(54, 162, 235, 0.2)',
                                                    'rgba(153, 102, 255, 0.2)',
                                                    'rgba(201, 203, 207, 0.2)'
                                                ],
                                                borderColor: [
                                                    'rgb(255, 99, 132)',
                                                    'rgb(255, 159, 64)',
                                                    'rgb(255, 205, 86)',
                                                    'rgb(75, 192, 192)',
                                                    'rgb(54, 162, 235)',
                                                    'rgb(153, 102, 255)',
                                                    'rgb(201, 203, 207)'
                                                ],
                                                borderWidth: 1
                                            }]
                                    };
                
                                    var roomCh = new Chart(roomChart, {
                                        type: 'bar',
                                        data: data_chartss,
                                        options: {
                                            scales: {
                                                y: {
                                                    beginAtZero: true,
                                                    min: 0,
                                                    title: {
                                                        display: true,
                                                        text: 'Booking Times'  // Label for y-axis
                                                    }
                                                },
                                                x: {
                                                    title: {
                                                        display: true,
                                                        text: 'Room Types'  // Label for x-axis
                                                    }
                                                }
                                            }
                                        }
                                    });
                                </script>-->
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
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const months = [];
                        const revenue = [];


                        <c:forEach var="entry" items="${revenueByMonth}">
                                            months.push('${entry.key}');
                                        revenue.push(${entry.value});
                                </c:forEach>


                        console.log(months, revenue);

                        const ctx = document.getElementById('revenueChart').getContext('2d');
                        const revenueChart = new Chart(ctx, {
                            type: 'bar',
                            data: {
                                labels: months,
                                datasets: [{
                                        label: 'Revenue (VND)',
                                        data: revenue,
                                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                                        borderColor: 'rgba(75, 192, 192, 1)',
                                        borderWidth: 1
                                    }]
                            },
                            options: {
                                scales: {
                                    y: {
                                        beginAtZero: true
                                    }
                                }
                            }
                        });
                    });
                    </script>


                    </body>
                    </html>
