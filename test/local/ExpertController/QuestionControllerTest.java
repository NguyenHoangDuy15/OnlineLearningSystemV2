package local.ExpertController;

import dal.TestEXDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.mockito.Mockito.*;

/**
 * @author CONG NINH
 */
public class QuestionControllerTest {

    @InjectMocks
    private QuestionController questionController;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private TestEXDAO testDAO;

    @Mock
    private RequestDispatcher requestDispatcher;

    @Before
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        // Gán mock TestEXDAO trực tiếp để tránh NPE trong init()
        questionController = new QuestionController();
        try {
            questionController.init();
        } catch (ServletException e) {
            // Ignore for test setup
        }
        when(request.getSession()).thenReturn(session);
        when(request.getRequestDispatcher("jsp/CreateTest.jsp")).thenReturn(requestDispatcher);
    }

    @Test
    public void testInit() throws Exception {
        questionController.init();

    }

    @Test
    public void testDoGet_ValidCourseId() throws Exception {
        when(request.getParameter("courseId")).thenReturn("1");
        questionController.doGet(request, response);
        verify(request).setAttribute("courseId", 1);
        verify(request).setAttribute("questionCount", 1);
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_InvalidCourseId() throws Exception {
        when(request.getParameter("courseId")).thenReturn("invalid");
        questionController.doGet(request, response);
        verify(request).setAttribute("error", "Invalid course ID");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_NullCourseId() throws Exception {
        when(request.getParameter("courseId")).thenReturn(null);
        questionController.doGet(request, response);
        verify(response).sendRedirect("ShowexpertServlet");
    }

    @Test
    public void testDoPost_UserNotLoggedIn() throws Exception {
        when(session.getAttribute("Fullname")).thenReturn(null);
        when(request.getParameter("courseId")).thenReturn("1");
        questionController.doPost(request, response);
        verify(request).setAttribute("error", "Please login first");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_AddQuestion() throws Exception {
        when(session.getAttribute("Fullname")).thenReturn("Test User");
        when(request.getParameter("courseId")).thenReturn("1");
        when(request.getParameter("action")).thenReturn("addQuestion");
        when(request.getParameter("questionCount")).thenReturn("1");
        when(request.getParameter("testName")).thenReturn("Test 1");
        questionController.doPost(request, response);
        verify(request).setAttribute("courseId", 1);
        verify(request).setAttribute("questionCount", 2);
        verify(request).setAttribute("testName", "Test 1");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_DeleteQuestion() throws Exception {
        when(session.getAttribute("Fullname")).thenReturn("Test User");
        when(request.getParameter("courseId")).thenReturn("1");
        when(request.getParameter("action")).thenReturn("deleteQuestion");
        when(request.getParameter("questionCount")).thenReturn("2");
        when(request.getParameter("testName")).thenReturn("Test 1");
        when(request.getParameter("deleteIndex")).thenReturn("0");
        questionController.doPost(request, response);
        verify(request).setAttribute("courseId", 1);
        verify(request).setAttribute("questionCount", 1);
        verify(request).setAttribute("testName", "Test 1");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_SubmitSuccess() throws Exception {
        when(session.getAttribute("Fullname")).thenReturn("Test User");
        when(request.getParameter("courseId")).thenReturn("1");
        when(request.getParameter("action")).thenReturn("submit");
        when(request.getParameter("questionCount")).thenReturn("1");
        when(request.getParameter("testName")).thenReturn("Test 1");
        when(request.getParameterValues("questions[]")).thenReturn(new String[]{"Question 1"});
        when(request.getParameterValues("optionsA[]")).thenReturn(new String[]{"A"});
        when(request.getParameterValues("optionsB[]")).thenReturn(new String[]{"B"});
        when(request.getParameterValues("optionsC[]")).thenReturn(new String[]{"C"});
        when(request.getParameterValues("optionsD[]")).thenReturn(new String[]{"D"});
        when(request.getParameter("correctAnswers_0")).thenReturn("A");
        when(testDAO.createTest("Test 1", "Test User", 1)).thenReturn(1);
        when(testDAO.addQuestion("Question 1", "A", "B", "C", "D", 1)).thenReturn(1);
        when(testDAO.addAnswer("A", 1)).thenReturn(1);
        questionController.doPost(request, response);
        verify(request).setAttribute("success", "Test created successfully");
        verify(request).setAttribute("courseId", 1);
        verify(request).setAttribute("questionCount", 1);
        verify(session).removeAttribute("tempTestName_1");
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_SubmitEmptyTestName() throws Exception {
        when(session.getAttribute("Fullname")).thenReturn("Test User");
        when(request.getParameter("courseId")).thenReturn("1");
        when(request.getParameter("action")).thenReturn("submit");
        when(request.getParameter("questionCount")).thenReturn("1");
        when(request.getParameter("testName")).thenReturn("");
        questionController.doPost(request, response);
        verify(request).setAttribute("error", "Test name is required");
        verify(request).setAttribute("courseId", 1);
        verify(request).setAttribute("questionCount", 1);
        verify(requestDispatcher).forward(request, response);
    }
}