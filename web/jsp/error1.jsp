<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Online Learning</title>
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
        .error-container {
            background-color: #FFFFFF;
            padding: 32px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .error-container h2 {
            color: #E74C3C;
            margin-bottom: 16px;
        }
        .error-container p {
            color: #333333;
            margin-bottom: 24px;
        }
        .btn {
            padding: 10px 24px;
            border: none;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            background: linear-gradient(90deg, #4A90E2, #357ABD);
            color: #FFFFFF;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .btn:hover {
            background: linear-gradient(90deg, #357ABD, #4A90E2);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(74, 144, 226, 0.3);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h2>Error</h2>
        <p><%= request.getAttribute("error") != null ? request.getAttribute("error") : "An unexpected error occurred." %></p>
        <button class="btn" onclick="window.history.back()">Go Back</button>
    </div>
</body>
</html>