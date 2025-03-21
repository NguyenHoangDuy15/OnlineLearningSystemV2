
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import Model.Courses;
import Model.Enrollment;
import Model.Feedback;
import dal.CourseDao;
import dal.CustomerDao;
import dal.EnrollmentDAO;
import dal.FeedbackDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class detail extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseIdParam = request.getParameter("courseId");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userid");

        // Lấy top 5 khóa học phổ biến
        CustomerDao coDAO = new CustomerDao();
        List<Courses> courses = coDAO.getTop5PopularCourses();
        request.setAttribute("courses", courses);

        Courses course = null;
        Courses coursedetails = null;
        Integer courseId = null;
        Enrollment enrollment = null;
        EnrollmentDAO enrollmentDAL = new EnrollmentDAO();
        List<Feedback> feedbacks = null;

        if (courseIdParam != null && !courseIdParam.isEmpty()) {
            try {
                courseId = Integer.parseInt(courseIdParam);
                CourseDao courseDAO = new CourseDao();
                course = courseDAO.getCourseByIdd(courseId);
                coursedetails = courseDAO.getCourseDetail(courseId);

                FeedbackDao feedbackDAL = new FeedbackDao();
                feedbacks = feedbackDAL.getFeedbacksByCourseId(courseId);
                if (userId != null) {
                    enrollment = enrollmentDAL.getEnrollmentStatus(userId, courseId);
                }

            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Invalid course ID");
                request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "An error occurred while retrieving course details");
                request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
                return;
            }
        } else {
            request.setAttribute("errorMessage", "Course ID is required");
            request.getRequestDispatcher("jsp/Error.jsp").forward(request, response);
            return;
        }

        // Đặt các thuộc tính vào request
        request.setAttribute("feedbacks", feedbacks);
        session.setAttribute("courseId", courseId);
        request.setAttribute("enrollment", enrollment);
        request.setAttribute("coursedetails", coursedetails);
        request.setAttribute("course", course);
        request.getRequestDispatcher("jsp/detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
