package dal;

import Model.CourseEX;
import dal.CourseDao;
import dal.DBContext;
import java.util.*;
import java.lang.*;
import java.io.*;
import java.sql.*;

public class CourseEXDAO extends DBContext {

    public List<CourseEX> searchCoursesByName(String keyword) {
        List<CourseEX> courses = new ArrayList<>();
        String sql = "SELECT * FROM CourseEX WHERE Name LIKE ?";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                courses.add(new CourseEX(
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
    
    public CourseEX getCourseByIdEx(int courseId) {
    String sql = "SELECT * FROM Courses WHERE CourseID = ? AND Status != 0";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setInt(1, courseId);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            CourseEX course = new CourseEX();
            course.setCourseID(rs.getInt("CourseID"));
            course.setName(rs.getString("Name"));
            course.setDescription(rs.getString("Description"));
            course.setPrice(rs.getFloat("Price"));
            course.setStatus(rs.getInt("Status"));
            return course;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
   public int createCourse(String name, String description, double price, String imageCources, int userID, int categoryID) {
        String sql = "INSERT INTO Courses (Name, Description, Price, imageCources, UserID, CategoryID, CreatedAt, Status) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), 1)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, price);
            ps.setString(4, imageCources);
            ps.setInt(5, userID);
            ps.setInt(6, categoryID);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; 
    }

    public int getLastInsertedCourseId() {
        String sql = "SELECT MAX(CourseID) as lastId FROM Courses";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("lastId");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void deleteCourse(int courseID) {
        String sql = "UPDATE Courses SET Status = 0 WHERE CourseID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, courseID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<CourseEX> getAllCourses() {
        List<CourseEX> courses = new ArrayList<>();
        String query = "SELECT CourseID, Name, Description, imageCources FROM Courses";

        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                courses.add(new CourseEX(
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

    public CourseEX getCourseByIdd(int courseId) {
        String query = "SELECT CourseID, Name,Price, imageCources,Description FROM Courses WHERE CourseID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(query);

            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new CourseEX(
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

    public List<CourseEX> getCourseByUserId(int userID) {
        List<CourseEX> courseList = new ArrayList<>();
        String query = "SELECT c.CourseID, c.Name, c.Description, c.Status, c.Price "
                + "FROM Courses c "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "WHERE c.UserID = ? AND u.RoleID = 2";

        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CourseEX course = new CourseEX(
                            rs.getInt("CourseID"),
                            rs.getString("Name"),
                            rs.getString("Description"),
                            rs.getFloat("Price"),
                            rs.getInt("Status")
                    );
                    courseList.add(course);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return courseList;
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

    public void updateCourseStatus(int courseId, int status) throws SQLException {
        String sql = "UPDATE Courses SET status = ? WHERE courseId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, courseId);
            ps.executeUpdate();
        }
    }

    public CourseEX getCourseById(int courseId) {
        String query = "SELECT CourseID, Name, Description, imageCources FROM Courses WHERE CourseID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new CourseEX(
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
        return new CourseEX(0, "Unknown", "default.jpg", "No description available");
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
//        List<CourseEX> courses = coursedao.getFilteredCourses(category, priceOrder, ratingOrder, offset, limit);

        // In danh sách khóa học
//        for (CourseEX course : courses) {
//            System.out.println("CourseID: " + course.getCourseID() + ", Name: " + course.getName() + ", Price: " + course.getPrice() + ", Rating: " + course.getAverageRating());
//        }
    }

}
