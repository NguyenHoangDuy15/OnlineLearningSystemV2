<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notification</title>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #F5F5F5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .notice-container {
            background-color: #FFFFFF;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        .success {
            color: green;
            background-color: #e6ffe6;
            padding: 15px;
            border: 1px solid green;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .error {
            color: red;
            background-color: #ffe6e6;
            padding: 15px;
            border: 1px solid red;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            background: linear-gradient(90deg, #4A90E2, #357ABD);
            color: #FFFFFF;
            text-transform: uppercase;
            transition: all 0.3s ease;
        }
        .btn:hover {
            background: linear-gradient(90deg, #357ABD, #4A90E2);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(74, 144, 226, 0.3);
        }
    </style>
</head>
<body>
    <div class="notice-container">
        <% 
            String success = (String) request.getAttribute("success");
            String error = (String) request.getAttribute("error");
        %>
        <% if (success != null) { %>
            <div class="success"><%= success %></div>
        <% } %>
        <% if (error != null) { %>
            <div class="error"><%= error %></div>
        <% } %>
        <button class="btn" onclick="window.location.href='ShowexpertServlet'">Back to Dashboard</button>
    </div>
</body>
</html>