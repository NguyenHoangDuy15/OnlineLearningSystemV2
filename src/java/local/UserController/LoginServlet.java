/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import Model.User;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.MaHoa;

/**
 *
 * @author DELL
 */
public class LoginServlet extends HttpServlet {

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
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        UserDAO d = new UserDAO();
        String pass = MaHoa.toSHA1(p);
        User a = d.check(u, pass);
        HttpSession sec = request.getSession();

        if (a == null) {  // Hợp nhất logic từ cả hai nhánh
            sec.setAttribute("isLoggedIn", false);
            request.setAttribute("username", u);
            request.setAttribute("password", p);
            request.setAttribute("err", "Username or password invalid ");
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else if (a.getStatus() == 0) {
            sec.setAttribute("isLoggedIn", false);
            request.setAttribute("username", u);
            request.setAttribute("password", p);
            request.setAttribute("err", "Your account was banned");
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            sec.setAttribute("Fullname", a.getFullName());
            sec.setAttribute("account", a);
            sec.setAttribute("isLoggedIn", true);
            sec.setAttribute("userid", a.getUserID());
            sec.setAttribute("sessionID", sec.getId());
            sec.setAttribute("rollID", a.getRoleID()); // Thêm rollID vào session
            request.setAttribute("rollID", a.getRoleID());
            sec.setAttribute("username", a.getUserName());
            if (a.getRoleID() == 1) {
                sec.setAttribute("admin", a.getRoleID());
                response.sendRedirect("ShowAdminDasboardServlet");
            } else if (a.getRoleID() == 2) {
                sec.setAttribute("expert", a.getRoleID());
                response.sendRedirect("ShowexpertServlet");
                sec.setAttribute("isExpert", true);
            } else if (a.getRoleID() == 3) {
                sec.setAttribute("sale", a.getRoleID());
                response.sendRedirect("viewownerbloglist");
                sec.setAttribute("isSale", true);
            } else {
                sec.setAttribute("customer", a.getRoleID());
                response.sendRedirect("index");
            }

        }
    }

}
