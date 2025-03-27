/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.ExpertController;

import Model.CourseEX;
import Model.Expert;
import Model.TestEX;
import Model.User;
import dal.CourseDao;
import dal.CourseEXDAO;
import dal.ExpertDao;
import dal.LessonEXDAO;
import dal.TestEXDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 *
 * @author CONG NINH
 */
@WebServlet(name = "ShowexpertServlet", urlPatterns = {"/ShowexpertServlet"})
public class ShowexpertServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ShowexpertServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ShowexpertServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer userID = (Integer) session.getAttribute("userid");
        Integer role = (Integer) session.getAttribute("rollID");
        String username = (String) session.getAttribute("username");
        String fullName = (String) session.getAttribute("Fullname");
        User user = (User) session.getAttribute("account");
        int registeredCourses = 0;
        int completedCourses = 0;

        CourseDao courseDAL = new CourseDao();
        if (userID != null) {

            registeredCourses = courseDAL.countRegisteredCourses(userID);
            completedCourses = courseDAL.countCompletedCourses(userID);
        }
        if (user == null || user.getRoleID() != 2) {
            response.sendRedirect("LoginServlet");
            return;
        }
        CourseEXDAO courseDao = new CourseEXDAO();
        List<CourseEX> courses = courseDao.getCourseByUserId(userID);
        request.setAttribute("courses", courses);
        TestEXDAO testDAO = new TestEXDAO();
        List<TestEX> tests = testDAO.getTestsByCreatorFullName(userID);

        request.setAttribute("tests", tests);

        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
            request.setAttribute("success", success);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }
        session.setAttribute("registeredCourses", registeredCourses);
        session.setAttribute("completedCourses", completedCourses);
        request.getRequestDispatcher("jsp/expertDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

}
