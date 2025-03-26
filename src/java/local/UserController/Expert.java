package local.UserController;

import Model.Category;
import Model.ExpertNew;
import dal.CategoryDao;
import dal.ExpertDao;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author THU UYEN
 */
@WebServlet(name = "Expert", urlPatterns = {"/Expert"})
public class Expert extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy danh sách categories
            CategoryDao categoryDao = new CategoryDao();
            List<Category> categories = categoryDao.getAllCategories();
            request.setAttribute("categories", categories);

            ExpertDao expertDao = new ExpertDao();
            List<ExpertNew> searchResults = null;

            // Lấy từ khóa tìm kiếm và kiểm tra xem có ấn nút Search không
            String keyword = request.getParameter("search");
            String searchSubmitted = request.getParameter("searchSubmitted");

            // Phân trang
            int page = 1;
            int limit = 3; // Giới hạn 3 chuyên gia mỗi trang
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
                searchResults = expertDao.searchExpertsByName(keyword, offset, limit);
                System.out.println("Search results size in Servlet: " + (searchResults != null ? searchResults.size() : 0)); // Thêm log
                request.setAttribute("searchResults", searchResults);
                request.setAttribute("keyword", keyword);

                // Tính tổng số trang cho kết quả tìm kiếm
                int totalSearchExperts = expertDao.countSearchExperts(keyword);
                int totalSearchPages = (int) Math.ceil((double) totalSearchExperts / limit);
                request.setAttribute("totalPages", totalSearchPages);
                request.setAttribute("currentPage", page);
            } else {
                // Nếu không có tìm kiếm, hiển thị tất cả chuyên gia hoặc theo bộ lọc
                String category = request.getParameter("category");
                String ratingOrder = request.getParameter("ratingOrder");

                // Xử lý category
                if (category == null || category.trim().isEmpty() || "0".equals(category)) {
                    category = null;
                }

                // Xử lý ratingOrder, chỉ chấp nhận "ASC" hoặc "DESC"
                if (ratingOrder == null || ratingOrder.trim().isEmpty() || "0".equals(ratingOrder)
                        || (!ratingOrder.equalsIgnoreCase("ASC") && !ratingOrder.equalsIgnoreCase("DESC"))) {
                    ratingOrder = null;
                }

                // Lấy danh sách chuyên gia có phân trang
                List<ExpertNew> experts = expertDao.getFilteredExperts(category, ratingOrder, offset, limit);
                System.out.println("Experts size in Servlet: " + (experts != null ? experts.size() : 0)); // Thêm log
                request.setAttribute("experts", experts);

                // Tính tổng số trang
                int totalExperts = expertDao.countFilteredExperts(category, ratingOrder);
                int totalPages = (int) Math.ceil((double) totalExperts / limit);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", page);

                // Giữ lại giá trị đã chọn khi lọc
                request.setAttribute("selectedCategory", category);
                request.setAttribute("selectedRatingOrder", ratingOrder);
            }

            // Forward sang JSP
            request.getRequestDispatcher("jsp/Instructor.jsp").forward(request, response);

        } catch (Exception e) {
            // Xử lý lỗi, in log và chuyển sang trang lỗi nếu cần
            System.err.println("Error in Expert Servlet doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("search");
        // Encode keyword để tránh lỗi URL
        String encodedKeyword = keyword != null ? URLEncoder.encode(keyword, StandardCharsets.UTF_8.toString()) : "";
        String redirectUrl = "Expert?search=" + encodedKeyword + "&searchSubmitted=true";
        response.sendRedirect(redirectUrl);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for handling expert listing and filtering";
    }
}
