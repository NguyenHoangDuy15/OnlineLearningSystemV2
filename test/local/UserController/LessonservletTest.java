package local.UserController;

import Model.Lesson;
import dal.LessonsDao;
import dal.TestDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.MockitoJUnitRunner;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class LessonservletTest {

    @InjectMocks
    private Lessonservlet lessonservlet;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private RequestDispatcher requestDispatcher;

    @Mock
    private LessonsDao lessonsDao;

    @Mock
    private TestDAO testDao;

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
        when(request.getContextPath()).thenReturn("/app");

        lessonservlet.processRequest(request, response);

        verify(response).setContentType("text/html;charset=UTF-8");
        String result = stringWriter.toString();
        assert(result.contains("<h1>Servlet Lessonservlet at /app</h1>"));
    }

    @Test
    public void testDoGetUserNotLoggedIn() throws Exception {
        when(session.getAttribute("userid")).thenReturn(null);

        lessonservlet.doGet(request, response);

        verify(response).sendRedirect("LogoutServlet");
        verify(requestDispatcher, never()).forward(any(), any());
    }

    @Test
    public void testDoGetMissingCourseId() throws Exception {
        when(session.getAttribute("userid")).thenReturn(1);
        when(request.getParameter("courseId")).thenReturn(null);

        lessonservlet.doGet(request, response);

        verify(response).sendRedirect("jsp/Error.jsp");
        verify(requestDispatcher, never()).forward(any(), any());
    }

    @Test
    public void testDoGetInvalidCourseId() throws Exception {
        when(session.getAttribute("userid")).thenReturn(1);
        when(request.getParameter("courseId")).thenReturn("invalid");

        lessonservlet.doGet(request, response);

        verify(response).sendRedirect("jsp/Error.jsp");
        verify(requestDispatcher, never()).forward(any(), any());
    }

    @Test
    public void testDoGetSuccessWithNoTest() throws Exception {
        int userId = 1;
        int courseId = 2;
        List<Lesson> lessons = new ArrayList<>();
        Lesson lesson = new Lesson("Lesson", 1, "Lesson Name", "Lesson Content");
        lessons.add(lesson);

        when(session.getAttribute("userid")).thenReturn(userId);
        when(request.getParameter("courseId")).thenReturn(String.valueOf(courseId));
        when(lessonsDao.getLessonsAndTests(courseId)).thenReturn(lessons);
        when(testDao.getLastTestId(userId, courseId)).thenReturn(null);

        lessonservlet.doGet(request, response);

        // Capture testStatuses để kiểm tra
        ArgumentCaptor<Map> testStatusesCaptor = ArgumentCaptor.forClass(Map.class);
        verify(session).setAttribute("courseId", courseId);
        verify(session).setAttribute("testId", null);
        verify(session).setAttribute("historyId", null);
        verify(request).setAttribute("lessonsAndTests", lessons);
        verify(request).setAttribute(eq("testStatuses"), testStatusesCaptor.capture());
        assertTrue("testStatuses should be an empty map", testStatusesCaptor.getValue().isEmpty());
        verify(request).getRequestDispatcher("jsp/lessons.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoGetSuccessWithTest() throws Exception {
        int userId = 1;
        int courseId = 2;
        int testId = 3;
        int historyId = 4;
        List<Lesson> lessons = new ArrayList<>();
        Lesson testLesson = new Lesson("Test", 1, "Test Name", null);
        lessons.add(testLesson);

        when(session.getAttribute("userid")).thenReturn(userId);
        when(request.getParameter("courseId")).thenReturn(String.valueOf(courseId));
        when(lessonsDao.getLessonsAndTests(courseId)).thenReturn(lessons);
        when(testDao.getLastTestId(userId, courseId)).thenReturn(testId);
        when(testDao.getHistoryId(userId, testId, courseId)).thenReturn(historyId);
        when(testDao.getTestStatus(historyId, courseId, 1, userId)).thenReturn(1);

        lessonservlet.doGet(request, response);

        // Capture testStatuses để kiểm tra
        ArgumentCaptor<Map> testStatusesCaptor = ArgumentCaptor.forClass(Map.class);
        verify(session).setAttribute("courseId", courseId);
        verify(session).setAttribute("testId", testId);
        verify(session).setAttribute("historyId", historyId);
        verify(request).setAttribute("lessonsAndTests", lessons);
        verify(request).setAttribute(eq("testStatuses"), testStatusesCaptor.capture());
        Map<Integer, Integer> capturedTestStatuses = testStatusesCaptor.getValue();
        assertEquals("testStatuses should have one entry", 1, capturedTestStatuses.size());
        assertEquals("testStatuses should map lesson ID 1 to status 1", Integer.valueOf(1), capturedTestStatuses.get(1));
        verify(request).getRequestDispatcher("jsp/lessons.jsp");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost() throws Exception {
        StringWriter stringWriter = new StringWriter();
        PrintWriter writer = new PrintWriter(stringWriter);
        when(response.getWriter()).thenReturn(writer);
        when(request.getContextPath()).thenReturn("/app");

        lessonservlet.doPost(request, response);

        verify(response).setContentType("text/html;charset=UTF-8");
        String result = stringWriter.toString();
        assert(result.contains("<h1>Servlet Lessonservlet at /app</h1>"));
    }

    @Test
    public void testGetServletInfo() {
        String result = lessonservlet.getServletInfo();
        assertEquals("Short description", result);
    }
}