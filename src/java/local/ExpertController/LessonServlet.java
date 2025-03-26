package local.ExpertController;

import Model.LessonEX;
import dal.LessonEXDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                String[] lessonIds = request.getParameterValues("lessonId[]");
                String[] titles = request.getParameterValues("title[]");
                String[] contents = request.getParameterValues("content[]");

                if (titles == null || contents == null || titles.length != contents.length) {
                    throw new Exception("Invalid lesson data: titles or contents missing or mismatched");
                }

                String youtubeUrlPattern = "^https://www\\.youtube\\.com/watch\\?v=[A-Za-z0-9_-]+";
                List<LessonEX> lessonsToUpdate = new ArrayList<>();

                for (int i = 0; i < titles.length; i++) {
                    if (titles[i] == null || titles[i].trim().isEmpty() || 
                        contents[i] == null || contents[i].trim().isEmpty()) {
                        throw new Exception("Title and content cannot be empty for lesson " + (i + 1));
                    }
                    if (!contents[i].matches(youtubeUrlPattern)) {
                        throw new Exception("Invalid YouTube URL for lesson " + (i + 1));
                    }

                    LessonEX lesson = new LessonEX();
                    lesson.setLessonID(Integer.parseInt(lessonIds[i]));
                    lesson.setTitle(titles[i]);
                    lesson.setContent(contents[i]);
                    lesson.setCourseID(courseId);
                    lessonsToUpdate.add(lesson);
                }

                System.out.println("Updating " + lessonsToUpdate.size() + " lessons");
                for (LessonEX lesson : lessonsToUpdate) {
                    lessonDAO.updateLesson(lesson);
                }

                response.sendRedirect("CourseServlet?courseId=" + courseId + "&message=" + 
                    java.net.URLEncoder.encode("Lessons updated successfully.", "UTF-8"));
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "An error occurred while updating lessons: " + e.getMessage());
                request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            }
        } else if ("addLesson".equals(action)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                String[] titles = request.getParameterValues("title[]");
                String[] contents = request.getParameterValues("content[]");

                if (titles == null || contents == null || titles.length != contents.length) {
                    throw new Exception("Invalid lesson data: titles or contents missing or mismatched");
                }

                String youtubeUrlPattern = "^https://www\\.youtube\\.com/watch\\?v=[A-Za-z0-9_-]+";
                List<Integer> newLessonIds = new ArrayList<>();

                for (int i = 0; i < titles.length; i++) {
                    if (titles[i] == null || titles[i].trim().isEmpty() || 
                        contents[i] == null || contents[i].trim().isEmpty()) {
                        throw new Exception("Title and content cannot be empty for lesson " + (i + 1));
                    }
                    if (!contents[i].matches(youtubeUrlPattern)) {
                        throw new Exception("Invalid YouTube URL for lesson " + (i + 1));
                    }

                    System.out.println("Adding lesson " + (i + 1) + " for courseId: " + courseId);
                    int newLessonId = lessonDAO.addLesson(courseId, titles[i], contents[i]);
                    if (newLessonId == -1) {
                        throw new Exception("Failed to add lesson " + (i + 1));
                    }
                    newLessonIds.add(newLessonId);
                }

                response.sendRedirect("CourseServlet?courseId=" + courseId + "&message=" + 
                    java.net.URLEncoder.encode("Added " + newLessonIds.size() + " lessons successfully.", "UTF-8"));
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "An error occurred while adding lessons: " + e.getMessage());
                request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            }
        }
    }
}