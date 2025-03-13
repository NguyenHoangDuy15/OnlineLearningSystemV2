/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.SaleController;

import dal.BlogDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;

/**
 *
 * @author THU UYEN
 */
@WebServlet(name = "CreateBlog", urlPatterns = {"/CreateBlog"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class CreateBlog extends HttpServlet {

    private static final String UPLOAD_DIR = "blog_images";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("jsp/createblog.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("rollID") == null || session.getAttribute("userid") == null) {
            request.setAttribute("message", "Bạn cần đăng nhập để tạo blog.");
            request.getRequestDispatcher("LoginServlet").forward(request, response);
            return;
        }

        int roleID = (Integer) session.getAttribute("rollID");
        int userID = (Integer) session.getAttribute("userid");  // Lấy UserID từ session

        if (roleID != 3) {
            request.setAttribute("message", "Bạn không có quyền tạo blog.");
            request.getRequestDispatcher("jsp/createblog.jsp").forward(request, response);
            return;
        }

        String title = request.getParameter("title");
        String detail = request.getParameter("detail");

        // Xử lý file upload
        Part filePart = request.getPart("image");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadPath = getServletContext().getRealPath("") + File.separator + "blog_images";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        // Lưu đường dẫn tương đối để hiển thị ảnh
        String imagePath = "blog_images/" + fileName;

        // Gọi DAO để tạo blog
        BlogDAO blogDAO = new BlogDAO();
        blogDAO.createBlog(title, detail, imagePath, userID, roleID);

        response.sendRedirect("viewownerbloglist");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
