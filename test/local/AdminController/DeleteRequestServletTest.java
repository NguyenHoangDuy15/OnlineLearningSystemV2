package local.AdminController;

import dal.AdminDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.runner.RunWith;
import static org.mockito.Mockito.*;
import org.mockito.junit.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
public class DeleteRequestServletTest {

    private HttpServletRequest request;
    private HttpServletResponse response;
    private RequestDispatcher requestDispatcher;
    private DeleteRequestServlet servlet;

    @Before
    public void setUp() {
        servlet = new DeleteRequestServlet();
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
    public void testDoGet_WithValidRequestId() throws Exception {
        // Arrange
        when(request.getParameter("requestID")).thenReturn("1");

        // Act
        servlet.doGet(request, response);

        // Assert
        verify(request).getRequestDispatcher("ListOfRequestByAdminServlet");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_WithNullRequestId() throws Exception {
        // Arrange
        when(request.getParameter("requestID")).thenReturn(null);

        // Act
        servlet.doGet(request, response);

        // Assert
        verify(request).getRequestDispatcher("ListOfRequestByAdminServlet");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost() throws Exception {
        // Arrange
        PrintWriter writer = mock(PrintWriter.class);
        when(response.getWriter()).thenReturn(writer);

        // Act
        servlet.doPost(request, response);

        // Assert
        // Kiểm tra rằng doPost gọi processRequest, nên hành vi sẽ giống processRequest
        verify(response).setContentType("text/html;charset=UTF-8");
        verify(writer).println("<!DOCTYPE html>");
        verify(writer).println("<html>");
        verify(writer).println("<head>");
        verify(writer).println("<title>Servlet DeleteRequestServlet</title>");
        verify(writer).println("</head>");
        verify(writer).println("<body>");
        verify(writer).println("<h1>Servlet DeleteRequestServlet at /test-context</h1>");
        verify(writer).println("</body>");
        verify(writer).println("</html>");
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
        verify(writer).println("<html>");
        verify(writer).println("<head>");
        verify(writer).println("<title>Servlet DeleteRequestServlet</title>");
        verify(writer).println("</head>");
        verify(writer).println("<body>");
        verify(writer).println("<h1>Servlet DeleteRequestServlet at /test-context</h1>");
        verify(writer).println("</body>");
        verify(writer).println("</html>");
    }

    @Test
    public void testGetServletInfo() {
        // Act
        String result = servlet.getServletInfo();

        // Assert
        assertEquals("Short description", result);
    }
}