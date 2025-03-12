<%-- 
    Document   : updateblog
    Created on : Mar 10, 2025, 2:04:10 PM
    Author     : THU UYEN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Model.Blog" %>

<% 
    Blog blog = (Blog) request.getAttribute("blog");
    if (blog == null) {
%>
<p style="color: red;">Blog không tồn tại hoặc bạn không có quyền chỉnh sửa.</p>
<% } else { %>
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
        <title>Edit My Blog</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            .form-container {
                max-width: 800px;
                margin: auto;
                padding: 30px;
                border: 1px solid #ddd;
                border-radius: 10px;
                background-color: #f9f9f9;
                box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            }
            .form-group {
                margin-bottom: 25px;
            }
            label {
                font-weight: bold;
                margin-bottom: 5px;
            }
            input, textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            textarea {
                height: 150px;
                resize: none;
            }
            .image-preview {
                display: block;
                max-width: 100%;
                height: auto;
                margin-top: 10px;
                border-radius: 5px;
            }
            button {
                background-color: #003d80;
                color: white;
                padding: 10px 15px;
                border: none;
                border-radius: 5px;
                width: 100%;
                font-size: 16px;
                transition: background 0.3s;
            }
            button:hover {
                background-color: #003d80;
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <div class="d-flex justify-content-center mt-4">
            <div class="form-container">
                <h2 class="text-center mb-4">Edit My Blog</h2>
                <form action="EditBlog" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="blogID" value="<%= blog.getBlogID() %>">

                    <div class="form-group">
                        <label for="title">Title:</label>
                        <input type="text" id="title" name="title" value="<%= blog.getBlogTitle() %>" required>
                    </div>

                    <div class="form-group">
                        <label for="detail">Details:</label>
                        <textarea id="detail" name="detail" required><%= blog.getBlogDetail() %></textarea>
                    </div>

                    <div class="form-group">
                        <label for="image">Image:</label>
                        <% if (blog.getBlogImage() != null && !blog.getBlogImage().isEmpty()) { %>
                        <img src="<%= blog.getBlogImage() %>" alt="Ảnh blog" class="image-preview">
                        <% } %>
                        <input type="file" id="image" name="image">
                    </div>

                    <button type="submit">Save changes</button>
                </form>
            </div>
        </div>

        <%@ include file="footer.jsp" %>
    </body>
</html>
<% } %>
