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

    public List<Courses> getTop5PopularCourses() {
        List<Courses> courses = new ArrayList<>();
        String sql = "SELECT TOP 5 "
                + "    c.CourseID, "
                + "    c.Name AS CourseName, "
                + "    c.imageCources, "
                + "    u.FullName AS ExpertName, "
                + "    c.Price, "
                + "    c.Status, "
                + "    COALESCE(AVG(f.Rating), 0) AS AverageRating, "
                + "    COUNT(DISTINCT e.EnrollmentID) AS TotalStudents, "
                + "    COUNT(DISTINCT f.FeedbackID) AS TotalFeedbacks "
                + "FROM Courses c "
                + "INNER JOIN Users u ON c.UserID = u.UserID "
                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
                + "LEFT JOIN Enrollments e ON c.CourseID = e.CourseID "
                + "WHERE c.Status = 4 "
                + "GROUP BY c.CourseID, c.Name, c.imageCources, u.FullName, c.Price, c.Status "
                + "ORDER BY TotalStudents DESC, TotalFeedbacks DESC;";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Courses course = new Courses();
                course.setCourseID(rs.getInt("CourseID"));
                course.setName(rs.getString("CourseName"));
                course.setImage(rs.getString("imageCources"));
                course.setExpertName(rs.getString("ExpertName"));
                course.setPrice(rs.getFloat("Price"));
                course.setCourseStatus(rs.getInt("Status"));
                course.setAverageRating(rs.getDouble("AverageRating"));
                course.setTotalenrollment(rs.getInt("TotalStudents"));

                courses.add(course);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return courses;
    }

    public List<Courses> getTopCourses(int userId) throws SQLException {
        List<Courses> courses = new ArrayList<>();
        String sql = "WITH TopCourses AS ("
                + "    SELECT c.CourseID, c.Name AS CourseName, c.imageCources, "
                + "        u.FullName AS ExpertName, c.Price, c.Status, "
                + "        COALESCE(AVG(f.Rating), 0) AS AverageRating "
                + "    FROM Courses c "
                + "    INNER JOIN Users u ON c.UserID = u.UserID "
                + "    LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
                + "    WHERE c.Status = 4 "
                + "    GROUP BY c.CourseID, c.Name, c.imageCources, u.FullName, c.Price, c.Status "
                + ") "
                + "SELECT TOP 5 tc.CourseID, tc.CourseName, tc.imageCources, "
                + "    tc.ExpertName, tc.Price, tc.Status, tc.AverageRating, "
                + "    COUNT(DISTINCT e.UserID) AS TotalStudents, "
                + "    MAX(e.Status) AS EnrollmentStatus, "
                + "    MAX(CASE WHEN e.UserID = ? THEN e.Status ELSE NULL END) AS UserEnrollStatus "
                + "FROM TopCourses tc "
                + "LEFT JOIN Enrollments e ON tc.CourseID = e.CourseID "
                + "GROUP BY tc.CourseID, tc.CourseName, tc.imageCources, tc.ExpertName, "
                + "    tc.Price, tc.Status, tc.AverageRating "
                + "ORDER BY tc.AverageRating DESC, TotalStudents DESC;";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Courses course = new Courses();
                    course.setCourseID(rs.getInt("CourseID"));
                    course.setName(rs.getString("CourseName"));
                    course.setImage(rs.getString("imageCources"));
                    course.setExpertName(rs.getString("ExpertName"));
                    course.setPrice(rs.getFloat("Price"));
                    course.setCourseStatus(rs.getInt("Status"));
                    course.setAverageRating(rs.getDouble("AverageRating"));
                    course.setTotalenrollment(rs.getInt("TotalStudents"));
                    course.setStatusss(rs.getInt("UserEnrollStatus"));
                    courses.add(course);
                }
            }
        }
        return courses;
    }

}
