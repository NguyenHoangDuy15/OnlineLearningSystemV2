package local.ExpertController;

import dal.TestEXDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "NoticeServlet", urlPatterns = {"/NoticeServlet"})
public class NoticeServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Lấy tham số success và error từ URL
        String success = request.getParameter("success");
        String error = request.getParameter("error");

        // Đặt các tham số này vào request attribute để JSP sử dụng
        if (success != null) {
            request.setAttribute("success", success);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }

        // Forward tới NoticeJSP.jsp
        request.getRequestDispatcher("jsp/NoticeJSP.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        TestEXDAO testDao = new TestEXDAO();

        if ("createTest".equals(action)) {
            processRequest(request, response);
        } else if ("deleteTest".equals(action)) {
            try {
                int testId = Integer.parseInt(request.getParameter("testId"));
                testDao.updateTestStatus(testId, 0);
                response.setContentType("text/plain");
                response.getWriter().write("success");
            } catch (Exception e) {
                response.setContentType("text/plain");
                response.getWriter().write("Error: " + e.getMessage());
            }
        } else {
            processRequest(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}