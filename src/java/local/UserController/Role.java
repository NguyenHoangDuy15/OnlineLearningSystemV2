/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import dal.RequestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "Role", urlPatterns = {"/Role"})
public class Role extends HttpServlet {

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
            out.println("<title>Servlet Role</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Role at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("jsp/Role.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userid");

        // Kiểm tra nếu người dùng chưa đăng nhập
        if (userId == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        // Lấy vai trò yêu cầu từ form
        int requestedRole;
        try {
            requestedRole = Integer.parseInt(request.getParameter("role"));
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid role selected.");
            request.setAttribute("selectedRole", null); // Đặt giá trị mặc định nếu lỗi
            request.getRequestDispatcher("jsp/Role.jsp").forward(request, response);
            return;
        }

        RequestDAO requestDAO = new RequestDAO();

        try {
            // Kiểm tra trạng thái yêu cầu gần nhất
            Integer latestStatus = requestDAO.getLatestRequestStatus(userId, requestedRole);

            if (latestStatus == null) {
                request.setAttribute("message", "You have a pending request. Please wait for Admin approval.");
            } else if (latestStatus == 1) {
                request.setAttribute("message", "Your request has already been approved. You cannot submit another request for this role.");
            } else if (latestStatus == 0 || latestStatus == -1) {
                // Status = 0: Bị từ chối, hoặc -1: Không có yêu cầu trước đó
                boolean success = requestDAO.insertRequest(userId, requestedRole);
                if (success) {
                    request.setAttribute("message", "Request submitted successfully! Please wait for Admin approval.");
                } else {
                    request.setAttribute("message", "Request submission failed!");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Error processing your request.");
        }

        // Gửi lại giá trị selectedRole để giữ trạng thái option
        request.setAttribute("selectedRole", requestedRole);
        // Chuyển hướng đến trang Role.jsp để hiển thị thông báo
        request.getRequestDispatcher("jsp/Role.jsp").forward(request, response);
    }
}
