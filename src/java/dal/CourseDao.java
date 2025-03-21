/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Model.CoursePrint;
import java.sql.*;
import Model.Courses;
import Model.History;
import Model.MoneyHistoryByAdmin;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class CourseDao extends DBContext {

    public List<Courses> searchCoursesByName(String keyword, int offset, int limit) {
        List<Courses> courses = new ArrayList<>();
        String sql = "SELECT "
                + "    c.CourseID, "
                + "    c.Name, "
                + "    c.Description, "
                + "    c.Price, "
                + "    c.imageCources, "
                + "    cat.CategoryName, "
                + "    u.FullName AS InstructorName, "
                + "    COALESCE(AVG(f.Rating), 0) AS AvgRating, "
                + "    COUNT(DISTINCT e.UserID) AS EnrollmentCount "
                + "FROM Courses c "
                + "LEFT JOIN Category cat ON c.CategoryID = cat.CategoryID "
                + "LEFT JOIN Users u ON c.UserID = u.UserID "
                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
                + "LEFT JOIN Enrollments e ON c.CourseID = e.CourseID "
                + "WHERE c.Status = 4 AND c.Name LIKE ? "
                + "GROUP BY c.CourseID, c.Name, c.Description, c.Price, c.imageCources, cat.CategoryName, u.FullName "
                + "ORDER BY c.CourseID "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, "%" + keyword + "%");
            stmt.setInt(2, offset);
            stmt.setInt(3, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                courses.add(new Courses(
                        rs.getInt("CourseID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getFloat("Price"),
                        rs.getString("imageCources"),
                        rs.getString("CategoryName"),
                        rs.getString("InstructorName"),
                        rs.getDouble("AvgRating"),
                        rs.getInt("EnrollmentCount")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public int countSearchCoursesss(String keyword) {
        int count = 0;
        String sql = "SELECT COUNT(DISTINCT c.CourseID) AS total "
                + "FROM Courses c "
                + "LEFT JOIN Category cat ON c.CategoryID = cat.CategoryID "
                + "LEFT JOIN Users u ON c.UserID = u.UserID "
                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
                + "LEFT JOIN Enrollments e ON c.CourseID = e.CourseID "
                + "WHERE c.Status = 4 AND c.Name LIKE ?";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
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

    public int countRegisteredCourses(int userId) {
        String sql = "SELECT COUNT(*) AS RegisteredCourses FROM Enrollments WHERE UserID = ? AND Status = 1";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("RegisteredCourses");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countCompletedCourses(int userId) {
        String sql = "SELECT COUNT(DISTINCT CourseID) AS CompletedCourses FROM History WHERE UserID = ? AND CourseStatus = 1";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("CompletedCourses");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
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

    public Courses getCourseDetail(int courseId) {
        String query = "SELECT "
                + "    c.CourseID, "
                + "    c.Name, "
                + "    u.FullName AS ExpertName, "
                + "    c.Price, "
                + "     COALESCE(AVG(CASE WHEN f.Status = 1 THEN f.Rating END), 0) AS AverageRating, "
                + "    COUNT(e.EnrollmentID) AS TotalEnrollment "
                + "FROM Courses c "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
                + "LEFT JOIN Enrollments e ON c.CourseID = e.CourseID "
                + "WHERE c.CourseID = ? "
                + "GROUP BY c.CourseID, c.Name, u.FullName, c.Price";

        try {
            PreparedStatement stmt = connection.prepareStatement(query);

            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Courses(
                        rs.getInt("CourseID"),
                        rs.getString("Name"),
                        rs.getString("ExpertName"),
                        rs.getFloat("Price"),
                        rs.getDouble("AverageRating"),
                        rs.getInt("TotalEnrollment")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
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
                + "cat.CategoryName, u.FullName AS InstructorName, "
                + " COALESCE(AVG(CASE WHEN f.Status = 1 THEN f.Rating END), 0) AS  AvgRating, "
                + "COUNT(DISTINCT e.UserID) AS EnrollmentCount " // Đếm số người tham gia
                + "FROM Courses c "
                + "JOIN Category cat ON c.CategoryID = cat.CategoryID "
                + "JOIN Users u ON c.UserID = u.UserID "
                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
                + "LEFT JOIN Enrollments e ON c.CourseID = e.CourseID " // Tham gia Enrollments
                + "WHERE c.Status = 4 ";  // Chỉ lấy Course có Status = 4

        List<String> conditions = new ArrayList<>();
        if (category != null) {
            conditions.add("cat.CategoryID = ?");
        }

        if (!conditions.isEmpty()) {
            sql += " AND " + String.join(" AND ", conditions);
        }

        sql += " GROUP BY c.CourseID, c.Name, c.Description, c.Price, c.imageCources, "
                + "cat.CategoryName, u.FullName ";

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
                            rs.getDouble("AvgRating"),
                            rs.getInt("EnrollmentCount") // Số người tham gia
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

    public List<Courses> getCompletedCourses(int userId) {
        List<Courses> completedCourses = new ArrayList<>();
        String sql = "SELECT DISTINCT \n"
                + "    c.CourseID, \n"
                + "    c.Name, \n"
                + "    c.imageCources, \n"
                + "    c.Description, \n"
                + "    CASE \n"
                + "        WHEN h.CourseStatus = 1 THEN 'Hoàn thành' \n"
                + "        ELSE 'Chưa hoàn thành' \n"
                + "    END AS CourseStatus\n"
                + "FROM History h\n"
                + "JOIN Courses c ON h.CourseID = c.CourseID\n"
                + "WHERE h.UserID = ? AND h.CourseStatus = 1;";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    completedCourses.add(new Courses(
                            rs.getInt("CourseID"),
                            rs.getString("Name"),
                            rs.getString("imageCources"),
                            rs.getString("Description"),
                            rs.getString("CourseStatus")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return completedCourses;
    }

    public static void main(String[] args) {
        CourseDao coursedao = new CourseDao();
        System.out.println(coursedao.get5CourseTopForAdmin(1));
    }

    public List<CoursePrint> getAllCourseForAdmin() {
        List<CoursePrint> list = new ArrayList<>();
        String sql = "SELECT \n"
                + "    c.CourseID, \n"
                + "    c.Name AS CourseName, \n"
                + "    c.Description, \n"
                + "    u.FullName AS CreatedBy, \n"
                + "    c.Price\n"
                + "FROM \n"
                + "    Courses c\n"
                + "JOIN \n"
                + "    Users u ON c.UserID = u.UserID\n"
                + "Where\n"
                + "	c.Status = 4;";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CoursePrint m = new CoursePrint(rs.getInt("CourseID"),
                        rs.getString("CourseName"), rs.getString("Description"),
                        rs.getString("CreatedBy"), rs.getFloat("Price"));
                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<CoursePrint> get5CourseForAdmin(int index) {
        List<CoursePrint> list = new ArrayList<>();
        String sql = "SELECT \n"
                + "    c.CourseID, \n"
                + "    c.Name AS CourseName, \n"
                + "    c.Description, \n"
                + "    u.FullName AS CreatedBy, \n"
                + "    c.Price\n"
                + "FROM \n"
                + "    Courses c\n"
                + "JOIN \n"
                + "    Users u ON c.UserID = u.UserID\n"
                + "Where\n"
                + "	c.Status = 4\n"
                + "ORDER BY CourseID OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY;";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CoursePrint m = new CoursePrint(rs.getInt("CourseID"),
                        rs.getString("CourseName"), rs.getString("Description"),
                        rs.getString("CreatedBy"), rs.getFloat("Price"));
                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<CoursePrint> getAllCourseRequestForAdmin() {
        List<CoursePrint> list = new ArrayList<>();
        String sql = "SELECT \n"
                + "    c.CourseID, \n"
                + "    c.Name AS CourseName, \n"
                + "    c.Description, \n"
                + "    u.FullName AS CreatedBy, \n"
                + "    c.Price\n"
                + "FROM \n"
                + "    Courses c\n"
                + "JOIN \n"
                + "    Users u ON c.UserID = u.UserID\n"
                + "Where\n"
                + "	c.Status = 2;";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CoursePrint m = new CoursePrint(rs.getInt("CourseID"),
                        rs.getString("CourseName"), rs.getString("Description"),
                        rs.getString("CreatedBy"), rs.getFloat("Price"));
                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<CoursePrint> get5CourseRequestForAdmin(int index) {
        List<CoursePrint> list = new ArrayList<>();
        String sql = "SELECT \n"
                + "    c.CourseID, \n"
                + "    c.Name AS CourseName, \n"
                + "    c.Description, \n"
                + "    u.FullName AS CreatedBy, \n"
                + "    c.Price\n"
                + "FROM \n"
                + "    Courses c\n"
                + "JOIN \n"
                + "    Users u ON c.UserID = u.UserID\n"
                + "Where\n"
                + "	c.Status = 2\n"
                + "ORDER BY CourseID OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY;";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CoursePrint m = new CoursePrint(rs.getInt("CourseID"),
                        rs.getString("CourseName"), rs.getString("Description"),
                        rs.getString("CreatedBy"), rs.getFloat("Price"));
                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<CoursePrint> getAllCourseTopForAdmin() {
        List<CoursePrint> list = new ArrayList<>();
        String sql = "SELECT \n"
                + "    c.CourseID, \n"
                + "    c.Name AS 'CourseName', \n"
                + "    c.Description, \n"
                + "    u.FullName AS 'CreatedBy', \n"
                + "    c.Price, \n"
                + "    COUNT(th.TransactionID) AS 'PurchaseCount'\n"
                + "FROM Courses c\n"
                + "JOIN Users u ON c.UserID = u.UserID\n"
                + "LEFT JOIN TransactionHistory th ON c.CourseID = th.CourseID\n"
                + "WHERE c.Status = 4  \n"
                + "GROUP BY c.CourseID, c.Name, c.Description, u.FullName, c.Price\n"
                + "ORDER BY PurchaseCount DESC; ";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CoursePrint m = new CoursePrint(rs.getInt("CourseID"),
                        rs.getString("CourseName"), rs.getString("Description"),
                        rs.getString("CreatedBy"), rs.getFloat("Price"));
                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<CoursePrint> get5CourseTopForAdmin(int index) {
        List<CoursePrint> list = new ArrayList<>();
        String sql = "SELECT \n"
                + "    c.CourseID, \n"
                + "    c.Name AS 'CourseName', \n"
                + "    c.Description, \n"
                + "    u.FullName AS 'CreatedBy', \n"
                + "    c.Price, \n"
                + "    COUNT(th.TransactionID) AS 'PurchaseCount'\n"
                + "FROM Courses c\n"
                + "JOIN Users u ON c.UserID = u.UserID\n"
                + "LEFT JOIN TransactionHistory th ON c.CourseID = th.CourseID\n"
                + "WHERE c.Status = 4  \n"
                + "GROUP BY c.CourseID, c.Name, c.Description, u.FullName, c.Price\n"
                + "ORDER BY PurchaseCount DESC OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY; ";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CoursePrint m = new CoursePrint(rs.getInt("CourseID"),
                        rs.getString("CourseName"), rs.getString("Description"),
                        rs.getString("CreatedBy"), rs.getFloat("Price"));
                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public void updateRequest(String id, String status) {
        String sql = "UPDATE [dbo].[Courses]\n"
                + "   SET [Status] = ?\n"
                + " WHERE CourseID = ?";
        try {
            PreparedStatement rs = connection.prepareStatement(sql);
            rs.setString(1, status);
            rs.setString(2, id);
            rs.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

}
