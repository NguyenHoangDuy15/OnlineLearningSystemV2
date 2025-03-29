package local.ExpertController;

import dal.TestEXDAO;
import dal.CourseEXDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "NoticeServlet", urlPatterns = {"/NoticeServlet"})
public class NoticeServlet extends HttpServlet {
    private TestEXDAO testDAO;
    private CourseEXDAO courseDAO;

    @Override
    public void init() throws ServletException {
        testDAO = new TestEXDAO();
        courseDAO = new CourseEXDAO(); 
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String success = request.getParameter("success");
        String error = request.getParameter("error");

        if (success != null) {
            request.setAttribute("success", success);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }

        request.getRequestDispatcher("jsp/NoticeJSP.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("createTest".equals(action)) {
            processRequest(request, response);
        } else if ("deleteTest".equals(action)) {
            try {
                int testId = Integer.parseInt(request.getParameter("testId"));
                testDAO.updateTestStatus(testId, 0);
                response.setContentType("text/plain");
                response.getWriter().write("success");
            } catch (Exception e) {
                response.setContentType("text/plain");
                response.getWriter().write("Error: " + e.getMessage());
            }
        } else if ("deleteCourse".equals(action)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                courseDAO.updateCourseStatus(courseId, 0); 
                testDAO.updateTestsStatusByCourseId(courseId, 0); 
                response.setContentType("text/plain");
                response.getWriter().write("success");
            } catch (Exception e) {
                response.setContentType("text/plain");
                response.getWriter().write("Error: " + e.getMessage());
            }
        } else if ("requestCourse".equals(action)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                courseDAO.updateCourseStatus(courseId, 2); 
                response.setContentType("text/plain");
                response.getWriter().write("success");
            } catch (SQLException e) {
                response.setContentType("text/plain");
                response.getWriter().write("Error: " + e.getMessage());
            }
        } else {
            processRequest(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); 
    }
}