/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import Model.Question;
import dal.TestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Administrator
 */
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
            response.sendRedirect("Error.jsp");
            return;
        }

        int questionID = Integer.parseInt(request.getParameter("questionID"));
        String selectedAnswer = request.getParameter("answer");

        // Lấy danh sách câu trả lời từ session
        Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
        if (userAnswers == null) {
            userAnswers = new HashMap<>();
        }

        // Lưu câu trả lời của người dùng
        userAnswers.put(questionID, selectedAnswer);
        session.setAttribute("userAnswers", userAnswers);

        // **Xác định currentIndex dựa vào vị trí của questionID trong danh sách questions**
        int currentIndex = 0;
        for (int i = 0; i < questions.size(); i++) {
            if (questions.get(i).getQuestionID() == questionID) {
                currentIndex = i;
                break;
            }
        }

        // Xử lý điều hướng giữa các câu hỏi
        String action = request.getParameter("action");
        if ("previous".equals(action) && currentIndex > 0) {
            currentIndex--;
        } else if ("next".equals(action) && currentIndex < questions.size() - 1) {
            currentIndex++;
        } else if ("submit".equals(action)) {
            int userId = (int) session.getAttribute("userid");
            int testId = (int) session.getAttribute("testId");
            int courseId = (int) session.getAttribute("courseId");
            int historyId = testDao.insertHistory(userId, testId, courseId);
            session.setAttribute("historyId", historyId);

            // Lưu toàn bộ câu trả lời vào database
            for (Map.Entry<Integer, String> entry : userAnswers.entrySet()) {
                int index = 0;
                for (int i = 0; i < questions.size(); i++) {
                    if (questions.get(i).getQuestionID() == entry.getKey()) {
                        index = i + 1; // currentIndex bắt đầu từ 1
                        break;
                    }
                }

                testDao.insertUserAnswer(userId, testId, entry.getKey(), entry.getValue(), index, historyId);
            }

            // Cập nhật số lượng câu đúng
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
