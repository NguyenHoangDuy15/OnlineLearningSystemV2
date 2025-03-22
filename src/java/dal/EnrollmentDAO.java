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
        String sql = "SELECT DISTINCT \n" // Use DISTINCT to avoid duplicates
                + "    e.EnrollmentID, \n"
                + "    e.UserID, \n"
                + "    u.FullName, \n"
                + "    c.CourseID, \n"
                + "    c.Name AS CourseName, \n"
                + "    c.imageCources, \n"
                + "    c.Description \n"
                + "FROM Enrollments e\n"
                + "JOIN Users u ON e.UserID = u.UserID\n"
                + "JOIN Courses c ON e.CourseID = c.CourseID\n"
                + "WHERE e.Status = 1 \n" // Only get enrollments with Status = 1
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
                        rs.getString("Description")
                );
                enrollments.add(enrollment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return enrollments;
    }

    public Enrollment getEnrollmentStatus(int userId, int courseId) {
        String sql = "SELECT u.UserID, c.CourseID, c.Description AS CourseTitle, e.Status AS EnrollmentStatus "
                + "FROM Users u "
                + "CROSS JOIN Courses c "
                + "LEFT JOIN Enrollments e ON e.UserID = u.UserID AND e.CourseID = c.CourseID "
                + "WHERE u.UserID = ? AND c.CourseID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Enrollment enrollment = new Enrollment();
                    enrollment.setUserId(rs.getInt("UserID"));
                    enrollment.setCourseId(rs.getInt("CourseID"));
                    enrollment.setCourseName(rs.getString("CourseTitle"));
                    enrollment.setPaymentStatus(rs.getInt("EnrollmentStatus"));
                    return enrollment;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
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
