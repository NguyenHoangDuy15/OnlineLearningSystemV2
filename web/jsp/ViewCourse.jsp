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
    <title>My Courses</title>
    <link rel="stylesheet" href="styles.css">
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
