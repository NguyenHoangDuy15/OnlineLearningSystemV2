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

        // Lấy tham số từ request
        String category = request.getParameter("category");
        String priceOrder = request.getParameter("priceOrder");
        String ratingOrder = request.getParameter("ratingOrder");

        // Nếu category hoặc các bộ lọc rỗng hoặc bằng 0, gán null để hiển thị tất cả
        if (category == null || category.trim().isEmpty() || "0".equals(category)) {
            category = null;
        }
        if (priceOrder == null || priceOrder.trim().isEmpty() || "0".equals(priceOrder)) {
            priceOrder = null;
        }
        if (ratingOrder == null || ratingOrder.trim().isEmpty() || "0".equals(ratingOrder)) {
            ratingOrder = null;
        }

        // Nhận số trang từ request
        int page = 1;
        int limit = 3; // Hiển thị 9 khóa học trên mỗi trang
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * limit;
       
        // Lấy danh sách khóa học có phân trang
        List<Courses> courses = courseDAO.getFilteredCourses(category, priceOrder, ratingOrder, offset, limit);
        request.setAttribute("courses", courses);
        
        // Lấy tổng số khóa học để tính tổng số trang
        int totalCourses = courseDAO.countFilteredCourses(category, priceOrder, ratingOrder);
        int totalPages = (int) Math.ceil((double) totalCourses / limit);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);

        // Giữ lại giá trị đã chọn khi lọc
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedPriceOrder", priceOrder);
        request.setAttribute("selectedRatingOrder", ratingOrder);

        request.getRequestDispatcher("jsp/course.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
