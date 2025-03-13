/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package local.AdminController;

import Model.Blog;
import Model.BlogPrint;
import Model.User;
import dal.BlogDAO;
import dal.UserDAO;
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
 * @author DELL
 */
public class ListBlogByAdminServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    public int getNoPage(List<Blog> list) {
        double page = (double) list.size() / 5;
        page = Math.ceil(page);
        return (int) page;
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {

            BlogDAO bdao = new BlogDAO();
            HttpSession session = request.getSession();

            int index = 1;
            int NoPage = getNoPage(bdao.getAllBlogs());
            if (request.getParameter("index") != null) {
                index = Integer.parseInt(request.getParameter("index"));
            }
            if (NoPage == 0) {
                request.setAttribute("noti", "No Blog found");
            }
            List<BlogPrint> listBlog = bdao.get5Blogs(index);
            session.setAttribute("Nopage", NoPage);
            session.setAttribute("currentindex", index);
            session.setAttribute("listBlog", listBlog);
            request.getRequestDispatcher("jsp/ListOfBlogByAdmin.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("exceptionErrorPage.jsp");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
