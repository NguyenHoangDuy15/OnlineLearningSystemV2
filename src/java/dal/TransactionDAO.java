/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Model.Payments;
import Model.Transaction;
import dal.DBContext;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

/**
 *
 * @author Administrator
 */
public class TransactionDAO extends DBContext {

    public List<Transaction> getTransactionHistoryByUserId(int userId) {
        List<Transaction> historyList = new ArrayList<>();
        String sql = "SELECT t.TransactionID, p.UserID, t.CourseID, c.Name AS CourseName, "
                + "p.Amount AS PaidAmount, t.PaymentMethod, t.Status, t.CreatedAt "
                + "FROM TransactionHistory t "
                + "JOIN Payment p ON t.PayID = p.PayID "
                + "JOIN Courses c ON t.CourseID = c.CourseID "
                + "WHERE t.Status = 1 AND p.UserID = ? "
                + "ORDER BY t.CreatedAt ASC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transaction th = new Transaction(
                            rs.getInt("TransactionID"),
                            rs.getInt("UserID"),
                            rs.getInt("CourseID"),
                            rs.getString("CourseName"),
                            rs.getDouble("PaidAmount"),
                            rs.getString("PaymentMethod"),
                            rs.getInt("Status"),
                            rs.getDate("CreatedAt")
                    );
                    historyList.add(th);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return historyList;
    }

    public boolean isUserEnrolled(int userID, int courseID) {
        String sql = "SELECT * FROM Enrollments WHERE UserID = ? AND CourseID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setInt(2, courseID);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // Trả về true nếu có bản ghi
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int insertPayment(Payments payment) {
        String sql = "INSERT INTO Payment (UserID, CourseID, Amount) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getUserid());
            ps.setInt(2, payment.getCourseid());
            ps.setDouble(3, payment.getAmount());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // Lấy PaymentID vừa tạo
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Trả về -1 nếu có lỗi
    }

    public void insertTransaction(Transaction transaction) {
        String sql = "INSERT INTO TransactionHistory (PayID, Status, CreatedAt, CourseID, PaymentMethod) VALUES (?, 1, GETDATE(), ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transaction.getPayid());

            ps.setInt(2, transaction.getCourseID());
            ps.setString(3, transaction.getPaymentMethod());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void enrollUser(int userID, int courseID) {
        String sql = "INSERT INTO Enrollments (UserID, CourseID, Status, EnrolledAt) VALUES (?, ?, 1 , GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setInt(2, courseID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        TransactionDAO dao = new TransactionDAO();
        int userID = 6; // ID người dùng
        int courseID = 8; // ID khóa học
        double amount = 170.000; // Số tiền thanh toán
        String paymentMethod = "Credit Card"; // Phương thức thanh toán

        // 1. Kiểm tra nếu user đã đăng ký khóa học chưa
        if (dao.isUserEnrolled(userID, courseID)) {
            System.out.println("Người dùng đã đăng ký khóa học này!");

            return;
        }

        // 2. Thêm thanh toán vào bảng Payments
        // 2. Thêm thanh toán vào bảng Payments
        // 2. Thêm thanh toán vào bảng Payments
        Payments payment = new Payments(userID, courseID, amount);
        int payID = dao.insertPayment(payment);

        if (payID <= 0) {  // Kiểm tra nếu payID không hợp lệ
            System.out.println("Lỗi khi thêm thanh toán! Không thể tiếp tục.");
            return;
        }

        System.out.println("Thanh toán thành công, PayID: " + payID); // Debug xem PayID có hợp lệ không

// 3. Thêm vào bảng TransactionHistory
        Transaction transaction = new Transaction(payID, courseID, paymentMethod);
        dao.insertTransaction(transaction);

        // 4. Cập nhật đăng ký khóa học
        dao.enrollUser(userID, courseID);

        // Commit giao dịch sau khi tất cả thành công
        System.out.println("Giao dịch thành công!");

    }
}
