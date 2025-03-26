<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Courses" %>

<%
    List<Courses> courses = (List<Courses>) request.getAttribute("courses");
    String fullname = (String) session.getAttribute("Fullname");
%>
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
   
<body>
    <h2>List courses of  <%= fullname %></h2>
    <table border="1">
        <tr>
            <th>CourseID</th>
            <th>Name of course</th>
            <th>Description</th>
            <th>Price</th>
        </tr>
        <% if (courses != null && !courses.isEmpty()) { %>
            <% for (Courses course : courses) { %>
                <tr>
                    <td><%= course.getCourseID() %></td>
                    <td><%= course.getName() %></td>
                    <td><%= course.getDescription() %></td>
                    <td><%= course.getPrice() %></td>
                </tr>
            <% } %>
        <% } else { %>
            <tr>
                <td colspan="5">Don't have any course</td>
            </tr>
        <% } %>
    </table>
    <a href="ShowexpertServlet">Return Dashboard</a>
</body>
</html>
