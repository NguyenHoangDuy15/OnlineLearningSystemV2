package local.ExpertController;

import dal.TestEXDAO;
import dal.QuestionEXDAO;
import dal.TestServlet;
import Model.TestEX;
import Model.QuestionEX;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.ArrayList;
import java.util.List;

import static org.mockito.Mockito.*;

public class TestServletTest {

    @InjectMocks
    private TestServlet testServlet;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private TestEXDAO testDAO;

    @Mock
    private QuestionEXDAO questionDAO;

    @Mock
    private RequestDispatcher requestDispatcher;

    @Before
    public void setUp() throws Exception {
        System.out.println("Setting up test environment...");
        try {
            MockitoAnnotations.openMocks(this);
        } catch (Exception e) {
            System.out.println("Failed to initialize mocks: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize mocks", e);
        }
        when(request.getSession()).thenReturn(session);
        when(request.getRequestDispatcher("jsp/error1.jsp")).thenReturn(requestDispatcher);
        when(request.getRequestDispatcher("jsp/editTest.jsp")).thenReturn(requestDispatcher);
        doNothing().when(requestDispatcher).forward(any(HttpServletRequest.class), any(HttpServletResponse.class));
        doNothing().when(response).sendRedirect(anyString());
        doNothing().when(session).setAttribute(anyString(), any());
        doNothing().when(session).removeAttribute(anyString());
        when(session.getAttribute(anyString())).thenReturn(null);
        System.out.println("Test environment setup complete.");
    }

    @Test
    public void testDoGet_InvalidTestId() throws Exception {
        System.out.println("Running testDoGet_InvalidTestId");
        when(request.getMethod()).thenReturn("GET");
        when(request.getParameter("testId")).thenReturn("invalid");

        testServlet.service(request, response);

        verify(request).setAttribute("error", "Invalid test ID");
        verify(requestDispatcher).forward(request, response);
        System.out.println("testDoGet_InvalidTestId passed");
    }

    @Test
    public void testDoGet_TestNotFound() throws Exception {
        System.out.println("Running testDoGet_TestNotFound");
        when(request.getMethod()).thenReturn("GET");
        when(request.getParameter("testId")).thenReturn("1");
        when(testDAO.getTestById(1)).thenReturn(null);

        testServlet.service(request, response);

        verify(request).setAttribute("error", "Test not found");
        verify(requestDispatcher).forward(request, response);
        System.out.println("testDoGet_TestNotFound passed");
    }

    @Test
    public void testDoGet_SuccessWithNoSessionQuestions() throws Exception {
        System.out.println("Running testDoGet_SuccessWithNoSessionQuestions");
        when(request.getMethod()).thenReturn("GET");
        when(request.getParameter("testId")).thenReturn("1");
        TestEX test = new TestEX();
        test.setTestID(1);
        when(testDAO.getTestById(1)).thenReturn(test);
        List<QuestionEX> questions = new ArrayList<>();
        when(questionDAO.getQuestionsByTestId(1)).thenReturn(questions);

        testServlet.service(request, response);

        verify(session).setAttribute("tempQuestions_1", questions);
        verify(request).setAttribute("test", test);
        verify(request).setAttribute("questions", questions);
        verify(requestDispatcher).forward(request, response);
        System.out.println("testDoGet_SuccessWithNoSessionQuestions passed");
    }

    @Test
    public void testDoGet_SuccessWithSessionQuestions() throws Exception {
        System.out.println("Running testDoGet_SuccessWithSessionQuestions");
        when(request.getMethod()).thenReturn("GET");
        when(request.getParameter("testId")).thenReturn("1");
        TestEX test = new TestEX();
        test.setTestID(1);
        when(testDAO.getTestById(1)).thenReturn(test);
        List<QuestionEX> sessionQuestions = new ArrayList<>();
        when(session.getAttribute("tempQuestions_1")).thenReturn(sessionQuestions);
        when(questionDAO.getQuestionsByTestId(1)).thenReturn(new ArrayList<>());

        testServlet.service(request, response);

        verify(request).setAttribute("test", test);
        verify(request).setAttribute("questions", sessionQuestions);
        verify(requestDispatcher).forward(request, response);
        System.out.println("testDoGet_SuccessWithSessionQuestions passed");
    }

    @Test
    public void testDoGet_WithSuccessParameter() throws Exception {
        System.out.println("Running testDoGet_WithSuccessParameter");
        when(request.getMethod()).thenReturn("GET");
        when(request.getParameter("testId")).thenReturn("1");
        when(request.getParameter("success")).thenReturn("Test updated successfully");
        TestEX test = new TestEX();
        test.setTestID(1);
        when(testDAO.getTestById(1)).thenReturn(test);
        List<QuestionEX> questions = new ArrayList<>();
        when(questionDAO.getQuestionsByTestId(1)).thenReturn(questions);

        testServlet.service(request, response);

        verify(request).setAttribute("success", "Test updated successfully");
        verify(request).setAttribute("test", test);
        verify(request).setAttribute("questions", questions);
        verify(requestDispatcher).forward(request, response);
        System.out.println("testDoGet_WithSuccessParameter passed");
    }

    @Test
    public void testDoPost_TestNotFound() throws Exception {
        System.out.println("Running testDoPost_TestNotFound");
        when(request.getMethod()).thenReturn("POST");
        when(request.getParameter("action")).thenReturn("updateTest");
        when(request.getParameter("testId")).thenReturn("1");
        when(testDAO.getTestById(1)).thenReturn(null);

        testServlet.service(request, response);

        verify(request).setAttribute("error", "Test not found");
        verify(requestDispatcher).forward(request, response);
        System.out.println("testDoPost_TestNotFound passed");
    }

    @Test
    public void testDoPost_UpdateTestSuccess() throws Exception {
        System.out.println("Running testDoPost_UpdateTestSuccess");
        when(request.getMethod()).thenReturn("POST");
        when(request.getParameter("action")).thenReturn("updateTest");
        when(request.getParameter("testId")).thenReturn("1");
        when(request.getParameter("testName")).thenReturn("Updated Test");
        when(request.getParameter("questionCount")).thenReturn("1");
        when(request.getParameterValues("question[]")).thenReturn(new String[]{"Question 1"});
        when(request.getParameterValues("optionA[]")).thenReturn(new String[]{"A"});
        when(request.getParameterValues("optionB[]")).thenReturn(new String[]{"B"});
        when(request.getParameterValues("optionC[]")).thenReturn(new String[]{"C"});
        when(request.getParameterValues("optionD[]")).thenReturn(new String[]{"D"});
        when(request.getParameterValues("questionId[]")).thenReturn(new String[]{"1"});
        when(request.getParameter("correctAnswer_0")).thenReturn("A");

        TestEX test = new TestEX();
        test.setTestID(1);
        test.setName("Old Test");
        when(testDAO.getTestById(1)).thenReturn(test);
        List<QuestionEX> questions = new ArrayList<>();
        QuestionEX question = new QuestionEX();
        question.setQuestionID(1);
        question.setTestID(1);
        questions.add(question);
        when(session.getAttribute("tempQuestions_1")).thenReturn(questions);
        when(questionDAO.getQuestionsByTestId(1)).thenReturn(new ArrayList<>());

        doNothing().when(testDAO).updateTest(any(TestEX.class));
        doNothing().when(questionDAO).updateQuestion(eq(1), anyString(), anyString(), anyString(), anyString(), anyString());
        doNothing().when(questionDAO).updateCorrectAnswer(eq(1), anyString());

        testServlet.service(request, response);

        verify(testDAO).updateTest(test);
        verify(questionDAO).updateQuestion(1, "Question 1", "A", "B", "C", "D");
        verify(questionDAO).updateCorrectAnswer(1, "A");
        verify(session).removeAttribute("tempQuestions_1");
        verify(response).sendRedirect("TestServlet?testId=1&success=Test updated successfully");
        System.out.println("testDoPost_UpdateTestSuccess passed");
    }

    @Test
    public void testDoPost_UpdateTestEmptyTestName() throws Exception {
        System.out.println("Running testDoPost_UpdateTestEmptyTestName");
        when(request.getMethod()).thenReturn("POST");
        when(request.getParameter("action")).thenReturn("updateTest");
        when(request.getParameter("testId")).thenReturn("1");
        when(request.getParameter("testName")).thenReturn("");
        when(request.getParameter("questionCount")).thenReturn("1");
        when(request.getParameterValues("question[]")).thenReturn(new String[]{"Question 1"});
        when(request.getParameterValues("optionA[]")).thenReturn(new String[]{"A"});
        when(request.getParameterValues("optionB[]")).thenReturn(new String[]{"B"});
        when(request.getParameterValues("optionC[]")).thenReturn(new String[]{"C"});
        when(request.getParameterValues("optionD[]")).thenReturn(new String[]{"D"});
        when(request.getParameterValues("questionId[]")).thenReturn(new String[]{"1"});
        when(request.getParameter("correctAnswer_0")).thenReturn("A");

        TestEX test = new TestEX();
        test.setTestID(1);
        when(testDAO.getTestById(1)).thenReturn(test);
        List<QuestionEX> questions = new ArrayList<>();
        when(session.getAttribute("tempQuestions_1")).thenReturn(questions);
        when(questionDAO.getQuestionsByTestId(1)).thenReturn(new ArrayList<>());

        testServlet.service(request, response);

        verify(request).setAttribute("error", "Error: Test name cannot be empty");
        verify(request).setAttribute("test", test);
        verify(request).setAttribute("questions", questions);
        verify(requestDispatcher).forward(request, response);
        System.out.println("testDoPost_UpdateTestEmptyTestName passed");
    }

    @Test
    public void testDoPost_UpdateTestNoQuestions() throws Exception {
        System.out.println("Running testDoPost_UpdateTestNoQuestions");
        when(request.getMethod()).thenReturn("POST");
        when(request.getParameter("action")).thenReturn("updateTest");
        when(request.getParameter("testId")).thenReturn("1");
        when(request.getParameter("testName")).thenReturn("Updated Test");
        when(request.getParameter("questionCount")).thenReturn("0");
        when(request.getParameterValues("question[]")).thenReturn(null);
        when(request.getParameterValues("optionA[]")).thenReturn(null);
        when(request.getParameterValues("optionB[]")).thenReturn(null);
        when(request.getParameterValues("optionC[]")).thenReturn(null);
        when(request.getParameterValues("optionD[]")).thenReturn(null);
        when(request.getParameterValues("questionId[]")).thenReturn(null);

        TestEX test = new TestEX();
        test.setTestID(1);
        when(testDAO.getTestById(1)).thenReturn(test);
        List<QuestionEX> questions = new ArrayList<>();
        when(session.getAttribute("tempQuestions_1")).thenReturn(questions);
        when(questionDAO.getQuestionsByTestId(1)).thenReturn(new ArrayList<>());

        testServlet.service(request, response);

        verify(request).setAttribute("error", "Error: At least one question must be provided");
        verify(request).setAttribute("test", test);
        verify(request).setAttribute("questions", questions);
        verify(requestDispatcher).forward(request, response);
        System.out.println("testDoPost_UpdateTestNoQuestions passed");
    }

    @Test
    public void testDoPost_AddQuestion() throws Exception {
        System.out.println("Running testDoPost_AddQuestion");
        when(request.getMethod()).thenReturn("POST");
        when(request.getParameter("action")).thenReturn("addQuestion");
        when(request.getParameter("testId")).thenReturn("1");
        when(request.getParameter("questionCount")).thenReturn("1");
        when(request.getParameterValues("question[]")).thenReturn(new String[]{"Question 1"});
        when(request.getParameterValues("optionA[]")).thenReturn(new String[]{"A"});
        when(request.getParameterValues("optionB[]")).thenReturn(new String[]{"B"});
        when(request.getParameterValues("optionC[]")).thenReturn(new String[]{"C"});
        when(request.getParameterValues("optionD[]")).thenReturn(new String[]{"D"});
        when(request.getParameterValues("questionId[]")).thenReturn(new String[]{"1"});
        when(request.getParameter("correctAnswer_0")).thenReturn("A");

        TestEX test = new TestEX();
        test.setTestID(1);
        when(testDAO.getTestById(1)).thenReturn(test);
        List<QuestionEX> questions = new ArrayList<>();
        when(session.getAttribute("tempQuestions_1")).thenReturn(questions);
        when(questionDAO.getQuestionsByTestId(1)).thenReturn(new ArrayList<>());

        testServlet.service(request, response);

        verify(session).setAttribute("tempQuestions_1", questions);
        verify(request).setAttribute("test", test);
        verify(request).setAttribute("questions", questions);
        verify(request).setAttribute("selectedCorrectAnswers", any(String[].class));
        verify(requestDispatcher).forward(request, response);
        System.out.println("testDoPost_AddQuestion passed");
    }

    @Test
    public void testDoPost_DeleteQuestionSuccess() throws Exception {
        System.out.println("Running testDoPost_DeleteQuestionSuccess");
        when(request.getMethod()).thenReturn("POST");
        when(request.getParameter("action")).thenReturn("deleteQuestion");
        when(request.getParameter("testId")).thenReturn("1");
        when(request.getParameter("questionCount")).thenReturn("1");
        when(request.getParameter("deleteIndex")).thenReturn("0");
        when(request.getParameter("correctAnswer_0")).thenReturn("A");

        TestEX test = new TestEX();
        test.setTestID(1);
        when(testDAO.getTestById(1)).thenReturn(test);
        List<QuestionEX> questions = new ArrayList<>();
        QuestionEX question = new QuestionEX();
        question.setQuestionID(1);
        question.setTestID(1);
        questions.add(question);
        when(session.getAttribute("tempQuestions_1")).thenReturn(questions);
        when(questionDAO.deactivateQuestion(1)).thenReturn(true);
        when(questionDAO.getQuestionsByTestId(1)).thenReturn(new ArrayList<>());

        testServlet.service(request, response);

        verify(questionDAO).deactivateQuestion(1);
        verify(session).setAttribute("tempQuestions_1", questions);
        verify(request).setAttribute("success", "Question removed successfully");
        verify(request).setAttribute("selectedCorrectAnswers", any(String[].class));
        verify(requestDispatcher).forward(request, response);
        System.out.println("testDoPost_DeleteQuestionSuccess passed");
    }

    @Test
    public void testDoPost_DeleteQuestionInvalidIndex() throws Exception {
        System.out.println("Running testDoPost_DeleteQuestionInvalidIndex");
        when(request.getMethod()).thenReturn("POST");
        when(request.getParameter("action")).thenReturn("deleteQuestion");
        when(request.getParameter("testId")).thenReturn("1");
        when(request.getParameter("questionCount")).thenReturn("1");
        when(request.getParameter("deleteIndex")).thenReturn("5");
        when(request.getParameter("correctAnswer_0")).thenReturn("A");

        TestEX test = new TestEX();
        test.setTestID(1);
        when(testDAO.getTestById(1)).thenReturn(test);
        List<QuestionEX> questions = new ArrayList<>();
        when(session.getAttribute("tempQuestions_1")).thenReturn(questions);
        when(questionDAO.getQuestionsByTestId(1)).thenReturn(new ArrayList<>());

        testServlet.service(request, response);

        verify(request).setAttribute("error", "Invalid question index to delete");
        verify(request).setAttribute("test", test);
        verify(request).setAttribute("questions", questions);
        verify(request).setAttribute("selectedCorrectAnswers", any(String[].class));
        verify(requestDispatcher).forward(request, response);
        System.out.println("testDoPost_DeleteQuestionInvalidIndex passed");
    }

    @Test
    public void testDoPost_UpdateTestInvalidCorrectAnswer() throws Exception {
        System.out.println("Running testDoPost_UpdateTestInvalidCorrectAnswer");
        when(request.getMethod()).thenReturn("POST");
        when(request.getParameter("action")).thenReturn("updateTest");
        when(request.getParameter("testId")).thenReturn("1");
        when(request.getParameter("testName")).thenReturn("Updated Test");
        when(request.getParameter("questionCount")).thenReturn("1");
        when(request.getParameterValues("question[]")).thenReturn(new String[]{"Question 1"});
        when(request.getParameterValues("optionA[]")).thenReturn(new String[]{"A"});
        when(request.getParameterValues("optionB[]")).thenReturn(new String[]{"B"});
        when(request.getParameterValues("optionC[]")).thenReturn(new String[]{"C"});
        when(request.getParameterValues("optionD[]")).thenReturn(new String[]{"D"});
        when(request.getParameterValues("questionId[]")).thenReturn(new String[]{"1"});
        when(request.getParameter("correctAnswer_0")).thenReturn("E");

        TestEX test = new TestEX();
        test.setTestID(1);
        when(testDAO.getTestById(1)).thenReturn(test);
        List<QuestionEX> questions = new ArrayList<>();
        when(session.getAttribute("tempQuestions_1")).thenReturn(questions);
        when(questionDAO.getQuestionsByTestId(1)).thenReturn(new ArrayList<>());

        testServlet.service(request, response);

        verify(request).setAttribute("error", "Error: Correct answer must be selected (A, B, C, or D) for question 1");
        verify(request).setAttribute("test", test);
        verify(request).setAttribute("questions", questions);
        verify(requestDispatcher).forward(request, response);
        System.out.println("testDoPost_UpdateTestInvalidCorrectAnswer passed");
    }
}