/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import Model.User;
import Model.VerifyCode;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import util.MaHoa;
import util.SendEmail;
import util.Validator;

/**
 *
 * @author DELL
 */
public class RegisterServlet extends HttpServlet {

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
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
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
    User getuserById(List<User> list, String user, String email) {

        for (User p : list) {
            System.out.println(user);
            System.out.println(p.getUserName());
            if (p.getUserName().equals(user) || p.getEmail().equals(email)) {
                return p;
            }
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
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
        response.setContentType("text/html; charset=UTF-8");
        HttpSession session = request.getSession();
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String fullname = request.getParameter("name");
        String mail = request.getParameter("email");
        String repass = request.getParameter("repassword");
        UserDAO d = new UserDAO();
        if (getuserById(d.getAll(), user, mail) != null) {
            request.setAttribute("err", "UserName or Gmail Dublicate");
            request.setAttribute("username", user);
            request.setAttribute("password", pass);
            request.setAttribute("repassword", repass);
            request.setAttribute("name", fullname);
            request.setAttribute("email", mail);
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
            return;
        } else if (!Validator.isValidUsername(user)) {
            request.setAttribute("err", "Invalid username! Must be 5-20 characters, no spaces, not starting with a number.");
            request.setAttribute("username", user);
            request.setAttribute("password", pass);
            request.setAttribute("repassword", repass);
            request.setAttribute("name", fullname);
            request.setAttribute("email", mail);
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
            return;
        } else if (!Validator.isValidEmail(mail)) {
            request.setAttribute("err", "Invalid email format!");
            request.setAttribute("username", user);
            request.setAttribute("password", pass);
            request.setAttribute("repassword", repass);
            request.setAttribute("name", fullname);
            request.setAttribute("email", mail);
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
            return;
        } else if (!Validator.isValidPassword(pass)) {
            request.setAttribute("err", "Password must be at least 8 characters with 1 uppercase, 1 lowercase, 1 number, and 1 special character.");
            request.setAttribute("username", user);
            request.setAttribute("password", pass);
            request.setAttribute("repassword", repass);
            request.setAttribute("name", fullname);
            request.setAttribute("email", mail);
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
            return;
        }
        if (!pass.equals(repass)) {
            request.setAttribute("err", "password or re-password invalid");
            request.setAttribute("username", user);
            request.setAttribute("password", pass);
            request.setAttribute("repassword", repass);
            request.setAttribute("name", fullname);
            request.setAttribute("email", mail);
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
            return;
        }
        SendEmail sendEmail = new SendEmail();
        String code = sendEmail.getRandom();
        VerifyCode verifyCode = new VerifyCode(code);
        boolean test = sendEmail.sendEmail(verifyCode, mail);
        if (test) {
            session.setAttribute("verifyCode", verifyCode);
            request.setAttribute("username", user);
            request.setAttribute("password", pass);
            request.setAttribute("repassword", repass);
            request.setAttribute("name", fullname);
            request.setAttribute("email", mail);
            request.getRequestDispatcher("jsp/verify.jsp").forward(request, response);
        } else{
            request.setAttribute("err", "Email isn't Existed");
            request.setAttribute("username", user);
            request.setAttribute("password", pass);
            request.setAttribute("repassword", repass);
            request.setAttribute("name", fullname);
            request.setAttribute("email", mail);
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
        }

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
