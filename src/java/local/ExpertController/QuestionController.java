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
import java.util.List;

@WebServlet(name = "QuestionController", urlPatterns = {"/QuestionController"})
public class QuestionController extends HttpServlet {
    private TestEXDAO testDAO;

    @Override
    public void init() throws ServletException {
        testDAO = new TestEXDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String fullName = (String) session.getAttribute("Fullname");
            if (fullName == null) {
                response.sendRedirect("LoginServlet?error=Please login first");
                return;
            }

            String testIdStr = request.getParameter("testId");
            String courseIdStr = request.getParameter("courseId");
            int courseId;
            try {
                courseId = Integer.parseInt(courseIdStr);
            } catch (NumberFormatException e) {
                response.sendRedirect("NoticeServlet?error=Invalid course ID");
                return;
            }

            int testId;
            if (testIdStr == null || testIdStr.equals("-1")) {
                String testName = request.getParameter("testName");
                if (testName == null || testName.trim().isEmpty()) {
                    response.sendRedirect("NoticeServlet?error=Test name is required");
                    return;
                }
                try {
                    testId = testDAO.createTest(testName, fullName, courseId);
                    if (testId == -1) {
                        response.sendRedirect("NoticeServlet?error=Failed to create test");
                        return;
                    }
                } catch (Exception e) {
                    response.sendRedirect("NoticeServlet?error=Failed to create test: " + e.getMessage());
                    return;
                }
            } else {
                testId = Integer.parseInt(testIdStr);
            }

            int questionCount = 1;
            boolean hasQuestions = false;
            while (request.getParameter("question" + questionCount) != null) {
                hasQuestions = true;
                String questionContent = request.getParameter("question" + questionCount);
                String optionA = request.getParameter("optionA" + questionCount);
                String optionB = request.getParameter("optionB" + questionCount);
                String optionC = request.getParameter("optionC" + questionCount);
                String optionD = request.getParameter("optionD" + questionCount);
                String correctAnswer = request.getParameter("correct-answer-" + questionCount);

                System.out.println("Processing question " + questionCount);
                System.out.println("Question: " + questionContent + ", Correct: " + correctAnswer);

                int questionId = testDAO.addQuestion(questionContent, optionA, optionB, optionC, optionD, testId);
                if (questionId == -1) {
                    response.sendRedirect("NoticeServlet?error=Failed to add question " + questionCount);
                    return;
                }

                if (correctAnswer != null && !correctAnswer.isEmpty()) {
                    int answerId = testDAO.addAnswer(correctAnswer, questionId);
                    if (answerId == -1) {
                        response.sendRedirect("NoticeServlet?error=Failed to add correct answer for question " + questionCount);
                        return;
                    }
                } else {
                    response.sendRedirect("NoticeServlet?error=Correct answer not selected for question " + questionCount);
                    return;
                }

                questionCount++;
            }

            if (!hasQuestions) {
                response.sendRedirect("NoticeServlet?error=No questions provided");
                return;
            }

            response.sendRedirect("NoticeServlet?success=Test created successfully&testId=" + testId);
        } catch (NumberFormatException e) {
            response.sendRedirect("NoticeServlet?error=Invalid test ID");
            e.printStackTrace();
        } catch (Exception e) {
            response.sendRedirect("NoticeServlet?error=An error occurred: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("getQuestions".equals(action)) {
            try {
                int testId = Integer.parseInt(request.getParameter("testId"));
                // Lấy danh sách câu hỏi từ TestEXDAO
                List<QuestionEX> questions = testDAO.getQuestionsByTestId(testId);
                // Lấy thông tin bài kiểm tra để hiển thị tên
                TestEX test = testDAO.getTestById(testId);

                // Đặt dữ liệu vào request attribute
                request.setAttribute("questions", questions);
                request.setAttribute("test", test);
                request.setAttribute("showQuestions", true); // Cờ để hiển thị section questionList

                // Lấy lại danh sách bài kiểm tra để hiển thị (vì JSP cần dữ liệu này)
                HttpSession session = request.getSession();
                String fullName = (String) session.getAttribute("Fullname");
                List<TestEX> tests = testDAO.getTestsByCreatorFullName(fullName);
                request.setAttribute("tests", tests);

                // Chuyển tiếp đến JSP
                request.getRequestDispatcher("jsp/expertDashboard.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect("NoticeServlet?error=Invalid test ID");
            } catch (Exception e) {
                response.sendRedirect("NoticeServlet?error=An error occurred: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            response.sendRedirect("NoticeServlet");
        }
    }
}