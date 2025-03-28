/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import java.sql.SQLException;

import Model.Category;
import Model.Courses;
import Model.CustomerCourse;
import Model.Expert;
import Model.Feedback;
import dal.CategoryDao;
import dal.CourseDao;
import dal.CustomerDao;
import dal.ExpertDao;
import dal.FeedbackDao;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;

import java.util.List;

/**
 *
 * @author Administrator
 */
public class index extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userid");
        int registeredCourses = 0;
        int completedCourses = 0;
        CustomerDao courseDAO = new CustomerDao();
        List<Courses> courses = new ArrayList<>();
        CourseDao courseDAL = new CourseDao();
        try {
            if (userId != null) {
                courses = courseDAO.getTopCourses(userId);
                registeredCourses = courseDAL.countRegisteredCourses(userId);
                completedCourses = courseDAL.countCompletedCourses(userId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("courses", courses);
        CategoryDao category = new CategoryDao();
        List<Category> categories = category.getAllCategories();
        FeedbackDao dao = new FeedbackDao();
        List<Feedback> feedbacks = dao.getCustomerFeedbacks();
        ExpertDao expertdao = new ExpertDao();
        List<Expert> coursesdao = expertdao.getTopInstructors();

        request.setAttribute("coursedao", coursesdao);
        request.setAttribute("feedbacks", feedbacks);
        session.setAttribute("registeredCourses", registeredCourses);
        session.setAttribute("completedCourses", completedCourses);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("jsp/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
