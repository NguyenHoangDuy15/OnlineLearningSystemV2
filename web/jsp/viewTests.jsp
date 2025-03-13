<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Test" %>

<%
    List<Test> tests = (List<Test>) request.getAttribute("tests");
    String fullName = (String) session.getAttribute("Fullname");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Tests</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h2>List test of  <%= fullName %></h2>
    <table border="1">
        <tr>
            <th>TestID</th>
            <th>Name of test</th>
            <th>Status</th>
            <th>Course ID</th>
        </tr>
        <% if (tests != null && !tests.isEmpty()) { %>
            <% for (Test test : tests) { %>
                <tr>
                    <td><%= test.getTestID() %></td>
                    <td><%= test.getName() %></td>
                    <td><%= test.getStatus() == 1 ? "Not done" : "Done" %></td>
                    <td><%= test.getCourseID() %></td>
                </tr>
            <% } %>
        <% } else { %>
            <tr>
                <td colspan="5">Don't have any test</td>
            </tr>
        <% } %>
    </table>
    <a href="ShowexpertServlet">Return Dashboard</a>
</body>
</html>
