--Create database OnlineLearning
--Use OnlineLearning
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY,
    RoleName VARCHAR(255) NOT NULL
);
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(255) NULL,
    UserName NVARCHAR(255) NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(1000) NULL,
    Avartar nvarchar(max),  -- Giữ lại cột Avartar từ nhánh `customer`
    RoleID INT FOREIGN KEY REFERENCES Roles(RoleID),
    Status TINYINT NOT NULL DEFAULT 1  -- Giữ lại kiểu dữ liệu TINYINT với DEFAULT 1 từ nhánh `customer`
);

CREATE TABLE Category (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(255) NOT NULL,
   Description nvarchar(max)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Description nvarchar(max),
    Price decimal(10,2),
	imageCources nvarchar(max),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    CategoryID INT FOREIGN KEY REFERENCES Category(CategoryID),
    CreatedAt DATE,
	 Status INT NULL CHECK (Status IN (0,1,2,3,4))
	
);

CREATE TABLE Lessons (
    LessonID INT IDENTITY(1,1) PRIMARY KEY,
    Content NVARCHAR(MAX) NOT NULL,
    CourseID INT  FOREIGN KEY REFERENCES Courses(CourseID),
    Title NVARCHAR(255) NOT NULL,
   	 Status INT NULL CHECK (Status IN (0,1)) default 1
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
	 Status TINYINT DEFAULT 1,
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
  
    PaymentDate DATETIME
);

CREATE TABLE Requests (
    RequestID INT PRIMARY KEY IDENTITY(1,1),
    RequestedRole INT FOREIGN KEY REFERENCES Roles(RoleID),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
	 Status INT NULL CHECK (Status IN (0,1)) DEFAULT null
);
CREATE TABLE Test (
    TestID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255),
   Status INT NULL CHECK (Status IN (0,1)) DEFAULT 1,
    CreatedBy NVARCHAR(50),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID)
);

CREATE TABLE Question (
    QuestionID INT PRIMARY KEY IDENTITY(1,1),
    QuestionType NVARCHAR(255),
    QuestionContent NVARCHAR(255),
    OptionA NVARCHAR(255),
    OptionB NVARCHAR(255),
    OptionC NVARCHAR(255),
    OptionD NVARCHAR(255),
	Status INT NULL CHECK (Status IN (0,1)) DEFAULT 1,
    TestID INT FOREIGN KEY REFERENCES Test(TestID)
);

CREATE TABLE Answer (
    AnswerID INT PRIMARY KEY IDENTITY(1,1),
    AnswerContent NVARCHAR(255),
    QuestionID INT FOREIGN KEY REFERENCES Question(QuestionID)
);

CREATE TABLE History (
    HistoryID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    CourseID INT NOT NULL FOREIGN KEY REFERENCES Courses(CourseID),
    TestID INT NOT NULL FOREIGN KEY REFERENCES Test(TestID),
    TestStatus INT DEFAULT null, 
    CourseStatus INT DEFAULT null,
    CreatedAt DATETIME DEFAULT GETDATE() -- Thêm cột ngày giờ
);


CREATE TABLE UserAnswers (
    UserAnswerID INT PRIMARY KEY IDENTITY(1,1), -- Khóa chính tự tăng
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    TestID INT FOREIGN KEY REFERENCES Test(TestID),
    QuestionID INT FOREIGN KEY REFERENCES Question(QuestionID),
    AnswerOption CHAR(1),
    AnswerID INT FOREIGN KEY REFERENCES Answer(AnswerID),
    IsCorrectAnswer INT CHECK (IsCorrectAnswer IN (0,1)), -- Đánh dấu đúng/sai
    HistoryID INT FOREIGN KEY REFERENCES History(HistoryID) -- Liên kết với lần làm bài
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY  IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    Status INT CHECK (Status IN (0,1)) default 0,
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
           ('Hoàng Công Ninh'
           ,'Congninh123@'
           ,'ninhhche187071@fpt.edu.vn'
           ,'Q29uZ25pbmgxMjNAZndlcWZ3ZTtoZml1ZHNmYXNkZmFzZGZhcw==' --Congninh123@
           ,'https://cdn.codegym.vn/wp-content/uploads/2023/01/27.Nguyen-Thanh-Cong-_-Giang-Vien.JPG.jpg'
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
           (N'Nguyễn Thị Mai'
           ,'NinhNH123@'
           ,'abc@gmail.com'
           ,'TmluaE5IMTIzQGZ3ZXFmd2U7aGZpdWRzZmFzZGZhc2RmYXM=' -- NinhNH123@
           ,'https://cdn.codegym.vn/wp-content/uploads/2020/05/1.-Duong-Thi-Minh-Chau-1.png'
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
		   --add thêm expert
		   INSERT INTO [dbo].[Users]
           ([FullName]
           ,[UserName]
           ,[Email]
           ,[Password]
           ,[Avartar]
           ,[RoleID]
           ,[Status])
     VALUES
           (N' Hồ Thị Thanh Phương'
           ,'Phuong123@'
           ,'phuongnthe186141@fpt.edu.vn'
           ,'TmluaE5IMTIzQGZ3ZXFmd2U7aGZpdWRzZmFzZGZhc2RmYXM=' -- NinhNH123@
           ,'https://cdn.codegym.vn/wp-content/uploads/2023/01/27.-Nguyen-Hong-Hanh-HQ.jpg.jpg'
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
           (N'Hà Anh Tài'
           ,'Tai123@'
           ,'anhtai@gmail.com'
           ,'TmluaE5IMTIzQGZ3ZXFmd2U7aGZpdWRzZmFzZGZhc2RmYXM=' -- NinhNH123@
           ,'https://cdn.codegym.vn/wp-content/uploads/2022/12/22.Doan-Phuoc-Trung_-CAH.jpg.jpg'
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
           (N'Nguyễn Đức Việt'
           ,'Viet123@'
           ,'hoangduy@gmail.com'
           ,'TmluaE5IMTIzQGZ3ZXFmd2U7aGZpdWRzZmFzZGZhc2RmYXM=' -- NinhNH123@
           ,'https://cdn.codegym.vn/wp-content/uploads/2022/12/1.CGH_-Nguyen-Huu-Anh-Khoa.jpg.jpg'
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
	(N'MinhAnh456', 'anh123@'
,'minhanh@gmail.com'
,'TWluaGFuaDEyM0Bmd2VxZndlO2hmaXVkc2Zhc2RmYXNkZmFz' -- Minhanh123@
,'https://aptechcantho.cusc.vn/DesktopModules/DANHSACH/HINH/QC2018813712788.jpg'
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
(N'Trần Văn Hùng'
,'HungTran789'
,'tranhung@gmail.com'
,'SHVuZzEyM0Bmd2VxZndlO2hmaXVkc2Zhc2RmYXNkZmFz' -- Hung123@
,'https://i1-vnexpress.vnecdn.net/2021/05/13/xter-Minh-4629-1620880505.jpg?w=680&h=0&q=100&dpr=1&fit=crop&s=JvK4ee9YMs_ppLU6KHzxmA'
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
(N'Lê Thị Hồng Ngọc'
,'HongNgoc101'
,'hongngoc@gmail.com'
,'TmdvYzEyM0Bmd2VxZndlO2hmaXVkc2Zhc2RmYXNkZmFz' -- Ngoc123@
,'https://aptechcantho.cusc.vn/DesktopModules/DANHSACH/HINH/QC2018813727251.jpg'
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
(N'Hoàng Minh Tuấn'
,'TuanHM321'
,'minhtuan@gmail.com'
,'VHVhbjEyM0Bmd2VxZndlO2hmaXVkc2Zhc2RmYXNkZmFz' -- Tuan123@
,'https://scontent.fhan5-6.fna.fbcdn.net/v/t39.30808-6/480611892_1190277999636090_6535903059927968272_n.jpg?_nc_cat=1&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=WPIQa_vmqHQQ7kNvgHuDOEA&_nc_oc=Adlw2KKhIhGcwiftP-NqM8S937BQ9tPrah5M3P0_5gk3vs4r874P0EUKET4Iq-UjiUo&_nc_zt=23&_nc_ht=scontent.fhan5-6.fna&_nc_gid=1aKPSIXgMNgzIowCTuIKXA&oh=00_AYFWrrXt5QKWkIrQUAbnO97M73ssPymLVk4qWXC8mqNesw&oe=67E8837A'
,2
,1)
INSERT INTO Category (CategoryName, Description) VALUES 
(N'Java Programming', N'Learn Java from basics to advanced concepts.'),
(N'Python Programming', N'Master Python for development, data science, and AI.'),
(N'JavaScript Programming', N'Build interactive web applications with JavaScript.')
INSERT INTO Courses (Name, Description, Price, imageCources, UserID, CategoryID, CreatedAt,[Status]) VALUES 
-- Java Courses


(N'Java for Beginners', N'Java for Beginners is an ideal course for those new to Java programming. It covers fundamental concepts, including setting up the environment, variables, data types, loops, conditions, and object-oriented programming (OOP). You will learn how to create and use classes, objects, inheritance, polymorphism, and exception handling. The course also introduces Java Collections, database connectivity (JDBC), and web application development using JSP and Servlets. This is a valuable resource for building a strong foundation in Java and preparing for professional software development.', 150000,'https://s3-sgn09.fptcloud.com/codelearnstorage/Upload/Blog/lap-trinh-java-for-beginner-63739300179.8416.jpg', 3, 1, GETDATE(),4),
(N'Advanced Java Development', N'Advanced Java Development is designed for experienced Java programmers looking to deepen their skills. This course covers advanced topics such as multi-threading, concurrency, design patterns, and JVM internals. You will explore Java EE, including Servlets, JSP, Spring Framework, and RESTful APIs. Additionally, it introduces enterprise-level solutions like microservices, message queues, and security best practices. With hands-on projects and real-world scenarios, this course helps developers master Java for large-scale applications and professional software development.', 180000,'https://skilltechacademy.in/wp-content/uploads/2024/07/advanced-java-online-training-1024x585.jpeg' , 2, 1, GETDATE(),4),
(N'Java Spring Boot Web Development', N'Java Spring Boot Web Development is a comprehensive guide for building modern web applications using the Spring Boot framework. This course covers core Spring concepts such as dependency injection, MVC architecture, RESTful APIs, and database integration with JPA and Hibernate. You will also explore security mechanisms, authentication, and deployment strategies. With hands-on projects, you will learn how to create scalable, high-performance web applications while following industry best practices.', 200000,'https://www.adm.ee/wordpress/wp-content/uploads/2023/12/Spring-768x512.png', 2, 1, GETDATE(),4),
-- Python Courses
(N'Python Basics', N'Python Basics is an introductory guide to the fundamental concepts of Python programming. It covers essential topics such as variables, data types, loops, functions, and object-oriented programming. This course provides a hands-on approach to learning Python with practical examples and exercises. Whether you are a beginner or transitioning from another language, Python Basics will equip you with the foundational skills needed to start coding and developing applications efficiently.', 120000, 'https://miro.medium.com/v2/resize:fit:2000/1*Zipt5ex6sSVSkciwlJoG4Q.png', 9, 2, GETDATE(),2),
(N'Data Science with Python', N'Data Science with Python explores the power of Python for data analysis, visualization, and machine learning. This course covers essential libraries such as NumPy, Pandas, Matplotlib, and Scikit-learn, enabling learners to process, analyze, and interpret complex datasets. It includes practical examples and real-world applications to help build strong analytical skills. Whether you are a beginner or an experienced programmer, this course provides a solid foundation in data science using Python.', 190000, 'https://cdn.shopaccino.com/igmguru/products/data-science--with-python-igmguru_176161162_l.jpg?v=509', 7, 2, GETDATE(),4),
(N'Python for Web Development', N'Build Web Applications using Django and Flask Frameworks is a comprehensive course designed to help learners create dynamic and scalable web applications using Python. The course covers the fundamentals of both Django and Flask, including routing, database integration, authentication, and REST API development. With hands-on projects and real-world examples, participants will gain practical experience in building modern web applications efficiently. Whether you are a beginner or an experienced developer, this course provides essential skills for mastering Python web development.', 170000, 'https://media.geeksforgeeks.org/wp-content/cdn-uploads/20220826185259/Why-to-Use-Python-for-Web-Development.jpg', 9, 2, GETDATE(),2),

-- JavaScript Courses

(N'JavaScript Essentials', N'JavaScript Essentials is a fundamental course designed for beginners and aspiring web developers. This course covers core JavaScript concepts, including variables, data types, functions, loops, and event handling. Learners will also explore the Document Object Model (DOM), asynchronous programming, and API interactions. Through hands-on exercises and real-world examples, students will gain practical coding experience to build interactive and dynamic web applications. Whether you are starting from scratch or looking to enhance your JavaScript skills, this course provides a strong foundation for modern web development.', 110000, 'https://img-c.udemycdn.com/course/750x422/1468694_d595_2.jpg', 7, 3, GETDATE(),4),
(N'Frontend Development with JavaScript', N'Frontend Development with JavaScript is a comprehensive course designed to equip learners with essential skills for building dynamic and interactive web applications. This course covers key JavaScript concepts, including DOM manipulation, event handling, asynchronous programming, and API integration. Students will also explore modern frontend frameworks like React or Vue.js to create responsive user interfaces. Through hands-on projects, participants will gain practical experience in developing real-world web applications. Whether you are a beginner or looking to enhance your frontend skills, this course provides the foundation needed to become a proficient JavaScript developer.', 160000, 'https://media.geeksforgeeks.org/wp-content/uploads/20240703165023/Frontend-Development-(1).webp', 2, 3, GETDATE(),1),
(N'Backend Development with Node.js', N'Backend Development with Node.js is a hands-on course designed to teach developers how to build scalable and efficient server-side applications. This course covers fundamental Node.js concepts, including event-driven programming, asynchronous operations, and working with modules. Students will also learn how to create RESTful APIs using Express.js, interact with databases like MongoDB and PostgreSQL, and implement authentication and authorization. With practical projects and real-world examples, this course provides the necessary skills to develop modern, high-performance backend applications using Node.js.', 200000, 'https://media.geeksforgeeks.org/wp-content/cdn-uploads/20220517005132/Why-to-Use-NodeJS-for-Backend-Development.jpg', 8, 3, GETDATE(),4);
--Payment 
INSERT INTO Payment (UserID, CourseID, Amount) VALUES
(5, 1, 150000),
(5, 2, 180000),
(3, 3, 200000),
(4, 1, 150000),
(5, 2, 180000);
-- Transaction History

INSERT INTO TransactionHistory (PayID, Status, CreatedAt, CourseID, PaymentDate) VALUES
(1, 1, '2024-03-01 10:15:30', 1, '2024-03-01 10:16:00'),
(2, 1, '2024-03-02 14:20:45', 2, '2024-03-02 14:21:00'),
(3, 0, '2024-03-03 09:30:15', 3, NULL),
(4, 1, '2024-03-04 16:45:50', 1, '2024-03-04 16:46:30'),
(5, 1, '2024-03-05 11:10:25', 2, '2024-03-05 11:11:00');


INSERT INTO Lessons (Title, Content, CourseID) VALUES 
('Java Programming for Beginner-Full-Course', 'https://www.youtube.com/watch?v=GoXwIVyNvX0', 4),
('Advanced Java Programming A Comprehensive Full-Course', 'https://www.youtube.com/watch?v=I_qP7H3STMg', 2),
('Java Spring Boot Web Development-Full-Course', 'https://www.youtube.com/watch?v=I_qP7H3STMg', 3),
('Python Full Course for Beginners', 'https://www.youtube.com/watch?v=_uQrJ0TkZlc', 4),
('Data Science with Python-Full Course', 'https://www.youtube.com/watch?v=nHAPcZRg9VM', 5),
('Web Development with Python Tutorial – Flask & Dynamic Database-Driven Web Apps', 'https://www.youtube.com/watch?v=yBDHkveJUf4', 6),
('JavaScript Course for Beginners 2024', 'https://www.youtube.com/watch?v=Zi-Q0t4gMC8', 7),
('Frontend Web Development Bootcamp Course (JavaScript, HTML, CSS)', 'https://www.youtube.com/watch?v=zJSY8tbf_ys', 8),
('Node.js and Express.js - Full Course', 'https://www.youtube.com/watch?v=Oe421EPjeBE', 9)
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
     'https://niithanoi.edu.vn/pic/News/100-ngay-hoc-code.png', GETDATE(), 5),
	 (N'Python – Vì sao ngôn ngữ này thống trị AI và khoa học dữ liệu?', 
	N'Python là một trong những ngôn ngữ lập trình phổ biến nhất hiện nay, đặc biệt trong lĩnh vực trí tuệ nhân tạo (AI) và khoa học dữ liệu. Nhờ cú pháp đơn giản, thư viện phong phú như TensorFlow, PyTorch, scikit-learn, Python giúp các nhà phát triển dễ dàng xây dựng mô hình AI. Ngoài ra, Python còn có ứng dụng rộng rãi trong phát triển web (Django, Flask), tự động hóa và phân tích dữ liệu. Nếu bạn muốn tham gia vào lĩnh vực AI hay Data Science, Python chắc chắn là lựa chọn hàng đầu.', 
	'https://imic.edu.vn/images/news/tai-sao-ngon-ngu-py-thon-la-ngon-ngu-tot-nhat-cho-AI.jpg', '2025-03-22', 4),
	(N'JavaScript – Ngôn ngữ không thể thiếu cho lập trình web hiện đại', 
	N'JavaScript là ngôn ngữ lập trình web phổ biến nhất, giúp tạo ra các trang web tương tác. Với sự hỗ trợ của các framework như React, Angular, Vue, JavaScript giúp xây dựng các ứng dụng web động một cách dễ dàng. Hơn nữa, JavaScript còn có mặt trong backend với Node.js, giúp đồng bộ hóa cả frontend và backend trên cùng một ngôn ngữ. Nếu bạn muốn phát triển web, JavaScript là một kỹ năng không thể thiếu.', 
	'https://cloud.z.com/vn/wp-content/uploads/2024/01/Screenshot_1-6.png', '2025-03-22', 5),
	(N'Java – Tại sao vẫn là lựa chọn hàng đầu cho doanh nghiệp?', 
	N'Java vẫn là một trong những ngôn ngữ phổ biến nhất trong hệ thống doanh nghiệp nhờ tính ổn định, bảo mật và khả năng mở rộng cao. Với các framework mạnh mẽ như Spring Boot, Java được sử dụng để xây dựng các hệ thống backend lớn. Ngoài ra, Java cũng là ngôn ngữ chính cho phát triển ứng dụng Android với Android Studio. Nếu bạn muốn làm việc trong các công ty công nghệ lớn, Java là một lựa chọn đáng cân nhắc.', 
	'https://vtiacademy.edu.vn/upload/images/anh-link/chung-chi-java-la-gi-co-may-loai-chung-chi-java-1.jpg', '2025-03-22', 4),
	(N'C# và Unity – Cặp đôi hoàn hảo cho lập trình game', 
	N'C# là một ngôn ngữ mạnh mẽ, đặc biệt khi kết hợp với Unity để phát triển game. Unity là một trong những nền tảng phát triển game phổ biến nhất, hỗ trợ cả 2D và 3D. Nhờ cú pháp rõ ràng và tài liệu phong phú, C# giúp lập trình viên dễ dàng tạo ra những trò chơi chất lượng cao. Nếu bạn đam mê lập trình game, học C# và Unity sẽ giúp bạn có cơ hội lớn trong ngành công nghiệp này.', 
	'https://caodang.fpt.edu.vn/wp-content/uploads/maxresdefault-2-3.jpg', '2025-03-22', 4),
	(N'Go – Ngôn ngữ tối ưu cho backend và hệ thống phân tán', 
	N'Go (Golang) được phát triển bởi Google để giải quyết các vấn đề về hiệu suất và khả năng mở rộng của hệ thống backend. Với cú pháp đơn giản, tốc độ cao và hỗ trợ xử lý song song mạnh mẽ, Go trở thành lựa chọn hàng đầu cho các hệ thống cloud-native, microservices và backend. Nếu bạn quan tâm đến lập trình hệ thống, Go là một ngôn ngữ đáng học.', 
	'https://200lab.io/blog/_next/image?url=https%3A%2F%2Fstatics.cdn.200lab.io%2F2023%2F06%2Fgolang-la-gi-1.jpg&w=3840&q=75', '2025-03-22', 4),
	(N'TypeScript – Tại sao nên dùng thay vì JavaScript thuần?', 
	N'TypeScript là một phiên bản nâng cấp của JavaScript với khả năng kiểm tra kiểu dữ liệu tĩnh, giúp giảm lỗi trong quá trình phát triển. Các framework hiện đại như Angular, React, Vue đều hỗ trợ TypeScript, giúp cải thiện hiệu suất và bảo trì code dễ dàng hơn. Nếu bạn là lập trình viên JavaScript, việc học TypeScript sẽ giúp bạn làm việc hiệu quả hơn.', 
	'https://blog.haposoft.com/content/images/2022/11/10b88c68-typescript-logo.png', '2025-03-22', 4),
	(N' ReactJS: Thư viện JavaScript thống trị frontend', 
	N'ReactJS giúp xây dựng giao diện người dùng mạnh mẽ, tái sử dụng component, cải thiện hiệu suất web. Được Facebook phát triển, ReactJS đang dẫn đầu xu hướng frontend hiện nay.', 
	'https://s3-sgn09.fptcloud.com/codelearnstorage/Upload/Blog/react-js-co-ban-phan-1-63738082145.3856.jpg', '2025-03-22', 4),
	(N'Spring Boot: Tại sao Java backend lại cần nó?', 
	N'Spring Boot giúp phát triển ứng dụng Java nhanh chóng, giảm bớt cấu hình phức tạp. Nó phù hợp với các hệ thống microservices và cloud-native.
Ưu điểm: Giảm thiểu cấu hình, dễ dàng mở rộng.
Nhược điểm: Học tập tốn thời gian, tiêu tốn nhiều tài nguyên hệ thống.', 
	'https://ant.ncc.asia/wp-content/uploads/2024/08/image-214.png', '2025-03-22', 4),
	(N'TypeScript: Nâng tầm JavaScript', 
	N'TypeScript thêm tính năng kiểm tra kiểu dữ liệu, giúp code dễ bảo trì hơn. Được sử dụng rộng rãi trong Angular, React và Vue.
Ưu điểm: Kiểm tra lỗi tốt hơn, hỗ trợ lập trình hướng đối tượng.
Nhược điểm: Cần biên dịch sang JavaScript, phức tạp hơn JS thuần.', 
	'https://images.viblo.asia/30fca26e-b706-4680-88b8-2ddaef08582b.png', '2025-03-22', 4),
	(N'JavaScript vs Python: Cuộc chiến của hai ông lớn', 
	N'JavaScript thống trị web, trong khi Python chiếm lĩnh AI và Data Science. Tùy vào mục tiêu nghề nghiệp, bạn có thể chọn một trong hai hoặc học cả hai.

Ưu điểm JavaScript: Chạy trên trình duyệt, hiệu suất cao.

Nhược điểm JavaScript: Không có kiểu tĩnh, dễ gây lỗi.

Ưu điểm Python: Dễ học, mạnh về AI, Data Science.

Nhược điểm Python: Chạy chậm hơn JS trên trình duyệt.', 
	'https://funix.edu.vn/wp-content/uploads/2021/10/JavaScript-v%C3%A0-Python.png', '2025-03-22', 4),
	(N' Web3 và Blockchain: Xu hướng công nghệ phi tập trung', 
	N'Blockchain không chỉ phục vụ tiền điện tử mà còn mở rộng sang hợp đồng thông minh, ứng dụng phi tập trung (DApps). Ethereum, Solana là những nền tảng phổ biến.

Ưu điểm: Bảo mật cao, minh bạch.

Nhược điểm: Khó mở rộng, phí giao dịch cao.', 
	'https://itviec.com/blog/wp-content/uploads/2024/03/moi-lien-he-giua-blockchain-va-web3-blog-thumbnail-vippro.png', '2025-03-22', 4),
	(N'Rust: Tương lai của lập trình an toàn và hiệu suất', 
	N'Rust nổi bật với cơ chế quản lý bộ nhớ an toàn, không cần garbage collector, giúp phát triển hệ thống nhúng và phần mềm hiệu suất cao.

Ưu điểm: An toàn bộ nhớ, hiệu suất cao.

Nhược điểm: Cú pháp phức tạp, khó học hơn các ngôn ngữ khác.', 
	'https://200lab.io/blog/_next/image?url=https%3A%2F%2Fstatics.cdn.200lab.io%2F2024%2F09%2Frust-la-gi-1.png&w=3840&q=75', '2025-03-22', 5),
	(N'SQL vs NoSQL: Chọn hệ quản trị dữ liệu nào?', 
	N'SQL như MySQL, PostgreSQL phù hợp với dữ liệu có cấu trúc. NoSQL như MongoDB, Firebase thích hợp cho hệ thống linh hoạt, mở rộng nhanh.', 
	'https://mastering-da.com/wp-content/uploads/2023/10/su-khac-nhau-giua-sql-va-nosql.jpg', '2025-03-22', 4),
	(N'Code AI chatbot với JavaScript: Bắt đầu từ đâu?', 
	N'Chatbot AI đang là xu hướng trong lập trình web. Để tạo một chatbot đơn giản bằng JavaScript, bạn cần:

Sử dụng thư viện NLP như natural.js hoặc API chatbot có sẵn.

Xây dựng logic phản hồi dựa trên dữ liệu đầu vào từ người dùng.

Tích hợp vào website bằng React hoặc đơn giản hơn là HTML, CSS, JavaScript thuần.', 
	'https://www.pullrequest.com/blog/ai-code-review-the-new-frontier-in-software-development/images/ai-code-review--the-new-frontier-in-software-development.webp', '2025-03-22', 5),
	(N'Làm sao để duy trì động lực khi học lập trình?', 
	N'Lập trình có thể khiến bạn nản chí, nhưng đừng bỏ cuộc! Hãy thử:

Chia nhỏ mục tiêu, mỗi ngày học một chút nhưng đều đặn.

Tham gia các thử thách coding như LeetCode, Codeforces.

Tạo một dự án cá nhân giúp áp dụng kiến thức thực tế.', 
	'https://howtolearnmachinelearning.com/wp-content/uploads/2022/12/how_is_ai_being_used_to_write_code-scaled.jpeg', '2025-03-22', 5),
	(N'Học ngôn ngữ nào dễ xin việc nhất?', 
	N'Nếu mục tiêu của bạn là tìm việc nhanh, hãy cân nhắc:

Web (frontend/backend): JavaScript, TypeScript, React, Node.js.

AI & Data Science: Python, SQL.

Lập trình mobile: Kotlin (Android), Swift (iOS), Flutter.

Lập trình game: C#, Unity, C++ (Unreal Engine).

Hệ thống lớn & tài chính: Java, C++, Go, Rust.', 
	'https://topdev.vn/blog/wp-content/uploads/2020/11/top-5-ngon-ngu-lap-trinh-nen-hoc-12.jpg', '2025-03-22', 5);



-- Insert test

INSERT INTO [dbo].[Test] ([Name],  [CreatedBy],[CourseID]) 
VALUES ('Final test','Hoàng Công Ninh', 1),
('Final test',N'Hoàng Công Ninh', 2),
('Final Test',N'Hoàng Công Ninh', 3),
('Final test',N'Hoàng Công Ninh', 4),
('Final test',N'Hoàng Công Ninh', 5),
('Final test',N'Nguyễn Thị Mai', 6),
('Final test',N'Hoàng Minh Tuấn', 7),
('Final test',N'Lê Thị Hồng Ngọc', 8),
('Final test',N'Hà Anh Tài', 9);
-- Insert questions into the Question table with TestID = 1
INSERT INTO Question (QuestionType, QuestionContent, OptionA, OptionB, OptionC, OptionD, TestID) 
VALUES 
('multiple choice', 'Which keyword is used to inherit a class in Java?', 'A. implements', 'B. extends', 'C. inherits', 'D. interface', 1),
('multiple choice', 'Which of the following is the correct declaration of the main method in Java?', 'A. public static void main(String[] args)', 'B. static void main(String[] args)', 'C. public void main(String[] args)', 'D. void main(String args[])', 1),
('multiple choice', 'Which data type is a primitive type in Java?', 'A. String', 'B. ArrayList', 'C. int', 'D. Integer', 1),
('multiple choice', 'Which statement is used to read input from the keyboard in Java?', 'A. Scanner scanner = new Scanner(System.in);', 'B. Input input = new Input(System.in);', 'C. System.console().readLine();', 'D. new Scanner();', 1),
('multiple choice', 'What is the scope of a local variable?', 'A. The entire program', 'B. Inside a method or block', 'C. The entire class', 'D. Inside a package', 1),
('multiple choice', 'What does the final keyword mean in Java?', 'A. A variable cannot be changed', 'B. A method cannot be overridden', 'C. A class cannot be inherited', 'D. All of the above', 1),
('multiple choice', 'An interface in Java can contain:', 'A. Methods with a body', 'B. Mutable variables', 'C. Abstract methods', 'D. Constructors', 1),
('multiple choice', 'Which package does the ArrayList class belong to?', 'A. java.util', 'B. java.lang', 'C. java.io', 'D. java.sql', 1),
('multiple choice', 'Which method of ArrayList is used to retrieve an element by index?', 'A. fetch(int index)', 'B. get(int index)', 'C. retrieve(int index)', 'D. find(int index)', 1),
('multiple choice', 'Which keyword is used to create an object in Java?', 'A. create', 'B. build', 'C. new', 'D. instance', 1),
('multiple choice', 'What is the default value of a boolean variable in Java?', 'A. true', 'B. false', 'C. null', 'D. 0', 1),
('multiple choice', 'What is the purpose of the equals() method?', 'A. Compare memory addresses of two objects', 'B. Compare the contents of two objects', 'C. Copy an object', 'D. Compare two integers', 1),
('multiple choice', 'Which of the following is an example of downcasting?', 'A. (Dog) animal;', 'B. (int) 3.5;', 'C. Integer.parseInt("123");', 'D. String.valueOf(123);', 1),
('multiple choice', 'Which class is used to read data from a file in Java?', 'A. FileReader', 'B. FileScanner', 'C. FileWriter', 'D. FileOutputStream', 1),
('multiple choice', 'What is try-catch-finally used for?', 'A. Exception handling', 'B. Defining loops', 'C. Ending a program', 'D. Initializing variables', 1),
('multiple choice', 'What is the purpose of the throw keyword?', 'A. Declare an exception', 'B. Throw an exception', 'C. Handle an exception', 'D. Catch an exception', 1),
('multiple choice', 'What is Runnable in Java?', 'A. A class', 'B. An interface', 'C. A package', 'D. An annotation', 1),
('multiple choice', 'What is the purpose of the super keyword?', 'A. Call the constructor of the parent class', 'B. Call a static method', 'C. Access a private method', 'D. Access a global variable', 1),
('multiple choice', 'What is the difference between == and equals()?', 'A. == compares memory addresses, equals() compares content', 'B. Both compare memory addresses', 'C. == compares content, equals() compares memory addresses', 'D. No difference', 1),
('multiple choice', 'Which statement is used to exit a loop?', 'A. stop', 'B. continue', 'C. break', 'D. exit', 1),
('multiple choice', 'Which class does System.out.println() belong to?', 'A. System', 'B. Console', 'C. OutputStream', 'D. PrintStream', 1),
('multiple choice', 'What does Math.random() return?', 'A. An integer', 'B. A floating-point number in the range [0,1)', 'C. A floating-point number in the range (0,1]', 'D. An integer in the range [0,10]', 1),
('multiple choice', 'What is the size of an int variable in Java?', 'A. 16 bits', 'B. 32 bits', 'C. 64 bits', 'D. 8 bits', 1),
('multiple choice', 'Which keyword is used to prevent a method from being overridden?', 'A. static', 'B. private', 'C. final', 'D. protected', 1),
('multiple choice', 'What will happen if we try to execute a program without a main method in Java?', 'A. It will compile and run', 'B. It will compile but not run', 'C. It will not compile', 'D. It will throw an exception', 1),
('multiple choice', 'Which method is called automatically when an object is created?', 'A. finalize()', 'B. constructor', 'C. start()', 'D. run()', 1),
('multiple choice', 'Which access modifier allows a variable to be accessed only within the same package?', 'A. public', 'B. private', 'C. protected', 'D. default (no modifier)', 1),
('multiple choice', 'What is the parent class of all classes in Java?', 'A. Object', 'B. Class', 'C. Super', 'D. Base', 1),
('multiple choice', 'What happens when you divide an integer by zero in Java?', 'A. Throws ArithmeticException', 'B. Returns Infinity', 'C. Returns NaN', 'D. Returns 0', 1),
('multiple choice', 'Which keyword is used to call the constructor of the parent class?', 'A. this', 'B. super', 'C. extends', 'D. parent', 1),
('multiple choice', 'What is Reflection in Java?', 'A. A way to access private methods', 'B. A mechanism to inspect and modify classes at runtime', 'C. A technique for garbage collection', 'D. A way to prevent object instantiation', 2),
('multiple choice', 'Which of the following is true about Java Annotations?', 'A. They can provide metadata about the code', 'B. They can change the behavior of a program at runtime', 'C. Both A and B', 'D. None of the above', 2),
('multiple choice', 'Which feature does Java provide for concurrent programming?', 'A. Thread', 'B. ExecutorService', 'C. CompletableFuture', 'D. All of the above', 2),
('multiple choice', 'What is the primary purpose of the volatile keyword in Java?', 'A. To make a variable immutable', 'B. To prevent compiler optimizations', 'C. To ensure visibility of changes to variables across threads', 'D. To improve performance', 2),
('multiple choice', 'Which of the following is NOT a valid state of a thread in Java?', 'A. Running', 'B. Blocked', 'C. Terminated', 'D. WaitingForExecution', 2),
('multiple choice', 'What is the purpose of the ForkJoinPool in Java?', 'A. To manage collections', 'B. To optimize recursive parallel processing', 'C. To replace traditional loops', 'D. To improve GUI performance', 2),
('multiple choice', 'Which Java class is used to establish a database connection?', 'A. DriverManager', 'B. ConnectionFactory', 'C. JDBCManager', 'D. DatabaseConnector', 2),
('multiple choice', 'Which of the following is NOT a Java collection?', 'A. HashMap', 'B. TreeSet', 'C. Stack', 'D. Dictionary', 2),
('multiple choice', 'What is the default capacity of an ArrayList in Java?', 'A. 5', 'B. 10', 'C. 15', 'D. 20', 2),
('multiple choice', 'Which functional interface represents a function that takes one argument and produces a result?', 'A. Consumer', 'B. Supplier', 'C. Function', 'D. BiFunction', 2),
('multiple choice', 'Which Java feature allows you to define a method without implementing it?', 'A. Abstract class', 'B. Interface', 'C. Both A and B', 'D. None of the above', 2),
('multiple choice', 'What is the purpose of the Optional class in Java?', 'A. To avoid null pointer exceptions', 'B. To improve performance', 'C. To manage memory', 'D. To handle exceptions', 2),
('multiple choice', 'Which method is used to execute a PreparedStatement in Java?', 'A. execute()', 'B. executeQuery()', 'C. executeUpdate()', 'D. Both B and C', 2),
('multiple choice', 'Which of the following is NOT a valid Java Stream operation?', 'A. filter()', 'B. collect()', 'C. transform()', 'D. map()', 2),
('multiple choice', 'Which Java feature is used to handle functional programming?', 'A. Streams', 'B. Lambda expressions', 'C. Both A and B', 'D. None of the above', 2),
('multiple choice', 'Which class in Java represents an immutable collection?', 'A. ArrayList', 'B. LinkedList', 'C. ImmutableList', 'D. None of the above', 2),
('multiple choice', 'Which interface is used for dynamic proxy creation in Java?', 'A. ProxyHandler', 'B. InvocationHandler', 'C. DynamicProxy', 'D. ProxyInterface', 2),
('multiple choice', 'What is the difference between Comparator and Comparable in Java?', 'A. Comparator is used for custom sorting, Comparable defines natural order', 'B. Comparable is faster than Comparator', 'C. Comparator sorts only primitive types', 'D. They are identical in functionality', 2),
('multiple choice', 'Which method is called when an object is garbage collected in Java?', 'A. finalize()', 'B. destroy()', 'C. dispose()', 'D. cleanUp()', 2),
('multiple choice', 'Which class is used for reading and writing objects in Java?', 'A. FileReader', 'B. ObjectStream', 'C. ObjectInputStream', 'D. ByteStream', 2),
('multiple choice', 'What is the purpose of the CompletableFuture class?', 'A. To handle asynchronous programming', 'B. To manage GUI operations', 'C. To simplify file handling', 'D. To improve memory management', 2),
('multiple choice', 'Which of the following is true about Java Records?', 'A. They are immutable by default', 'B. They can extend other classes', 'C. They allow method overriding', 'D. They are a type of interface', 2),
('multiple choice', 'Which of the following best describes Java Modules?', 'A. They allow encapsulation of packages', 'B. They replace JAR files', 'C. They enable Java to run without JVM', 'D. They are only used in Android development', 2),
('multiple choice', 'Which API is used for JSON parsing in Java?', 'A. JSONParser', 'B. Gson', 'C. Jackson', 'D. Both B and C', 2),
('multiple choice', 'Which method in Stream API is used to perform aggregation?', 'A. sum()', 'B. aggregate()', 'C. collect()', 'D. process()', 2),
('multiple choice', 'Which of the following is a valid way to create a new thread in Java?', 'A. Extending Thread class', 'B. Implementing Runnable interface', 'C. Using ExecutorService', 'D. All of the above', 2),
('multiple choice', 'Which keyword is used to define a lambda expression in Java?', 'A. ->', 'B. =>', 'C. **', 'D. &&', 2),
('multiple choice', 'What is the purpose of the reentrant lock in Java?', 'A. Prevents deadlocks', 'B. Allows multiple reentrant locks in a thread', 'C. Ensures atomic operations', 'D. None of the above', 2),
('multiple choice', 'Which exception is thrown when trying to access an element outside the bounds of an array?', 'A. NullPointerException', 'B. ArrayIndexOutOfBoundsException', 'C. IllegalArgumentException', 'D. ClassCastException', 2),
('multiple choice', 'Which Java keyword is used to prevent a class from being extended?',  'A. sealed', 'B. final', 'C. abstract','D. static', 2),
('multiple choice', 'What is Spring Boot primarily used for?', 'A. Front-end development', 'B. Simplifying Java-based web applications', 'C. Managing databases', 'D. Writing JavaScript code', 3),
('multiple choice', 'Which annotation is used to mark the main class in a Spring Boot application?', 'A. @SpringApplication', 'B. @SpringBootApplication', 'C. @SpringMain', 'D. @SpringConfig', 3),
('multiple choice', 'Which dependency is required for creating RESTful APIs in Spring Boot?', 'A. spring-boot-starter-web', 'B. spring-boot-starter-data-jpa', 'C. spring-boot-starter-security', 'D. spring-boot-starter-test', 3),
('multiple choice', 'What is the default embedded server in Spring Boot?', 'A. Tomcat', 'B. Jetty', 'C. Undertow', 'D. WildFly', 3),
('multiple choice', 'Which file is used to configure properties in a Spring Boot application?', 'A. application.properties', 'B. spring.xml', 'C. config.json', 'D. settings.yaml', 3),
('multiple choice', 'Which annotation is used to define a RESTful web service?', 'A. @RestService', 'B. @RestController', 'C. @WebService', 'D. @Controller', 3),
('multiple choice', 'Which command is used to run a Spring Boot application?', 'A. mvn spring-boot:run', 'B. java -jar app.jar', 'C. gradle bootRun', 'D. All of the above', 3),
('multiple choice', 'What does the @Autowired annotation do?', 'A. Handles HTTP requests', 'B. Enables automatic dependency injection', 'C. Creates database tables', 'D. Configures properties', 3),
('multiple choice', 'Which database is embedded by default in Spring Boot?', 'A. MySQL', 'B. PostgreSQL', 'C. H2', 'D. SQLite', 3),
('multiple choice', 'Which annotation is used to enable JPA repositories in Spring Boot?', 'A. @EnableJpaRepositories', 'B. @SpringData', 'C. @JpaConfig', 'D. @EnableORM', 3),
('multiple choice', 'What is Spring Boot DevTools used for?', 'A. Security enhancements', 'B. Database migrations', 'C. Automatic restart and live reload', 'D. Logging improvements', 3),
('multiple choice', 'Which annotation is used for exception handling at the controller level?', 'A. @ExceptionHandler', 'B. @HandleException', 'C. @RestException', 'D. @ErrorHandler', 3),
('multiple choice', 'What is the default port for a Spring Boot application?', 'A. 8080', 'B. 9090', 'C. 8000', 'D. 8888', 3),
('multiple choice', 'Which dependency is required for Spring Boot JPA?', 'A. spring-boot-starter-web', 'B. spring-boot-starter-jpa', 'C. spring-boot-starter-security', 'D. spring-boot-starter-test', 3),
('multiple choice', 'Which annotation is used to map HTTP GET requests?', 'A. @PostMapping', 'B. @PutMapping', 'C. @DeleteMapping', 'D. @GetMapping', 3),
('multiple choice', 'What is the purpose of the @Transactional annotation?', 'A. Manage transactions', 'B. Handle REST API calls', 'C. Define scheduled tasks', 'D. Enable logging', 3),
('multiple choice', 'Which annotation is used to define scheduled tasks?', 'A. @Schedule', 'B. @EnableScheduling', 'C. @Scheduled', 'D. @TaskScheduler', 3),
('multiple choice', 'What is Thymeleaf used for in Spring Boot?', 'A. Database management', 'B. Front-end templating', 'C. Dependency injection', 'D. Security', 3),
('multiple choice', 'Which class is used to make RESTful API calls in Spring Boot?', 'A. RestClient', 'B. HttpClient', 'C. WebClient', 'D. RestTemplate', 3),
('multiple choice', 'Which annotation is used for field-level validation in Spring Boot?', 'A. @NotNull', 'B. @Valid', 'C. @Validated', 'D. @Check', 3),
('multiple choice', 'Which annotation enables global exception handling?', 'A. @ExceptionHandler', 'B. @ControllerAdvice', 'C. @RestControllerAdvice', 'D. Both B and C', 3),
('multiple choice', 'What does Spring Boot Actuator provide?', 'A. Database migration tools', 'B. Security features', 'C. Monitoring and management endpoints', 'D. Logging mechanisms', 3),
('multiple choice', 'Which annotation is used to inject values from properties files?', 'A. @PropertySource', 'B. @Value', 'C. @Autowired', 'D. @ConfigurationProperties', 3),
('multiple choice', 'What is the purpose of the application.properties file?', 'A. Define business logic', 'B. Manage configurations', 'C. Create database connections', 'D. Compile Java code', 3),
('multiple choice', 'Which annotation is used to define a service layer in Spring Boot?', 'A. @Component', 'B. @Service', 'C. @Repository', 'D. @RestController', 3),
('multiple choice', 'What does the @SpringBootApplication annotation do?', 'A. Enables auto-configuration', 'B. Defines a main class', 'C. Enables component scanning', 'D. All of the above', 3),
('multiple choice', 'Which Spring Boot component manages dependency injection?', 'A. Bean Factory', 'B. ApplicationContext', 'C. Spring Container', 'D. Dependency Manager', 3),
('multiple choice', 'What is the purpose of the Spring Boot banner.txt file?', 'A. Configure logging', 'B. Customize the startup banner', 'C. Enable debugging mode', 'D. Manage security settings', 3),
('multiple choice', 'How do you change the default port in Spring Boot?', 'A. Modify application.properties', 'B. Change server.xml', 'C. Edit boot.config', 'D. Set an environment variable', 3),
('multiple choice', 'Which command is used to package a Spring Boot application as a JAR file?', 'A. mvn package', 'B. gradle build', 'C. java -jar', 'D. Both A and B', 3),
('multiple choice', 'Which keyword is used to define a function in Python?', 'A. func', 'B. define', 'C. def', 'D. function', 4),
('multiple choice', 'What is the output of print(2 + 3)?', 'A. 23', 'B. 5', 'C. "5"', 'D. Error', 4),
('multiple choice', 'Which of the following is a valid variable name in Python?', 'A. 1variable', 'B. variable_1', 'C. variable-1', 'D. variable#1', 4),
('multiple choice', 'Which data type is used to store a sequence of characters in Python?', 'A. int', 'B. float', 'C. str', 'D. bool', 4),
('multiple choice', 'How do you create a list in Python?', 'A. []', 'B. {}', 'C. ()', 'D. <>', 4),
('multiple choice', 'What is the output of len("Python")?', 'A. 5', 'B. 6', 'C. 7', 'D. Error', 4),
('multiple choice', 'Which operator is used for exponentiation in Python?', 'A. ^', 'B. **', 'C. ', 'D. //', 4),
('multiple choice', 'Which statement is used to exit a loop in Python?', 'A. stop', 'B. break', 'C. exit', 'D. continue', 4),
('multiple choice', 'What is the default value of a variable if it is not initialized in Python?', 'A. 0', 'B. None', 'C. null', 'D. False', 4),
('multiple choice', 'Which keyword is used to handle exceptions in Python?', 'A. try', 'B. catch', 'C. except', 'D. Both A and C', 4),
('multiple choice', 'What does the append() method do in a Python list?', 'A. Removes an element', 'B. Adds an element to the end', 'C. Sorts the list', 'D. Reverses the list', 4),
('multiple choice', 'Which of the following is a mutable data type in Python?', 'A. tuple', 'B. str', 'C. list', 'D. int', 4),
('multiple choice', 'What is the output of "Hello" + " World"?', 'A. Hello World', 'B. HelloWorld', 'C. "Hello World"', 'D. Error', 4),
('multiple choice', 'Which method is used to convert a string to lowercase in Python?', 'A. lower()', 'B. down()', 'C. toLower()', 'D. lowercase()', 4),
('multiple choice', 'How do you write a single-line comment in Python?', 'A. //', 'B. #', 'C. / */', 'D. --', 4),
('multiple choice', 'Which keyword is used to create a class in Python?', 'A. class', 'B. struct', 'C. object', 'D. type', 4),
('multiple choice', 'What is the output of 10 // 3?', 'A. 3.33', 'B. 3', 'C. 4', 'D. Error', 4),
('multiple choice', 'Which module is used to generate random numbers in Python?', 'A. math', 'B. random', 'C. numbers', 'D. rand', 4),
('multiple choice', 'What does the pop() method do in a Python list?', 'A. Adds an element', 'B. Removes and returns the last element', 'C. Reverses the list', 'D. Sorts the list', 4),
('multiple choice', 'Which of the following is a correct way to define a tuple in Python?', 'A. (1, 2, 3)', 'B. [1, 2, 3]', 'C. {1, 2, 3}', 'D. <1, 2, 3>', 4),
('multiple choice', 'What is the output of type(3.14)?', 'A. int', 'B. float', 'C. str', 'D. bool', 4),
('multiple choice', 'Which keyword is used to inherit a class in Python?', 'A. extends', 'B. inherits', 'C. class', 'D. No keyword needed', 4),
('multiple choice', 'What does the strip() method do to a string?', 'A. Removes leading and trailing whitespace', 'B. Splits the string', 'C. Joins the string', 'D. Reverses the string', 4),
('multiple choice', 'Which of the following is used to read input from the user in Python?', 'A. input()', 'B. read()', 'C. get()', 'D. scan()', 4),
('multiple choice', 'What is the purpose of the pass statement in Python?', 'A. Ends a loop', 'B. Does nothing (placeholder)', 'C. Raises an exception', 'D. Prints a message', 4),
('multiple choice', 'What is the output of [1, 2, 3][1]?', 'A. 1', 'B. 2', 'C. 3', 'D. Error', 4),
('multiple choice', 'Which keyword is used to define a loop that iterates over a sequence?', 'A. for', 'B. while', 'C. loop', 'D. do', 4),
('multiple choice', 'What does the import keyword do in Python?', 'A. Defines a function', 'B. Loads a module', 'C. Declares a variable', 'D. Exits the program', 4),
('multiple choice', 'Which method is used to find the index of an element in a list?', 'A. find()', 'B. index()', 'C. search()', 'D. position()', 4),
('multiple choice', 'What is the output of bool(0)?', 'A. True', 'B. False', 'C. None', 'D. Error', 4),
('multiple choice', 'Which library is commonly used for data manipulation in Python?', 'A. Matplotlib', 'B. Pandas', 'C. NumPy', 'D. Scikit-learn', 5),
('multiple choice', 'What does the NumPy library primarily provide?', 'A. Data visualization', 'B. Numerical arrays and operations', 'C. Machine learning models', 'D. Web scraping', 5),
('multiple choice', 'Which function is used to read a CSV file in Pandas?', 'A. read_csv()', 'B. load_csv()', 'C. open_csv()', 'D. import_csv()', 5),
('multiple choice', 'What is the purpose of Matplotlib in data science?', 'A. Data cleaning', 'B. Data visualization', 'C. Statistical modeling', 'D. Data storage', 5),
('multiple choice', 'Which Python library is used for machine learning?', 'A. Seaborn', 'B. Scikit-learn', 'C. Pandas', 'D. NumPy', 5),
('multiple choice', 'What does the shape attribute of a Pandas DataFrame return?', 'A. Number of columns', 'B. Number of rows and columns', 'C. Data types', 'D. Column names', 5),
('multiple choice', 'Which method is used to drop missing values in Pandas?', 'A. dropna()', 'B. remove_na()', 'C. delete_na()', 'D. clean_na()', 5),
('multiple choice', 'What is the purpose of the groupby() function in Pandas?', 'A. Sort data', 'B. Aggregate data by categories', 'C. Merge datasets', 'D. Filter rows', 5),
('multiple choice', 'Which function creates a histogram in Matplotlib?', 'A. plot()', 'B. scatter()', 'C. hist()', 'D. bar()', 5),
('multiple choice', 'What does the fit() method do in Scikit-learn?', 'A. Predicts outcomes', 'B. Trains a model', 'C. Evaluates a model', 'D. Scales data', 5),
('multiple choice', 'Which data structure is used by NumPy for multi-dimensional arrays?', 'A. List', 'B. Array', 'C. ndarray', 'D. Tuple', 5),
('multiple choice', 'What is the output of df.head() in Pandas?', 'A. Last 5 rows', 'B. First 5 rows', 'C. Random 5 rows', 'D. All rows', 5),
('multiple choice', 'Which library is used for statistical data visualization?', 'A. Seaborn', 'B. Pandas', 'C. NumPy', 'D. Scikit-learn', 5),
('multiple choice', 'What does the describe() method in Pandas return?', 'A. Data types', 'B. Summary statistics', 'C. Missing values', 'D. Column names', 5),
('multiple choice', 'Which function splits data into training and testing sets in Scikit-learn?', 'A. train_test_split()', 'B. split_data()', 'C. divide_data()', 'D. separate_data()', 5),
('multiple choice', 'What is the purpose of a correlation matrix?', 'A. Visualize data', 'B. Show relationships between variables', 'C. Clean data', 'D. Train models', 5),
('multiple choice', 'Which Matplotlib function creates a line plot?', 'A. plot()', 'B. scatter()', 'C. bar()', 'D. hist()', 5),
('multiple choice', 'What does the iloc[] method in Pandas do?', 'A. Selects by label', 'B. Selects by integer position', 'C. Filters rows', 'D. Groups data', 5),
('multiple choice', 'Which metric evaluates a regression model’s accuracy?', 'A. Accuracy score', 'B. Mean Squared Error', 'C. Confusion matrix', 'D. F1 score', 5),
('multiple choice', 'What is the purpose of feature scaling?', 'A. Reduce data size', 'B. Normalize data for models', 'C. Visualize data', 'D. Remove duplicates', 5),
('multiple choice', 'Which function creates a heatmap in Seaborn?', 'A. heatmap()', 'B. plot()', 'C. barplot()', 'D. scatterplot()', 5),
('multiple choice', 'What does the apply() method in Pandas do?', 'A. Applies a function to each element', 'B. Drops rows', 'C. Merges data', 'D. Sorts data', 5),
('multiple choice', 'Which algorithm is used for classification in Scikit-learn?', 'A. Linear Regression', 'B. Logistic Regression', 'C. K-Means', 'D. PCA', 5),
('multiple choice', 'What is the purpose of the random_state parameter?', 'A. Sets random seed for reproducibility', 'B. Scales data', 'C. Splits data', 'D. Trains models', 5),
('multiple choice', 'Which library is used for numerical computations in Python?', 'A. Pandas', 'B. Matplotlib', 'C. NumPy', 'D. Seaborn', 5),
('multiple choice', 'What does the merge() function in Pandas do?', 'A. Combines DataFrames', 'B. Drops rows', 'C. Filters data', 'D. Sorts data', 5),
('multiple choice', 'Which plot is used to show data distribution in Seaborn?', 'A. Barplot', 'B. Boxplot', 'C. Lineplot', 'D. Scatterplot', 5),
('multiple choice', 'What is overfitting in machine learning?', 'A. Model fits training data too well', 'B. Model fails to train', 'C. Model predicts perfectly', 'D. Model has no errors', 5),
('multiple choice', 'Which function evaluates a model’s performance in Scikit-learn?', 'A. score()', 'B. predict()', 'C. fit()', 'D. transform()', 5),
('multiple choice', 'What does EDA stand for in data science?', 'A. Error Detection Analysis', 'B. Exploratory Data Analysis', 'C. Efficient Data Aggregation', 'D. Enhanced Data Adjustment', 5),
('multiple choice', 'What is Flask in Python?', 'A. A database', 'B. A web framework', 'C. A data visualization library', 'D. A machine learning tool', 6),
('multiple choice', 'Which command installs Flask?', 'A. pip install flask', 'B. npm install flask', 'C. python install flask', 'D. apt-get install flask', 6),
('multiple choice', 'What does the @app.route() decorator do in Flask?', 'A. Defines a URL route', 'B. Connects to a database', 'C. Renders a template', 'D. Starts the server', 6),
('multiple choice', 'Which HTTP method is used to retrieve data in Flask?', 'A. POST', 'B. GET', 'C. PUT', 'D. DELETE', 6),
('multiple choice', 'What is Jinja2 in Flask?', 'A. A routing system', 'B. A templating engine', 'C. A database library', 'D. A security module', 6),
('multiple choice', 'Which function renders an HTML template in Flask?', 'A. render_template()', 'B. display_template()', 'C. show_template()', 'D. load_template()', 6),
('multiple choice', 'What is the default port for a Flask app?', 'A. 3000', 'B. 5000', 'C. 8080', 'D. 8000', 6),
('multiple choice', 'Which database is commonly used with Flask?', 'A. SQLite', 'B. MongoDB', 'C. PostgreSQL', 'D. All of the above', 6),
('multiple choice', 'What does SQLAlchemy provide in Flask?', 'A. ORM capabilities', 'B. Routing', 'C. Templating', 'D. Authentication', 6),
('multiple choice', 'How do you start a Flask application?', 'A. app.start()', 'B. app.run()', 'C. flask.start()', 'D. flask.run()', 6),
('multiple choice', 'Which file extension is used for Flask templates?', 'A. .py', 'B. .html', 'C. .css', 'D. .js', 6),
('multiple choice', 'What does the request object do in Flask?', 'A. Handles HTTP requests', 'B. Renders templates', 'C. Connects to databases', 'D. Manages routes', 6),
('multiple choice', 'Which method retrieves form data in Flask?', 'A. request.form', 'B. request.data', 'C. request.get', 'D. request.post', 6),
('multiple choice', 'What is the purpose of the Flask debug mode?', 'A. Speeds up the app', 'B. Provides error details', 'C. Secures the app', 'D. Disables routes', 6),
('multiple choice', 'Which command runs a Flask app in debug mode?', 'A. app.run(debug=True)', 'B. flask debug', 'C. app.debug()', 'D. debug.run()', 6),
('multiple choice', 'What is a Flask blueprint?', 'A. A database schema', 'B. A modular component', 'C. A template file', 'D. A routing rule', 6),
('multiple choice', 'Which HTTP method updates data in Flask?', 'A. GET', 'B. POST', 'C. PUT', 'D. DELETE', 6),
('multiple choice', 'What does the redirect() function do in Flask?', 'A. Reloads the page', 'B. Sends user to another URL', 'C. Renders a template', 'D. Stops the app', 6),
('multiple choice', 'Which library integrates Flask with a database?', 'A. Flask-SQLAlchemy', 'B. Flask-Mongo', 'C. Flask-DB', 'D. Flask-Data', 6),
('multiple choice', 'What is the purpose of Flask-WTF?', 'A. Form handling', 'B. Database management', 'C. Routing', 'D. Authentication', 6),
('multiple choice', 'Which folder stores static files in Flask?', 'A. templates', 'B. static', 'C. assets', 'D. public', 6),
('multiple choice', 'What does url_for() do in Flask?', 'A. Builds a URL', 'B. Redirects users', 'C. Renders templates', 'D. Fetches data', 6),
('multiple choice', 'Which method deletes data in Flask?', 'A. GET', 'B. POST', 'C. PUT', 'D. DELETE', 6),
('multiple choice', 'What is a session in Flask?', 'A. A database connection', 'B. A way to store user data', 'C. A template engine', 'D. A routing system', 6),
('multiple choice', 'Which command sets the Flask environment variable?', 'A. export FLASK_APP', 'B. set FLASK_ENV', 'C. flask set app', 'D. app.env()', 6),
('multiple choice', 'What does the g object in Flask do?', 'A. Stores global variables', 'B. Manages routes', 'C. Renders templates', 'D. Handles requests', 6),
('multiple choice', 'Which Flask extension adds login functionality?', 'A. Flask-Login', 'B. Flask-Security', 'C. Flask-Auth', 'D. Flask-User', 6),
('multiple choice', 'What is the purpose of Flask-Migrate?', 'A. Database migrations', 'B. User authentication', 'C. Form validation', 'D. Template rendering', 6),
('multiple choice', 'Which method retrieves URL parameters in Flask?', 'A. request.args', 'B. request.params', 'C. request.url', 'D. request.query', 6),
('multiple choice', 'What does the jsonify() function do in Flask?', 'A. Converts data to JSON', 'B. Renders templates', 'C. Redirects users', 'D. Fetches data', 6),
('multiple choice', 'Which keyword declares a variable in JavaScript?', 'A. var', 'B. let', 'C. const', 'D. All of the above', 7),
('multiple choice', 'What is the output of console.log(typeof "hello")?', 'A. number', 'B. string', 'C. boolean', 'D. object', 7),
('multiple choice', 'Which operator checks for equality in value and type?', 'A. ==', 'B. ===', 'C. =', 'D. !=', 7),
('multiple choice', 'How do you define a function in JavaScript?', 'A. function myFunc() {}', 'B. def myFunc() {}', 'C. func myFunc() {}', 'D. myFunc() = {}', 7),
('multiple choice', 'What does the push() method do to an array?', 'A. Removes an element', 'B. Adds an element to the end', 'C. Sorts the array', 'D. Reverses the array', 7),
('multiple choice', 'Which loop iterates over an array?', 'A. for', 'B. while', 'C. do-while', 'D. All of the above', 7),
('multiple choice', 'What is the output of 5 + "5" in JavaScript?', 'A. 10', 'B. "55"', 'C. "10"', 'D. Error', 7),
('multiple choice', 'Which method converts a string to an integer?', 'A. parseInt()', 'B. toString()', 'C. parseFloat()', 'D. Number()', 7),
('multiple choice', 'What does the querySelector() method do?', 'A. Selects an element by ID', 'B. Selects the first matching element', 'C. Selects all elements', 'D. Adds an element', 7),
('multiple choice', 'What is an arrow function in JavaScript?', 'A. () => {}', 'B. function() {}', 'C. => {}', 'D. func => {}', 7),
('multiple choice', 'Which keyword prevents variable reassignment?', 'A. var', 'B. let', 'C. const', 'D. static', 7),
('multiple choice', 'What does the splice() method do?', 'A. Adds/removes array elements', 'B. Joins arrays', 'C. Sorts arrays', 'D. Filters arrays', 7),
('multiple choice', 'What is the output of console.log(0 == "0")?', 'A. true', 'B. false', 'C. undefined', 'D. Error', 7),
('multiple choice', 'Which event listener detects a mouse click?', 'A. onclick', 'B. onmouseover', 'C. onkeydown', 'D. onchange', 7),
('multiple choice', 'What does JSON stand for?', 'A. JavaScript Object Notation', 'B. JavaScript Online Notation', 'C. Java Standard Object Name', 'D. JavaScript Ordered Notation', 7),
('multiple choice', 'Which method adds an element to the beginning of an array?', 'A. push()', 'B. unshift()', 'C. pop()', 'D. shift()', 7),
('multiple choice', 'What is the purpose of the this keyword?', 'A. Refers to the current object', 'B. Declares a variable', 'C. Defines a function', 'D. Loops over arrays', 7),
('multiple choice', 'Which operator performs logical AND?', 'A. ||', 'B. &&', 'C. !', 'D. ??', 7),
('multiple choice', 'What does the map() method do?', 'A. Filters an array', 'B. Creates a new array with transformed elements', 'C. Sorts an array', 'D. Removes elements', 7),
('multiple choice', 'Which method removes the last element from an array?', 'A. pop()', 'B. shift()', 'C. splice()', 'D. slice()', 7),
('multiple choice', 'What is the output of console.log(typeof null)?', 'A. null', 'B. object', 'C. undefined', 'D. string', 7),
('multiple choice', 'Which statement stops a loop?', 'A. return', 'B. break', 'C. continue', 'D. exit', 7),
('multiple choice', 'What does the addEventListener() method do?', 'A. Adds a CSS style', 'B. Attaches an event handler', 'C. Removes an element', 'D. Fetches data', 7),
('multiple choice', 'Which method converts an object to a JSON string?', 'A. JSON.parse()', 'B. JSON.stringify()', 'C. JSON.convert()', 'D. JSON.object()', 7),
('multiple choice', 'What is the purpose of promises in JavaScript?', 'A. Handle synchronous code', 'B. Manage asynchronous operations', 'C. Define variables', 'D. Loop over arrays', 7),
('multiple choice', 'Which keyword defines a class in JavaScript?', 'A. class', 'B. object', 'C. struct', 'D. type', 7),
('multiple choice', 'What does the filter() method do?', 'A. Creates a new array with filtered elements', 'B. Sorts an array', 'C. Removes elements', 'D. Maps elements', 7),
('multiple choice', 'Which symbol denotes a template literal?', 'A. ""', 'B. ''', 'C. ``', 'D. //', 7),
('multiple choice', 'What is the output of console.log(!!0)?', 'A. true', 'B. false', 'C. 0', 'D. undefined', 7),
('multiple choice', 'Which method fetches data from a server?', 'A. fetch()', 'B. get()', 'C. request()', 'D. load()', 7),
('multiple choice', 'Which tag defines the main content in HTML?', 'A. <header>', 'B. <main>', 'C. <section>', 'D. <div>', 8),
('multiple choice', 'What does CSS stand for?', 'A. Cascading Style Sheets', 'B. Creative Style System', 'C. Computer Style Sheets', 'D. Custom Style Syntax', 8),
('multiple choice', 'Which property sets the text color in CSS?', 'A. font-color', 'B. color', 'C. text-color', 'D. foreground', 8),
('multiple choice', 'How do you link a CSS file to HTML?', 'A. <link rel="stylesheet" href="style.css">', 'B. <style src="style.css">', 'C. <css href="style.css">', 'D. <script src="style.css">', 8),
('multiple choice', 'Which HTML tag creates a paragraph?', 'A. <p>', 'B. <para>', 'C. <text>', 'D. <paragraph>', 8),
('multiple choice', 'What does the display: flex property do in CSS?', 'A. Centers an element', 'B. Creates a flexible layout', 'C. Hides an element', 'D. Adds padding', 8),
('multiple choice', 'Which JavaScript method selects an element by ID?', 'A. getElementById()', 'B. querySelector()', 'C. getElementsByClassName()', 'D. selectById()', 8),
('multiple choice', 'What is the purpose of the <head> tag in HTML?', 'A. Displays content', 'B. Contains metadata', 'C. Defines the footer', 'D. Adds styles', 8),
('multiple choice', 'Which CSS unit is relative to the viewport width?', 'A. px', 'B. em', 'C. vw', 'D. rem', 8),
('multiple choice', 'What does the <script> tag do in HTML?', 'A. Links a CSS file', 'B. Embeds JavaScript', 'C. Adds an image', 'D. Creates a form', 8),
('multiple choice', 'Which CSS property controls element spacing?', 'A. margin', 'B. padding', 'C. border', 'D. Both A and B', 8),
('multiple choice', 'What is the default value of the position property in CSS?', 'A. absolute', 'B. relative', 'C. static', 'D. fixed', 8),
('multiple choice', 'Which HTML attribute specifies an image source?', 'A. src', 'B. href', 'C. alt', 'D. link', 8),
('multiple choice', 'What does the box-sizing: border-box property do?', 'A. Includes padding and border in width', 'B. Excludes padding', 'C. Centers the box', 'D. Adds a shadow', 8),
('multiple choice', 'Which JavaScript method adds a class to an element?', 'A. classList.add()', 'B. addClass()', 'C. className.add()', 'D. appendClass()', 8),
('multiple choice', 'What is the purpose of the alt attribute in an <img> tag?', 'A. Sets image size', 'B. Provides alternative text', 'C. Links to another page', 'D. Adds a caption', 8),
('multiple choice', 'Which CSS selector targets all elements?', 'A. #id', 'B. .class', 'C. *', 'D. element', 8),
('multiple choice', 'What does the <a> tag create in HTML?', 'A. A link', 'B. An image', 'C. A button', 'D. A form', 8),
('multiple choice', 'Which property sets the font size in CSS?', 'A. font-size', 'B. text-size', 'C. size', 'D. font-height', 8),
('multiple choice', 'What does the innerHTML property do in JavaScript?', 'A. Sets or gets HTML content', 'B. Adds a style', 'C. Removes an element', 'D. Fetches data', 8),
('multiple choice', 'Which HTML tag defines a list item?', 'A. <li>', 'B. <ul>', 'C. <ol>', 'D. <list>', 8),
('multiple choice', 'What is the purpose of media queries in CSS?', 'A. Add animations', 'B. Create responsive designs', 'C. Set colors', 'D. Define fonts', 8),
('multiple choice', 'Which JavaScript event occurs when a page loads?', 'A. onclick', 'B. onload', 'C. onsubmit', 'D. onchange', 8),
('multiple choice', 'What does the float property do in CSS?', 'A. Centers an element', 'B. Positions an element left or right', 'C. Hides an element', 'D. Adds margin', 8),
('multiple choice', 'Which HTML tag creates a form?', 'A. <form>', 'B. <input>', 'C. <button>', 'D. <submit>', 8),
('multiple choice', 'What does the z-index property control in CSS?', 'A. Element stacking order', 'B. Font size', 'C. Margin', 'D. Padding', 8),
('multiple choice', 'Which JavaScript method removes a class from an element?', 'A. classList.remove()', 'B. removeClass()', 'C. deleteClass()', 'D. className.remove()', 8),
('multiple choice', 'What is the purpose of the <meta> tag in HTML?', 'A. Adds content', 'B. Provides metadata', 'C. Links a script', 'D. Defines a section', 8),
('multiple choice', 'Which CSS property creates a shadow effect?', 'A. box-shadow', 'B. text-shadow', 'C. shadow', 'D. Both A and B', 8),
('multiple choice', 'What does the querySelectorAll() method return?', 'A. A single element', 'B. A NodeList of elements', 'C. An array', 'D. A string', 8),
('multiple choice', 'What is Node.js?', 'A. A JavaScript framework', 'B. A runtime environment', 'C. A database', 'D. A browser', 9),
('multiple choice', 'Which command installs Node.js packages?', 'A. npm install', 'B. pip install', 'C. node install', 'D. yarn install', 9),
('multiple choice', 'What is Express.js?', 'A. A database library', 'B. A web framework for Node.js', 'C. A templating engine', 'D. A testing tool', 9),
('multiple choice', 'Which method starts an Express server?', 'A. app.listen()', 'B. app.start()', 'C. server.run()', 'D. express.start()', 9),
('multiple choice', 'What does npm stand for?', 'A. Node Package Manager', 'B. Node Programming Module', 'C. New Package Manager', 'D. Node Project Manager', 9),
('multiple choice', 'Which HTTP method retrieves data in Express?', 'A. app.post()', 'B. app.get()', 'C. app.put()', 'D. app.delete()', 9),
('multiple choice', 'What is the purpose of middleware in Express?', 'A. Handles requests and responses', 'B. Connects to a database', 'C. Renders templates', 'D. Defines routes', 9),
('multiple choice', 'Which module manages file operations in Node.js?', 'A. fs', 'B. http', 'C. path', 'D. url', 9),
('multiple choice', 'What does the require() function do in Node.js?', 'A. Imports modules', 'B. Exports functions', 'C. Runs the app', 'D. Defines routes', 9),
('multiple choice', 'Which Express method defines a route?', 'A. app.route()', 'B. app.get()', 'C. app.use()', 'D. Both A and B', 9),
('multiple choice', 'What is the default port for an Express app?', 'A. 3000', 'B. 5000', 'C. 8080', 'D. No default', 9),
('multiple choice', 'Which function sends a response in Express?', 'A. res.send()', 'B. res.write()', 'C. res.end()', 'D. res.reply()', 9),
('multiple choice', 'What does the path module do in Node.js?', 'A. Handles file paths', 'B. Manages HTTP requests', 'C. Renders templates', 'D. Connects to databases', 9),
('multiple choice', 'Which middleware parses JSON data in Express?', 'A. express.json()', 'B. body-parser', 'C. express.urlencoded()', 'D. Both A and C', 9),
('multiple choice', 'What is a callback function in Node.js?', 'A. A function passed as an argument', 'B. A synchronous function', 'C. A routing function', 'D. A template function', 9),
('multiple choice', 'Which method updates data in Express?', 'A. app.get()', 'B. app.post()', 'C. app.put()', 'D. app.delete()', 9),
('multiple choice', 'What does the process.env object do?', 'A. Stores environment variables', 'B. Manages routes', 'C. Handles files', 'D. Parses JSON', 9),
('multiple choice', 'Which package manages asynchronous operations in Node.js?', 'A. async', 'B. promises', 'C. fs', 'D. http', 9),
('multiple choice', 'What is the purpose of the res.json() method?', 'A. Sends a JSON response', 'B. Renders a template', 'C. Redirects users', 'D. Fetches data', 9),
('multiple choice', 'Which module creates an HTTP server in Node.js?', 'A. fs', 'B. http', 'C. path', 'D. url', 9),
('multiple choice', 'What does app.use() do in Express?', 'A. Defines a route', 'B. Applies middleware', 'C. Sends a response', 'D. Starts the server', 9),
('multiple choice', 'Which method removes data in Express?', 'A. app.get()', 'B. app.post()', 'C. app.put()', 'D. app.delete()', 9),
('multiple choice', 'What is a Promise in Node.js?', 'A. A synchronous function', 'B. An object for asynchronous operations', 'C. A routing method', 'D. A file handler', 9),
('multiple choice', 'Which Express method redirects users?', 'A. res.redirect()', 'B. res.send()', 'C. res.render()', 'D. res.json()', 9),
('multiple choice', 'What does the __dirname variable represent?', 'A. Current file path', 'B. Current directory path', 'C. Root directory', 'D. Server path', 9),
('multiple choice', 'Which tool debugs Node.js applications?', 'A. node debug', 'B. node --inspect', 'C. npm debug', 'D. express debug', 9),
('multiple choice', 'What is the purpose of the next() function in Express?', 'A. Ends the response', 'B. Calls the next middleware', 'C. Redirects users', 'D. Renders a template', 9),
('multiple choice', 'Which method serves static files in Express?', 'A. express.static()', 'B. app.static()', 'C. res.static()', 'D. serve.static()', 9),
('multiple choice', 'What does the req.params object contain?', 'A. Query strings', 'B. Route parameters', 'C. Form data', 'D. JSON data', 9),
('multiple choice', 'Which Node.js feature allows non-blocking I/O?', 'A. Event loop', 'B. Callbacks', 'C. Promises', 'D. All of the above', 9);

INSERT INTO Answer (AnswerContent, QuestionID)
VALUES
('B', 1), -- Correct answer for question 1
('A', 2), -- Correct answer for question 2
('C', 3), -- Correct answer for question 3
('A', 4), -- Correct answer for question 4
('B', 5), -- Correct answer for question 5
('D', 6), -- Correct answer for question 6
('C', 7), -- Correct answer for question 7
('A', 8), -- Correct answer for question 8
('B', 9), -- Correct answer for question 9
('C', 10), -- Correct answer for question 10
('A', 11), -- Correct answer for question 11
('B', 12), -- Correct answer for question 12
('C', 13), -- Correct answer for question 13
('B', 14), -- Correct answer for question 14
('A', 15), -- Correct answer for question 15
('B', 16), -- Correct answer for question 16
('C', 17), -- Correct answer for question 17
('A', 18), -- Correct answer for question 18
('B', 19), -- Correct answer for question 19
('C', 20), -- Correct answer for question 20
('A', 21), -- Correct answer for question 21
('B', 22), -- Correct answer for question 22
('A', 23), -- Correct answer for question 23
('B', 24), -- Correct answer for question 24
('A', 25), -- Correct answer for question 25
('B', 26), -- Correct answer for question 26
('C', 27), -- Correct answer for question 27
('A', 28), -- Correct answer for question 28
('B', 29), -- Correct answer for question 29
('C', 30), -- Correct answer for question 30
('B', 31), ('B', 32), ('D', 33), ('A', 34), ('B', 35),
('B', 36), ('D', 37), ('B', 38), ('C', 39), ('A', 40),
('A', 41), ('B', 42), ('A', 43), ('A', 44), ('B', 45),
('B', 46), ('A', 47), ('D', 48), ('C', 49), ('B', 50),
('C', 51), ('B', 52), ('C', 53), ('B', 54), ('B', 55),
('A', 56), ('A', 57), ('B', 58), ('C', 59), ('D', 60),
('B', 61),
('C', 62),
('D', 63),
('C', 64),
('B', 65),
('D', 66),
('A', 67),
('A', 68),
('B', 69),
('C', 70),
('C', 71),
('A', 72),
('D', 73),
('C', 74),
('B', 75),
('A', 76),
('C', 77),
('B', 78),
('A', 79),
('A', 80),
('C', 81),
('B', 82),
('A', 83),
('D', 84),
('B', 85),
('D', 86),
('A', 87),
('A', 88),
('B', 89),
('B', 90),
('C', 91),  -- Q1: def
('B', 92),  -- Q2: 5
('B', 93),  -- Q3: variable_1
('C', 94),  -- Q4: str
('A', 95),  -- Q5: []
('B', 96),  -- Q6: 6
('B', 97),  -- Q7: **
('B', 98),  -- Q8: break
('B', 99),  -- Q9: None
('D', 100), -- Q10: Both try and except
('B', 101), -- Q11: Adds an element to the end
('C', 102), -- Q12: list
('A', 103), -- Q13: Hello World
('A', 104), -- Q14: lower()
('B', 105), -- Q15: #
('A', 106), -- Q16: class
('B', 107), -- Q17: 3
('B', 108), -- Q18: random
('B', 109), -- Q19: Removes and returns the last element
('A', 110), -- Q20: (1, 2, 3)
('B', 111), -- Q21: float
('D', 112), -- Q22: No keyword needed
('A', 113), -- Q23: Removes leading and trailing whitespace
('A', 114), -- Q24: input()
('B', 115), -- Q25: Does nothing (placeholder)
('B', 116), -- Q26: 2
('A', 117), -- Q27: for
('B', 118), -- Q28: Loads a module
('B', 119), -- Q29: index()
('B', 120), -- Q30: False
('B', 121), ('B', 122), ('A', 123), ('B', 124), ('B', 125), ('B', 126), ('A', 127), ('B', 128), ('C', 129), ('B', 130),
('C', 131), ('B', 132), ('A', 133), ('B', 134), ('A', 135), ('B', 136), ('A', 137), ('B', 138), ('B', 139), ('B', 140),
('A', 141), ('A', 142), ('B', 143), ('A', 144), ('C', 145), ('A', 146), ('B', 147), ('A', 148), ('A', 149), ('B', 150),
('B', 151), ('A', 152), ('A', 153), ('B', 154), ('B', 155), ('A', 156), ('B', 157), ('D', 158), ('A', 159), ('B', 160),
('B', 161), ('A', 162), ('A', 163), ('B', 164), ('A', 165), ('B', 166), ('C', 167), ('B', 168), ('A', 169), ('A', 170),
('B', 171), ('A', 172), ('D', 173), ('B', 174), ('A', 175), ('A', 176), ('A', 177), ('A', 178), ('A', 179), ('A', 180),
('D', 181), ('B', 182), ('B', 183), ('A', 184), ('B', 185), ('D', 186), ('B', 187), ('A', 188), ('B', 189), ('A', 190),
('C', 191), ('A', 192), ('A', 193), ('A', 194), ('A', 195), ('B', 196), ('A', 197), ('B', 198), ('B', 199), ('A', 200),
('B', 201), ('B', 202), ('B', 203), ('B', 204), ('B', 205), ('A', 206), ('A', 207), ('C', 208), ('B', 209), ('A', 210),
('B', 211), ('A', 212), ('B', 213), ('A', 214), ('A', 215), ('B', 216), ('A', 217), ('B', 218), ('C', 219), ('B', 220),
('D', 221), ('C', 222), ('A', 223), ('A', 224), ('A', 225), ('B', 226), ('C', 227), ('A', 228), ('A', 229), ('A', 230),
('A', 231), ('B', 232), ('B', 233), ('B', 234), ('A', 235), ('A', 236), ('A', 237), ('B', 238), ('D', 239), ('B', 240),
('B', 241), ('A', 242), ('B', 243), ('A', 244), ('A', 245), ('B', 246), ('A', 247), ('A', 248), ('A', 249), ('B', 250),
('D', 251), ('A', 252), ('A', 253), ('D', 254), ('A', 255), ('C', 256), ('A', 257), ('B', 258), ('A', 259), ('B', 260),
('B', 261), ('D', 262), ('B', 263), ('A', 264), ('B', 265), ('B', 266), ('B', 267), ('A', 268), ('B', 269), ('D', 270);