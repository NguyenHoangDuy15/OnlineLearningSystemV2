<%-- 
    Document   : sidebarManager
    Created on : Mar 7, 2025, 8:17:21 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sidebar</title>
    </head>
    <body>
        <!-- Sidebar -->
        <div class="sidebar" data-background-color="dark">
            <div class="sidebar-logo">
                <!-- Logo Header -->
                <div class="logo-header" data-background-color="dark">
                    <a href="ShowAdminDasboardServlet" class="logo">
                        <img
                            src="./img/logo/logo.JPG"
                            alt="navbar brand"
                            class="navbar-brand"
                            height="40"
                            />
                    </a>
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
            <div class="sidebar-wrapper scrollbar scrollbar-inner">
                <div class="sidebar-content">
                    <ul class="nav nav-secondary">
                        <li class="nav-item">
                            <a
                                href="ShowAdminDasboardServlet"
                                >
                                <i class="fas fa-home"></i>
                                <p>Dashboard</p>
                            </a>
                        </li>
                        <li class="nav-section">
                            <span class="sidebar-mini-icon">
                                <i class="fa fa-ellipsis-h"></i>
                            </span>
                            <h4 class="text-section">Manage</h4>
                        </li>
                        <li class="nav-item">
                            <a data-bs-toggle="collapse" href="#base">
                                <i class="fas fa-users"></i>
                                <p>User</p>
                                <span class="caret"></span>
                            </a>
                            <div class="collapse" id="base">
                                <ul class="nav nav-collapse">
                                    <li>
                                        <a href="ListOfUserByAdminServlet">
                                            <span class="sub-item">List User</span>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="ListOfExpertServlet">
                                            <span class="sub-item">List Expert</span>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="ListOfSellerServlet">
                                            <span class="sub-item">List Seller</span>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="AddNewUserServlet">
                                            <span class="sub-item">Add Expert/Seller</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </li>
                        <li class="nav-item">
                            <a data-bs-toggle="collapse" href="#tab">
                                <i class="fas fa-pen-square"></i>
                                <p>Manage Course</p>
                                <span class="caret"></span>
                            </a>
                            <div class="collapse" id="tab">
                                <ul class="nav nav-collapse">
                                    <li>
                                        <a href="ListOfCourseByAdminServlet">
                                            <span class="sub-item">List Course</span>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="ListOfCourseRequestByAdminServlet">
                                            <span class="sub-item">List Courses Request</span>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <!--                                        <a href=""> ListOfTopCourseByAdminServlet-->
                                            <span class="sub-item">List Top Courses</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </li>
                        <!--                        <li class="nav-item">
                                                    <a data-bs-toggle="collapse" href="#guestForms" aria-expanded="false" aria-controls="guestForms">
                                                        <i class="fas fa-pen-square"></i>
                                                        <p>Manage Course</p>
                                                        <span class="caret"></span>
                                                    </a>
                                                    <div class="collapse" id="guestForms">
                                                        <ul class="nav nav-collapse">
                                                            <li>
                                                                <a href="ListOfCourseByAdminServlet">
                                                                    <span class="sub-item">List Course</span>
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a href="ListOfCourseRequestByAdminServlet">
                                                                    <span class="sub-item">List Courses Request</span>
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a href="ListOfTopCourseByAdminServlet">
                                                                    <span class="sub-item">List Top Courses</span>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </li>-->
                        <li class="nav-item">
                            <a data-bs-toggle="collapse" href="#maps">
                                <i class="fas fa-comment-dots"></i>
                                <p>Feedback</p>
                                <span class="caret"></span>
                            </a>
                            <div class="collapse" id="maps">
                                <ul class="nav nav-collapse">
                                    <li>
                                        <a href="ListOfFeedbackByAdminServlet">
                                            <span class="sub-item">List Feedback</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </li>
                        <li class="nav-item">
                            <a data-bs-toggle="collapse" href="#sidebarLayouts">
                                <i class="far fa-check-circle"></i>
                                <p>Request</p>
                                <span class="caret"></span>
                            </a>
                            <div class="collapse" id="sidebarLayouts">
                                <ul class="nav nav-collapse">
                                    <li>
                                        <a href="ListOfRequestByAdminServlet">
                                            <span class="sub-item">List Request</span>
                                        </a>                                    
                                    </li>
                                </ul>
                            </div>
                        </li>
                        <li class="nav-item">
                            <a data-bs-toggle="collapse" href="#forms">
                                <i class="fas fa-window-maximize"></i>
                                <p>Blog</p>
                                <span class="caret"></span>
                            </a>
                            <div class="collapse" id="forms">
                                <ul class="nav nav-collapse">
                                    <li>
                                        <a href="ListBlogByAdminServlet">
                                            <span class="sub-item">List Blog</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </li>

                        <li class="nav-item">
                            <a data-bs-toggle="collapse" href="#tables">
                                <i class="fas fa-bell"></i>
                                <p>Transaction history</p>
                                <span class="caret"></span>
                            </a>
                            <div class="collapse" id="tables">
                                <ul class="nav nav-collapse">
                                    <li>
                                        <a href="ListTranscriptByAdminServlet">
                                            <span class="sub-item">List Transaction history</span>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <!-- End Sidebar -->
    </body>
</html>
