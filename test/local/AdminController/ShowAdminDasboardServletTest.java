/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package local.AdminController;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.AdminDao;
import dal.BlogDAO;
import dal.CourseDao;
import dal.FeedbackDao;
import dal.UserDAO;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import Model.*;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

/**
 *
 * @author CONG NINH
 */
public class ShowAdminDasboardServletTest {
    
    private ShowAdminDasboardServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private UserDAO userDAO;
    private BlogDAO blogDAO;
    private FeedbackDao feedbackDAO;
    private AdminDao adminDAO;
    private CourseDao courseDAO;
    private RequestDispatcher requestDispatcher;
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
        servlet = new ShowAdminDasboardServlet();
        
        // Mock objects
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
        userDAO = mock(UserDAO.class);
        blogDAO = mock(BlogDAO.class);
        feedbackDAO = mock(FeedbackDao.class);
        adminDAO = mock(AdminDao.class);
        courseDAO = mock(CourseDao.class);
        requestDispatcher = mock(RequestDispatcher.class);
        
        // Setup basic behavior
        when(request.getSession()).thenReturn(session);
        when(request.getRequestDispatcher("jsp/dashboard.jsp")).thenReturn(requestDispatcher);
    }

    @Test
    public void testDoGet_SuccessfulDashboardLoad() throws Exception {
        // Arrange
        List<CoursePrint> courses = new ArrayList<>();
        courses.add(new CoursePrint()); // Add dummy course
        List<Blog> blogs = new ArrayList<>();
        blogs.add(new Blog()); // Add dummy blog
        List<User> experts = new ArrayList<>();
        experts.add(new User()); // Add dummy expert
        List<User> sales = new ArrayList<>();
        sales.add(new User()); // Add dummy sale
        List<Feedback> feedbacks = new ArrayList<>();
        feedbacks.add(new Feedback()); // Add dummy feedback
        List<RequestPrint> requests = new ArrayList<>();
        requests.add(new RequestPrint()); // Add dummy request
        List<User> users = new ArrayList<>();
        users.add(new User());
        users.add(new User()); // Add 2 users
        List<MoneyHistoryByAdmin> moneyHistory = new ArrayList<>();
        MoneyHistoryByAdmin money = new MoneyHistoryByAdmin();
        money.setStatus(1);
        money.setPrice(100.0f);
        moneyHistory.add(money);
        List<CoursePrint> courseRequests = new ArrayList<>();
        courseRequests.add(new CoursePrint());

        // Mock DAO responses
        when(courseDAO.getAllCourseForAdmin()).thenReturn(courses);
        when(blogDAO.getAllBlogs()).thenReturn(blogs);
        when(userDAO.getAllExpert()).thenReturn(experts);
        when(userDAO.getAllSale()).thenReturn(sales);
        when(feedbackDAO.getAllFeedback()).thenReturn(feedbacks);
        when(adminDAO.getAllRequest()).thenReturn(requests);
        when(userDAO.getAll()).thenReturn(users);
        when(adminDAO.getAllHistory()).thenReturn(moneyHistory);
        when(courseDAO.getAllCourseRequestForAdmin()).thenReturn(courseRequests);

        // Act
        servlet.doGet(request, response);

        // Assert
        verify(session).setAttribute("numberOfCourse", 1);
        verify(session).setAttribute("numberOfBlog", 1);
        verify(session).setAttribute("numberOfExpert", 1);
        verify(session).setAttribute("numberOfSale", 1);
        verify(session).setAttribute("numberOfFeedback", 1);
        verify(session).setAttribute("numberOfRequest", 1);
        verify(session).setAttribute("numberOfCourseRequest", 1);
        verify(session).setAttribute("numberOfUsers", 1); // users.size() - 1
        verify(session).setAttribute("TotalMoney", 100.0f);
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_EmptyLists() throws Exception {
        // Arrange
        when(courseDAO.getAllCourseForAdmin()).thenReturn(new ArrayList<>());
        when(blogDAO.getAllBlogs()).thenReturn(new ArrayList<>());
        when(userDAO.getAllExpert()).thenReturn(new ArrayList<>());
        when(userDAO.getAllSale()).thenReturn(new ArrayList<>());
        when(feedbackDAO.getAllFeedback()).thenReturn(new ArrayList<>());
        when(adminDAO.getAllRequest()).thenReturn(new ArrayList<>());
        when(userDAO.getAll()).thenReturn(new ArrayList<>());
        when(adminDAO.getAllHistory()).thenReturn(new ArrayList<>());
        when(courseDAO.getAllCourseRequestForAdmin()).thenReturn(new ArrayList<>());

        // Act
        servlet.doGet(request, response);

        // Assert
        verify(session).setAttribute("numberOfCourse", 0);
        verify(session).setAttribute("numberOfBlog", 0);
        verify(session).setAttribute("numberOfExpert", 0);
        verify(session).setAttribute("numberOfSale", 0);
        verify(session).setAttribute("numberOfFeedback", 0);
        verify(session).setAttribute("numberOfRequest", 0);
        verify(session).setAttribute("numberOfCourseRequest", 0);
        verify(session).setAttribute("numberOfUsers", -1);
        verify(session).setAttribute("TotalMoney", 0.0f);
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testProcessRequest() throws Exception {
        // Arrange
        PrintWriter writer = mock(PrintWriter.class);
        when(response.getWriter()).thenReturn(writer);

        // Act
        servlet.processRequest(request, response);

        // Assert
        verify(response).setContentType("text/html;charset=UTF-8");
        verify(writer).println("<!DOCTYPE html>");
        // Add more verifications for HTML content as needed
    }

    @Test
    public void testGetServletInfo() {
        // Act
        String result = servlet.getServletInfo();

        // Assert
        assertEquals("Short description", result);
    }
}