
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import Model.Courses;
import dal.CourseDao;
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

        Courses course = null;
        Courses coursedetails = null;
        Integer courseId = null;

        if (courseIdParam != null && !courseIdParam.isEmpty()) {
            try {
                courseId = Integer.parseInt(courseIdParam); // Chuyển thành Integer
                CourseDao courseDAO = new CourseDao();
                course = courseDAO.getCourseByIdd(courseId);
                coursedetails = courseDAO.getCourseDetails(courseId);
            } catch (NumberFormatException e) {
                e.printStackTrace(); // Debug lỗi nếu có
            }
        }

        // Lưu vào session dưới dạng Integer
        HttpSession session = request.getSession();
        session.setAttribute("courseId", courseId);

        request.setAttribute("coursedetails", coursedetails);
        request.setAttribute("course", course);
        request.getRequestDispatcher("jsp/detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
