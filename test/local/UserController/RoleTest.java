package local.UserController;

import dal.RequestDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.MockitoJUnitRunner;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.SQLException;

import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class RoleTest {

    @InjectMocks
    private Role role;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private RequestDispatcher requestDispatcher;

    @Mock
    private RequestDAO requestDAO;

    @Before
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        when(request.getSession()).thenReturn(session);
        when(request.getRequestDispatcher(anyString())).thenReturn(requestDispatcher);
    }

    @Test
    public void testProcessRequest() throws Exception {
        StringWriter stringWriter = new StringWriter();
        PrintWriter writer = new PrintWriter(stringWriter);
        when(response.getWriter()).thenReturn(writer);

        role.processRequest(request, response);

        verify(response).setContentType("text/html;charset=UTF-8");
        String result = stringWriter.toString();
        assert(result.contains("<h1>Servlet Role at"));
    }

    @Test
    public void testDoGet() throws Exception {
        role.doGet(request, response);

        verify(request).getRequestDispatcher("jsp/Role.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPostUserNotLoggedIn() throws Exception {
        when(session.getAttribute("userid")).thenReturn(null);

        role.doPost(request, response);

        verify(response).sendRedirect("LoginServlet");
        verify(requestDispatcher, never()).forward(any(), any());
    }

    @Test
    public void testDoPostInvalidRoleId() throws Exception {
        when(session.getAttribute("userid")).thenReturn(1);
        when(request.getParameter("rollID")).thenReturn("invalid");

        role.doPost(request, response);

        verify(request).setAttribute("message", "Invalid role selected.");
        verify(request).setAttribute("selectedRole", null);
        verify(request).getRequestDispatcher("jsp/Role.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPostPendingRequest() throws Exception {
        when(session.getAttribute("userid")).thenReturn(1);
        when(request.getParameter("rollID")).thenReturn("2");
        when(requestDAO.getLatestRequestStatus(1, 2)).thenReturn(null);

        role.doPost(request, response);

        verify(requestDAO).getLatestRequestStatus(1, 2);
        verify(request).setAttribute("message", "You have a pending request. Please wait for Admin approval.");
        verify(request).setAttribute("selectedRole", 2);
        verify(request).getRequestDispatcher("jsp/Role.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPostApprovedRequest() throws Exception {
        when(session.getAttribute("userid")).thenReturn(1);
        when(request.getParameter("rollID")).thenReturn("2");
        when(requestDAO.getLatestRequestStatus(1, 2)).thenReturn(1);

        role.doPost(request, response);

        verify(requestDAO).getLatestRequestStatus(1, 2);
        verify(request).setAttribute("message", "Your request has already been approved. You cannot submit another request for this role.");
        verify(request).setAttribute("selectedRole", 2);
        verify(request).getRequestDispatcher("jsp/Role.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPostNewRequestSuccess() throws Exception {
        when(session.getAttribute("userid")).thenReturn(1);
        when(request.getParameter("rollID")).thenReturn("2");
        when(requestDAO.getLatestRequestStatus(1, 2)).thenReturn(0);
        when(requestDAO.insertRequest(1, 2)).thenReturn(true);

        role.doPost(request, response);

        verify(requestDAO).insertRequest(1, 2);
        verify(request).setAttribute("message", "Request submitted successfully! Please wait for Admin approval.");
        verify(request).setAttribute("selectedRole", 2);
        verify(request).getRequestDispatcher("jsp/Role.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPostSQLException() throws Exception {
        when(session.getAttribute("userid")).thenReturn(1);
        when(request.getParameter("rollID")).thenReturn("2");
        when(requestDAO.getLatestRequestStatus(1, 2)).thenThrow(new SQLException("Database error"));

        role.doPost(request, response);

        verify(request).setAttribute("message", "Error processing your request.");
        verify(request).setAttribute("selectedRole", 2);
        verify(request).getRequestDispatcher("jsp/Role.jsp");
        verify(requestDispatcher).forward(request, response);
    }
}