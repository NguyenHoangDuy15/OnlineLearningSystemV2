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
CREATE TABLE ChatHistory (
    ChatID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    MessageContent nvarchar(max)  NOT NULL,
    Timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ChatType VARCHAR(10) NOT NULL DEFAULT 'User-AI' CHECK (ChatType = 'User-AI'),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
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
INSERT INTO Courses (Name, Description, Price, imageCources, UserID, CategoryID, CreatedAt,[Status]) VALUES 
-- Java Courses


(N'Java for Beginners', N'Java for Beginners is an ideal course for those new to Java programming. It covers fundamental concepts, including setting up the environment, variables, data types, loops, conditions, and object-oriented programming (OOP). You will learn how to create and use classes, objects, inheritance, polymorphism, and exception handling. The course also introduces Java Collections, database connectivity (JDBC), and web application development using JSP and Servlets. This is a valuable resource for building a strong foundation in Java and preparing for professional software development.', 150000,'https://s3-sgn09.fptcloud.com/codelearnstorage/Upload/Blog/lap-trinh-java-for-beginner-63739300179.8416.jpg', 2, 1, GETDATE(),4),
(N'Advanced Java Development', N'Advanced Java Development is designed for experienced Java programmers looking to deepen their skills. This course covers advanced topics such as multi-threading, concurrency, design patterns, and JVM internals. You will explore Java EE, including Servlets, JSP, Spring Framework, and RESTful APIs. Additionally, it introduces enterprise-level solutions like microservices, message queues, and security best practices. With hands-on projects and real-world scenarios, this course helps developers master Java for large-scale applications and professional software development.', 180000,'https://skilltechacademy.in/wp-content/uploads/2024/07/advanced-java-online-training-1024x585.jpeg' , 2, 1, GETDATE(),4),
(N'Java Spring Boot Web Development', N'Java Spring Boot Web Development is a comprehensive guide for building modern web applications using the Spring Boot framework. This course covers core Spring concepts such as dependency injection, MVC architecture, RESTful APIs, and database integration with JPA and Hibernate. You will also explore security mechanisms, authentication, and deployment strategies. With hands-on projects, you will learn how to create scalable, high-performance web applications while following industry best practices.', 200000,'https://www.adm.ee/wordpress/wp-content/uploads/2023/12/Spring-768x512.png', 2, 1, GETDATE(),4),



-- Python Courses
(N'Python Basics', N'Python Basics is an introductory guide to the fundamental concepts of Python programming. It covers essential topics such as variables, data types, loops, functions, and object-oriented programming. This course provides a hands-on approach to learning Python with practical examples and exercises. Whether you are a beginner or transitioning from another language, Python Basics will equip you with the foundational skills needed to start coding and developing applications efficiently.', 120000, 'https://miro.medium.com/v2/resize:fit:2000/1*Zipt5ex6sSVSkciwlJoG4Q.png', 2, 2, GETDATE(),4),
(N'Data Science with Python', N'Data Science with Python explores the power of Python for data analysis, visualization, and machine learning. This course covers essential libraries such as NumPy, Pandas, Matplotlib, and Scikit-learn, enabling learners to process, analyze, and interpret complex datasets. It includes practical examples and real-world applications to help build strong analytical skills. Whether you are a beginner or an experienced programmer, this course provides a solid foundation in data science using Python.', 190000, 'https://cdn.shopaccino.com/igmguru/products/data-science--with-python-igmguru_176161162_l.jpg?v=509', 2, 2, GETDATE(),4),
(N'Python for Web Development', N'Build Web Applications using Django and Flask Frameworks is a comprehensive course designed to help learners create dynamic and scalable web applications using Python. The course covers the fundamentals of both Django and Flask, including routing, database integration, authentication, and REST API development. With hands-on projects and real-world examples, participants will gain practical experience in building modern web applications efficiently. Whether you are a beginner or an experienced developer, this course provides essential skills for mastering Python web development.', 170000, 'https://media.geeksforgeeks.org/wp-content/cdn-uploads/20220826185259/Why-to-Use-Python-for-Web-Development.jpg', 2, 2, GETDATE(),4),

-- JavaScript Courses

(N'JavaScript Essentials', N'JavaScript Essentials is a fundamental course designed for beginners and aspiring web developers. This course covers core JavaScript concepts, including variables, data types, functions, loops, and event handling. Learners will also explore the Document Object Model (DOM), asynchronous programming, and API interactions. Through hands-on exercises and real-world examples, students will gain practical coding experience to build interactive and dynamic web applications. Whether you are starting from scratch or looking to enhance your JavaScript skills, this course provides a strong foundation for modern web development.', 110000, 'https://img-c.udemycdn.com/course/750x422/1468694_d595_2.jpg', 2, 3, GETDATE(),4),
(N'Frontend Development with JavaScript', N'Frontend Development with JavaScript is a comprehensive course designed to equip learners with essential skills for building dynamic and interactive web applications. This course covers key JavaScript concepts, including DOM manipulation, event handling, asynchronous programming, and API integration. Students will also explore modern frontend frameworks like React or Vue.js to create responsive user interfaces. Through hands-on projects, participants will gain practical experience in developing real-world web applications. Whether you are a beginner or looking to enhance your frontend skills, this course provides the foundation needed to become a proficient JavaScript developer.', 160000, 'https://media.geeksforgeeks.org/wp-content/uploads/20240703165023/Frontend-Development-(1).webp', 2, 3, GETDATE(),2),
(N'Backend Development with Node.js', N'Backend Development with Node.js is a hands-on course designed to teach developers how to build scalable and efficient server-side applications. This course covers fundamental Node.js concepts, including event-driven programming, asynchronous operations, and working with modules. Students will also learn how to create RESTful APIs using Express.js, interact with databases like MongoDB and PostgreSQL, and implement authentication and authorization. With practical projects and real-world examples, this course provides the necessary skills to develop modern, high-performance backend applications using Node.js.', 200000, 'https://media.geeksforgeeks.org/wp-content/cdn-uploads/20220517005132/Why-to-Use-NodeJS-for-Backend-Development.jpg', 2, 3, GETDATE(),2);
--Payment 
INSERT INTO Payment (UserID, CourseID, Amount) VALUES
(1, 1, 500.00),
(2, 2, 750.00),
(3, 3, 600.00),
(4, 1, 500.00),
(5, 2, 750.00);
-- Transaction History

INSERT INTO TransactionHistory (PayID, Status, CreatedAt, CourseID, PaymentDate) VALUES
(1, 1, '2024-03-01 10:15:30', 1, '2024-03-01 10:16:00'),
(2, 1, '2024-03-02 14:20:45', 2, '2024-03-02 14:21:00'),
(3, 0, '2024-03-03 09:30:15', 3, NULL),
(4, 1, '2024-03-04 16:45:50', 4, '2024-03-04 16:46:30'),
(5, 1, '2024-03-05 11:10:25', 5, '2024-03-05 11:11:00');


INSERT INTO Lessons (Title, Content, CourseID) VALUES 
('Java Programming for Beginner-Full-Course', 'https://www.youtube.com/watch?v=GoXwIVyNvX0', 1),
('Java 24 - Better Language, Better APIs, Better Runtime', 'https://www.youtube.com/watch?v=2NTyzL-9Bfo', 1),
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
     'https://niithanoi.edu.vn/pic/News/100-ngay-hoc-code.png', GETDATE(), 2);



-- Insert answers into the Answer table (only correct answers)

INSERT INTO [dbo].[Test] ([Name],  [CreatedBy],[CourseID]) 
VALUES ('Test 1','Hoang Cong Ninh', 1),
('Test 2','Hoang Cong Ninh', 2);
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
('multiple choice', 'What is Spring Boot primarily used for?', 'A. Front-end development', 'B. Simplifying Java-based web applications', 'C. Managing databases', 'D. Writing JavaScript code', 2),
('multiple choice', 'Which annotation is used to mark the main class in a Spring Boot application?', 'A. @SpringApplication', 'B. @SpringBootApplication', 'C. @SpringMain', 'D. @SpringConfig', 2),
('multiple choice', 'Which dependency is required for creating RESTful APIs in Spring Boot?', 'A. spring-boot-starter-web', 'B. spring-boot-starter-data-jpa', 'C. spring-boot-starter-security', 'D. spring-boot-starter-test', 2),
('multiple choice', 'What is the default embedded server in Spring Boot?', 'A. Tomcat', 'B. Jetty', 'C. Undertow', 'D. WildFly', 2),
('multiple choice', 'Which file is used to configure properties in a Spring Boot application?', 'A. application.properties', 'B. spring.xml', 'C. config.json', 'D. settings.yaml', 2),
('multiple choice', 'Which annotation is used to define a RESTful web service?', 'A. @RestService', 'B. @RestController', 'C. @WebService', 'D. @Controller', 2),
('multiple choice', 'Which command is used to run a Spring Boot application?', 'A. mvn spring-boot:run', 'B. java -jar app.jar', 'C. gradle bootRun', 'D. All of the above', 2),
('multiple choice', 'What does the @Autowired annotation do?', 'A. Handles HTTP requests', 'B. Enables automatic dependency injection', 'C. Creates database tables', 'D. Configures properties', 2),
('multiple choice', 'Which database is embedded by default in Spring Boot?', 'A. MySQL', 'B. PostgreSQL', 'C. H2', 'D. SQLite', 2),
('multiple choice', 'Which annotation is used to enable JPA repositories in Spring Boot?', 'A. @EnableJpaRepositories', 'B. @SpringData', 'C. @JpaConfig', 'D. @EnableORM', 2),
('multiple choice', 'What is Spring Boot DevTools used for?', 'A. Security enhancements', 'B. Database migrations', 'C. Automatic restart and live reload', 'D. Logging improvements', 2),
('multiple choice', 'Which annotation is used for exception handling at the controller level?', 'A. @ExceptionHandler', 'B. @HandleException', 'C. @RestException', 'D. @ErrorHandler', 2),
('multiple choice', 'What is the default port for a Spring Boot application?', 'A. 8080', 'B. 9090', 'C. 8000', 'D. 8888', 2),
('multiple choice', 'Which dependency is required for Spring Boot JPA?', 'A. spring-boot-starter-web', 'B. spring-boot-starter-jpa', 'C. spring-boot-starter-security', 'D. spring-boot-starter-test', 2),
('multiple choice', 'Which annotation is used to map HTTP GET requests?', 'A. @PostMapping', 'B. @PutMapping', 'C. @DeleteMapping', 'D. @GetMapping', 2),
('multiple choice', 'What is the purpose of the @Transactional annotation?', 'A. Manage transactions', 'B. Handle REST API calls', 'C. Define scheduled tasks', 'D. Enable logging', 2),
('multiple choice', 'Which annotation is used to define scheduled tasks?', 'A. @Schedule', 'B. @EnableScheduling', 'C. @Scheduled', 'D. @TaskScheduler', 2),
('multiple choice', 'What is Thymeleaf used for in Spring Boot?', 'A. Database management', 'B. Front-end templating', 'C. Dependency injection', 'D. Security', 2),
('multiple choice', 'Which class is used to make RESTful API calls in Spring Boot?', 'A. RestClient', 'B. HttpClient', 'C. WebClient', 'D. RestTemplate', 2),
('multiple choice', 'Which annotation is used for field-level validation in Spring Boot?', 'A. @NotNull', 'B. @Valid', 'C. @Validated', 'D. @Check', 2),
('multiple choice', 'Which annotation enables global exception handling?', 'A. @ExceptionHandler', 'B. @ControllerAdvice', 'C. @RestControllerAdvice', 'D. Both B and C', 2),
('multiple choice', 'What does Spring Boot Actuator provide?', 'A. Database migration tools', 'B. Security features', 'C. Monitoring and management endpoints', 'D. Logging mechanisms', 2),
('multiple choice', 'Which annotation is used to inject values from properties files?', 'A. @PropertySource', 'B. @Value', 'C. @Autowired', 'D. @ConfigurationProperties', 2),
('multiple choice', 'What is the purpose of the application.properties file?', 'A. Define business logic', 'B. Manage configurations', 'C. Create database connections', 'D. Compile Java code', 2),
('multiple choice', 'Which annotation is used to define a service layer in Spring Boot?', 'A. @Component', 'B. @Service', 'C. @Repository', 'D. @RestController', 2),
('multiple choice', 'What does the @SpringBootApplication annotation do?', 'A. Enables auto-configuration', 'B. Defines a main class', 'C. Enables component scanning', 'D. All of the above', 2),
('multiple choice', 'Which Spring Boot component manages dependency injection?', 'A. Bean Factory', 'B. ApplicationContext', 'C. Spring Container', 'D. Dependency Manager', 2),
('multiple choice', 'What is the purpose of the Spring Boot banner.txt file?', 'A. Configure logging', 'B. Customize the startup banner', 'C. Enable debugging mode', 'D. Manage security settings', 2),
('multiple choice', 'How do you change the default port in Spring Boot?', 'A. Modify application.properties', 'B. Change server.xml', 'C. Edit boot.config', 'D. Set an environment variable', 2),
('multiple choice', 'Which command is used to package a Spring Boot application as a JAR file?', 'A. mvn package', 'B. gradle build', 'C. java -jar', 'D. Both A and B', 2);


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
('A', 56), ('A', 57), ('B', 58), ('C', 59), ('D', 60);

select * from ChatHistory

select * from Roles

