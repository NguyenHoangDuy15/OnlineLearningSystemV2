/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.UserController;

import Model.Courses;
import Model.Payments;
import Model.Transaction;
import dal.CourseDao;
import dal.TransactionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "PaymentServlet", urlPatterns = {"/PaymentServlet"})
public class PaymentServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PaymentServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PaymentServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Không tạo session mới nếu chưa có

        // Kiểm tra xem session có tồn tại và có lưu userid không
        if (session == null || session.getAttribute("userid") == null) {
            response.sendRedirect("LoginServlet"); // Chuyển hướng đến đăng xuất hoặc đăng nhập
            return;
        }

        Integer courseId = (Integer) session.getAttribute("courseId");

        if (courseId != null) { // Kiểm tra courseId có tồn tại không
            CourseDao courseDAO = new CourseDao();
            Courses course = courseDAO.getCourseByIdd(courseId);

            request.setAttribute("course", course);
            request.getRequestDispatcher("jsp/Payment.jsp").forward(request, response);
            return;
        }

        response.sendRedirect("jsp/Error.jsp"); // Nếu không có courseId thì chuyển hướng đến trang lỗi
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Lấy giá trị từ session (ép kiểu trực tiếp về Integer)
        Integer userID = (Integer) session.getAttribute("userid");
        Integer courseID = (Integer) session.getAttribute("courseId");

        // Kiểm tra nếu userID hoặc courseID null
        if (userID == null || courseID == null) {
            request.setAttribute("message", "Lỗi: Không tìm thấy thông tin đăng nhập hoặc khóa học.");
            request.getRequestDispatcher("jsp/Payment.jsp").forward(request, response);
            return;
        }

        // Lấy số tiền thanh toán từ request
        String amountStr = request.getParameter("amount");
        double amount = 0;

        try {
            amount = Double.parseDouble(amountStr);
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Lỗi: Số tiền thanh toán không hợp lệ.");
            request.getRequestDispatcher("jsp/Payment.jsp").forward(request, response);
            return;
        }

        // Lấy phương thức thanh toán
        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.isEmpty()) {
            request.setAttribute("message", "Lỗi: Vui lòng chọn phương thức thanh toán.");
            request.getRequestDispatcher("jsp/Payment.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xem user đã đăng ký khóa học chưa
        TransactionDAO paymentDAO = new TransactionDAO();
        if (paymentDAO.isUserEnrolled(userID, courseID)) {
            request.setAttribute("message", "Bạn đã đăng ký khóa học này!");
            request.getRequestDispatcher("jsp/Payment.jsp").forward(request, response);
            return;
        }

        // Thêm thanh toán vào DB
        Payments payment = new Payments(userID, courseID, amount);
        int payID = paymentDAO.insertPayment(payment);

        if (payID > 0) {
            Transaction transaction = new Transaction(payID, courseID, paymentMethod);
            paymentDAO.insertTransaction(transaction);
            paymentDAO.enrollUser(userID, courseID);

            request.setAttribute("message", "Thanh toán thành công! Bạn đã được ghi danh vào khóa học.");
        } else {
            request.setAttribute("message", "Thanh toán thất bại! Vui lòng thử lại.");
        }

        // Chuyển hướng về trang thanh toán
        request.getRequestDispatcher("jsp/Payment.jsp").forward(request, response);
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
