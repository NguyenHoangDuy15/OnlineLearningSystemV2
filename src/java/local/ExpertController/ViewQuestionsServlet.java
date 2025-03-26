package local.ExpertController;

import Model.QuestionEX;
import Model.TestEX;
import dal.QuestionEXDAO;
import dal.TestEXDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/ViewQuestionsServlet")
public class ViewQuestionsServlet extends HttpServlet {
    private QuestionEXDAO questionDAO;
    private TestEXDAO testDAO;

    @Override
    public void init() throws ServletException {
        questionDAO = new QuestionEXDAO();
        testDAO = new TestEXDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            int testId = Integer.parseInt(request.getParameter("testId"));
            List<QuestionEX> questions = questionDAO.getQuestionsByTestId(testId);
            TestEX test = testDAO.getTestById(testId);

            request.setAttribute("questions", questions);
            request.setAttribute("test", test);

            request.getRequestDispatcher("jsp/viewQuestions.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while fetching questions: " + e.getMessage());
            request.getRequestDispatcher("jsp/expertDashboard.jsp").forward(request, response);
        }
    }
}