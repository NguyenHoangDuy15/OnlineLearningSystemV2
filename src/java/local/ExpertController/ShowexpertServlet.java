/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.ExpertController;

import Model.CourseEX;
import Model.TestEX;
import Model.User;
import dal.CourseDao;
import dal.CourseEXDAO;
import dal.TestEXDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ShowexpertServlet", urlPatterns = {"/ShowexpertServlet"})
public class ShowexpertServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        Integer userID = (Integer) session.getAttribute("userid");
        Integer role = (Integer) session.getAttribute("rollID");
        User user = (User) session.getAttribute("account");

        if (user == null || user.getRoleID() != 2) {
            response.sendRedirect("LoginServlet");
            return;
        }

        // Lấy thông tin số khóa học đã đăng ký và hoàn thành
        CourseDao courseDAL = new CourseDao();
        int registeredCourses = courseDAL.countRegisteredCourses(userID);
        int completedCourses = courseDAL.countCompletedCourses(userID);
        session.setAttribute("registeredCourses", registeredCourses);
        session.setAttribute("completedCourses", completedCourses);

        // Lấy tham số action từ request
        String action = request.getParameter("action");

        // Khởi tạo DAO
        CourseEXDAO courseDao = new CourseEXDAO();
        TestEXDAO testDAO = new TestEXDAO();

        // Xử lý theo action
        if ("viewCourses".equals(action)) {
            List<CourseEX> courses = courseDao.getCourseByUserId(userID);
            request.setAttribute("courses", courses);
            request.setAttribute("showCourseList", true);
        } else {
            List<CourseEX> courses = courseDao.getCourseByUserId(userID);
            List<TestEX> tests = testDAO.getTestsByCreatorFullName(userID);
            request.setAttribute("courses", courses);
            request.setAttribute("tests", tests);
            request.setAttribute("showCourseList", false); 
        }

        // Xử lý thông báo success/error nếu có
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
            request.setAttribute("success", success);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }

        request.getRequestDispatcher("jsp/expertDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to handle Expert Dashboard and Course List";
    }
}