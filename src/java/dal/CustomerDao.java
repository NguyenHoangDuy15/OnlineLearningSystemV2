/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Model.Courses;
import Model.CustomerCourse;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

/**
 *
 * @author Administrator
 */
public class CustomerDao extends DBContext {

    public List<CustomerCourse> getAllCourses() {
        List<CustomerCourse> courses = new ArrayList<>();
        String sql = "SELECT "
                + "c.CourseID, "
                + "c.Name AS CourseName, "
                + "c.imageCources, "
                + "u.FullName AS ExpertName, "
                + "c.Price, "
                + "COALESCE(AVG(f.Rating), 0) AS AverageRating, "
                + "COUNT(f.Rating) AS TotalReviews "
                + "FROM Courses c "
                + "INNER JOIN Users u ON c.UserID = u.UserID "
                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
                + "GROUP BY c.CourseID, c.Name, c.imageCources, u.FullName, c.Price;";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                courses.add(new CustomerCourse(
                        rs.getInt("CourseID"),
                        rs.getString("CourseName"),
                        rs.getFloat("Price"),
                        rs.getString("ExpertName"),
                        rs.getString("imageCources")// Đổi Instructor thành ExpertName
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public List<Courses> getTop5Courses() {
        List<Courses> courses = new ArrayList<>();
        String sql = "SELECT TOP 5 "
                + "    c.CourseID, "
                + "    c.Name AS CourseName, "
                + "    c.imageCources, "
                + "    u.FullName AS ExpertName, "
                + "    c.Price, "
                + "    COALESCE(AVG(f.Rating), 0) AS AverageRating, "
                + "    (SELECT COUNT(*) FROM Enrollments e WHERE e.CourseID = c.CourseID) AS TotalEnrollments "
                + "FROM Courses c "
                + "INNER JOIN Users u ON c.UserID = u.UserID "
                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
                + "GROUP BY c.CourseID, c.Name, c.imageCources, u.FullName, c.Price "
                + "ORDER BY AverageRating DESC, TotalEnrollments DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Courses course = new Courses(
                        rs.getInt("CourseID"),
                        rs.getString("CourseName"),
                        rs.getString("imageCources"),
                        rs.getString("ExpertName"),
                        rs.getFloat("Price"),
                        rs.getDouble("AverageRating"),
                        rs.getInt("TotalEnrollments")
                );
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public static void main(String[] args) {
        CustomerDao customerDao = new CustomerDao();
     
            List<Courses> courses = customerDao.getTop5Courses();

            // Hiển thị danh sách khóa học
            for (Courses course : courses) {
                System.out.println("ID: " + course.getCourseID());
                System.out.println("Tên khóa học: " + course.getName());
                System.out.println("Giá: " + course.getPrice());
                System.out.println("Giảng viên: " + course.getExpertName());
                System.out.println("Đánh giá trung bình: " + course.getAverageRating());
                System.out.println("Số lượng đăng ký: " + course.getTotalenrollment());
                System.out.println("-------------------------");
            }
        } 
}
