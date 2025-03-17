/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.AdminController;

import Model.Blog;
import Model.CoursePrint;
import Model.CustomerCourse;
import Model.Feedback;
import Model.MoneyHistoryByAdmin;
import Model.RequestPrint;
import Model.Requests;
import Model.User;
import dal.AdminDao;
import dal.BlogDAO;
import dal.CourseDao;
import dal.CustomerDao;
import dal.FeedbackDao;
import dal.RequestDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author DELL
 */
public class ShowAdminDasboardServlet extends HttpServlet {

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
            out.println("<title>Servlet ShowAdminDasboardServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ShowAdminDasboardServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        // GET ALL DAO
        //CustomerDao courseDAO = new CustomerDao();
        UserDAO userDAO = new UserDAO();
        BlogDAO blogDAO = new BlogDAO();
        FeedbackDao feedbackDAO = new FeedbackDao();
        AdminDao requestDAO = new AdminDao();
        AdminDao adao = new AdminDao();
        CourseDao cdao = new CourseDao();
        // Get all list
        List<CoursePrint> courses = cdao.getAllCourseForAdmin();
        List<Blog> blogs = blogDAO.getAllBlogs();
        List<User> experts = userDAO.getAllExpert();
        List<User> sales = userDAO.getAllSale();
        List<Feedback> feedbacks = feedbackDAO.getAllFeedback();
        List<RequestPrint> requests = requestDAO.getAllRequest();
        List<User> users = userDAO.getAll();
        List<MoneyHistoryByAdmin> money = adao.getAllHistory();

        //
        float price = 0;
        for (MoneyHistoryByAdmin moneyHistoryByAdmin : money) {
            if (moneyHistoryByAdmin.getStatus() == 1) {
                price += moneyHistoryByAdmin.getPrice();
            }
        }
        // Luu Session
        session.setAttribute("numberOfCourse", courses.size());
        session.setAttribute("numberOfBlog", blogs.size());
        session.setAttribute("numberOfExpert", experts.size());
        session.setAttribute("numberOfSale", sales.size());
        session.setAttribute("numberOfFeedback", feedbacks.size());
        session.setAttribute("numberOfRequest", requests.size());
        session.setAttribute("numberOfUsers", (users.size() - 1));
        session.setAttribute("TotalMoney", price);
        request.getRequestDispatcher("jsp/dashboard.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
