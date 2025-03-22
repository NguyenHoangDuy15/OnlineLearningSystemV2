package local.UserController;

import Model.Payments;
import Model.Transaction;
import dal.TransactionDAO;
import dal.VNPayUtils;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "VNPAYReturnServlet", urlPatterns = {"/VNPAYReturnServlet"})
public class VNPAYReturnServlet extends HttpServlet {

    private static final String VNP_HASH_SECRET = "5KHHKTNBTNGL9PTDF2YOA1AJZMMMMEC7"; // Replace with actual Secret Key

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Map<String, String> params = new HashMap<>();

        // Collect all parameters returned by VNPay
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            params.put(entry.getKey(), entry.getValue()[0]);
        }

        // Verify the secure hash to ensure data integrity
        String vnp_SecureHash = params.remove("vnp_SecureHash");
        String generatedHash = VNPayUtils.hmacSHA512(VNP_HASH_SECRET, VNPayUtils.createQueryString(params));

        Payments tempPayment = (Payments) session.getAttribute("tempPayment");

        // Get context path dynamically to ensure correct URL
        String contextPath = request.getContextPath();
        String paymentServletUrl = contextPath + "/VNPAYServlet";

        // Check for critical errors and redirect to payment servlet
        if (tempPayment == null) {
            response.sendRedirect(paymentServletUrl); // Redirect with context path
            return;
        }

        if (!generatedHash.equals(vnp_SecureHash)) {
            response.sendRedirect(paymentServletUrl); // Redirect with context path
            return;
        }

        TransactionDAO paymentDAO = new TransactionDAO();
        int payID = paymentDAO.insertPayment(tempPayment);

        // Check if payment insertion failed (critical error)
        if (payID <= 0) {
            response.sendRedirect(paymentServletUrl); // Redirect with context path
            return;
        }

        // Create a transaction object with the generated payID and courseID
        Transaction transaction = new Transaction(payID, tempPayment.getCourseid());

        String vnp_ResponseCode = params.get("vnp_ResponseCode");
        if ("00".equals(vnp_ResponseCode)) {
            // Transaction successful
            paymentDAO.insertTransaction(transaction, true); // Status = 1 (success)
            paymentDAO.enrollUser(tempPayment.getUserid(), tempPayment.getCourseid());

            request.setAttribute("message", "Transaction successful!");
            request.setAttribute("orderId", params.get("vnp_TxnRef"));
            request.setAttribute("amount", params.get("vnp_Amount"));
            request.setAttribute("bankCode", params.get("vnp_BankCode"));

            // Clean up temporary data from session
            session.removeAttribute("tempPayment");
        } else {
            // Transaction failed (e.g., canceled by user or VNPay error)
            paymentDAO.insertTransaction(transaction, false); // Status = 0 (failure)
            request.setAttribute("message", "Transaction failed! Error code: " + vnp_ResponseCode + ". Please try again.");
            request.setAttribute("retryUrl", paymentServletUrl); // Manual retry to payment servlet
        }

        // Forward to the result page for success or failure
        request.getRequestDispatcher("jsp/return.jsp").forward(request, response);
    }
}
