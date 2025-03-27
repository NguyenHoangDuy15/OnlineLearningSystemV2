package dal;

import Model.TestEX;
import Model.QuestionEX;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/TestServlet")
public class TestServlet extends HttpServlet {
    private TestEXDAO testDAO;
    private QuestionEXDAO questionDAO;

    @Override
    public void init() throws ServletException {
        testDAO = new TestEXDAO();
        questionDAO = new QuestionEXDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String testIdStr = request.getParameter("testId");
        int testId;
        HttpSession session = request.getSession();

        try {
            testId = Integer.parseInt(testIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid test ID");
            request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            return;
        }

        TestEX test = testDAO.getTestById(testId);
        if (test == null) {
            request.setAttribute("error", "Test not found");
            request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            return;
        }
        List<QuestionEX> questions = questionDAO.getQuestionsByTestId(testId);
        if (questions == null) {
            questions = new ArrayList<>();
        }
        List<QuestionEX> sessionQuestions = (List<QuestionEX>) session.getAttribute("tempQuestions_" + testId);
        if (sessionQuestions != null) {
            questions = sessionQuestions;
        } else {
            session.setAttribute("tempQuestions_" + testId, questions);
        }

        request.setAttribute("test", test);
        request.setAttribute("questions", questions);
        String success = request.getParameter("success");
        if (success != null) {
            request.setAttribute("success", success);
        }
        request.getRequestDispatcher("jsp/editTest.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        int testId = Integer.parseInt(request.getParameter("testId"));
        TestEX test = testDAO.getTestById(testId);

        if (test == null) {
            request.setAttribute("error", "Test not found");
            request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            return;
        }

        try {
            int questionCount = Integer.parseInt(request.getParameter("questionCount"));
            String[] questionContents = request.getParameterValues("question[]");
            String[] optionAs = request.getParameterValues("optionA[]");
            String[] optionBs = request.getParameterValues("optionB[]");
            String[] optionCs = request.getParameterValues("optionC[]");
            String[] optionDs = request.getParameterValues("optionD[]");
            String[] questionIds = request.getParameterValues("questionId[]");
            String[] selectedCorrectAnswers = new String[questionCount];
            for (int i = 0; i < questionCount; i++) {
                selectedCorrectAnswers[i] = request.getParameter("correctAnswer_" + i);
            }

            List<QuestionEX> questions = (List<QuestionEX>) session.getAttribute("tempQuestions_" + testId);
            if (questions == null) {
                questions = questionDAO.getQuestionsByTestId(testId);
                if (questions == null) {
                    questions = new ArrayList<>();
                }
            }
            questions.clear();
            for (int i = 0; i < questionCount; i++) {
                QuestionEX question = new QuestionEX();
                question.setQuestionID(questionIds[i].isEmpty() ? -1 : Integer.parseInt(questionIds[i]));
                question.setTestID(testId);
                question.setQuestionContent(questionContents[i]);
                question.setOptionA(optionAs[i]);
                question.setOptionB(optionBs[i]);
                question.setOptionC(optionCs[i]);
                question.setOptionD(optionDs[i]);
                questions.add(question);
            }
            session.setAttribute("tempQuestions_" + testId, questions);

            if ("updateTest".equals(action)) {
                String testName = request.getParameter("testName");

                if (testName == null || testName.trim().isEmpty()) {
                    throw new Exception("Test name cannot be empty");
                }

                if (questionContents == null || questionContents.length == 0) {
                    throw new Exception("At least one question must be provided");
                }

                for (int i = 0; i < questionCount; i++) {
                    String correctAnswer = request.getParameter("correctAnswer_" + i);
                    if (questionContents[i] == null || questionContents[i].trim().isEmpty()) {
                        throw new Exception("Question content must be filled for question " + (i + 1));
                    }
                    if (optionAs[i] == null || optionAs[i].trim().isEmpty()) {
                        throw new Exception("Option A must be filled for question " + (i + 1));
                    }
                    if (optionBs[i] == null || optionBs[i].trim().isEmpty()) {
                        throw new Exception("Option B must be filled for question " + (i + 1));
                    }
                    if (optionCs[i] == null || optionCs[i].trim().isEmpty()) {
                        throw new Exception("Option C must be filled for question " + (i + 1));
                    }
                    if (optionDs[i] == null || optionDs[i].trim().isEmpty()) {
                        throw new Exception("Option D must be filled for question " + (i + 1));
                    }
                    if (correctAnswer == null || correctAnswer.trim().isEmpty() || !correctAnswer.matches("^[A-D]$")) {
                        throw new Exception("Correct answer must be selected (A, B, C, or D) for question " + (i + 1));
                    }
                }
                test.setName(testName);
                testDAO.updateTest(test);

                List<Integer> submittedQuestionIds = new ArrayList<>();
                for (int i = 0; i < questionContents.length; i++) {
                    String questionIdStr = (questionIds != null && i < questionIds.length) ? questionIds[i] : "";
                    String correctAnswer = request.getParameter("correctAnswer_" + i);
                    if (!questionIdStr.isEmpty()) {
                        int questionId = Integer.parseInt(questionIdStr);
                        submittedQuestionIds.add(questionId);
                        questionDAO.updateQuestion(questionId, questionContents[i], optionAs[i], optionBs[i], optionCs[i], optionDs[i]);
                        questionDAO.updateCorrectAnswer(questionId, correctAnswer);
                    } else {
                        int newQuestionId = questionDAO.addQuestion(questionContents[i], optionAs[i], optionBs[i], optionCs[i], optionDs[i], testId);
                        if (newQuestionId == -1) {
                            throw new Exception("Failed to add new question " + (i + 1));
                        }
                        submittedQuestionIds.add(newQuestionId);
                        questionDAO.addCorrectAnswer(newQuestionId, correctAnswer);
                    }
                }
                session.removeAttribute("tempQuestions_" + testId);
                response.sendRedirect("TestServlet?testId=" + testId + "&success=Test updated successfully");
            } else if ("addQuestion".equals(action)) {
                if (questions.size() >= 30) {
                    request.setAttribute("error", "Cannot add more questions. Maximum limit of 30 questions reached.");
                    request.setAttribute("test", test);
                    request.setAttribute("questions", questions);
                    request.setAttribute("selectedCorrectAnswers", selectedCorrectAnswers);
                    request.getRequestDispatcher("jsp/editTest.jsp").forward(request, response);
                    return;
                }
                QuestionEX newQuestion = new QuestionEX();
                newQuestion.setTestID(testId);
                newQuestion.setQuestionID(-1);
                questions.add(newQuestion);
                session.setAttribute("tempQuestions_" + testId, questions);
                request.setAttribute("test", test);
                request.setAttribute("questions", questions);
                request.setAttribute("selectedCorrectAnswers", selectedCorrectAnswers); // Gửi lại các đáp án đã chọn
                request.getRequestDispatcher("jsp/editTest.jsp").forward(request, response);
            } else if ("deleteQuestion".equals(action)) {
                int deleteIndex = Integer.parseInt(request.getParameter("deleteIndex"));

                if (deleteIndex >= 0 && deleteIndex < questions.size()) {
                    QuestionEX questionToDelete = questions.get(deleteIndex);
                    if (questionToDelete.getQuestionID() != -1) {
                        if (!questionDAO.deactivateQuestion(questionToDelete.getQuestionID())) {
                            throw new Exception("Failed to remove question");
                        }
                    }
                    questions.remove(deleteIndex);
                    List<String> updatedCorrectAnswers = new ArrayList<>();
                    for (int i = 0; i < selectedCorrectAnswers.length; i++) {
                        if (i != deleteIndex) {
                            updatedCorrectAnswers.add(selectedCorrectAnswers[i]);
                        }
                    }
                    selectedCorrectAnswers = updatedCorrectAnswers.toArray(new String[0]);
                    session.setAttribute("tempQuestions_" + testId, questions);
                    request.setAttribute("success", "Question removed successfully");
                } else {
                    request.setAttribute("error", "Invalid question index to delete");
                }
                request.setAttribute("test", test);
                request.setAttribute("questions", questions);
                request.setAttribute("selectedCorrectAnswers", selectedCorrectAnswers);
                request.getRequestDispatcher("jsp/editTest.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            request.setAttribute("test", test);
            List<QuestionEX> questions = (List<QuestionEX>) session.getAttribute("tempQuestions_" + testId);
            if (questions == null) {
                questions = questionDAO.getQuestionsByTestId(testId);
            }
            request.setAttribute("questions", questions);
            request.getRequestDispatcher("jsp/editTest.jsp").forward(request, response);
        }
    }
}