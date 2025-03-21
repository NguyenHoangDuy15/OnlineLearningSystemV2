package local.UserController;

import Model.Category;
import Model.Courses;

import dal.CategoryDao;
import dal.CourseDao;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class course extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDao categoryDao = new CategoryDao();
        List<Category> categories = categoryDao.getAllCategories();
        request.setAttribute("categories", categories);

        CourseDao courseDAO = new CourseDao();
        List<Courses> searchResults = null;

        // Lấy từ khóa tìm kiếm và kiểm tra xem có ấn nút Search không
        String keyword = request.getParameter("search");
        String searchSubmitted = request.getParameter("searchSubmitted");

        // Phân trang
        int page = 1;
        int limit = 3; // Giới hạn 3 khóa học mỗi trang
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * limit;

        // Nếu người dùng ấn nút Search và có từ khóa
        if ("true".equals(searchSubmitted) && keyword != null && !keyword.trim().isEmpty()) {
            searchResults = courseDAO.searchCoursesByName(keyword, offset, limit);
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("keyword", keyword);

            // Tính tổng số trang cho kết quả tìm kiếm
            int totalSearchCourses = courseDAO.countSearchCoursesss(keyword);
            int totalSearchPages = (int) Math.ceil((double) totalSearchCourses / limit);
            request.setAttribute("totalPages", totalSearchPages);
            request.setAttribute("currentPage", page);
        } else {
            // Nếu không có tìm kiếm, hiển thị tất cả khóa học hoặc theo bộ lọc
            String category = request.getParameter("category");
            String priceOrder = request.getParameter("priceOrder");
            String ratingOrder = request.getParameter("ratingOrder");

            // Nếu các tham số bộ lọc rỗng, để null để lấy tất cả khóa học
            if (category == null || category.trim().isEmpty() || "0".equals(category)) {
                category = null;
            }
            if (priceOrder == null || priceOrder.trim().isEmpty() || "0".equals(priceOrder)) {
                priceOrder = null;
            }
            if (ratingOrder == null || ratingOrder.trim().isEmpty() || "0".equals(ratingOrder)) {
                ratingOrder = null;
            }

            // Lấy danh sách khóa học có phân trang (mặc định hiển thị tất cả nếu không có bộ lọc)
            List<Courses> courses = courseDAO.getFilteredCourses(category, priceOrder, ratingOrder, offset, limit);
            request.setAttribute("courses", courses);

            // Tính tổng số trang
            int totalCourses = courseDAO.countFilteredCourses(category, priceOrder, ratingOrder);
            int totalPages = (int) Math.ceil((double) totalCourses / limit);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);

            // Giữ lại giá trị đã chọn khi lọc
            request.setAttribute("selectedCategory", category);
            request.setAttribute("selectedPriceOrder", priceOrder);
            request.setAttribute("selectedRatingOrder", ratingOrder);
        }

        request.getRequestDispatcher("jsp/course.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng POST về GET để xử lý tìm kiếm
        String keyword = request.getParameter("search");
        String redirectUrl = "course?search=" + (keyword != null ? keyword : "") + "&searchSubmitted=true";
        response.sendRedirect(redirectUrl);
    }

}
