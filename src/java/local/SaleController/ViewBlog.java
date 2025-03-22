/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.SaleController;

import Model.Blog;
import dal.BlogDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author THU UYEN
 */
@WebServlet(name = "ViewBlog", urlPatterns = {"/ViewBlog"})
public class ViewBlog extends HttpServlet {

    private BlogDAO blogDAO;

    @Override
    public void init() {
        blogDAO = new BlogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        BlogDAO blogDAO = new BlogDAO();
//        List<Blog> blogList = blogDAO.getAllBlogs();
//
//        request.setAttribute("blogList", blogList);
//        request.getRequestDispatcher("jsp/viewblog.jsp").forward(request, response);
//    } 
        int page = 1;
        int blogsPerPage = 6; // Số blog mỗi trang

        // Lấy số trang từ request (nếu có)
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        // Lấy tổng số blog
        int totalBlogs = blogDAO.getTotalBlogs();
        int totalPages = (int) Math.ceil((double) totalBlogs / blogsPerPage);

        // Lấy danh sách blog theo trang
        List<Blog> blogList = blogDAO.getBlogsByPage(page, blogsPerPage);

        // Đẩy dữ liệu lên JSP
        request.setAttribute("blogList", blogList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("jsp/viewblog.jsp").forward(request, response);
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
