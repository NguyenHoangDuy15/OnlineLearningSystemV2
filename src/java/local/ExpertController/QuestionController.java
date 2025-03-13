package local.ExpertController;

import Model.Test;
import dal.TestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;

@WebServlet(name = "QuestionController", urlPatterns = {"/QuestionController"})
public class QuestionController extends HttpServlet {
    private TestDAO testDAO;

    QuestionController(TestDAO testDAO) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void init() throws ServletException {
        testDAO = new TestDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String fullName = (String) session.getAttribute("Fullname");
            if (fullName == null) {
                response.sendRedirect("login.jsp?error=Please login first");
                return;
            }

            String testIdStr = request.getParameter("testId");
            int testId;
            if (testIdStr == null || testIdStr.equals("-1")) {
                String testName = request.getParameter("testName"); // Lấy tên từ form
                if (testName == null || testName.trim().isEmpty()) {
                    response.sendRedirect("NoticeServlet?error=Test name is required");
                    return;
                }
                testId = testDAO.createTest(testName, fullName, 1); // Truyền testName vào createTest
                if (testId == -1) {
                    response.sendRedirect("NoticeServlet?error=Failed to create test");
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

                System.out.println("Processing question " + questionCount); // Debug
                System.out.println("Question: " + questionContent + ", Correct: " + correctAnswer); // Debug

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
            response.sendRedirect("NoticeServlet?error=An error occurred");
            e.printStackTrace();
        }
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("NoticeServlet");
    }
}