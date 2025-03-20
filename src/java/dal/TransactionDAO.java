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
                + "p.Amount AS PaidAmount,  t.Status, t.CreatedAt "
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

    public void insertTransaction(Transaction transaction, boolean isSuccess) {
        String sql = "INSERT INTO TransactionHistory (PayID, Status, CreatedAt, CourseID, PaymentDate) VALUES (?, ?, GETDATE(), ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transaction.getPayid());               // Set PayID
            ps.setInt(2, isSuccess ? 1 : 0);                   // Set Status: 1 for success, 0 for failure
            ps.setInt(3, transaction.getCourseID());           // Set CourseID

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
        TransactionDAO transactionDAO = new TransactionDAO();

        int userId = 6; // Thay bằng UserID thực tế cần kiểm tra
        List<Transaction> transactions = transactionDAO.getTransactionHistoryByUserId(userId);

        // Hiển thị kết quả
        for (Transaction transaction : transactions) {
            System.out.println(transaction);
        }
    }
}
