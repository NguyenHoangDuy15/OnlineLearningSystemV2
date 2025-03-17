﻿--Create database OnlineLearning
--Use OnlineLearning
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY,
    RoleName VARCHAR(255) NOT NULL
);
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(255) NOT NULL,
    UserName NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(1000) NOT NULL,
    Avartar nvarchar(max),  -- Giữ lại cột Avartar từ nhánh `customer`
    RoleID INT FOREIGN KEY REFERENCES Roles(RoleID),
    Status TINYINT NOT NULL DEFAULT 1  -- Giữ lại kiểu dữ liệu TINYINT với DEFAULT 1 từ nhánh `customer`
);




CREATE TABLE Category (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(255) NOT NULL,
    Description TEXT
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Description TEXT,
    Price FLOAT,
	imageCources nvarchar(max),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    CategoryID INT FOREIGN KEY REFERENCES Category(CategoryID),
    CreatedAt DATE,
	
);

CREATE TABLE Lessons (
    LessonID INT IDENTITY(1,1) PRIMARY KEY,
    Content NVARCHAR(MAX),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    Title NVARCHAR(255),
    Status INT CHECK (Status IN (0,1))
);

CREATE TABLE Blogs (
    BlogID INT IDENTITY(1,1) PRIMARY KEY,
    BlogTitle NVARCHAR(255) NOT NULL,
    BlogDetail NVARCHAR(1000) NOT NULL,
    BlogImage nvarchar(max),
    BlogDate DATE,
    UserID INT FOREIGN KEY REFERENCES Users(UserID)
);

CREATE TABLE Feedbacks (
    FeedbackID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    CourseID INT NOT NULL FOREIGN KEY REFERENCES Courses(CourseID),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(1000) NOT NULL,
    CreatedAt DATE
);

CREATE TABLE Payment (
    PayID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    Amount DECIMAL(10,2)
);

CREATE TABLE TransactionHistory (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    PayID INT NOT NULL FOREIGN KEY REFERENCES Payment(PayID),
    Status INT CHECK (Status IN (0,1)),
    CreatedAt DATETIME,
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    PaymentMethod NVARCHAR(50),
    PaymentDate DATETIME
);

CREATE TABLE Requests (
    RequestID INT PRIMARY KEY IDENTITY(1,1),
    RequestedRole INT FOREIGN KEY REFERENCES Roles(RoleID),
    UserID INT FOREIGN KEY REFERENCES Users(UserID)
);
CREATE TABLE Answer (
    AnswerID INT PRIMARY KEY IDENTITY(1,1),
    IsCorrectAnswer INT CHECK (IsCorrectAnswer IN (0,1)),
    AnswerContent NVARCHAR(255),
  
);
CREATE TABLE Question (
    QuestionID INT PRIMARY KEY IDENTITY(1,1),
    QuestionType NVARCHAR(255),
    QuestionContent NVARCHAR(255),
	OptionA NVARCHAR(255),
    OptionB NVARCHAR(255),
    OptionC NVARCHAR(255),
    OptionD NVARCHAR(255),
    AnswerID INT FOREIGN KEY REFERENCES Answer(AnswerID)
);
CREATE TABLE Test (
    TestID INT PRIMARY KEY  IDENTITY(1,1),
    Name VARCHAR(255),
    Status INT CHECK (Status IN (0,1)),
    CreatedBy NVARCHAR(50),
   
    TotalMark FLOAT,
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID)
);

CREATE TABLE Test_Question ( -- Bảng trung gian để Test có nhiều Question
    TestID INT FOREIGN KEY REFERENCES Test(TestID),
    QuestionID INT FOREIGN KEY REFERENCES Question(QuestionID),
    PRIMARY KEY (TestID, QuestionID)
);

CREATE TABLE UserAnswers (--lưu câu trả lời của từng người dùn
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    TestID INT FOREIGN KEY REFERENCES Test(TestID),
    QuestionID INT FOREIGN KEY REFERENCES Question(QuestionID),
    AnswerID INT FOREIGN KEY REFERENCES Answer(AnswerID),
    PRIMARY KEY (UserID, TestID, QuestionID)
);





CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY  IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    Status INT CHECK (Status IN (0,1)),
    EnrolledAt DATETIME
);
ALTER TABLE Blogs  
ALTER COLUMN BlogTitle NVARCHAR(255) COLLATE Vietnamese_CI_AS;  

ALTER TABLE Blogs  
ALTER COLUMN BlogDetail NVARCHAR(MAX) COLLATE Vietnamese_CI_AS;

INSERT INTO Roles (RoleID, RoleName) 
VALUES 
    (1, 'Admin'),
    (2, 'Expert'),
    (3, 'Sale'),
    (4, 'Customer');
	INSERT INTO [dbo].[Users]
           ([FullName]
           ,[UserName]
           ,[Email]
           ,[Password]
           ,[Avartar]
           ,[RoleID]
           ,[Status])
     VALUES
           ('Admin123@'
           ,'Admin123@'
           ,'Admin123@gmail.com'
           ,'QWRtaW4xMjNAZndlcWZ3ZTtoZml1ZHNmYXNkZmFzZGZhcw=='
           ,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjA8mLF9lMmoWREqCbb6rT8RLp7In1x_5hlA&s'
           ,1
           ,1)
INSERT INTO [dbo].[Users]
           ([FullName]
           ,[UserName]
           ,[Email]
           ,[Password]
           ,[Avartar]
           ,[RoleID]
           ,[Status])
     VALUES
           ('Hoang Cong Ninh'
           ,'Congninh123@'
           ,'ninhhche187071@fpt.edu.vn'
           ,'Q29uZ25pbmgxMjNAZndlcWZ3ZTtoZml1ZHNmYXNkZmFzZGZhcw==' --Congninh123@
           ,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjA8mLF9lMmoWREqCbb6rT8RLp7In1x_5hlA&s'
           ,2
           ,1)
INSERT INTO [dbo].[Users]
           ([FullName]
           ,[UserName]
           ,[Email]
           ,[Password]
           ,[Avartar]
           ,[RoleID]
           ,[Status])
     VALUES
           ('NinhNH123@'
           ,'NinhNH123@'
           ,'congninh@gmail.com'
           ,'TmluaE5IMTIzQGZ3ZXFmd2U7aGZpdWRzZmFzZGZhc2RmYXM=' -- NinhNH123@
           ,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjA8mLF9lMmoWREqCbb6rT8RLp7In1x_5hlA&s'
           ,2
           ,1)
INSERT INTO [dbo].[Users]
           ([FullName]
           ,[UserName]
           ,[Email]
           ,[Password]
           ,[Avartar]
           ,[RoleID]
           ,[Status])
     VALUES
           ('Nguyen Thu Uyen'
           ,'Sale123@'
           ,'nguyenuyenpb68@gmail.com'
           ,'U2FsZTEyM0Bmd2VxZndlO2hmaXVkc2Zhc2RmYXNkZmFz'
           ,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjA8mLF9lMmoWREqCbb6rT8RLp7In1x_5hlA&s'
           ,3
           ,1)
INSERT INTO [dbo].[Users]
           ([FullName]
           ,[UserName]
           ,[Email]
           ,[Password]
           ,[Avartar]
           ,[RoleID]
           ,[Status])
     VALUES
           ('Nguyen Saler'
           ,'Saler2@123'
           ,'Sale@gmail.com'
           ,'U2FsZXIyQDEyM2Z3ZXFmd2U7aGZpdWRzZmFzZGZhc2RmYXM='
           ,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjA8mLF9lMmoWREqCbb6rT8RLp7In1x_5hlA&s'
           ,3
           ,1)
INSERT INTO [dbo].[Users]
           ([FullName]
           ,[UserName]
           ,[Email]
           ,[Password]
           ,[Avartar]
           ,[RoleID]
           ,[Status])
     VALUES
           ('Pham Trung hieu'
           ,'Hieu123@'
           ,'phamtrunghieucr7@gmail.com'
           ,'SGlldTEyM0Bmd2VxZndlO2hmaXVkc2Zhc2RmYXNkZmFz'
           ,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjA8mLF9lMmoWREqCbb6rT8RLp7In1x_5hlA&s'
           ,4
           ,1)
INSERT INTO Category (CategoryName, Description) VALUES 
(N'Java Programming', N'Learn Java from basics to advanced concepts.'),
(N'Python Programming', N'Master Python for development, data science, and AI.'),
(N'JavaScript Programming', N'Build interactive web applications with JavaScript.')
INSERT INTO Courses (Name, Description, Price, imageCources, UserID, CategoryID, CreatedAt) VALUES 
-- Java Courses


(N'Java for Beginners', N'Java for Beginners is an ideal course for those new to Java programming. It covers fundamental concepts, including setting up the environment, variables, data types, loops, conditions, and object-oriented programming (OOP). You will learn how to create and use classes, objects, inheritance, polymorphism, and exception handling. The course also introduces Java Collections, database connectivity (JDBC), and web application development using JSP and Servlets. This is a valuable resource for building a strong foundation in Java and preparing for professional software development.', 150,'https://s3-sgn09.fptcloud.com/codelearnstorage/Upload/Blog/lap-trinh-java-for-beginner-63739300179.8416.jpg', 2, 1, GETDATE()),
(N'Advanced Java Development', N'Advanced Java Development is designed for experienced Java programmers looking to deepen their skills. This course covers advanced topics such as multi-threading, concurrency, design patterns, and JVM internals. You will explore Java EE, including Servlets, JSP, Spring Framework, and RESTful APIs. Additionally, it introduces enterprise-level solutions like microservices, message queues, and security best practices. With hands-on projects and real-world scenarios, this course helps developers master Java for large-scale applications and professional software development.', 180,'https://skilltechacademy.in/wp-content/uploads/2024/07/advanced-java-online-training-1024x585.jpeg' , 2, 1, GETDATE()),
(N'Java Spring Boot Web Development', N'Java Spring Boot Web Development is a comprehensive guide for building modern web applications using the Spring Boot framework. This course covers core Spring concepts such as dependency injection, MVC architecture, RESTful APIs, and database integration with JPA and Hibernate. You will also explore security mechanisms, authentication, and deployment strategies. With hands-on projects, you will learn how to create scalable, high-performance web applications while following industry best practices.', 200,'https://www.adm.ee/wordpress/wp-content/uploads/2023/12/Spring-768x512.png', 2, 1, GETDATE()),



-- Python Courses
(N'Python Basics', N'Python Basics is an introductory guide to the fundamental concepts of Python programming. It covers essential topics such as variables, data types, loops, functions, and object-oriented programming. This course provides a hands-on approach to learning Python with practical examples and exercises. Whether you are a beginner or transitioning from another language, Python Basics will equip you with the foundational skills needed to start coding and developing applications efficiently.', 120, 'https://miro.medium.com/v2/resize:fit:2000/1*Zipt5ex6sSVSkciwlJoG4Q.png', 2, 2, GETDATE()),
(N'Data Science with Python', N'Data Science with Python explores the power of Python for data analysis, visualization, and machine learning. This course covers essential libraries such as NumPy, Pandas, Matplotlib, and Scikit-learn, enabling learners to process, analyze, and interpret complex datasets. It includes practical examples and real-world applications to help build strong analytical skills. Whether you are a beginner or an experienced programmer, this course provides a solid foundation in data science using Python.', 190, 'https://cdn.shopaccino.com/igmguru/products/data-science--with-python-igmguru_176161162_l.jpg?v=509', 2, 2, GETDATE()),
(N'Python for Web Development', N'Build Web Applications using Django and Flask Frameworks is a comprehensive course designed to help learners create dynamic and scalable web applications using Python. The course covers the fundamentals of both Django and Flask, including routing, database integration, authentication, and REST API development. With hands-on projects and real-world examples, participants will gain practical experience in building modern web applications efficiently. Whether you are a beginner or an experienced developer, this course provides essential skills for mastering Python web development.', 170, 'https://media.geeksforgeeks.org/wp-content/cdn-uploads/20220826185259/Why-to-Use-Python-for-Web-Development.jpg', 2, 2, GETDATE()),

-- JavaScript Courses

(N'JavaScript Essentials', N'JavaScript Essentials is a fundamental course designed for beginners and aspiring web developers. This course covers core JavaScript concepts, including variables, data types, functions, loops, and event handling. Learners will also explore the Document Object Model (DOM), asynchronous programming, and API interactions. Through hands-on exercises and real-world examples, students will gain practical coding experience to build interactive and dynamic web applications. Whether you are starting from scratch or looking to enhance your JavaScript skills, this course provides a strong foundation for modern web development.', 110, 'https://img-c.udemycdn.com/course/750x422/1468694_d595_2.jpg', 2, 3, GETDATE()),
(N'Frontend Development with JavaScript', N'Frontend Development with JavaScript is a comprehensive course designed to equip learners with essential skills for building dynamic and interactive web applications. This course covers key JavaScript concepts, including DOM manipulation, event handling, asynchronous programming, and API integration. Students will also explore modern frontend frameworks like React or Vue.js to create responsive user interfaces. Through hands-on projects, participants will gain practical experience in developing real-world web applications. Whether you are a beginner or looking to enhance your frontend skills, this course provides the foundation needed to become a proficient JavaScript developer.', 160, 'https://media.geeksforgeeks.org/wp-content/uploads/20240703165023/Frontend-Development-(1).webp', 2, 3, GETDATE()),
(N'Backend Development with Node.js', N'Backend Development with Node.js is a hands-on course designed to teach developers how to build scalable and efficient server-side applications. This course covers fundamental Node.js concepts, including event-driven programming, asynchronous operations, and working with modules. Students will also learn how to create RESTful APIs using Express.js, interact with databases like MongoDB and PostgreSQL, and implement authentication and authorization. With practical projects and real-world examples, this course provides the necessary skills to develop modern, high-performance backend applications using Node.js.', 200, 'https://media.geeksforgeeks.org/wp-content/cdn-uploads/20220517005132/Why-to-Use-NodeJS-for-Backend-Development.jpg', 2, 3, GETDATE());



INSERT INTO Lessons (Title, Content, CourseID, Status) VALUES 
('Java Programming for Beginner-Full-Course', 'https://www.youtube.com/watch?v=eIrMbAQSU34&t=2989s&ab_channel=ProgrammingwithMosh', 1, 1),
('Java 24 - Better Language, Better APIs, Better Runtime', 'https://www.youtube.com/watch?v=2NTyzL-9Bfo', 1, 1),
('Advanced Java Programming A Comprehensive Full-Course', 'https://www.youtube.com/watch?v=I_qP7H3STMg', 2, 1),
('Java Spring Boot Web Development-Full-Course', 'https://www.youtube.com/watch?v=I_qP7H3STMg', 3, 1),
('Python Full Course for Beginners', 'https://www.youtube.com/watch?v=_uQrJ0TkZlc', 4, 1),
('Data Science with Python-Full Course', 'https://www.youtube.com/watch?v=nHAPcZRg9VM', 5, 1),
('Web Development with Python Tutorial – Flask & Dynamic Database-Driven Web Apps', 'https://www.youtube.com/watch?v=yBDHkveJUf4', 6, 1),
('JavaScript Course for Beginners 2024', 'https://www.youtube.com/watch?v=Zi-Q0t4gMC8', 7, 1),
('Frontend Web Development Bootcamp Course (JavaScript, HTML, CSS)', 'https://www.youtube.com/watch?v=zJSY8tbf_ys', 8, 1),
('Node.js and Express.js - Full Course', 'https://www.youtube.com/watch?v=Oe421EPjeBE', 9, 1)
INSERT INTO Blogs (BlogTitle, BlogDetail, BlogImage, BlogDate, UserID)
VALUES 
    (N'Bắt đầu học lập trình: Lộ trình cho người mới', 
     N'Bạn mới học lập trình? Đây là hướng dẫn chi tiết giúp bạn bắt đầu với ngôn ngữ phù hợp và tài nguyên học tập. Để bắt đầu học lập trình hiệu quả, bạn cần xác định mục tiêu rõ ràng: muốn làm web, ứng dụng di động hay AI? Hãy chọn một ngôn ngữ phù hợp như Python, JavaScript hoặc Java. Tiếp theo, xây dựng nền tảng vững chắc với thuật toán và cấu trúc dữ liệu. Đừng quên tham gia cộng đồng lập trình để học hỏi và rèn luyện tư duy giải quyết vấn đề. Quan trọng nhất, hãy thực hành qua các dự án thực tế để nâng cao kỹ năng.',
     'https://iviettech.vn/wp-content/uploads/2024/01/lo-trinh-hoc-lap-trinh.png', GETDATE(), 4),

    (N'Top 5 ngôn ngữ lập trình nên học trong năm 2025', 
     N'Python, JavaScript, Java, C#, Go - Đâu là lựa chọn tốt nhất cho bạn trong năm nay? 
	 Python tiếp tục dẫn đầu với ứng dụng mạnh mẽ trong AI và khoa học dữ liệu. JavaScript vẫn là lựa chọn số một cho lập trình web, đặc biệt với các framework như React, Vue. Java giữ vững vị trí trong các hệ thống doanh nghiệp. C# phát triển mạnh trong game development với Unity. Go nổi lên như một lựa chọn hàng đầu cho backend nhờ hiệu suất cao. Chọn ngôn ngữ phù hợp với định hướng nghề nghiệp của bạn để phát triển nhanh nhất.',
     'https://st.quantrimang.com/photos/image/2022/12/08/top-20-ngon-ngu-lap-trinh-nen-hoc.jpg', GETDATE(), 4),

    (N'Dự án lập trình đầu tay: Viết một To-Do List đơn giản', 
     N'Hướng dẫn từng bước tạo một ứng dụng danh sách công việc bằng HTML, CSS, và JavaScript. Bắt đầu với HTML để tạo giao diện, CSS để thiết kế, và JavaScript để xử lý sự kiện. Hãy sử dụng `localStorage` để lưu dữ liệu trên trình duyệt, giúp danh sách công việc không bị mất khi tải lại trang. Thêm các tính năng như đánh dấu hoàn thành, chỉnh sửa hoặc xóa công việc để ứng dụng trở nên thực tế hơn. Khi đã nắm vững cơ bản, hãy thử nâng cấp dự án bằng React hoặc Vue để làm quen với framework hiện đại.',
     'https://glints.com/vn/blog/wp-content/uploads/2022/09/ma%CC%82%CC%83u-to-do-list.jpeg', GETDATE(), 4),

    (N'Học lập trình có cần giỏi toán không?',
N'Nhiều người nghĩ lập trình yêu cầu toán cao cấp, nhưng sự thật không hẳn như vậy. Cùng tìm hiểu! Nhiều lĩnh vực lập trình không yêu cầu toán cao cấp, nhưng tư duy logic và giải quyết vấn đề là bắt buộc. Nếu bạn hướng đến AI, khoa học dữ liệu hay mật mã học, kiến thức toán sẽ rất quan trọng. Ngược lại, phát triển web hay ứng dụng di động chủ yếu cần kỹ năng lập trình hơn là toán. Thay vì lo lắng về toán, hãy tập trung vào tư duy thuật toán, phân tích yêu cầu và cách viết code sạch, dễ bảo trì.',
     'https://cdn.codegym.vn/wp-content/uploads/2021/09/hoc-lap-trinh-co-can-gioi-toan-khong-8.jpg', GETDATE(), 4),

    (N'100 ngày code: Hành trình từ newbie đến lập trình viên', 
     N'Bạn có thể trở thành lập trình viên sau 100 ngày học tập? Hãy thử thách bản thân với kế hoạch này! Cam kết dành ít nhất 1 giờ mỗi ngày để code, học từ các nguồn uy tín như FreeCodeCamp, Codecademy. Mỗi tuần, chọn một chủ đề như HTML, CSS, JavaScript, API, hoặc database để thực hành. Theo dõi tiến trình bằng cách viết blog hoặc chia sẻ dự án trên GitHub. Nếu duy trì đủ 100 ngày, bạn sẽ không chỉ có kiến thức vững vàng mà còn hình thành thói quen lập trình, sẵn sàng cho công việc thực tế.',
     'https://niithanoi.edu.vn/pic/News/100-ngay-hoc-code.png', GETDATE(), 5);


	 INSERT INTO [dbo].[Feedbacks]
           ([UserID]
           ,[CourseID]
           ,[Rating]
           ,[Comment]
           ,[CreatedAt])
     VALUES
           (6
           ,1
           ,5
           ,'Good'
           ,GETDATE())
INSERT INTO [dbo].[Feedbacks]
           ([UserID]
           ,[CourseID]
           ,[Rating]
           ,[Comment]
           ,[CreatedAt])
     VALUES
           (6
           ,1
           ,4
           ,'Well'
           ,GETDATE())
INSERT INTO [dbo].[Feedbacks]
           ([UserID]
           ,[CourseID]
           ,[Rating]
           ,[Comment]
           ,[CreatedAt])
     VALUES
           (6
           ,1
           ,3
           ,'Fantastic'
           ,GETDATE())

		   INSERT INTO Payment (UserID, CourseID, Amount) VALUES 
(6, 3, 200.00),  -- Java Spring Boot Web Development
(6, 5, 190.00),

(6, 1, 150.00),
(6, 2, 180.00);

-- Data Science with Python
-- Giao dịch cho khóa học "Java Spring Boot Web Development"
INSERT INTO TransactionHistory (PayID, Status, CreatedAt, CourseID, PaymentMethod, PaymentDate) 
VALUES (1, 1, GETDATE(), 3, N'VNPay', GETDATE());
INSERT INTO TransactionHistory (PayID, Status, CreatedAt, CourseID, PaymentMethod, PaymentDate) 
VALUES (1, 1, GETDATE(), 5, N'VNPay', GETDATE());
-- Giao dịch cho khóa học "Data Science with Python"
INSERT INTO TransactionHistory (PayID, Status, CreatedAt, CourseID, PaymentMethod, PaymentDate) 
VALUES (2, 1, GETDATE(), 1, N'VNPay', GETDATE());
INSERT INTO TransactionHistory (PayID, Status, CreatedAt, CourseID, PaymentMethod, PaymentDate) 
VALUES (3, 1, GETDATE(), 2, N'VNPay', GETDATE());
INSERT INTO [dbo].[Requests]
           ([RequestedRole]
           ,[UserID])
     VALUES
           (2
           ,6)
INSERT INTO [dbo].[Requests]
           ([RequestedRole]
           ,[UserID])
     VALUES
           (2
           ,6)
INSERT INTO [dbo].[Requests]
           ([RequestedRole]
           ,[UserID])
     VALUES
           (3
           ,6)

INSERT INTO Answer (IsCorrectAnswer, AnswerContent) VALUES 
(1, 'B'), (0, 'A'), (0, 'C'), (0, 'D'), 
(1, 'A'), (0, 'B'), (0, 'C'), (0, 'D'), 
(1, 'C'), (0, 'A'), (0, 'B'), (0, 'D'), 
(1, 'A'), (0, 'B'), (0, 'C'), (0, 'D'), 
(1, 'B'), (0, 'A'), (0, 'C'), (0, 'D'), 
(1, 'D'), (0, 'A'), (0, 'B'), (0, 'C'), 
(1, 'C'), (0, 'A'), (0, 'B'), (0, 'D'), 
(1, 'A'), (0, 'B'), (0, 'C'), (0, 'D'), 
(1, 'B'), (0, 'A'), (0, 'C'), (0, 'D'), 
(1, 'C'), (0, 'A'), (0, 'B'), (0, 'D'), 
(1, 'A'), (0, 'B'), (0, 'C'), (0, 'D'), 
(1, 'B'), (0, 'A'), (0, 'C'), (0, 'D'), 
(1, 'C'), (0, 'A'), (0, 'B'), (0, 'D'),
(1, 'B'), (0, 'A'), (0, 'C'), (0, 'D'), 
(1, 'B'), (0, 'A'), (0, 'C'), (0, 'D'),  
(1, 'A'), (0, 'B'), (0, 'C'), (0, 'D'),
(1, 'A'), (0, 'B'), (0, 'C'), (0, 'D'), 
(1, 'A'), (0, 'B'), (0, 'C'), (0, 'D'), 
(1, 'B'), (0, 'A'), (0, 'C'), (0, 'D'),
(1, 'B'), (0, 'A'), (0, 'C'), (0, 'D'),
(1, 'A'), (0, 'B'), (0, 'C'), (0, 'D'),
(1, 'A'), (0, 'B'), (0, 'C'), (0, 'D'),
(1, 'C'), (0, 'B'), (0, 'A'), (0, 'D'),    
(1, 'D'), (0, 'A'), (0, 'B'), (0, 'C'), 
(1, 'B'), (0, 'A'), (0, 'C'), (0, 'D'),
(1, 'B'), (0, 'A'), (0, 'D'), (0, 'C'),
(1, 'D'), (0, 'A'), (0, 'B'), (0, 'C'),
(1, 'A'), (0, 'B'), (0, 'C'), (0, 'D'),
(1, 'A'), (0, 'B'), (0, 'C'), (0, 'D'),
(1, 'B'), (0, 'A'), (0, 'C'), (0, 'D');


INSERT INTO Question(QuestionType, QuestionContent, OptionA, OptionB, OptionC, OptionD, AnswerID) 
VALUES 
('multiple choice', 'Which keyword is used to inherit a class in Java?', 'A. implements', 'B. extends', 'C. inherits', 'D. interface', 1),
('multiple choice', 'Which of the following is the correct declaration of the main method in Java?', 'A. public static void main(String[] args)', 'B. static void main(String[] args)', 'C. public void main(String[] args)', 'D. void main(String args[])', 2),
('multiple choice', 'Which data type is a primitive type in Java?', 'A. String', 'B. ArrayList', 'C. int', 'D. Integer', 3),
('multiple choice', 'Which statement is used to read input from the keyboard in Java?', 'A. Scanner scanner = new Scanner(System.in);', 'B. Input input = new Input(System.in);', 'C. System.console().readLine();', 'D. new Scanner();', 4),
('multiple choice', 'What is the scope of a local variable?', 'A. The entire program', 'B. Inside a method or block', 'C. The entire class', 'D. Inside a package', 5),
('multiple choice', 'What does the final keyword mean in Java?', 'A. A variable cannot be changed', 'B. A method cannot be overridden', 'C. A class cannot be inherited', 'D. All of the above', 6),
('multiple choice', 'An interface in Java can contain:', 'A. Methods with a body', 'B. Mutable variables', 'C. Abstract methods', 'D. Constructors', 7),
('multiple choice', 'Which package does the ArrayList class belong to?', 'A. java.util', 'B. java.lang', 'C. java.io', 'D. java.sql', 8),
('multiple choice', 'Which method of ArrayList is used to retrieve an element by index?', 'A. fetch(int index)', 'B. get(int index)', 'C. retrieve(int index)', 'D. find(int index)',9),
('multiple choice', 'Which keyword is used to create an object in Java?', 'A. create', 'B. build', 'C. new', 'D. instance', 10),
('multiple choice', 'What is the default value of a boolean variable in Java?', 'A. true', 'B. false', 'C. null', 'D. 0', 11),
('multiple choice', 'What is the purpose of the equals() method?', 'A. Compare memory addresses of two objects', 'B. Compare the contents of two objects', 'C. Copy an object', 'D. Compare two integers', 12),
('multiple choice', 'Which of the following is an example of downcasting?', 'A. (Dog) animal;', 'B. (int) 3.5;', 'C. Integer.parseInt("123");', 'D. String.valueOf(123);', 13),
('multiple choice', 'Which class is used to read data from a file in Java?', 'A. FileReader', 'B. FileScanner', 'C. FileWriter', 'D. FileOutputStream', 14),
('multiple choice', 'What is try-catch-finally used for?', 'A. Exception handling', 'B. Defining loops', 'C. Ending a program', 'D. Initializing variables', 15),
('multiple choice', 'What is the purpose of the throw keyword?', 'A. Declare an exception', 'B. Throw an exception', 'C. Handle an exception', 'D. Catch an exception', 16),
('multiple choice', 'What is Runnable in Java?', 'A. A class', 'B. An interface', 'C. A package', 'D. An annotation', 17),
('multiple choice', 'What is the purpose of the super keyword?', 'A. Call the constructor of the parent class', 'B. Call a static method', 'C. Access a private method', 'D. Access a global variable', 18),
('multiple choice', 'What is the difference between == and equals()?', 'A. == compares memory addresses, equals() compares content', 'B. Both compare memory addresses', 'C. == compares content, equals() compares memory addresses', 'D. No difference', 19),
('multiple choice', 'Which statement is used to exit a loop?', 'A. stop', 'B. continue', 'C. break', 'D. exit', 20),
('multiple choice', 'Which class does System.out.println() belong to?', 'A. System', 'B. Console', 'C. OutputStream', 'D. PrintStream', 21),
('multiple choice', 'What does Math.random() return?', 'A. An integer', 'B. A floating-point number in the range [0,1)', 'C. A floating-point number in the range (0,1]', 'D. An integer in the range [0,10]', 22),
('multiple choice', 'What is the size of an int variable in Java?', 'A. 16 bits', 'B. 32 bits', 'C. 64 bits', 'D. 8 bits', 23),
('multiple choice', 'Which keyword is used to prevent a method from being overridden?', 'A. static', 'B. private', 'C. final', 'D. protected', 24),
('multiple choice', 'What will happen if we try to execute a program without a main method in Java?', 'A. It will compile and run', 'B. It will compile but not run', 'C. It will not compile', 'D. It will throw an exception', 25),
('multiple choice', 'Which method is called automatically when an object is created?', 'A. finalize()', 'B. constructor', 'C. start()', 'D. run()', 26),
('multiple choice', 'Which access modifier allows a variable to be accessed only within the same package?', 'A. public', 'B. private', 'C. protected', 'D. default (no modifier)', 27),
('multiple choice', 'What is the parent class of all classes in Java?', 'A. Object', 'B. Class', 'C. Super', 'D. Base', 28),
('multiple choice', 'What happens when you divide an integer by zero in Java?', 'A. Throws ArithmeticException', 'B. Returns Infinity', 'C. Returns NaN', 'D. Returns 0', 29),
('multiple choice', 'Which keyword is used to call the constructor of the parent class?', 'A. this', 'B. super', 'C. extends', 'D. parent', 30);



INSERT INTO [dbo].[Test] ([Name], [Status], [CreatedBy], [TotalMark], [CourseID]) 
VALUES ('Test 1', 0, 'Hoang Cong Ninh', 0, 1);

select * from Answer



INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,1)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,2)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,3)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,4)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,5)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,6)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,7)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,8)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,9)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,10)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,11)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,12)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,13)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,14)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,15)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,16)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,17)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,18)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,19)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,20)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,21)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,22)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,23)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,24)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,25)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,26)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,27)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,28)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,29)
INSERT INTO [dbo].[Test_Question]
           ([TestID]
           ,[QuestionID])
     VALUES
           (1
           ,30)
INSERT INTO [dbo].[Enrollments]
           ([UserID]
           ,[CourseID]
           ,[Status]
           ,[EnrolledAt])
     VALUES
           (6
           ,3
           ,1
           ,GETDATE())
INSERT INTO [dbo].[Enrollments]
           ([UserID]
           ,[CourseID]
           ,[Status]
           ,[EnrolledAt])
     VALUES
           (6
           ,5
           ,1
           ,GETDATE());
		   INSERT INTO [dbo].[Enrollments]
           ([UserID]
           ,[CourseID]
           ,[Status]
           ,[EnrolledAt])
     VALUES
           (6
           ,1
           ,1
           ,GETDATE());
		   	   INSERT INTO [dbo].[Enrollments]
           ([UserID]
           ,[CourseID]
           ,[Status]
           ,[EnrolledAt])
     VALUES
           (6
           ,2
           ,1

           ,GETDATE());




	