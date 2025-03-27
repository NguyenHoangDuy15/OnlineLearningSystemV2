package local.AdminController;

import Model.User;
import dal.UserDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.runner.RunWith;
import static org.mockito.Mockito.*;
import org.mockito.junit.MockitoJUnitRunner;
import util.MaHoa;
import util.Validator;

@RunWith(MockitoJUnitRunner.class)
public class AddNewUserServletTest {

    private HttpServletRequest request;
    private HttpServletResponse response;
    private RequestDispatcher requestDispatcher;
    private AddNewUserServlet servlet;

    @Before
    public void setUp() {
        servlet = new AddNewUserServlet();
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        requestDispatcher = mock(RequestDispatcher.class);

        when(request.getRequestDispatcher(anyString())).thenReturn(requestDispatcher);
        when(request.getContextPath()).thenReturn("/test-context");
    }

    @After
    public void tearDown() {
    }

    @Test
    public void testDoGet() throws Exception {
        servlet.doGet(request, response);
        verify(request).getRequestDispatcher("jsp/addNewUser.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_DuplicateUser() throws Exception {
        UserDAO userDAO = mock(UserDAO.class);
        when(request.getParameter("username")).thenReturn("existingUser");
        when(request.getParameter("password")).thenReturn("Password123!");
        when(request.getParameter("repassword")).thenReturn("Password123!");
        when(request.getParameter("name")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn("existing@example.com");
        when(request.getParameter("role")).thenReturn("1");

        List<User> users = new ArrayList<>();
        User existingUser = new User();
        existingUser.setUserName("existingUser");
        existingUser.setEmail("existing@example.com");
        users.add(existingUser);
        when(userDAO.getAll()).thenReturn(users);

        servlet.doPost(request, response);

        verify(request).setAttribute("err", "UserName or Gmail Dublicate");
        verify(request).setAttribute("username", "existingUser");
        verify(request).setAttribute("password", "Password123!");
        verify(request).setAttribute("repassword", "Password123!");
        verify(request).setAttribute("name", "John Doe");
        verify(request).setAttribute("email", "existing@example.com");
        verify(request).getRequestDispatcher("AddNewUserServlet");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_InvalidUsername() throws Exception {
        UserDAO userDAO = mock(UserDAO.class);
        when(request.getParameter("username")).thenReturn("bad user");
        when(request.getParameter("password")).thenReturn("Password123!");
        when(request.getParameter("repassword")).thenReturn("Password123!");
        when(request.getParameter("name")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn("john@example.com");
        when(request.getParameter("role")).thenReturn("1");

        when(userDAO.getAll()).thenReturn(new ArrayList<>());
        when(Validator.isValidUsername("bad user")).thenReturn(false);

        servlet.doPost(request, response);

        verify(request).setAttribute("err", "Invalid username! Must be 5-20 characters, no spaces, not starting with a number.");
        verify(request).setAttribute("username", "bad user");
        verify(request).setAttribute("password", "Password123!");
        verify(request).setAttribute("repassword", "Password123!");
        verify(request).setAttribute("name", "John Doe");
        verify(request).setAttribute("email", "john@example.com");
        verify(request).getRequestDispatcher("AddNewUserServlet");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_InvalidEmail() throws Exception {
        UserDAO userDAO = mock(UserDAO.class);
        when(request.getParameter("username")).thenReturn("newuser");
        when(request.getParameter("password")).thenReturn("Password123!");
        when(request.getParameter("repassword")).thenReturn("Password123!");
        when(request.getParameter("name")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn("invalid-email");
        when(request.getParameter("role")).thenReturn("1");

        when(userDAO.getAll()).thenReturn(new ArrayList<>());
        when(Validator.isValidUsername("newuser")).thenReturn(true);
        when(Validator.isValidEmail("invalid-email")).thenReturn(false);

        servlet.doPost(request, response);

        verify(request).setAttribute("err", "Invalid email format!");
        verify(request).setAttribute("username", "newuser");
        verify(request).setAttribute("password", "Password123!");
        verify(request).setAttribute("repassword", "Password123!");
        verify(request).setAttribute("name", "John Doe");
        verify(request).setAttribute("email", "invalid-email");
        verify(request).getRequestDispatcher("AddNewUserServlet");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_InvalidPassword() throws Exception {
        UserDAO userDAO = mock(UserDAO.class);
        when(request.getParameter("username")).thenReturn("newuser");
        when(request.getParameter("password")).thenReturn("weak");
        when(request.getParameter("repassword")).thenReturn("weak");
        when(request.getParameter("name")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn("john@example.com");
        when(request.getParameter("role")).thenReturn("1");

        when(userDAO.getAll()).thenReturn(new ArrayList<>());
        when(Validator.isValidUsername("newuser")).thenReturn(true);
        when(Validator.isValidEmail("john@example.com")).thenReturn(true);
        when(Validator.isValidPassword("weak")).thenReturn(false);

        servlet.doPost(request, response);

        verify(request).setAttribute("err", "Password must be at least 8 characters with 1 uppercase, 1 lowercase, 1 number, and 1 special character.");
        verify(request).setAttribute("username", "newuser");
        verify(request).setAttribute("password", "weak");
        verify(request).setAttribute("repassword", "weak");
        verify(request).setAttribute("name", "John Doe");
        verify(request).setAttribute("email", "john@example.com");
        verify(request).getRequestDispatcher("AddNewUserServlet");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_PasswordMismatch() throws Exception {
        UserDAO userDAO = mock(UserDAO.class);
        when(request.getParameter("username")).thenReturn("newuser");
        when(request.getParameter("password")).thenReturn("Password123!");
        when(request.getParameter("repassword")).thenReturn("Different123!");
        when(request.getParameter("name")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn("john@example.com");
        when(request.getParameter("role")).thenReturn("1");

        when(userDAO.getAll()).thenReturn(new ArrayList<>());
        when(Validator.isValidUsername("newuser")).thenReturn(true);
        when(Validator.isValidEmail("john@example.com")).thenReturn(true);
        when(Validator.isValidPassword("Password123!")).thenReturn(true);

        servlet.doPost(request, response);

        verify(request).setAttribute("err", "password or re-password invalid");
        verify(request).setAttribute("username", "newuser");
        verify(request).setAttribute("password", "Password123!");
        verify(request).setAttribute("repassword", "Different123!");
        verify(request).setAttribute("name", "John Doe");
        verify(request).setAttribute("email", "john@example.com");
        verify(request).getRequestDispatcher("AddNewUserServlet");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_Success() throws Exception {
        // Sử dụng timestamp để tạo username và email duy nhất
        String timestamp = String.valueOf(System.currentTimeMillis());
        String uniqueUsername = "user" + timestamp;
        String uniqueEmail = "email" + timestamp + "@example.com";

        when(request.getParameter("username")).thenReturn(uniqueUsername);
        when(request.getParameter("password")).thenReturn("Password123!");
        when(request.getParameter("repassword")).thenReturn("Password123!");
        when(request.getParameter("name")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn(uniqueEmail);
        when(request.getParameter("role")).thenReturn("1");

        when(Validator.isValidUsername(uniqueUsername)).thenReturn(true);
        when(Validator.isValidEmail(uniqueEmail)).thenReturn(true);
        when(Validator.isValidPassword("Password123!")).thenReturn(true);
        when(MaHoa.toSHA1("Password123!")).thenReturn("hashedPassword");

        servlet.doPost(request, response);

        verify(response).sendRedirect("ShowAdminDasboardServlet");
    }

    @Test
    public void testGetuserById_UserFound() {
        List<User> users = new ArrayList<>();
        User user1 = new User();
        user1.setUserName("testuser");
        user1.setEmail("test@example.com");
        users.add(user1);

        User result = servlet.getuserById(users, "testuser", "wrong@example.com");

        assertNotNull(result);
        assertEquals("testuser", result.getUserName());
        assertEquals("test@example.com", result.getEmail());
    }

    @Test
    public void testGetuserById_UserNotFound() {
        List<User> users = new ArrayList<>();
        User user1 = new User();
        user1.setUserName("testuser");
        user1.setEmail("test@example.com");
        users.add(user1);

        User result = servlet.getuserById(users, "otheruser", "other@example.com");

        assertNull(result);
    }

    @Test
    public void testProcessRequest() throws Exception {
        PrintWriter writer = mock(PrintWriter.class);
        when(response.getWriter()).thenReturn(writer);

        servlet.processRequest(request, response);

        verify(response).setContentType("text/html;charset=UTF-8");
        verify(writer).println("<!DOCTYPE html>");
        verify(writer).println("<html>");
        verify(writer).println("<head>");
        verify(writer).println("<title>Servlet AddNewUserServlet</title>");
        verify(writer).println("</head>");
        verify(writer).println("<body>");
        verify(writer).println("<h1>Servlet AddNewUserServlet at /test-context</h1>");
        verify(writer).println("</body>");
        verify(writer).println("</html>");
    }

    @Test
    public void testGetServletInfo() {
        String result = servlet.getServletInfo();
        assertEquals("Short description", result);
    }
}