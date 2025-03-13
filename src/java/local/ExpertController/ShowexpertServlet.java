/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.ExpertController;

import Model.Courses;
import Model.Expert;
import Model.Test;
import dal.CourseDao;
import dal.ExpertDao;
import dal.TestDAO;
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
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String fullName = (String) session.getAttribute("Fullname");
        Integer userID = (Integer) session.getAttribute("userid");
        Integer role = (Integer) session.getAttribute("rollID");
        if (username == null) {
            response.sendRedirect("LoginServlet");
            return;
        }
        // Lấy thông tin giảng viên từ database
        ExpertDao expertDao = new ExpertDao();
        String expertId = expertDao.getUserIdByUsernameAndRole(username);  // Lấy expertId từ DB bằng username

        if (expertId == null) {
            // Nếu không tìm thấy expertId, chuyển hướng tới trang login
            response.sendRedirect("LoginServlet");
            return;
        }

        // Lưu expertId vào session để sử dụng sau này
        session.setAttribute("expertId", expertId);

        // Lấy danh sách khóa học của giảng viên
        List<Expert> experts = expertDao.getAllInstructorCourses(expertId);  // Truy vấn danh sách khóa học của giảng viên

        // Đưa danh sách khóa học vào request để hiển thị trong JSP
        if (fullName == null || role == null || role != 2) {
            response.sendRedirect("jsp/expertDashboard.jsp");
            return;
        }
        request.setAttribute("experts", experts);
        TestDAO testDAO = new TestDAO();
        List<Test> tests = testDAO.getTestsByCreatorFullName(fullName);

        request.setAttribute("tests", tests);
        if (userID == null || role == null || role != 2) {
            response.sendRedirect("jsp/expertDashboard.jsp");
            return;
        }
        
        CourseDao coursedao = new CourseDao();
        List<Courses> courses = coursedao.getCourseByUserId(userID);

        request.setAttribute("courses", courses);

        // Chuyển hướng đến trang expertDashboard.jsp để hiển thị thông tin
        request.getRequestDispatcher("jsp/expertDashboard.jsp").forward(request, response);
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
        String action = request.getParameter("action");
        CourseDao courseDao = new CourseDao();
        HttpSession session = request.getSession();
        String expertId = (String) session.getAttribute("expertId");

        if (expertId == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        if ("addCourse".equals(action)) {
            try {
                String courseName = request.getParameter("courseName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                String imageCourses = request.getParameter("imageCourses");
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));

                // Thêm khóa học mới vào database
                courseDao.addCourse(courseName, description, price, imageCourses, expertId, categoryId);

                request.setAttribute("successMessage", "Khóa học đã được thêm thành công!");
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Có lỗi khi thêm khóa học: " + e.getMessage());
            }
        } else if ("deleteCourse".equals(action)) {
            try {
                String courseId = request.getParameter("courseId");
                // Xóa khóa học khỏi database
                courseDao.deleteCourse(courseId);

                request.setAttribute("successMessage", "Khóa học đã được xóa thành công!");
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Có lỗi khi xóa khóa học: " + e.getMessage());
            }
        }

        // Sau khi thao tác xong, chuyển hướng lại trang dashboard
        response.sendRedirect("ShowexpertServlet");
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
