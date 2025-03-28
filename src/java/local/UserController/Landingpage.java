/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import Model.Category;
import Model.Courses;
import Model.Expert;
import Model.Feedback;
import dal.CategoryDao;
import dal.CustomerDao;
import dal.ExpertDao;
import dal.FeedbackDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "Landingpage", urlPatterns = {"/Landingpage"})
public class Landingpage extends HttpServlet {

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
            out.println("<title>Servlet Landingpage</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Landingpage at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CustomerDao courseDAO = new CustomerDao();
        List<Courses> courses = null;
        try {
            courses = courseDAO.getTop5PopularCourses();
        } catch (SQLException ex) {
            Logger.getLogger(Landingpage.class.getName()).log(Level.SEVERE, null, ex);
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

        request.setAttribute("categories", categories);

        request.getRequestDispatcher("jsp/Landingpage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
