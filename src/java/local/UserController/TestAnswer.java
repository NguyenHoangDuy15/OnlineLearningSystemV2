package local.UserController;

import Model.Question;
import dal.TestDAO;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "TestAnswer", urlPatterns = {"/TestAnswer"})
public class TestAnswer extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String testIdParam = request.getParameter("testId");
            if (testIdParam == null || testIdParam.isEmpty()) {
                response.sendRedirect("jsp/Error.jsp");
                return;
            }

            int testID = Integer.parseInt(testIdParam);
            TestDAO testDao = new TestDAO();
            List<Question> questions = testDao.getQuestionsByTestId(testID);

            if (questions.isEmpty()) {
                response.sendRedirect("jsp/Error.jsp");
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("questions", questions);
            session.setAttribute("userAnswers", new HashMap<Integer, String>());
            session.setAttribute("uncertainQuestions", new HashMap<Integer, Boolean>());
            session.setAttribute("testId", testID);
            session.setAttribute("currentIndex", 0);
            request.getRequestDispatcher("jsp/Dotest.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("jsp/Error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        TestDAO testDao = new TestDAO();

        List<Question> questions = (List<Question>) session.getAttribute("questions");
        if (questions == null) {
            response.sendRedirect("jsp/Error.jsp");
            return;
        }

        // Lấy questionID từ form
        String questionIdParam = request.getParameter("questionID");
        if (questionIdParam == null || questionIdParam.trim().isEmpty()) {
            response.sendRedirect("jsp/Error.jsp");
            return;
        }
        int questionID = Integer.parseInt(questionIdParam);
        String selectedAnswer = request.getParameter("answer");

        // Lưu câu trả lời của người dùng
        Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
        if (userAnswers == null) {
            userAnswers = new HashMap<>();
        }
        if (selectedAnswer != null && !selectedAnswer.trim().isEmpty()) {
            userAnswers.put(questionID, selectedAnswer.trim());
        }
        session.setAttribute("userAnswers", userAnswers);

        // Xử lý đánh dấu câu hỏi chưa chắc chắn
        String markUncertain = request.getParameter("markUncertain");
        Map<Integer, Boolean> uncertainQuestions = (Map<Integer, Boolean>) session.getAttribute("uncertainQuestions");
        if (uncertainQuestions == null) {
            uncertainQuestions = new HashMap<>();
        }
        if (markUncertain != null && !markUncertain.trim().isEmpty()) {
            try {
                int markedQuestionId = Integer.parseInt(markUncertain);
                if (uncertainQuestions.containsKey(markedQuestionId)) {
                    uncertainQuestions.remove(markedQuestionId);
                } else {
                    uncertainQuestions.put(markedQuestionId, true);
                }
            } catch (NumberFormatException e) {
                // Log lỗi nếu cần
                System.err.println("Invalid markUncertain value: " + markUncertain);
            }
        }
        session.setAttribute("uncertainQuestions", uncertainQuestions);

        // Xác định currentIndex dựa trên questionID
        int currentIndex = 0;
        String navigateQuestionId = request.getParameter("navigate");
        if (navigateQuestionId != null && !navigateQuestionId.trim().isEmpty()) {
            try {
                int selectedQuestionId = Integer.parseInt(navigateQuestionId);
                for (int i = 0; i < questions.size(); i++) {
                    if (questions.get(i).getQuestionID() == selectedQuestionId) {
                        currentIndex = i;
                        break;
                    }
                }
            } catch (NumberFormatException e) {
                // Log lỗi nếu cần
                System.err.println("Invalid navigateQuestionId value: " + navigateQuestionId);
            }
        } else {
            for (int i = 0; i < questions.size(); i++) {
                if (questions.get(i).getQuestionID() == questionID) {
                    currentIndex = i;
                    break;
                }
            }
        }

        // Xử lý hành động submit
        String action = request.getParameter("action");
        if ("submit".equals(action)) {
            int userId = (int) session.getAttribute("userid");
            int testId = (int) session.getAttribute("testId");
            int courseId = (int) session.getAttribute("courseId");
            int historyId = testDao.insertHistory(userId, testId, courseId);
            session.setAttribute("historyId", historyId);

            for (Map.Entry<Integer, String> entry : userAnswers.entrySet()) {
                int index = 0;
                for (int i = 0; i < questions.size(); i++) {
                    if (questions.get(i).getQuestionID() == entry.getKey()) {
                        index = i + 1;
                        break;
                    }
                }
                testDao.insertUserAnswer(userId, testId, entry.getKey(), entry.getValue(), index, historyId);
            }

            testDao.updateCorrectAnswers(userId, testId, historyId);
            String correctCount = testDao.getTestResult(userId, testId, historyId);
            session.setAttribute("correctCount", correctCount);
            request.getRequestDispatcher("jsp/Result.jsp").forward(request, response);
            return;
        }

        session.setAttribute("currentIndex", currentIndex);
        request.getRequestDispatcher("jsp/Dotest.jsp").forward(request, response);
    }
}