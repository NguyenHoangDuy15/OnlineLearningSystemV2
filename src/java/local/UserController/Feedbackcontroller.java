/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import Model.User;
import dal.FeedbackDao;
import java.io.IOException;
import Model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.Date;

/**
 *
 * @author Administrator
 */
public class Feedbackcontroller extends HttpServlet {

  @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    HttpSession session = request.getSession();
    Integer userId = (Integer) session.getAttribute("userid");

    if (userId == null) {
        response.sendRedirect("jsp/login.jsp");
        return;
    }
    
    
    int courseId = Integer.parseInt(request.getParameter("courseId"));
    int rating = Integer.parseInt(request.getParameter("rating"));
    String comment = request.getParameter("comment");

    Feedback feedback = new Feedback(userId, courseId, rating, comment);

  
    FeedbackDao feedbackDAO = new FeedbackDao();

    boolean success = feedbackDAO.insertFeedback(feedback);

    if (success) {
        session.setAttribute("message", "Gửi phản hồi thành công!");
    } else {
        session.setAttribute("message", "Gửi phản hồi thất bại!");
    }
    
    response.sendRedirect("index");
}


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
