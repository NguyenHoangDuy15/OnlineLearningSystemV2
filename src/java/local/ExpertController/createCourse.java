package local.ExpertController;

import dal.CourseEXDAO;
import dal.LessonEXDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet(name = "createCourse", urlPatterns = {"/createCourse"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class createCourse extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userid");
        Integer role = (Integer) session.getAttribute("rollID");

        if (userID == null || role == null || role != 2) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        CourseEXDAO courseDao = new CourseEXDAO();
        LessonEXDAO lessonDao = new LessonEXDAO();

        if ("createCourse".equals(action)) {
            try {
                String courseName = request.getParameter("courseName");
                String description = request.getParameter("description");
                float price = Float.parseFloat(request.getParameter("price"));
                String imageCourses = "default.jpg";
                Part filePart = request.getPart("imageFile");

                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = extractFileName(filePart);
                    String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdir();
                    String filePath = uploadPath + File.separator + fileName;
                    filePart.write(filePath);
                    imageCourses = UPLOAD_DIR + "/" + fileName;
                }

                int categoryId = Integer.parseInt(request.getParameter("categoryId"));

                int courseId = courseDao.createCourse(courseName, description, price, imageCourses, userID, categoryId);
                if (courseId <= 0) {
                    throw new Exception("Failed to create course in the database.");
                }

                String[] lessonNames = request.getParameterValues("lessonName[]");
                String[] lessonContents = request.getParameterValues("lessonContent[]");
                int lessonCount = 0;

                if (lessonNames != null && lessonContents != null && lessonNames.length == lessonContents.length) {
                    for (int i = 0; i < lessonNames.length; i++) {
                        String lessonName = lessonNames[i].trim();
                        String lessonContent = lessonContents[i].trim();

                        if (!lessonName.isEmpty() && !lessonContent.isEmpty()) {
                            lessonDao.addLesson(courseId, lessonName, lessonContent);
                            lessonCount++;
                        }
                    }
                }

                request.setAttribute("success", "Course '" + courseName + "' created successfully with " + lessonCount + " lessons!");
                request.getRequestDispatcher("jsp/createCourse.jsp").forward(request, response);

            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error creating course: " + e.getMessage());
                request.getRequestDispatcher("jsp/createCourse.jsp").forward(request, response);
            }
        } else if ("deleteLesson".equals(action)) {
            try {
                int lessonId = Integer.parseInt(request.getParameter("lessonId"));
                lessonDao.deleteLesson(lessonId);
                request.setAttribute("success", "Lesson deleted successfully");
                request.getRequestDispatcher("jsp/createCourse.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("errorMessage", "Error deleting lesson: " + e.getMessage());
                request.getRequestDispatcher("jsp/createCourse.jsp").forward(request, response);
            }
        } else if ("deleteCourse".equals(action)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                courseDao.updateCourseStatus(courseId, 0);
                response.setContentType("text/plain");
                response.getWriter().write("success");
            } catch (Exception e) {
                response.setContentType("text/plain");
                response.getWriter().write("Error: " + e.getMessage());
            }
        } else if ("requestCourse".equals(action)) {
            try {
                int courseId = Integer.parseInt(request.getParameter("courseId"));
                courseDao.updateCourseStatus(courseId, 2);
                response.setContentType("text/plain");
                response.getWriter().write("success");
            } catch (Exception e) {
                response.setContentType("text/plain");
                response.getWriter().write("Error: " + e.getMessage());
            }
        } else {
            request.getRequestDispatcher("jsp/createCourse.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}