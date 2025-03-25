<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>--%>
<%@ page import="Model.Usernew, Model.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Edukate - Online Education Website Template</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="Free HTML Templates" name="keywords">
        <meta content="Free HTML Templates" name="description">

        <!-- Favicon -->
        <link href="img/favicon.ico" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap" rel="stylesheet"> 
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

        <!-- Libraries Stylesheet -->
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/style.css" rel="stylesheet">

    </head>
    <head>
        <meta charset="utf-8">
        <title>Account Information</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .profile-container {
                max-width: 500px;
                margin: 50px auto;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                text-align: center;
            }
            .profile-avatar {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                object-fit: cover;
            }
            .save-btn {
                background-color: #f8d7da;
                color: #dc3545;
                width: 100%;
                cursor: not-allowed;
                border: none;
                padding: 10px;
                border-radius: 5px;
                transition: background-color 0.3s ease, color 0.3s ease;
            }

            .save-btn:hover {
                background-color: #dc3545;
                color: white;
            }

            .save-btn.active {
                background-color: #28a745; /* Màu xanh khi có thay đổi */
                color: white;
                cursor: pointer;
            }
            .form-group {
                text-align: left;
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jsp" %>
        <div class="profile-container">
            <h2 class="mb-4">My Profile</h2>
            <img src="<%= userNew.getAvatar() %>" class="profile-avatar" alt="User Avatar">
            <form action="ViewProfile" method="post" enctype="multipart/form-data">
                <div class="form-group mb-3">
                    <label for="avatar">Change Avatar:</label>
                    <input type="file" name="avatar" class="form-control">
                </div>
                <div class="form-group mb-3">
                    <label for="username">Username:</label>
                    <input type="text" name="username" class="form-control" value="<%= userNew.getUserName() %>" readonly>
                </div>
                <div class="form-group mb-3">
                    <label for="fullName">Full Name:</label>
                    <input type="text" name="fullName" class="form-control" value="<%= userNew.getFullName() %>">
                </div>
                <div class="form-group mb-3">
                    <label for="email">Email:</label>
                    <input type="email" name="email" class="form-control" required value="<%= userNew.getEmail() %>">
                </div>
                <button type="submit" class="save-btn" name ="save-btn">Save changes</button>
            </form>
        </div>
        <%@ include file="footer.jsp" %>
    </body>
</html>