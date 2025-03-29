package local.ExpertController;

import Model.CourseEX;
import Model.LessonEX;
import Model.TestEX;
import dal.CourseEXDAO;
import dal.LessonEXDAO;
import dal.TestEXDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/CourseServlet")
public class CourseServlet extends HttpServlet {

    private CourseEXDAO courseDAO;
    private LessonEXDAO lessonDAO;
    private TestEXDAO testDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseEXDAO();
        lessonDAO = new LessonEXDAO();
        testDAO = new TestEXDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy courseId từ request
        HttpSession session = request.getSession();
        String courseIdStr = request.getParameter("courseId");

        System.out.println("[CourseServlet] Received courseId: " + courseIdStr);

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            System.err.println("[CourseServlet] Course ID is null or empty");
            request.setAttribute("error", "Course ID is missing");
            request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdStr);
            session.setAttribute("courseId", courseId);
        } catch (NumberFormatException e) {
            System.err.println("[CourseServlet] Invalid course ID: " + courseIdStr);
            request.setAttribute("error", "Invalid course ID");
            request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            return;
        }
        CourseEX course = courseDAO.getCourseByIdEx(courseId);
        System.out.println("[CourseServlet] Fetched course: " + (course != null ? course.getCourseID() : "null"));
        if (course == null) {
            System.err.println("[CourseServlet] Course not found for courseId: " + courseId);
            request.setAttribute("error", "Course not found");
            request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            return;
        }

        // Lấy danh sách bài học và bài kiểm tra
        List<LessonEX> lessons = lessonDAO.getLessonsByCourseId(courseId);
        System.out.println("[CourseServlet] Lessons list size: " + (lessons != null ? lessons.size() : "null"));
        if (lessons != null) {
            for (LessonEX lesson : lessons) {
                System.out.println("[CourseServlet] Lesson: ID=" + lesson.getLessonID() + ", CourseID=" + lesson.getCourseID() + ", Status=" + lesson.getStatus());
            }
        }

        List<TestEX> tests = testDAO.getTestsByCourseId(courseId);
        System.out.println("[CourseServlet] Tests list size: " + (tests != null ? tests.size() : "null"));

        // Đặt dữ liệu vào request
        request.setAttribute("course", course);
        request.setAttribute("lessons", lessons);
        request.setAttribute("tests", tests);

        // Chuyển tiếp đến courseDetails.jsp
        request.getRequestDispatcher("jsp/courseDetails.jsp").forward(request, response);
    }
}
