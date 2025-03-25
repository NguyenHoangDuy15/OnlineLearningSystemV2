package local.ExpertController;

import Model.TestEX;
import Model.QuestionEX;
import dal.TestEXDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "QuestionController", urlPatterns = {"/QuestionController"})
public class QuestionController extends HttpServlet {
    private TestEXDAO testDAO;
    private static final Logger LOGGER = Logger.getLogger(QuestionController.class.getName());
    private static final int MAX_QUESTION_COUNT = 30; 

    @Override
    public void init() throws ServletException {
        testDAO = new TestEXDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseIdStr = request.getParameter("courseId");
        if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
            try {
                int courseId = Integer.parseInt(courseIdStr);
                request.setAttribute("courseId", courseId);
                request.setAttribute("questionCount", 1);
                request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid course ID");
                request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("ShowexpertServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String fullName = (String) session.getAttribute("Fullname");
            if (fullName == null) {
                request.setAttribute("error", "Please login first");
                request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                return;
            }

            String courseIdStr = request.getParameter("courseId");
            int courseId = Integer.parseInt(courseIdStr);
            String action = request.getParameter("action");
            int questionCount = Integer.parseInt(request.getParameter("questionCount"));
            if (questionCount > MAX_QUESTION_COUNT) {
                request.setAttribute("error", "Maximum number of questions (30) exceeded");
                request.setAttribute("courseId", courseId);
                request.setAttribute("questionCount", questionCount);
                request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                return;
            }

            String testName = request.getParameter("testName");
            String[] questions = new String[questionCount];
            String[] optionsA = new String[questionCount];
            String[] optionsB = new String[questionCount];
            String[] optionsC = new String[questionCount];
            String[] optionsD = new String[questionCount];
            String[] correctAnswers = new String[questionCount];

            for (int i = 0; i < questionCount; i++) {
                questions[i] = request.getParameter("questions[" + i + "]");
                optionsA[i] = request.getParameter("optionsA[" + i + "]");
                optionsB[i] = request.getParameter("optionsB[" + i + "]");
                optionsC[i] = request.getParameter("optionsC[" + i + "]");
                optionsD[i] = request.getParameter("optionsD[" + i + "]");
                correctAnswers[i] = request.getParameter("correctAnswers[" + i + "]");
            }

            if ("addQuestion".equals(action)) {
                if (questionCount >= MAX_QUESTION_COUNT) {
                    request.setAttribute("error", "Cannot add more questions. Maximum limit of 30 questions reached.");
                    request.setAttribute("courseId", courseId);
                    request.setAttribute("questionCount", questionCount);
                    request.setAttribute("testName", testName);
                    request.setAttribute("questions", questions);
                    request.setAttribute("optionsA", optionsA);
                    request.setAttribute("optionsB", optionsB);
                    request.setAttribute("optionsC", optionsC);
                    request.setAttribute("optionsD", optionsD);
                    request.setAttribute("correctAnswers", correctAnswers);
                    request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                    return;
                }

                request.setAttribute("courseId", courseId);
                request.setAttribute("questionCount", questionCount + 1);
                request.setAttribute("testName", testName);
                request.setAttribute("questions", questions);
                request.setAttribute("optionsA", optionsA);
                request.setAttribute("optionsB", optionsB);
                request.setAttribute("optionsC", optionsC);
                request.setAttribute("optionsD", optionsD);
                request.setAttribute("correctAnswers", correctAnswers);
                request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                return;
            }

            if ("deleteQuestion".equals(action)) {
                int deleteIndex = Integer.parseInt(request.getParameter("deleteIndex"));
                if (deleteIndex >= 0 && deleteIndex < questionCount && questionCount > 1) {
                    ArrayList<String> newQuestions = new ArrayList<>();
                    ArrayList<String> newOptionsA = new ArrayList<>();
                    ArrayList<String> newOptionsB = new ArrayList<>();
                    ArrayList<String> newOptionsC = new ArrayList<>();
                    ArrayList<String> newOptionsD = new ArrayList<>();
                    ArrayList<String> newCorrectAnswers = new ArrayList<>();

                    for (int i = 0; i < questionCount; i++) {
                        if (i != deleteIndex) {
                            newQuestions.add(questions[i]);
                            newOptionsA.add(optionsA[i]);
                            newOptionsB.add(optionsB[i]);
                            newOptionsC.add(optionsC[i]);
                            newOptionsD.add(optionsD[i]);
                            newCorrectAnswers.add(correctAnswers[i]);
                        }
                    }

                    request.setAttribute("courseId", courseId);
                    request.setAttribute("questionCount", questionCount - 1);
                    request.setAttribute("testName", testName);
                    request.setAttribute("questions", newQuestions.toArray(new String[0]));
                    request.setAttribute("optionsA", newOptionsA.toArray(new String[0]));
                    request.setAttribute("optionsB", newOptionsB.toArray(new String[0]));
                    request.setAttribute("optionsC", newOptionsC.toArray(new String[0]));
                    request.setAttribute("optionsD", newOptionsD.toArray(new String[0]));
                    request.setAttribute("correctAnswers", newCorrectAnswers.toArray(new String[0]));
                    request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                } else {
                    request.setAttribute("courseId", courseId);
                    request.setAttribute("questionCount", questionCount);
                    request.setAttribute("testName", testName);
                    request.setAttribute("questions", questions);
                    request.setAttribute("optionsA", optionsA);
                    request.setAttribute("optionsB", optionsB);
                    request.setAttribute("optionsC", optionsC);
                    request.setAttribute("optionsD", optionsD);
                    request.setAttribute("correctAnswers", correctAnswers);
                    request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                }
                return;
            }

            if ("submit".equals(action)) {
                if (testName == null || testName.trim().isEmpty()) {
                    request.setAttribute("error", "Test name is required");
                    request.setAttribute("courseId", courseId);
                    request.setAttribute("questionCount", questionCount);
                    request.setAttribute("testName", testName);
                    request.setAttribute("questions", questions);
                    request.setAttribute("optionsA", optionsA);
                    request.setAttribute("optionsB", optionsB);
                    request.setAttribute("optionsC", optionsC);
                    request.setAttribute("optionsD", optionsD);
                    request.setAttribute("correctAnswers", correctAnswers);
                    request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                    return;
                }
                for (int i = 0; i < questionCount; i++) {
                    String questionContent = questions[i];
                    String optionA = optionsA[i];
                    String optionB = optionsB[i];
                    String optionC = optionsC[i];
                    String optionD = optionsD[i];
                    String correctAnswer = correctAnswers[i];
                    if (questionContent == null || questionContent.trim().isEmpty()) {
                        request.setAttribute("error", "Question content must be filled for question " + (i + 1));
                        request.setAttribute("courseId", courseId);
                        request.setAttribute("questionCount", questionCount);
                        request.setAttribute("testName", testName);
                        request.setAttribute("questions", questions);
                        request.setAttribute("optionsA", optionsA);
                        request.setAttribute("optionsB", optionsB);
                        request.setAttribute("optionsC", optionsC);
                        request.setAttribute("optionsD", optionsD);
                        request.setAttribute("correctAnswers", correctAnswers);
                        request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                        return;
                    }
                    if (optionA == null || optionA.trim().isEmpty()) {
                        request.setAttribute("error", "Option A must be filled for question " + (i + 1));
                        request.setAttribute("courseId", courseId);
                        request.setAttribute("questionCount", questionCount);
                        request.setAttribute("testName", testName);
                        request.setAttribute("questions", questions);
                        request.setAttribute("optionsA", optionsA);
                        request.setAttribute("optionsB", optionsB);
                        request.setAttribute("optionsC", optionsC);
                        request.setAttribute("optionsD", optionsD);
                        request.setAttribute("correctAnswers", correctAnswers);
                        request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                        return;
                    }
                    if (optionB == null || optionB.trim().isEmpty()) {
                        request.setAttribute("error", "Option B must be filled for question " + (i + 1));
                        request.setAttribute("courseId", courseId);
                        request.setAttribute("questionCount", questionCount);
                        request.setAttribute("testName", testName);
                        request.setAttribute("questions", questions);
                        request.setAttribute("optionsA", optionsA);
                        request.setAttribute("optionsB", optionsB);
                        request.setAttribute("optionsC", optionsC);
                        request.setAttribute("optionsD", optionsD);
                        request.setAttribute("correctAnswers", correctAnswers);
                        request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                        return;
                    }
                    if (optionC == null || optionC.trim().isEmpty()) {
                        request.setAttribute("error", "Option C must be filled for question " + (i + 1));
                        request.setAttribute("courseId", courseId);
                        request.setAttribute("questionCount", questionCount);
                        request.setAttribute("testName", testName);
                        request.setAttribute("questions", questions);
                        request.setAttribute("optionsA", optionsA);
                        request.setAttribute("optionsB", optionsB);
                        request.setAttribute("optionsC", optionsC);
                        request.setAttribute("optionsD", optionsD);
                        request.setAttribute("correctAnswers", correctAnswers);
                        request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                        return;
                    }
                    if (optionD == null || optionD.trim().isEmpty()) {
                        request.setAttribute("error", "Option D must be filled for question " + (i + 1));
                        request.setAttribute("courseId", courseId);
                        request.setAttribute("questionCount", questionCount);
                        request.setAttribute("testName", testName);
                        request.setAttribute("questions", questions);
                        request.setAttribute("optionsA", optionsA);
                        request.setAttribute("optionsB", optionsB);
                        request.setAttribute("optionsC", optionsC);
                        request.setAttribute("optionsD", optionsD);
                        request.setAttribute("correctAnswers", correctAnswers);
                        request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                        return;
                    }
                    if (correctAnswer == null || correctAnswer.trim().isEmpty() || !("A".equals(correctAnswer) || "B".equals(correctAnswer) || "C".equals(correctAnswer) || "D".equals(correctAnswer))) {
                        request.setAttribute("error", "Correct answer must be selected (A, B, C, or D) for question " + (i + 1));
                        request.setAttribute("courseId", courseId);
                        request.setAttribute("questionCount", questionCount);
                        request.setAttribute("testName", testName);
                        request.setAttribute("questions", questions);
                        request.setAttribute("optionsA", optionsA);
                        request.setAttribute("optionsB", optionsB);
                        request.setAttribute("optionsC", optionsC);
                        request.setAttribute("optionsD", optionsD);
                        request.setAttribute("correctAnswers", correctAnswers);
                        request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                        return;
                    }
                }

                int testId = testDAO.createTest(testName, fullName, courseId);
                if (testId == -1) {
                    request.setAttribute("error", "Failed to create test");
                    request.setAttribute("courseId", courseId);
                    request.setAttribute("questionCount", questionCount);
                    request.setAttribute("testName", testName);
                    request.setAttribute("questions", questions);
                    request.setAttribute("optionsA", optionsA);
                    request.setAttribute("optionsB", optionsB);
                    request.setAttribute("optionsC", optionsC);
                    request.setAttribute("optionsD", optionsD);
                    request.setAttribute("correctAnswers", correctAnswers);
                    request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                    return;
                }

                boolean allSuccess = true;
                for (int i = 0; i < questionCount; i++) {
                    String questionContent = questions[i];
                    String optionA = optionsA[i];
                    String optionB = optionsB[i];
                    String optionC = optionsC[i];
                    String optionD = optionsD[i];
                    String correctAnswer = correctAnswers[i];

                    int questionId = testDAO.addQuestion(questionContent, optionA, optionB, optionC, optionD, testId);
                    if (questionId == -1) {
                        request.setAttribute("error", "Failed to add question " + (i + 1));
                        request.setAttribute("courseId", courseId);
                        request.setAttribute("questionCount", questionCount);
                        request.setAttribute("testName", testName);
                        request.setAttribute("questions", questions);
                        request.setAttribute("optionsA", optionsA);
                        request.setAttribute("optionsB", optionsB);
                        request.setAttribute("optionsC", optionsC);
                        request.setAttribute("optionsD", optionsD);
                        request.setAttribute("correctAnswers", correctAnswers);
                        request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                        return;
                    }

                    int answerId = testDAO.addAnswer(correctAnswer, questionId);
                    if (answerId == -1) {
                        allSuccess = false;
                        break;
                    }
                }

                if (allSuccess) {
                    request.setAttribute("success", "Test created successfully");
                    request.setAttribute("courseId", courseId);
                    request.setAttribute("questionCount", 1);
                    request.setAttribute("testName", "");
                    request.setAttribute("questions", new String[]{});
                    request.setAttribute("optionsA", new String[]{});
                    request.setAttribute("optionsB", new String[]{});
                    request.setAttribute("optionsC", new String[]{});
                    request.setAttribute("optionsD", new String[]{});
                    request.setAttribute("correctAnswers", new String[]{});
                } else {
                    request.setAttribute("error", "Test created failed");
                    request.setAttribute("courseId", courseId);
                    request.setAttribute("questionCount", questionCount);
                    request.setAttribute("testName", testName);
                    request.setAttribute("questions", questions);
                    request.setAttribute("optionsA", optionsA);
                    request.setAttribute("optionsB", optionsB);
                    request.setAttribute("optionsC", optionsC);
                    request.setAttribute("optionsD", optionsD);
                    request.setAttribute("correctAnswers", correctAnswers);
                }
                request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing request: {0}", e.getMessage());
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.setAttribute("courseId", Integer.parseInt(request.getParameter("courseId")));
            request.setAttribute("questionCount", Integer.parseInt(request.getParameter("questionCount")));
            request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
        }
    }
}