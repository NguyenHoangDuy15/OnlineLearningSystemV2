/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.SaleController;

import Model.Blog;
import Model.Courses;
import Model.User;
import dal.BlogDAO;
import dal.CourseDao;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author THU UYEN
 */
@WebServlet(name = "ViewOwnerBlogList", urlPatterns = {"/viewownerbloglist"})
public class ViewOwnerBlogList extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        
        HttpSession session = request.getSession();

        Integer userId = (Integer) session.getAttribute("userid");
        User user = (User) session.getAttribute("account");
        int registeredCourses = 0;
        int completedCourses = 0;

        CourseDao courseDAL = new CourseDao();
        if (userId != null) {

            registeredCourses = courseDAL.countRegisteredCourses(userId);
            completedCourses = courseDAL.countCompletedCourses(userId);
        }
        // Kiểm tra nếu chưa đăng nhập hoặc không phải Sale
        if (user == null || user.getRoleID() != 3) {
            response.sendRedirect("LoginServlet");
            return;
        }

        String search = request.getParameter("search"); // Lấy từ khóa tìm kiếm
        BlogDAO blogDAO = new BlogDAO();
        List<Blog> blogs;

        if (search == null || search.trim().isEmpty()) {
            blogs = blogDAO.getBlogsByUserID(user.getUserID(), user.getRoleID()); // Lấy toàn bộ
        } else {
            blogs = blogDAO.searchBlogsByUserID(user.getUserID(), search); // Tìm kiếm theo từ khóa
        }
        session.setAttribute("registeredCourses", registeredCourses);
        session.setAttribute("completedCourses", completedCourses);
        request.setAttribute("blogs", blogs);
        request.setAttribute("search", search); // Trả lại từ khóa cho giao diện
        request.getRequestDispatcher("jsp/viewownerbloglist.jsp").forward(request, response);
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
