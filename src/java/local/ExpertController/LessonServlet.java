package local.ExpertController;

import Model.LessonEX;
import dal.LessonEXDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/LessonServlet")
public class LessonServlet extends HttpServlet {
    private LessonEXDAO lessonDAO;

    @Override
    public void init() throws ServletException {
        lessonDAO = new LessonEXDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            try {
                int lessonId = Integer.parseInt(request.getParameter("lessonId"));
                System.out.println("Editing lesson with lessonId: " + lessonId);
                LessonEX lesson = lessonDAO.getLessonById(lessonId);
                if (lesson == null) {
                    request.setAttribute("error", "Lesson not found or has been deactivated");
                    request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
                    return;
                }
                request.setAttribute("lesson", lesson);
                request.setAttribute("courseId", lesson.getCourseID());
                request.getRequestDispatcher("jsp/editLesson.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid lesson ID: " + e.getMessage());
                request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            }
        } else if ("add".equals(action)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                System.out.println("Adding new lesson for courseId: " + courseId);
                request.setAttribute("courseId", courseId);
                request.getRequestDispatcher("jsp/editLesson.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid course ID: " + e.getMessage());
                request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                String lessonIdStr = request.getParameter("lesson");
                System.out.println("Received lessonId: " + lessonIdStr);

                if (lessonIdStr == null || lessonIdStr.trim().isEmpty()) {
                    System.err.println("Lesson ID is null or empty: " + lessonIdStr);
                    throw new NumberFormatException("Lesson ID is null or empty");
                }

                int lessonId = Integer.parseInt(lessonIdStr);
                
                if (lessonId <= 0) {
                    throw new IllegalArgumentException("Lesson ID must be a positive integer");
                }

                System.out.println("Deactivating lesson with lessonId: " + lessonId);
                boolean success = lessonDAO.deactivateLesson(lessonId);
                System.out.println("Deactivate lesson result: " + success);
                
                if (success) {
                    response.setContentType("text/plain");
                    response.getWriter().write("success");
                } else {
                    throw new Exception("Failed to deactivate lesson: Lesson may not exist or already deactivated");
                }
            } catch (NumberFormatException e) {
                System.err.println("NumberFormatException: " + e.getMessage());
                response.setContentType("text/plain");
                response.getWriter().write("Invalid lesson ID: " + e.getMessage());
            } catch (IllegalArgumentException e) {
                System.err.println("IllegalArgumentException: " + e.getMessage());
                response.setContentType("text/plain");
                response.getWriter().write("Error: " + e.getMessage());
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("Exception: " + e.getMessage());
                response.setContentType("text/plain");
                response.getWriter().write("Error: " + e.getMessage());
            }
        } else if ("updateLesson".equals(action)) {
            try {
                int lessonId = Integer.parseInt(request.getParameter("lessonId"));
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
                    throw new Exception("Title and content cannot be empty");
                }
                String youtubeUrlPattern = "^https://www\\.youtube\\.com/watch\\?v=[A-Za-z0-9_-]+";
                if (!content.matches(youtubeUrlPattern)) {
                    throw new Exception("Content must be a valid YouTube URL starting with 'https://www.youtube.com/watch?v='");
                }

                LessonEX lesson = new LessonEX();
                lesson.setLessonID(lessonId);
                lesson.setTitle(title);
                lesson.setContent(content);
                lesson.setCourseID(courseId);
                System.out.println("Updating lesson with lessonId: " + lessonId);
                lessonDAO.updateLesson(lesson);

                response.sendRedirect("CourseServlet?courseId=" + courseId + "&message=" + 
                    java.net.URLEncoder.encode("Lesson updated successfully.", "UTF-8"));
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "An error occurred while updating the lesson: " + e.getMessage());
                request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            }
        } else if ("addLesson".equals(action)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
                    throw new Exception("Title and content cannot be empty");
                }

                String youtubeUrlPattern = "^https://www\\.youtube\\.com/watch\\?v=[A-Za-z0-9_-]+";
                if (!content.matches(youtubeUrlPattern)) {
                    throw new Exception("Content must be a valid YouTube URL starting with 'https://www.youtube.com/watch?v='");
                }

                System.out.println("Adding new lesson for courseId: " + courseId);
                int newLessonId = lessonDAO.addLesson(courseId, title, content);
                if (newLessonId == -1) {
                    throw new Exception("Failed to add new lesson");
                }

                response.sendRedirect("CourseServlet?courseId=" + courseId + "&message=" + 
                    java.net.URLEncoder.encode("Lesson added successfully. Lesson ID: " + newLessonId, "UTF-8"));
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "An error occurred while adding the lesson: " + e.getMessage());
                request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            }
        }
    }
}