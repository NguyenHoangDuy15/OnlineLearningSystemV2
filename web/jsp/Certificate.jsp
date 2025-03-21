<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Certificate of Specialization Completion</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@300;400&display=swap');

        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 40px;
        }
        .certificate {
            background-color: #ffffff;
            border: 4px solid #b8860b;
            border-radius: 15px;
            padding: 50px;
            max-width: 900px;
            margin: auto;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            position: relative;
        }
        .certificate::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('https://www.transparenttextures.com/patterns/diagonal-striped-brick.png');
            opacity: 0.1;
            z-index: 0;
        }
        .header {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
            z-index: 1;
        }
        .header img {
            max-width: 180px;
            margin-bottom: 20px;
        }
        .header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 36px;
            color: #333;
            margin: 0;
        }
        .content {
            text-align: center;
            position: relative;
            z-index: 1;
        }
        .content h2 {
            font-family: 'Playfair Display', serif;
            font-size: 28px;
            color: #b8860b;
            margin: 15px 0;
        }
        .content p {
            font-size: 18px;
            color: #555;
            margin: 10px 0;
        }
        .courses {
            text-align: left;
            margin: 30px auto;
            max-width: 600px;
            font-size: 16px;
            color: #444;
        }
        .courses li {
            margin-bottom: 10px;
        }
        .signature {
            margin-top: 50px;
            display: flex;
            justify-content: space-between;
            position: relative;
            z-index: 1;
        }
        .signature div {
            text-align: center;
            width: 45%;
        }
        .signature p {
            font-size: 16px;
            color: #333;
            margin: 5px 0;
        }
        .signature .sign {
            border-bottom: 1px solid #000;
            margin-bottom: 10px;
        }
        .footer {
            text-align: center;
            margin-top: 40px;
            font-size: 14px;
            color: #777;
            position: relative;
            z-index: 1;
        }
        .footer a {
            color: #b8860b;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="certificate">
        <div class="header">
            <img src="path/to/logo.png" alt="Logo"> <!-- Replace with your logo path -->
            <h1>Certificate of Specialization Completion</h1>
        </div>
        <div class="content">
            <p>This is to certify that</p>
            <h2>[Recipient Name]</h2>
            <p>has successfully completed the specialization</p>
            <h2>[Specialization Name]</h2>
            <p>The specialization includes the following courses:</p>
            <ul class="courses">
                <li>Course 1</li>
                <li>Course 2</li>
                <li>Course 3</li>
            </ul>
            <p>[Specialization Description]</p>
        </div>
        <div class="signature">
            <div>
                <p class="sign">________________________</p>
                <p>Praveen Mittal</p>
                <p>Adjunct Professor</p>
            </div>
            <div>
                <p class="sign">________________________</p>
                <p>Kevin Wendt</p>
                <p>Academic Director</p>
            </div>
        </div>
        <div class="footer">
            <p>The specialization named in this certificate may draw on material from courses taught on-campus, but the included courses are not equivalent to on-campus courses. Participation in this online specialization does not constitute enrollment at the university. This certificate does not confer a University grade, course credit or degree, and it does not verify the identity of the learner.</p>
            <p>Verify this certificate at: <a href="https://platform.com/verify/9C1SRH67X8VA">https://platform.com/verify/9C1SRH67X8VA</a></p>
        </div>
    </div>
</body>
</html>