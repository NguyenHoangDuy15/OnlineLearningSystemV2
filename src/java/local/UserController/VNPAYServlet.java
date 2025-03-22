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
import dal.VNPayUtils;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "VNPAYServlet", urlPatterns = {"/VNPAYServlet"})
public class VNPAYServlet extends HttpServlet {

    private static final String VNP_TMN_CODE = "IWEN8M23";  // Mã Website của bạn
    private static final String VNP_HASH_SECRET = "5KHHKTNBTNGL9PTDF2YOA1AJZMMMMEC7"; // Secret Key
    private static final String VNP_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html"; // URL thanh toán của VNPAY
    private static final String RETURN_URL = "http://localhost:8080/LearningOnlineSystem/VNPAYReturnServlet"; // Trang xử lý sau khi thanh toán

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
            request.getRequestDispatcher("jsp/PaymentVN.jsp").forward(request, response);
            return;
        }

        response.sendRedirect("jsp/Error.jsp"); // Nếu không có courseId thì chuyển hướng đến trang lỗi
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        Integer userID = (Integer) session.getAttribute("userid");
        Integer courseID = (Integer) session.getAttribute("courseId");

        if (userID == null || courseID == null) {
            request.setAttribute("message", "Error: No course selected.");
            request.getRequestDispatcher("jsp/PaymentVN.jsp").forward(request, response);
            return;
        }

        String amountStr = request.getParameter("amount");
        double amountDouble;
        try {
            amountDouble = Double.parseDouble(amountStr);
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Error: Invalid amount.");
            request.getRequestDispatcher("jsp/PaymentVN.jsp").forward(request, response);
            return;
        }

        // Store temporary payment data in session
        session.setAttribute("tempPayment", new Payments(userID, courseID, amountDouble));

        long amount = (long) (amountDouble * 100);
        String orderId = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", "2.1.0");
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", VNP_TMN_CODE);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        vnp_Params.put("vnp_TxnRef", orderId);
        vnp_Params.put("vnp_OrderInfo", "Nap tien vao tai khoan");
        vnp_Params.put("vnp_OrderType", "topup");
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", RETURN_URL);
        vnp_Params.put("vnp_IpAddr", request.getRemoteAddr());
        vnp_Params.put("vnp_CreateDate", new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));

        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        for (String fieldName : fieldNames) {
            String value = vnp_Params.get(fieldName);
            if ((value != null) && (!value.isEmpty())) {
                hashData.append(fieldName).append('=').append(URLEncoder.encode(value, "UTF-8"));
                query.append(fieldName).append('=').append(URLEncoder.encode(value, "UTF-8"));
                if (!fieldName.equals(fieldNames.get(fieldNames.size() - 1))) {
                    hashData.append('&');
                    query.append('&');
                }
            }
        }

        String secureHash = VNPayUtils.hmacSHA512(VNP_HASH_SECRET, hashData.toString());
        query.append("&vnp_SecureHash=").append(secureHash);

        String paymentUrl = VNP_URL + "?" + query.toString();
        response.sendRedirect(paymentUrl);
    }
}
