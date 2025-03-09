/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import Model.Category;
import Model.Courses;
import Model.CustomerCourse;
import Model.Expert;
import Model.Feedback;
import dal.CategoryDao;
import dal.CustomerDao;
import dal.ExpertDao;
import dal.FeedbackDao;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.List;

/**
 *
 * @author Administrator
 */
public class index extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CustomerDao courseDAO = new CustomerDao();
        List<CustomerCourse> courses = courseDAO.getAllCourses();

        CategoryDao category = new CategoryDao();
        List<Category> categories = category.getAllCategories();
        FeedbackDao dao = new FeedbackDao();
        List<Feedback> feedbacks = dao.getCustomerFeedbacks();
        ExpertDao expertdao = new ExpertDao();
        List<Expert> coursesdao = expertdao.getAllInstructorCourses();
         request.setAttribute("coursedao", coursesdao);
        request.setAttribute("feedbacks", feedbacks);

        request.setAttribute("courses", courses);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("jsp/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
