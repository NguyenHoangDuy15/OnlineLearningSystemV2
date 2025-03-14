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
        String sql = "SELECT \n"
                + "    e.EnrollmentID, \n"
                + "    e.UserID, \n"
                + "    u.FullName, \n"
                + "    c.CourseID, \n"
                + "    c.Name AS CourseName, \n"
                + "    c.imageCources, \n"
                + "    c.Description, \n"
                + "    COALESCE(t.Status, 0) AS PaymentStatus -- Nếu chưa thanh toán, đặt mặc định là 0\n"
                + "FROM Enrollments e\n"
                + "JOIN Users u ON e.UserID = u.UserID\n"
                + "JOIN Courses c ON e.CourseID = c.CourseID\n"
                + "LEFT JOIN TransactionHistory t ON t.CourseID = e.CourseID AND t.Status = 1 -- Giữ các khóa học dù chưa thanh toán\n"
                + "WHERE u.RoleID = 4 \n"
                + "AND e.UserID = ?;";

        try {
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
        int testUserId = 6; // Thay đổi ID người dùng để kiểm tra
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
