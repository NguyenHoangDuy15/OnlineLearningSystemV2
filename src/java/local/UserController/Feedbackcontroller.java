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
        String courseId = request.getParameter("courseId");
        if (courseId != null) {
            response.sendRedirect("detail?courseId=" + courseId);
        } else {
            response.sendRedirect("jsp/Error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userid");

        if (userId == null) {
            request.setAttribute("errorMessage", "You must be logged in to perform this action.");
            request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        FeedbackDao feedbackDao = new FeedbackDao();
        String courseIdParam = request.getParameter("courseId");
        int courseId;

        try {
            courseId = Integer.parseInt(courseIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid course ID.");
            request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
            return;
        }

        if ("add".equals(action)) {
            String ratingParam = request.getParameter("rating");
            String comment = request.getParameter("comment");

            try {
                int rating = Integer.parseInt(ratingParam);

                if (!feedbackDao.hasPurchasedCourse(userId, courseId)) {
                    request.setAttribute("errorMessage", "You must purchase the course to leave a comment.");
                    request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
                    return;
                }

                boolean added = feedbackDao.addFeedback(userId, courseId, rating, comment);
                if (added) {
                   response.sendRedirect("detail?courseId=" + courseId + "&commentAdded=true");
                } else {
                    request.setAttribute("errorMessage", "Failed to add the comment.");
                    request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid rating value.");
                request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            String feedbackIdParam = request.getParameter("feedbackId");
            String ratingParam = request.getParameter("rating");
            String comment = request.getParameter("comment");

            System.out.println("Update request: feedbackId=" + feedbackIdParam + ", rating=" + ratingParam + ", comment=" + comment);

            try {
                int feedbackId = Integer.parseInt(feedbackIdParam);
                int rating = Integer.parseInt(ratingParam);

                if (!feedbackDao.isFeedbackOwner(feedbackId, userId)) {
                    request.setAttribute("errorMessage", "You are not authorized to update this comment.");
                    request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
                    return;
                }

                boolean updated = feedbackDao.updateFeedback(feedbackId, rating, comment);
                System.out.println("Update result: " + updated);
                if (updated) {
                 response.sendRedirect("detail?courseId=" + courseId + "&commentUpdated=true");
                } else {
                    request.setAttribute("errorMessage", "Failed to update the comment. It may not exist or is inactive.");
                    request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid input data.");
                request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
            }
        } else if ("delete".equals(action)) {
            String feedbackIdParam = request.getParameter("feedbackId");

            try {
                int feedbackId = Integer.parseInt(feedbackIdParam);

                if (!feedbackDao.isFeedbackOwner(feedbackId, userId)) {
                    request.setAttribute("errorMessage", "You are not authorized to delete this comment.");
                    request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
                    return;
                }

                boolean deleted = feedbackDao.deleteFeedback(feedbackId);
                if (deleted) {
                  response.sendRedirect("detail?courseId=" + courseId + "&commentDeleted=true");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete the comment.");
                    request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid feedback ID.");
                request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Invalid action.");
            request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
        }
    }

}
