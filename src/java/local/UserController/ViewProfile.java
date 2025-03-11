/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import Model.User;
import Model.Usernew;
import dal.UserDAO;
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
@WebServlet(name = "ViewProfile", urlPatterns = {"/ViewProfile"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
) // Giới hạn ảnh 5MB
public class ViewProfile extends HttpServlet {

    private static final String UPLOAD_DIR = "avatars";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("account"); // Lấy User từ session

        if (user == null) {
            response.sendRedirect("LoginServlet"); // Nếu chưa đăng nhập, chuyển hướng về login
            return;
        }
        UserDAO dao = new UserDAO();
        Usernew userNew = dao.getUserNewByUserId(user.getUserID()); // Chuyển đổi sang Usernew để lấy avatar
        request.setAttribute("user", userNew);
        request.getRequestDispatcher("jsp/viewprofile.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");

        if (user == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");

        Part filePart = request.getPart("avatar");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;

        // Ensure upload directory exists
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        // Save file on server
        String filePath = uploadPath + File.separator + user.getUserID() + "_" + fileName;
        filePart.write(filePath);

        // Save file URL in the database
        String fileUrl = UPLOAD_DIR + "/" + user.getUserID() + "_" + fileName;

        // Cập nhật thông tin user
        UserDAO dao = new UserDAO();
        Usernew userNew = new Usernew(user);// Chuyển đổi từ User sang Usernew
        userNew.setFullName(fullName);
        userNew.setEmail(email);
        if (fileName != null) {
            userNew.setAvatar(fileUrl);
        }
        boolean updateSuccess = dao.updateProfile(userNew);

        if (updateSuccess) {
            session.setAttribute("account", userNew);
        }

        response.sendRedirect("ViewProfile"); // Load lại trang sau khi update
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
