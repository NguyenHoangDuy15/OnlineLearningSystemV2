package local.ExpertController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RequestServlet", urlPatterns = {"/RequestServlet"})
public class RequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseIdStr = request.getParameter("courseId");
        try {
            int courseId = Integer.parseInt(courseIdStr);
            // Logic xử lý yêu cầu (ví dụ: cập nhật trạng thái trong cơ sở dữ liệu)
            request.setAttribute("success", "Yêu cầu cho khóa học ID " + courseId + " đã được gửi thành công");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID khóa học không hợp lệ");
        }
        request.getRequestDispatcher("jsp/expertDashboard.jsp").forward(request, response);
    }
}