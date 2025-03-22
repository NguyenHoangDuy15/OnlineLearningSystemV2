<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
                background-color: #e8f0fe;
                margin: 0;
                padding: 40px;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
            }
            .certificate {
                background-color: #ffffff;
                border: 5px solid #276FD7;
                border-radius: 20px;
                padding: 60px;
                max-width: 900px;
                margin: auto;
                box-shadow: 0 15px 30px rgba(39, 111, 215, 0.2);
                position: relative;
                overflow: hidden;
            }
            .certificate::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: url('https://www.transparenttextures.com/patterns/diagonal-striped-brick.png');
                opacity: 0.05;
                z-index: 0;
            }
            .header {
                text-align: center;
                margin-bottom: 40px;
                position: relative;
                z-index: 1;
            }
            .header img {
                max-width: 200px;
                margin-bottom: 25px;
                border-radius: 10px;
                box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
            }
            .header h1 {
                font-family: 'Playfair Display', serif;
                font-size: 40px;
                color: #276FD7;
                margin: 0;
                text-transform: uppercase;
                letter-spacing: 2px;
            }
            .content {
                text-align: center;
                position: relative;
                z-index: 1;
            }
            .content h2 {
                font-family: 'Playfair Display', serif;
                font-size: 32px;
                color: #276FD7;
                margin: 15px 0;
                font-weight: 700;
            }
            .content p {
                font-size: 18px;
                color: #444;
                margin: 10px 0;
                line-height: 1.6;
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
                border-bottom: 2px dashed #276FD7;
                margin-bottom: 10px;
                padding-bottom: 10px;
            }
            .footer {
                text-align: center;
                margin-top: 40px;
                font-size: 14px;
                color: #666;
                position: relative;
                z-index: 1;
                line-height: 1.8;
            }
            .footer a {
                color: #276FD7;
                text-decoration: none;
                font-weight: 500;
            }
            .footer a:hover {
                text-decoration: underline;
            }
            .download-btn {
                display: inline-block;
                padding: 10px 20px;
                background-color: #276FD7;
                color: #ffffff;
                text-decoration: none;
                border-radius: 5px;
                margin-top: 20px;
                font-weight: 500;
            }
            .download-btn:hover {
                background-color: #1e5bb5;
            }
        </style>
    </head>
    <body>
        <div class="certificate">
            <div class="header">
                <img src="${certificate.imageCourses}" alt="Logo">
                <h1>Certificate of Specialization Completion</h1>
            </div>
            <div class="content">
                <p>This is to certify that</p>
                <h2>${certificate.fullname}</h2>
                <p>has successfully completed the specialization</p>
                <h2>${certificate.name}</h2>
                <p>Completed on: ${certificate.completionTime}</p>
            </div>
            <div class="signature">
                <div>
                    <p class="sign"></p>
                    <p>Praveen Mittal</p>
                    <p>Adjunct Professor</p>
                </div>
                <div>
                    <p class="sign"></p>
                    <p>Kevin Wendt</p>
                    <p>Academic Director</p>
                </div>
            </div>
            <div class="footer">
                <p>The specialization named in this certificate may draw on material from courses taught on-campus, but the included courses are not equivalent to on-campus courses. Participation in this online specialization does not constitute enrollment at the university. This certificate does not confer a University grade, course credit or degree, and it does not verify the identity of the learner.</p>
                <p>Verify this certificate at: <a href="https://platform.com/verify/9C1SRH67X8VA">https://platform.com/verify/9C1SRH67X8VA</a></p>
                <!-- Nút Download PDF -->
                <c:if test="${not empty certificate}">
                    <a href="DownloadCertificateServlet?courseId=${certificate.courseId}" class="download-btn">Download PDF</a>
                </c:if>
                <!-- Debug Info -->
                <div>
                    <p>Debug Info:</p>
                    <p>UserID: ${sessionScope.userid}</p>
                    <p>Certificate: ${certificate.courseId}</p>
                </div>
            </div>
        </div>
    </body>
</html>