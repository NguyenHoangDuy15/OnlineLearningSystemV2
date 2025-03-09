/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Model.Enrollment;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

/**
 *
 * @author Administrator
 */
public class EnrollmentDAO extends DBContext {

    public List<Enrollment> getEnrollmentsByUserId(int userId) {
        List<Enrollment> enrollments = new ArrayList<>();
        String sql = "SELECT e.EnrollmentID, e.UserID, u.FullName, c.CourseID, c.Name AS CourseName, " +
                     "c.imageCources, c.Description, t.Status AS PaymentStatus " +
                     "FROM Enrollments e " +
                     "JOIN Users u ON e.UserID = u.UserID " +
                     "JOIN Courses c ON e.CourseID = c.CourseID " +
                     "JOIN TransactionHistory t ON t.CourseID = e.CourseID " +
                     "WHERE t.Status = 1 AND u.RoleID = 4 AND e.UserID = ?";

        try  {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Enrollment enrollment = new Enrollment(
                    rs.getInt("EnrollmentID"),
                    rs.getInt("UserID"),
                    rs.getString("FullName"),
                    rs.getInt("CourseID"),
                    rs.getString("CourseName"),
                    rs.getString("imageCources"),
                    rs.getString("Description"),
                    rs.getInt("PaymentStatus")
                );
                enrollments.add(enrollment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return enrollments;
    }
     public static void main(String[] args) {
        // Tạo đối tượng DAO giả lập (giả sử đã có kết nối)
        EnrollmentDAO enrollmentDAO = new EnrollmentDAO(); // Truyền null vì không cần kết nối

        // Kiểm tra hàm getEnrollmentsByUserId với userId cụ thể
        int testUserId = 2; // Thay đổi ID người dùng để kiểm tra
        List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByUserId(testUserId);

        // In kết quả ra màn hình
        System.out.println("📌 Danh sách khóa học đã đăng ký của User ID: " + testUserId);
        for (Enrollment e : enrollments) {
            System.out.println("Enrollment ID: " + e.getEnrollmentId());
            System.out.println("User ID: " + e.getUserId());
            System.out.println("Full Name: " + e.getFullName());
            System.out.println("Course ID: " + e.getCourseId());
            System.out.println("Course Name: " + e.getCourseName());
            System.out.println("Image: " + e.getImageCourses());
            System.out.println("Description: " + e.getDescription());
            System.out.println("Payment Status: " + (e.getPaymentStatus() == 1 ? "Paid" : "Pending"));
            System.out.println("--------------------------------------------------");
        }
    }
}
