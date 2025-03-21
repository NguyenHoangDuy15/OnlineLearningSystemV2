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
        String sql = "SELECT TOP 5 \n"
                + "    c.CourseID, \n"
                + "    c.Name AS CourseName, \n"
                + "    c.imageCources, \n"
                + "    u.FullName AS ExpertName, \n"
                + "    c.Price, \n"
                + "    c.Status, \n"
                + "    COALESCE(AVG(CASE WHEN f.Status = 1 THEN f.Rating END), 0) AS AverageRating, \n"
                + "    COUNT(DISTINCT e.EnrollmentID) AS TotalStudents, \n"
                + "    COUNT(DISTINCT CASE WHEN f.Status = 1 THEN f.FeedbackID END) AS TotalFeedbacks \n"
                + "FROM Courses c \n"
                + "INNER JOIN Users u ON c.UserID = u.UserID \n"
                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID \n"
                + "LEFT JOIN Enrollments e ON c.CourseID = e.CourseID \n"
                + "WHERE c.Status = 4 \n"
                + "GROUP BY c.CourseID, c.Name, c.imageCources, u.FullName, c.Price, c.Status \n"
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
        String sql = "WITH TopCourses AS (\n"
                + "    SELECT \n"
                + "        c.CourseID, \n"
                + "        c.Name AS CourseName, \n"
                + "        c.imageCources, \n"
                + "        u.FullName AS ExpertName, \n"
                + "        c.Price, \n"
                + "        c.Status, \n"
                + "       COALESCE(AVG(CASE WHEN f.Status = 1 THEN f.Rating END), 0) AS AverageRating\n"
                + "    FROM Courses c\n"
                + "    INNER JOIN Users u ON c.UserID = u.UserID\n"
                + "    LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID\n"
                + "    WHERE c.Status = 4\n"
                + "    GROUP BY c.CourseID, c.Name, c.imageCources, u.FullName, c.Price, c.Status\n"
                + ")\n"
                + "SELECT TOP 5 \n"
                + "    tc.CourseID, \n"
                + "    tc.CourseName, \n"
                + "    tc.imageCources, \n"
                + "    tc.ExpertName, \n"
                + "    tc.Price, \n"
                + "    tc.Status, \n"
                + "    tc.AverageRating, \n"
                + "    COUNT(DISTINCT e.UserID) AS TotalStudents, \n"
                + "    MAX(e.Status) AS EnrollmentStatus, \n"
                + "    MAX(CASE WHEN e.UserID = ?  THEN e.Status ELSE NULL END) AS UserEnrollStatus\n"
                + "FROM TopCourses tc\n"
                + "LEFT JOIN Enrollments e ON tc.CourseID = e.CourseID\n"
                + "GROUP BY \n"
                + "    tc.CourseID, \n"
                + "    tc.CourseName, \n"
                + "    tc.imageCources, \n"
                + "    tc.ExpertName, \n"
                + "    tc.Price, \n"
                + "    tc.Status, \n"
                + "    tc.AverageRating\n"
                + "ORDER BY \n"
                + "    tc.AverageRating DESC, \n"
                + "    TotalStudents DESC;";

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
