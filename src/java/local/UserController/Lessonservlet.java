/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import Model.History;

import Model.Lesson;

import dal.LessonsDao;
import dal.TestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "Lessonservlet", urlPatterns = {"/Lessonservlet"})
public class Lessonservlet extends HttpServlet {

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
            out.println("<title>Servlet Lessonservlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Lessonservlet at " + request.getContextPath() + "</h1>");
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
        Integer userId = (Integer) session.getAttribute("userid");

        if (userId == null) {
            response.sendRedirect("LogoutServlet");
            return;
        }

        String courseIdParam = request.getParameter("courseId");
        if (courseIdParam == null || courseIdParam.isEmpty()) {
            response.sendRedirect("jsp/Error.jsp");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdParam);
            session.setAttribute("courseId", courseId);

            LessonsDao lessonDAO = new LessonsDao();
            TestDAO testDao = new TestDAO();

            List<Lesson> lessonsAndTests = lessonDAO.getLessonsAndTests(courseId);
            Map<Integer, Integer> testStatuses = testDao.getAllTestStatuses(userId, courseId);
            Integer lastTestId = testDao.getLastTestId(userId, courseId);
            Integer historyId = (lastTestId != null) ? testDao.getHistoryId(userId, lastTestId, courseId) : null;

            // Lọc danh sách tests chỉ lấy những test có status 0 hoặc 1
            List<Lesson> tests = lessonDAO.getTestsByCourseId(courseId)
                    .stream()
                    .filter(test -> {
                        Integer status = testStatuses.get(test.getId());
                        return status != null && (status == 0 || status == 1);
                    })
                    .collect(Collectors.toList());

            Integer courseStatus = testDao.getCourseStatus(userId, courseId);

            request.setAttribute("lessonsAndTests", lessonsAndTests);
            request.setAttribute("tests", tests);
            request.setAttribute("testStatuses", testStatuses);
            request.setAttribute("historyId", historyId);
            request.setAttribute("courseStatus", courseStatus);
            // Kiểm tra xem có test nào để hiển thị trong Test History không
            request.setAttribute("hasTestHistory", !tests.isEmpty());

            request.getRequestDispatcher("jsp/lessons.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("jsp/Error.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/Error.jsp");
        }
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
