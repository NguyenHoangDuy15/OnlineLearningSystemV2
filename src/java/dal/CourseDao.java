/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import Model.Courses;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class CourseDao extends DBContext {

    public List<Courses> searchCoursesByName(String keyword) {
        List<Courses> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses WHERE Name LIKE ?";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                courses.add(new Courses(
                        rs.getInt("CourseID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getFloat("Price")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public List<Courses> getAllCourses() {
        List<Courses> courses = new ArrayList<>();
        String query = "SELECT CourseID, Name, Description, imageCources FROM Courses";

        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                courses.add(new Courses(
                        rs.getInt("CourseID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getString("imageCources")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return courses;
    }

    public Courses getCourseByIdd(int courseId) {
        String query = "SELECT CourseID, Name,Price, imageCources,Description FROM Courses WHERE CourseID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(query);

            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Courses(
                            rs.getInt("CourseID"),
                            rs.getString("Name"),
                            rs.getFloat("Price"),
                            rs.getString("imageCources"),
                            rs.getString("Description")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Courses getCourseDetails(int courseId) {
        Courses course = null;
        String sql = "SELECT c.CourseID, c.Name, u.FullName AS ExpertName, c.Price, "
                + "COALESCE(AVG(f.Rating), 0) AS AverageRating, COUNT(f.Rating) AS TotalReviews "
                + "FROM Courses c "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
                + "WHERE c.CourseID = ? "
                + "GROUP BY c.CourseID, c.Name, u.FullName, c.Price";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                course = new Courses(
                        rs.getInt("CourseID"),
                        rs.getString("Name"),
                        rs.getString("ExpertName"),
                        rs.getFloat("Price"),
                        rs.getDouble("AverageRating"),
                        rs.getInt("TotalReviews")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return course;
    }

    public List<Courses> getCourseByUserId(int userID) {
        List<Courses> courseList = new ArrayList<>();
        String query = "SELECT c.CourseID, c.Name, c.Description, c.Price FROM Courses c "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "WHERE c.UserID = ? AND u.RoleID = 2";

        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, userID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Courses course = new Courses(
                            rs.getInt("CourseID"),
                            rs.getString("Name"),
                            rs.getString("Description"),
                            rs.getFloat("Price")
                    );
                    courseList.add(course); // Add the course to the list
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return courseList; // Return the list of courses
    }

    public void addCourse(String courseName, String description, double price, String imageCourses, String expertId, int categoryId) {
        String sql = "INSERT INTO Courses (Name, Description, Price, imageCources, UserID, CategoryID, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, courseName);
            ps.setString(2, description);
            ps.setDouble(3, price);
            ps.setString(4, imageCourses);
            ps.setString(5, expertId);
            ps.setInt(6, categoryId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteCourse(String courseId) {
        String sql = "DELETE FROM Courses WHERE CourseID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, courseId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Courses getCourseById(int courseId) {
        String query = "SELECT CourseID, Name, Description, imageCources FROM Courses WHERE CourseID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Courses(
                            rs.getInt("CourseID"),
                            rs.getString("Name"),
                            rs.getString("imageCources"),
                            rs.getString("Description")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Nếu không tìm thấy, trả về một đối tượng mặc định thay vì null
        return new Courses(0, "Unknown", "default.jpg", "No description available");
    }

    public static void main(String[] args) {
        CourseDao courseDAO = new CourseDao();

        // Nhập CourseID cần kiểm tra (ví dụ: 1)
        int courseId = 1;

        Courses course = courseDAO.getCourseDetails(courseId);

        if (course != null) {
            System.out.println(" Course ID: " + course.getCourseID());
            System.out.println(" Course Name: " + course.getName());
            System.out.println(" Instructor: " + course.getExpertName());
            System.out.println(" Price: $" + course.getPrice());
            System.out.println(" Average Rating: " + course.getAverageRating());
            System.out.println(" Total Reviews: " + course.getTotalReviews());
        } else {
            System.out.println("️ Course not found with ID: " + courseId);
        }
    }

}
