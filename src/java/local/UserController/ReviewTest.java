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
import java.util.List;

/**
 *
 * @author Administrator
 */
@WebServlet(name="ReviewTest", urlPatterns={"/ReviewTest"})
public class ReviewTest extends HttpServlet {
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session = request.getSession();
    Integer userId = (Integer) session.getAttribute("userid");
    String historyIdParam = request.getParameter("historyId");
    String pageParam = request.getParameter("page");

    if (userId == null || historyIdParam == null) {
        response.sendRedirect("LoginServlet");
        return;
    }

    int historyId = Integer.parseInt(historyIdParam);
    int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
    int questionsPerPage = 5; // Số câu hỏi mỗi trang

    TestDAO userAnswerDAO = new TestDAO();
    List<UserAnswer> userAnswers = userAnswerDAO.getUserAnswersByHistoryId(userId, historyId);

    // Tính toán phân trang
    int totalQuestions = userAnswers.size();
    int totalPages = (int) Math.ceil((double) totalQuestions / questionsPerPage);
    int startIndex = (currentPage - 1) * questionsPerPage;
    int endIndex = Math.min(startIndex + questionsPerPage, totalQuestions);

    List<UserAnswer> paginatedUserAnswers = userAnswers.subList(startIndex, endIndex);

    request.setAttribute("userAnswers", paginatedUserAnswers);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("historyId", historyId);

    request.getRequestDispatcher("jsp/ReviewTest.jsp").forward(request, response);
}


    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
