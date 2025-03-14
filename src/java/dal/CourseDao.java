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

    public List<Courses> getFilteredCourses(String category, String priceOrder, String ratingOrder, int offset, int limit) {
        List<Courses> courses = new ArrayList<>();
        String sql = "SELECT c.CourseID, c.Name, c.Description, c.Price, c.imageCources, "
                + "cat.CategoryName, u.FullName AS InstructorName, COALESCE(AVG(f.Rating), 0) AS AvgRating "
                + "FROM Courses c "
                + "JOIN Category cat ON c.CategoryID = cat.CategoryID "
                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
                + "JOIN Users u ON c.UserID = u.UserID ";

        List<String> conditions = new ArrayList<>();
        if (category != null) {
            conditions.add("cat.CategoryID = ?");
        }

        sql += conditions.isEmpty() ? "" : " WHERE " + String.join(" AND ", conditions);
        sql += " GROUP BY c.CourseID, c.Name, c.Description, c.Price, c.imageCources, cat.CategoryName, u.FullName ";

        // Thêm điều kiện sắp xếp nếu có
        List<String> orderList = new ArrayList<>();
        if ("low-high".equals(priceOrder)) {
            orderList.add("c.Price ASC");
        } else if ("high-low".equals(priceOrder)) {
            orderList.add("c.Price DESC");
        }
        if ("high".equals(ratingOrder)) {
            orderList.add("AvgRating DESC");
        } else if ("low".equals(ratingOrder)) {
            orderList.add("AvgRating ASC");
        }

        if (!orderList.isEmpty()) {
            sql += " ORDER BY " + String.join(", ", orderList);
        } else {
            sql += " ORDER BY c.CourseID"; // Mặc định sắp xếp theo ID
        }

        // Phân trang
        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (category != null) {
                ps.setInt(index++, Integer.parseInt(category));
            }
            ps.setInt(index++, offset);
            ps.setInt(index++, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    courses.add(new Courses(
                            rs.getInt("CourseID"),
                            rs.getString("Name"),
                            rs.getString("Description"),
                            rs.getFloat("Price"),
                            rs.getString("imageCources"),
                            rs.getString("CategoryName"),
                            rs.getString("InstructorName"),
                            rs.getDouble("AvgRating")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return courses;
    }

    public int countFilteredCourses(String category, String priceOrder, String ratingOrder) {
        int count = 0;
        String sql = "SELECT COUNT(*) AS total FROM Courses c JOIN Category cat ON c.CategoryID = cat.CategoryID ";

        List<String> conditions = new ArrayList<>();
        if (category != null && !category.isEmpty()) {
            conditions.add("cat.CategoryID = ?");
        }

        sql += conditions.isEmpty() ? "" : " WHERE " + String.join(" AND ", conditions);

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (category != null && !category.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(category));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("total");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public static void main(String[] args) {
        CourseDao coursedao = new CourseDao();
        String category = "1"; // ID của category cần lọc
        String priceOrder = "low-high"; // Sắp xếp giá từ thấp đến cao
        String ratingOrder = "high"; // Sắp xếp đánh giá từ cao xuống thấp
        int totalCourses = coursedao.countFilteredCourses(category, priceOrder, ratingOrder);
        System.out.println("Total courses found: " + totalCourses);
        int offset = 0; // Trang đầu tiên
        int limit = 5; // Số lượng kết quả tối đa mỗi lần truy vấn
        List<Courses> courses = coursedao.getFilteredCourses(category, priceOrder, ratingOrder, offset, limit);

        // In danh sách khóa học
        for (Courses course : courses) {
            System.out.println("CourseID: " + course.getCourseID() + ", Name: " + course.getName() + ", Price: " + course.getPrice() + ", Rating: " + course.getAverageRating());
        }
    }

}
