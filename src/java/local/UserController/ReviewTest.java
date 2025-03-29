/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import Model.UserAnswer;
import dal.TestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "ReviewTest", urlPatterns = {"/ReviewTest"})
public class ReviewTest extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userid");
        String testIdParam = request.getParameter("testId");
        String pageParam = request.getParameter("page");
        Integer courseId = (Integer) session.getAttribute("courseId");

        // Validate parameters
        if (userId == null || testIdParam == null || courseId == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        try {
            int testId = Integer.parseInt(testIdParam);
            int currentPage = pageParam != null ? Integer.parseInt(pageParam) : 1;
            final int QUESTIONS_PER_PAGE = 5;

            TestDAO testDAO = new TestDAO();

            // Get history ID
            Integer historyId = testDAO.getHistoryId(userId, testId, courseId);
            if (historyId == null) {
                request.setAttribute("errorMessage", "No test history found");
                request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
                return;
            }

            // Get user answers
            List<UserAnswer> userAnswers = testDAO.getUserAnswers(userId, testId, historyId);
            if (userAnswers.isEmpty()) {
                request.setAttribute("errorMessage", "No answers found for this test");
                request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
                return;
            }

            // Calculate score
            int correctAnswers = (int) userAnswers.stream()
                    .filter(UserAnswer::isIsCorrectAnswer)
                    .count();
            int totalQuestions = userAnswers.size();
            String score = String.format("%d/%d", correctAnswers, totalQuestions);

            // Pagination
            int totalPages = (int) Math.ceil((double) totalQuestions / QUESTIONS_PER_PAGE);
            int startIndex = (currentPage - 1) * QUESTIONS_PER_PAGE;
            int endIndex = Math.min(startIndex + QUESTIONS_PER_PAGE, totalQuestions);

            // Validate page number
            if (startIndex >= totalQuestions || currentPage < 1) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid page number");
                return;
            }

            List<UserAnswer> paginatedAnswers = userAnswers.subList(startIndex, endIndex);

            // Set request attributes
            request.setAttribute("userAnswers", paginatedAnswers);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("historyId", historyId);
            request.setAttribute("score", score);
            request.setAttribute("testId", testId);
            request.setAttribute("courseId", courseId);

            request.getRequestDispatcher("jsp/ReviewTest.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameter format");
        } catch (SQLException e) {
            throw new ServletException("Database error occurred", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
