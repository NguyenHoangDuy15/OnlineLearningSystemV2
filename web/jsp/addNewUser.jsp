<%-- 
    Document   : addNewUser
    Created on : Mar 8, 2025, 9:18:42 AM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <title>Add user</title><!--  page only for manager  -->
        <meta
            content="width=device-width, initial-scale=1.0, shrink-to-fit=no"
            name="viewport"
            />
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
        <!--        <link rel="stylesheet" href="assets/css/demo.css" />-->

    </head>
    <body>
        <div class="wrapper">
            <!-- Sidebar -->
            <jsp:include page="sidebarManager.jsp"/>
            <!-- End Sidebar -->
            <div class="main-panel">
                <div class="main-header">
                    <div class="main-header-logo">
                        <!-- Logo Header -->
                        <div class="logo-header" data-background-color="dark">
                            <a href="../index.jsp" class="logo">
                                <img
                                    src="assets/img/kaiadmin/logo_light.svg"
                                    alt="navbar brand"
                                    class="navbar-brand"
                                    height="20"
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
                    <!-- Navbar Header -->
                    <jsp:include page="navbar-header.jsp"/>
                </div>

                <div class="container">
                    <div class="page-inner">
                        <div class="page-header">
                            <h3 class="fw-bold mb-3">Manage User</h3>
                        </div>



                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-header">
                                    <div class="d-flex align-items-center">
                                        <h4 class="card-title">Add User</h4>
                                        <button class="btn btn-primary btn-round ms-auto" onclick="BackToList()">
                                            <i class="fas fa-angle-left"></i>
                                            Back to list
                                        </button>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <!-- Modal -->
                                    <div>
                                        <div class="modal-dialog" role="document">
                                            <div class="modal-content">
                                                <form action="AddNewUserServlet"  method="POST"  onsubmit="return validate()">
                                                    <div class="modal-body">
                                                        <c:set value="${requestScope.user}" var="u"/>
                                                        <div class="row">
                                                            <div class="col-sm-12">
                                                                <div class="form-group form-group-default">
                                                                    <label>Full Name</label>
                                                                    <input
                                                                        name="name"
                                                                        id="name"
                                                                        value="${name}"
                                                                        type="text"
                                                                        maxlength="100"
                                                                        minlength="4"
                                                                        pattern="^[A-Za-zÀ-ÿ\s'-]{1,100}$"
                                                                        title="Name contains only character, length should more than 4 and less than 100"
                                                                        class="form-control"
                                                                        required
                                                                        placeholder="Enter user's fullname"
                                                                        />
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6">
                                                                <div class="form-group form-group-default">
                                                                    <label>Username</label>
                                                                    <input
                                                                        value="${username}"
                                                                        id="username"
                                                                        name="username"
                                                                        type="text"
                                                                        placeholder="Enter username"
                                                                        pattern="^(?![0-9])[a-zA-Z0-9_]{5,20}$" title="Invalid username! Must be 5-20 characters, no spaces, not starting with a number."
                                                                        class="form-control"
                                                                        required
                                                                        />
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6">
                                                                <div class="form-group form-group-default">
                                                                    <label>Password</label>
                                                                    <input
                                                                        name="password"
                                                                        id="password"
                                                                        value="${password}"
                                                                        type="text" pattern="^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$!%^&*])[A-Za-z\d@#$!%^&*]{8,}$" title="Password must be at least 8 characters with 1 uppercase, 1 lowercase, 1 number, and 1 special character."
                                                                        class="form-control"
                                                                        style="width: 50%"
                                                                        placeholder="Enter password"
                                                                        required
                                                                        />
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6">
                                                                <div class="form-group form-group-default">
                                                                    <label>Email</label>
                                                                    <input
                                                                        id="email"
                                                                        name="email"
                                                                        type="text"
                                                                        value="${email}"
                                                                        class="form-control"
                                                                        placeholder="Enter email"
                                                                        required
                                                                        pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                                                        title="Invalid email format!"
                                                                        />
                                                                </div>
                                                            </div>
                                                            <div class="col-sm-6">
                                                                <div class="form-group form-group-default">
                                                                    <label>Re-Password</label>
                                                                    <input
                                                                        name="repassword"
                                                                        id="repassword"
                                                                        value="${password}"
                                                                        type="text" pattern="^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$!%^&*])[A-Za-z\d@#$!%^&*]{8,}$" title="Password must be at least 8 characters with 1 uppercase, 1 lowercase, 1 number, and 1 special character."
                                                                        class="form-control"
                                                                        style="width: 50%"
                                                                        placeholder="Enter re-password"
                                                                        required
                                                                        />
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-sm-6">
                                                            <div class="form-group form-group-default">
                                                                <label>Role</label>                  
                                                                <select name="role" class="form-control">
                                                                    <option value="2" ${u.role == 2 ? "selected" : ""}>Expert</option>
                                                                    <option value="3" ${u.role == 3 ? "selected" : ""}>Seller</option>
                                                                </select>

                                                            </div>
                                                        </div>
                                                    </div>
                                                    <input type="text" name="userid" value="${u.userID}" hidden="">
                                                    <div class="modal-footer border-0">
                                                        ${err}
                                                        <button
                                                            type="submit"
                                                            class="btn btn-primary">
                                                            ADD
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <footer class="footer">

            </footer>
        </div>

        <!-- Custom template | don't include it in your project! -->

        <!-- End Custom template -->
    </div>
    <!--   Core JS Files   -->
    <script src="assets/js/core/jquery-3.7.1.min.js"></script>
    <script src="assets/js/core/popper.min.js"></script>
    <script src="assets/js/core/bootstrap.min.js"></script>

    <!-- jQuery Scrollbar -->
    <script src="assets/js/plugin/jquery-scrollbar/jquery.scrollbar.min.js"></script>
    <!-- Datatables -->
    <script src="assets/js/plugin/datatables/datatables.min.js"></script>
    <!-- Kaiadmin JS -->
    <script src="assets/js/kaiadmin.min.js"></script>
    <!-- Kaiadmin DEMO methods, don't include it in your project! -->
    <script src="assets/js/setting-demo2.js"></script>
    <script>
                                                    document.querySelector('.close').editEventListener('click', function () {
                                                        $('#editUserModal').modal('hide');
                                                    });
    </script>
    <script>
        function doClose() {
            $('#editUserModal').modal('hide');
        }
    </script>
    <script>
        function BackToList() {
            window.location = "ShowAdminDasboardServlet";
        }
    </script>

    <script>
        document.getElementById("address").addEventListener("blur", function () {
            const address = this.value.trim();
            const pattern = /^[\p{L}\p{N}\s,.'-]+$/u; // Supports letters, numbers, and common punctuation
            if (address !== "") {
                if (!pattern.test(address)) {
                    alert("Invalid address. Please use only letters, numbers, spaces, commas, periods, apostrophes, and hyphens.");
                    this.value = "";
                }
            }
        });
        document.getElementById("email").addEventListener("blur", function () {
            const email = this.value.trim();
            const regexEmail = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            if (email !== "") {
                if (!regexEmail.test(email)) {
                    alert("Invalid email format!");
                    this.value = "";
                }
            }
        });
    </script>
    <script>
        function validate() {

            var option = confirm("Are you sure to add new user?");
            if (option === true) {
                return true;
            }
            return false;
        }
    </script>
    <script>
        const startDateInput = document.getElementById("startdate");

        // Set today's date as the minimum date (can't be in the past)
        const today = new Date();
        const minDate = today.toISOString().split('T')[0];
        startDateInput.setAttribute("min", minDate);

        // Set the max date to 30 days in the future
        const maxFutureDate = new Date(today);
        maxFutureDate.setDate(maxFutureDate.getDate() + 30); // 30 days from today
        const maxDate = maxFutureDate.toISOString().split('T')[0];
        startDateInput.setAttribute("max", maxDate);
    </script>
    <script>
        const today2 = new Date();
        // Set the max attribute for the birthday input to today's date
        const minAgeDate = new Date(today2.getFullYear() - 18, today2.getMonth(), today2.getDate());
        // Set the max attribute for the birthday input to the date 18 years ago
        document.getElementById("birthday").setAttribute("max", minAgeDate.toISOString().split('T')[0]);
    </script>

    <script>
        $(document).ready(function () {
            $("#basic-datatables").DataTable({});

            $("#multi-filter-select").DataTable({
                pageLength: 5,
                initComplete: function () {
                    this.api()
                            .columns()
                            .every(function () {
                                var column = this;
                                var select = $(
                                        '<select class="form-select"><option value=""></option></select>'
                                        )
                                        .appendTo($(column.footer()).empty())
                                        .on("change", function () {
                                            var val = $.fn.dataTable.util.escapeRegex($(this).val());
                                            column
                                                    .search(val ? "^" + val + "$" : "", true, false)
                                                    .draw();
                                        });

                                column
                                        .data()
                                        .unique()
                                        .sort()
                                        .each(function (d, j) {
                                            select.append(
                                                    '<option value="' + d + '">' + d + "</option>"
                                                    );
                                        });
                            });
                },
            });

            // edit Row
            $("#edit-user").DataTable({
                pageLength: 5,
            });

            var action =
                    '<td> <div class="form-button-action"> <button type="button" data-bs-toggle="tooltip" title="" class="btn btn-link btn-primary btn-lg" data-original-title="Edit Task"> <i class="fa fa-edit"></i> </button> <button type="button" data-bs-toggle="tooltip" title="" class="btn btn-link btn-danger" data-original-title="Remove"> <i class="fa fa-times"></i> </button> </div> </td>';

            $("#editUserButton").click(function () {
                $("#edit-user")
                        .dataTable()
                        .fneditData([
                            $("#editName").val(),
                            $("#editPosition").val(),
                            $("#editOffice").val(),
                            action,
                        ]);
                $("#editUserModal").modal("hide");
            });
        });
    </script>

</body>
</html>
