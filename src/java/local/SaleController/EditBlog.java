package local.SaleController;

import Model.Blog;
import Model.User;
import dal.BlogDAO;
import java.io.IOException;
import java.io.File;
import java.nio.file.Paths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(name = "EditBlog", urlPatterns = {"/EditBlog"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class EditBlog extends HttpServlet {

    private static final String UPLOAD_DIR = "blog_images";
    private BlogDAO blogDAO = new BlogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        if (user == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        String blogIDStr = request.getParameter("blogID");
        if (blogIDStr == null || blogIDStr.isEmpty()) {
            response.sendRedirect("viewownerbloglist?error=MissingBlogID");
            return;
        }

        int blogID;
        try {
            blogID = Integer.parseInt(blogIDStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("viewownerbloglist?error=InvalidBlogID");
            return;
        }

        Blog blog = blogDAO.getBlogByID(blogID);
        if (blog == null || blog.getUserID() != user.getUserID()) {
            response.sendRedirect("viewownerbloglist?error=BlogNotFound");
            return;
        }

        request.setAttribute("blog", blog);
        request.getRequestDispatcher("jsp/updateblog.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userid");
        if (userID == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        String blogIDStr = request.getParameter("blogID");
        if (blogIDStr == null || blogIDStr.isEmpty()) {
            response.sendRedirect("viewownerbloglist?error=MissingBlogID");
            return;
        }

        int blogID;
        try {
            blogID = Integer.parseInt(blogIDStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("viewownerbloglist?error=InvalidBlogID");
            return;
        }

        String title = request.getParameter("title").trim();
        String detail = request.getParameter("detail").trim();

        Blog existingBlog = blogDAO.getBlogByID(blogID);
        if (existingBlog == null || existingBlog.getUserID() != userID) {
            response.sendRedirect("viewownerbloglist?error=BlogNotFound");
            return;
        }

        // Xử lý ảnh
        Part filePart = request.getPart("image");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String imagePath = existingBlog.getBlogImage();

        if (filePart != null && fileName != null && !fileName.isEmpty()) {
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);
            imagePath = UPLOAD_DIR + "/" + fileName;
        }

        // Cập nhật blog
        blogDAO.editBlog(blogID, title, detail, imagePath, userID);
        response.sendRedirect("EditBlog?blogID=" + blogID);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for editing blog posts";
    }
}
