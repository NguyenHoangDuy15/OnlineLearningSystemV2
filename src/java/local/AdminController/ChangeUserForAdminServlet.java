/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.AdminController;

import Model.User;
import dal.AdminDao;
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
public class ChangeUserForAdminServlet extends HttpServlet {

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
            out.println("<title>Servlet ChangeUserForAdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangeUserForAdminServlet at " + request.getContextPath() + "</h1>");
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
        response.setContentType("text/html;charset=UTF-8");
        String userid = request.getParameter("userid");
        UserDAO uDao = new UserDAO();
        User u = uDao.getUserByUserId(userid);
        request.setAttribute("userid", userid);
        request.setAttribute("fullname", u.getFullName());
        request.setAttribute("email", u.getEmail());
        request.setAttribute("role", u.getRoleID());
        request.setAttribute("status", u.getStatus());
        request.getRequestDispatcher("jsp/ChangeUserForAdmin.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    User getuserById(List<User> list, String email) {

        for (User p : list) {
            if (p.getEmail().equals(email)) {
                return p;
            }
        }
        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        String userid = request.getParameter("userid");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        UserDAO udao = new UserDAO();
        AdminDao adao = new AdminDao();
        int r = Integer.parseInt(role);
        if (!email.equals(udao.getUserByUserId(userid).getEmail())) {
            
        }
//        if (getuserById(udao.getAll(), email) != null) {
//            session.setAttribute("noti", "Gmail Dublicate");
//            request.setAttribute("fullname", fullname);
//            request.setAttribute("email", email);
//            request.setAttribute("role", role);
//            request.setAttribute("name", fullname);
//            request.setAttribute("status", status);
//            request.getRequestDispatcher("jsp/ChangeUserForAdmin.jsp").forward(request, response);
//        } else{
        adao.UpdateUserForAdmin(userid, fullname, email, role, status);
        if (r == 2) {
            response.sendRedirect("ListOfExpertServlet");
        } else {
              response.sendRedirect("ListOfSellerServlet");
        }
//        }
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
