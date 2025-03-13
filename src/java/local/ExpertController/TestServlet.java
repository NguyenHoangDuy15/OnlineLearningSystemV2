package local.ExpertController;

import dal.TestDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Enumeration;

@WebServlet(name = "TestServlet", urlPatterns = {"/TestServlet"})
public class TestServlet extends HttpServlet {
    private final TestDAO testDAO = new TestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processTestSubmission(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processTestSubmission(request, response);
    }

    private void processTestSubmission(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        Enumeration<String> parameterNames = request.getParameterNames();
        boolean hasQuestions = false;

        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            if (paramName.startsWith("question")) {
                hasQuestions = true;
                break;
            }
        }

        if (!hasQuestions) {
            request.setAttribute("message", "Please add at least one question.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/test.jsp");
            dispatcher.forward(request, response);
            return;
        }

        int questionCounter = 1;
        boolean isSuccess = false;

        while (request.getParameter("question" + questionCounter) != null) {
            String questionContent = request.getParameter("question" + questionCounter);
            String correctOptionStr = request.getParameter("question" + questionCounter + "_correct");

            if (correctOptionStr == null) {
                request.setAttribute("message", "Please select a correct answer for each question.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/test.jsp");
                dispatcher.forward(request, response);
                return;
            }

            int correctOption = Integer.parseInt(correctOptionStr);
            String[] options = new String[4];
            int[] isCorrectArray = new int[4];

            int answerId = -1;
            boolean allOptionsValid = true;

            for (int i = 1; i <= 4; i++) {
                String optionContent = request.getParameter("question" + questionCounter + "_option" + i);
                if (optionContent != null && !optionContent.trim().isEmpty()) {
                    options[i - 1] = optionContent;
                    isCorrectArray[i - 1] = (i == correctOption) ? 1 : 0;
                    answerId = testDAO.addAnswer(optionContent, isCorrectArray[i - 1]); // Insert options using modified DAO method
                } else {
                    allOptionsValid = false;
                    break;
                }
            }

            if (allOptionsValid && answerId != -1) {
                // After collecting all options, add the question to the database
                testDAO.addQuestion(questionContent, options[0], options[1], options[2], options[3], answerId);
                isSuccess = true;
            } else {
                request.setAttribute("message", "Please fill in all options for each question.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/test.jsp");
                dispatcher.forward(request, response);
                return;
            }

            questionCounter++;
        }

        request.setAttribute("message", isSuccess ? "Submission successful!" : "Submission unsuccessful, please try again.");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/test.jsp");
        dispatcher.forward(request, response);
    }
}
