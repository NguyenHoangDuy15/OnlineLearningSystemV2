<%-- 
    Document   : viewblog
    Created on : Mar 6, 2025, 1:49:27 PM
    Author     : THU UYEN
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Model.Blog" %>
<!DOCTYPE html>
<html>
    <head>
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
        <meta charset="UTF-8">
        <title>Blog</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
            }
            h2 {
                text-align: center;
                font-size: 28px;
                font-weight: bold;
                margin-top: 20px;
            }
            .blog-container {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 20px;
                margin-top: 20px;
            }
            .blog-item {
                width: 600px;
                border: 1px solid #ddd;
                padding: 15px;
                border-radius: 8px;
                text-align: left;
            }
            .blog-item img {
                width: 100%;
                height: 300px; /* Đặt chiều cao cố định */
                object-fit: cover; /* Cắt ảnh để vừa khung mà không bị méo */
                border-radius: 8px;
            }
            .blog-title {
                font-size: 20px;
                font-weight: bold;
                margin-top: 10px;
            }
            .blog-detail {
                margin-top: 10px;
            }
            /* Style cho nút search */
            .search-btn {
                padding: 8px 12px;
                border: none;
                background: #b3d9ff;
                color: black;
                border-radius: 5px;
                cursor: pointer;
            }
            .search-btn:hover {
                background: #0056b3;
            </style>
        </head>
    </head>
    <body>
        <%@ include file="header.jsp" %>
        <div style="text-align: center;
            padding: 10px 20px;">
            <h2 style="margin-bottom: 10px;">Our Blog</h2>
            <form action="SearchBlog" method="get" style="display: flex;
                justify-content: center;">
                <input type="text" name="keyword" placeholder="Search blogs..." required 
                       value="${param.keyword}"
                       style="padding: 8px;
                width: 300px;
                border: 1px solid #ccc;
                border-radius: 5px;
                margin-right: 5px;">
                <button type="submit" class="search-btn">Search</button>
            </form>
        </div>
        <div class="blog-container">

            <c:forEach var="blog" items="${blogList}">
                <div class="blog-item">
                    <img src="${blog.blogImage}" alt="Blog Image">
                    <div class="blog-title">${blog.blogTitle}</div>
                    <div class="blog-detail">${blog.blogDetail}</div>
                </div>
            </c:forEach>
            <c:if test="${empty blogList}">
                <p>No results found for your search.</p>
            </c:if>

        </div>

        <%@ include file="footer.jsp" %>
    </body>
</html>