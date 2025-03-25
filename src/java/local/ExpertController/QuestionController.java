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
import java.util.List;
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
            String[] questions = request.getParameterValues("questions[]");
            String[] optionsA = request.getParameterValues("optionsA[]");
            String[] optionsB = request.getParameterValues("optionsB[]");
            String[] optionsC = request.getParameterValues("optionsC[]");
            String[] optionsD = request.getParameterValues("optionsD[]");
            String[] correctAnswers = new String[questionCount];

            // Lấy giá trị của radio button
            for (int i = 0; i < questionCount; i++) {
                correctAnswers[i] = request.getParameter("correctAnswers_" + i);
            }

            // Lưu dữ liệu vào session
            List<String> tempQuestions = new ArrayList<>();
            List<String> tempOptionsA = new ArrayList<>();
            List<String> tempOptionsB = new ArrayList<>();
            List<String> tempOptionsC = new ArrayList<>();
            List<String> tempOptionsD = new ArrayList<>();
            List<String> tempCorrectAnswers = new ArrayList<>();

            for (int i = 0; i < questionCount; i++) {
                tempQuestions.add(questions != null && i < questions.length ? questions[i] : "");
                tempOptionsA.add(optionsA != null && i < optionsA.length ? optionsA[i] : "");
                tempOptionsB.add(optionsB != null && i < optionsB.length ? optionsB[i] : "");
                tempOptionsC.add(optionsC != null && i < optionsC.length ? optionsC[i] : "");
                tempOptionsD.add(optionsD != null && i < optionsD.length ? optionsD[i] : "");
                tempCorrectAnswers.add(correctAnswers != null && i < correctAnswers.length ? correctAnswers[i] : "");
            }

            session.setAttribute("tempTestName_" + courseId, testName);
            session.setAttribute("tempQuestions_" + courseId, tempQuestions);
            session.setAttribute("tempOptionsA_" + courseId, tempOptionsA);
            session.setAttribute("tempOptionsB_" + courseId, tempOptionsB);
            session.setAttribute("tempOptionsC_" + courseId, tempOptionsC);
            session.setAttribute("tempOptionsD_" + courseId, tempOptionsD);
            session.setAttribute("tempCorrectAnswers_" + courseId, tempCorrectAnswers);

            if ("addQuestion".equals(action)) {
                if (questionCount >= MAX_QUESTION_COUNT) {
                    request.setAttribute("error", "Cannot add more questions. Maximum limit of 30 questions reached.");
                    request.setAttribute("courseId", courseId);
                    request.setAttribute("questionCount", questionCount);
                    request.setAttribute("testName", testName);
                    request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                    request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                    request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                    request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                    request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                    request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
                    request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                    return;
                }

                tempQuestions.add("");
                tempOptionsA.add("");
                tempOptionsB.add("");
                tempOptionsC.add("");
                tempOptionsD.add("");
                tempCorrectAnswers.add("");
                session.setAttribute("tempQuestions_" + courseId, tempQuestions);
                session.setAttribute("tempOptionsA_" + courseId, tempOptionsA);
                session.setAttribute("tempOptionsB_" + courseId, tempOptionsB);
                session.setAttribute("tempOptionsC_" + courseId, tempOptionsC);
                session.setAttribute("tempOptionsD_" + courseId, tempOptionsD);
                session.setAttribute("tempCorrectAnswers_" + courseId, tempCorrectAnswers);

                request.setAttribute("courseId", courseId);
                request.setAttribute("questionCount", questionCount + 1);
                request.setAttribute("testName", testName);
                request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
                request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                return;
            }

            if ("deleteQuestion".equals(action)) {
                int deleteIndex = Integer.parseInt(request.getParameter("deleteIndex"));
                if (deleteIndex >= 0 && deleteIndex < questionCount && questionCount > 1) {
                    tempQuestions.remove(deleteIndex);
                    tempOptionsA.remove(deleteIndex);
                    tempOptionsB.remove(deleteIndex);
                    tempOptionsC.remove(deleteIndex);
                    tempOptionsD.remove(deleteIndex);
                    tempCorrectAnswers.remove(deleteIndex);

                    session.setAttribute("tempQuestions_" + courseId, tempQuestions);
                    session.setAttribute("tempOptionsA_" + courseId, tempOptionsA);
                    session.setAttribute("tempOptionsB_" + courseId, tempOptionsB);
                    session.setAttribute("tempOptionsC_" + courseId, tempOptionsC);
                    session.setAttribute("tempOptionsD_" + courseId, tempOptionsD);
                    session.setAttribute("tempCorrectAnswers_" + courseId, tempCorrectAnswers);

                    request.setAttribute("courseId", courseId);
                    request.setAttribute("questionCount", questionCount - 1);
                    request.setAttribute("testName", testName);
                    request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                    request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                    request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                    request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                    request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                    request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
                    request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                } else {
                    request.setAttribute("courseId", courseId);
                    request.setAttribute("questionCount", questionCount);
                    request.setAttribute("testName", testName);
                    request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                    request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                    request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                    request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                    request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                    request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
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
                    request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                    request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                    request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                    request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                    request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                    request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
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
                        request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                        request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                        request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                        request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                        request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                        request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
                        request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                        return;
                    }
                    if (optionA == null || optionA.trim().isEmpty()) {
                        request.setAttribute("error", "Option A must be filled for question " + (i + 1));
                        request.setAttribute("courseId", courseId);
                        request.setAttribute("questionCount", questionCount);
                        request.setAttribute("testName", testName);
                        request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                        request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                        request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                        request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                        request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                        request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
                        request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                        return;
                    }
                    if (optionB == null || optionB.trim().isEmpty()) {
                        request.setAttribute("error", "Option B must be filled for question " + (i + 1));
                        request.setAttribute("courseId", courseId);
                        request.setAttribute("questionCount", questionCount);
                        request.setAttribute("testName", testName);
                        request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                        request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                        request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                        request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                        request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                        request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
                        request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                        return;
                    }
                    if (optionC == null || optionC.trim().isEmpty()) {
                        request.setAttribute("error", "Option C must be filled for question " + (i + 1));
                        request.setAttribute("courseId", courseId);
                        request.setAttribute("questionCount", questionCount);
                        request.setAttribute("testName", testName);
                        request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                        request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                        request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                        request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                        request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                        request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
                        request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                        return;
                    }
                    if (optionD == null || optionD.trim().isEmpty()) {
                        request.setAttribute("error", "Option D must be filled for question " + (i + 1));
                        request.setAttribute("courseId", courseId);
                        request.setAttribute("questionCount", questionCount);
                        request.setAttribute("testName", testName);
                        request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                        request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                        request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                        request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                        request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                        request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
                        request.getRequestDispatcher("jsp/CreateTest.jsp").forward(request, response);
                        return;
                    }
                    if (correctAnswer == null || correctAnswer.trim().isEmpty() || !("A".equals(correctAnswer) || "B".equals(correctAnswer) || "C".equals(correctAnswer) || "D".equals(correctAnswer))) {
                        request.setAttribute("error", "Correct answer must be selected (A, B, C, or D) for question " + (i + 1));
                        request.setAttribute("courseId", courseId);
                        request.setAttribute("questionCount", questionCount);
                        request.setAttribute("testName", testName);
                        request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                        request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                        request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                        request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                        request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                        request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
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
                    request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                    request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                    request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                    request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                    request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                    request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
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
                        request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                        request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                        request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                        request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                        request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                        request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
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
                    // Xóa dữ liệu tạm trong session sau khi submit thành công
                    session.removeAttribute("tempTestName_" + courseId);
                    session.removeAttribute("tempQuestions_" + courseId);
                    session.removeAttribute("tempOptionsA_" + courseId);
                    session.removeAttribute("tempOptionsB_" + courseId);
                    session.removeAttribute("tempOptionsC_" + courseId);
                    session.removeAttribute("tempOptionsD_" + courseId);
                    session.removeAttribute("tempCorrectAnswers_" + courseId);

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
                    request.setAttribute("questions", tempQuestions.toArray(new String[0]));
                    request.setAttribute("optionsA", tempOptionsA.toArray(new String[0]));
                    request.setAttribute("optionsB", tempOptionsB.toArray(new String[0]));
                    request.setAttribute("optionsC", tempOptionsC.toArray(new String[0]));
                    request.setAttribute("optionsD", tempOptionsD.toArray(new String[0]));
                    request.setAttribute("correctAnswers", tempCorrectAnswers.toArray(new String[0]));
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