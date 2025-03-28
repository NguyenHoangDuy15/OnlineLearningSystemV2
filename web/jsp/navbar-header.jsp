<%-- 
    Document   : navbar-header
    Created on : Mar 7, 2025, 8:19:56 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <!-- Navbar Header -->
        <nav
            class="navbar navbar-header navbar-header-transparent navbar-expand-lg border-bottom"
            >
            <div class="container-fluid">
                <ul class="navbar-nav topbar-nav ms-md-auto align-items-center">
                    <li class="nav-item topbar-user dropdown hidden-caret">
                        <a
                            class="dropdown-toggle profile-pic"
                            data-bs-toggle="dropdown"
                            href="#"
                            aria-expanded="false"
                            >
                            <div class="avatar-sm">
                                <img
                                    src="./img/logo/logo.JPG"
                                    alt="..."
                                    class="avatar-img rounded-circle"
                                    />
                            </div>
                            <span class="profile-username">
                                <span class="op-7">Hi,</span>
                                <!-- Sidebar -->
                                <span class="fw-bold">
                                    ${sessionScope.account.getFullName()}
                                </span>
                            </span>
                        </a>
                        <ul class="dropdown-menu dropdown-user animated fadeIn">
                            <div class="dropdown-user-scroll scrollbar-outer">
                                <li>
                                    <div class="user-box">
                                        <div class="avatar-lg">
                                            <img
                                                src="./img/logo/logo.JPG"
                                                alt="image profile"
                                                class="avatar-img rounded"
                                                />
                                        </div>
                                        <div class="u-text">
                                            <h4>${sessionScope.account.getFullName()}</h4>
                                            <p class="text-muted">${sessionScope.user.email}</p>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item" href="ChangePasswordServlet">Change Password</a>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item" href="LogoutServlet">Logout</a>
                                </li>
                            </div>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>
        <!-- End Navbar -->
    </body>
</html>
