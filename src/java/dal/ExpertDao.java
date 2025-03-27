/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Model.Courses;
import Model.Expert;
import Model.ExpertNew;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 *
 * @author Administrator
 */
public class ExpertDao extends DBContext {

    public List<Expert> getAllInstructorCourses() {
        List<Expert> list = new ArrayList<>();
        String sql = "SELECT u.FullName AS username, c.Name AS name "
                + "FROM Users u "
                + "JOIN Courses c ON u.UserID = c.UserID "
                + "JOIN Roles r ON u.RoleID = r.RoleID "
                + "WHERE r.RoleID = 2"; // RoleID = 2 là giảng viên

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Expert(
                        rs.getString("username"),
                        rs.getString("name")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Expert> getAllInstructorCoursesss() {
        List<Expert> list = new ArrayList<>();
        String sql = "SELECT u.FullName AS username, c.Name AS course_name, u.Avartar "
                + "FROM Users u "
                + "JOIN Courses c ON u.UserID = c.UserID "
                + "JOIN Roles r ON u.RoleID = r.RoleID "
                + "WHERE r.RoleID = 2;"; // RoleID = 2 là giảng viên

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Expert(
                        rs.getString("username"),
                        rs.getString("course_name"),
                        rs.getString("Avartar")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Expert> getAllInstructorCourses(String expertId) {
        List<Expert> list = new ArrayList<>();
        // Sửa lại câu truy vấn SQL để lọc theo expertId
        String sql = "SELECT u.FullName AS username, c.Name AS name "
                + "FROM Users u "
                + "JOIN Courses c ON u.UserID = c.UserID "
                + "JOIN Roles r ON u.RoleID = r.RoleID "
                + "WHERE r.RoleID = 2 AND u.UserID = ?"; // Thêm điều kiện để lọc theo UserID (expertId)

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, expertId);  // Sử dụng expertId để thay thế cho dấu hỏi chấm trong câu truy vấn
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Expert(
                        rs.getString("username"),
                        rs.getString("name")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Expert> getExpertsWithCourses() {
        List<Expert> experts = new ArrayList<>();
        String sql = "SELECT DISTINCT u.UserID, u.UserName, u.Email, u.Avartar, c.Name "
                + "FROM Users u "
                + "LEFT JOIN Courses c ON u.UserID = c.UserID "
                + "WHERE u.RoleID = 2 "
                + "ORDER BY u.UserID";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int userID = rs.getInt("UserID");
                String userName = rs.getString("UserName");
                String email = rs.getString("Email");
                String avatar = rs.getString("Avartar");
                String courseName = rs.getString("Name");

                experts.add(new Expert(userID, userName, email, avatar, courseName));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return experts;
    }
//    public List<ExpertNew> getExpertswCourses() {
//    List<ExpertNew> experts = new ArrayList<>();
//    String sql = "SELECT DISTINCT u.UserID, u.UserName, u.FullName, u.Email, u.Avartar, c.Name "
//               + "FROM Users u "
//               + "LEFT JOIN Courses c ON u.UserID = c.UserID "
//               + "WHERE u.RoleID = 2 "
//               + "ORDER BY u.UserID";
//
//    try {
//        PreparedStatement ps = connection.prepareStatement(sql);
//        ResultSet rs = ps.executeQuery();
//        while (rs.next()) {
//            int userID = rs.getInt("UserID");
//            String userName = rs.getString("UserName");
//            String fullName = rs.getString("FullName"); // Thêm FullName
//            String email = rs.getString("Email");
//            String avatar = rs.getString("Avartar");
//            String courseName = rs.getString("Name");
//
//            experts.add(new ExpertNew(userID, userName, fullName, email, avatar, courseName));
//        }
//    } catch (SQLException e) {
//        e.printStackTrace();
//    }
//    return experts;
//}

    public static void main(String[] args) {
        ExpertDao expertDAO = new ExpertDao();
        List<Expert> experts = expertDAO.getAllInstructorCourses();

        // Hiển thị danh sách giảng viên và khóa học của họ
        for (Expert expert : experts) {
            System.out.println("Giảng viên: " + expert.getUsername()
                    + ", Khóa học: " + expert.getCourseName()
                    + ", Avatar: " + expert.getAvatar());
        }
    }

    public String getUserIdByUsernameAndRole(String username) {
        String userId = null;
        String sql = "SELECT u.UserID FROM Users u "
                + "JOIN Roles r ON u.RoleID = r.RoleID "
                + "WHERE r.RoleID = 2 AND u.UserName = ?"; // RoleID = 2 là giảng viên

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);  // Set username vào câu truy vấn
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                userId = rs.getString("UserID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return userId;
    }

//    
   public List<ExpertNew> getFilteredExperts(String category, String ratingOrder, int offset, int limit) {
    List<ExpertNew> experts = new ArrayList<>();
    String sql = "SELECT u.UserID, u.UserName, u.FullName, u.Email, u.Avartar, c.Name AS CourseName, cat.CategoryName, "
            + "f.Rating " // Lấy từng rating thay vì AVG ngay trong SQL
            + "FROM Users u "
            + "LEFT JOIN Courses c ON u.UserID = c.UserID "
            + "LEFT JOIN Category cat ON c.CategoryID = cat.CategoryID "
            + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
            + "WHERE u.RoleID = 2 "
            + (category != null && !category.isEmpty() ? "AND cat.CategoryID = ? " : "")
            + "AND (f.FeedbackID IS NULL OR f.Status = 1) " // Add condition for Feedbacks.Status = 1
            + "ORDER BY u.UserID";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        if (category != null && !category.isEmpty()) {
            ps.setString(1, category);
        }
        ResultSet rs = ps.executeQuery();

        // Map để lưu trữ expert, danh sách khóa học và danh sách rating
        Map<Integer, ExpertNew> expertMap = new LinkedHashMap<>();
        Map<Integer, List<Double>> ratingsMap = new HashMap<>();

        while (rs.next()) {
            int userID = rs.getInt("userID");
            ExpertNew expert = expertMap.get(userID);

            if (expert == null) {
                expert = new ExpertNew();
                expert.setUserID(userID);
                expert.setUserName(rs.getString("userName"));
                expert.setFullName(rs.getString("fullName"));
                expert.setEmail(rs.getString("email"));
                expert.setAvartar(rs.getString("avartar"));
                expert.setCategoryName(rs.getString("categoryName"));
                expertMap.put(userID, expert);
                ratingsMap.put(userID, new ArrayList<>());
            }

            // Thêm khóa học
            String courseName = rs.getString("courseName");
            if (courseName != null && !courseName.equals("No Course")) {
                expert.getCourseNames().add(courseName);
            }

            // Thu thập rating
            double rating = rs.getDouble("Rating");
            if (rs.wasNull()) {
                rating = 0; // Nếu không có rating, gán 0
            }
            ratingsMap.get(userID).add(rating);
        }

        // Tính trung bình rating cho mỗi expert
        for (Map.Entry<Integer, ExpertNew> entry : expertMap.entrySet()) {
            int userID = entry.getKey();
            ExpertNew expert = entry.getValue();
            List<Double> ratings = ratingsMap.get(userID);

            double avgRating = 0;
            if (!ratings.isEmpty()) {
                double sum = 0;
                int count = 0;
                for (Double rating : ratings) {
                    if (rating > 0) { // Chỉ tính rating > 0
                        sum += rating;
                        count++;
                    }
                }
                avgRating = (count > 0) ? sum / count : 0;
            }
            expert.setAvgRating(avgRating);
        }

        // Chuyển map thành list
        experts = new ArrayList<>(expertMap.values());

        // Sắp xếp theo rating nếu cần
        if (ratingOrder != null && !ratingOrder.isEmpty()) {
            experts.sort((e1, e2) -> {
                if ("ASC".equalsIgnoreCase(ratingOrder)) {
                    return Double.compare(e1.getAvgRating(), e2.getAvgRating());
                } else {
                    return Double.compare(e2.getAvgRating(), e1.getAvgRating());
                }
            });
        }

        // Áp dụng phân trang
        int start = Math.min(offset, experts.size());
        int end = Math.min(start + limit, experts.size());
        experts = experts.subList(start, end);

        System.out.println("Experts size in DAO: " + experts.size());
    } catch (SQLException e) {
        System.err.println("SQL Error in getFilteredExperts: " + e.getMessage());
        e.printStackTrace();
    }
    return experts;
}
//    public int countFilteredExperts(String category, String ratingOrder) {
//        String sql = "SELECT COUNT(*) AS Total FROM Users u "
//                + "JOIN Courses c ON u.UserID = c.UserID "
//                + "JOIN Category cat ON c.CategoryID = cat.CategoryID "
//                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
//                + "WHERE u.RoleID = 2 " + (category != null && !category.isEmpty() ? "AND cat.CategoryID = ?" : "");
//
//        try (PreparedStatement ps = connection.prepareStatement(sql)) {
//            if (category != null && !category.isEmpty()) {
//                ps.setString(1, category);
//            }
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                int total = rs.getInt("Total");
//                System.out.println("Total filtered items: " + total); // Sửa log để rõ ràng
//                return total;
//            }
//        } catch (SQLException e) {
//            System.err.println("SQL Error in countFilteredExperts: " + e.getMessage());
//            e.printStackTrace();
//        }
//        return 0;
//    }
    public int countFilteredExperts(String category, String ratingOrder) {
        String sql = "SELECT COUNT(DISTINCT u.UserID) AS Total FROM Users u "
                + "LEFT JOIN Courses c ON u.UserID = c.UserID "
                + "LEFT JOIN Category cat ON c.CategoryID = cat.CategoryID "
                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
                + "WHERE u.RoleID = 2 " + (category != null && !category.isEmpty() ? "AND cat.CategoryID = ?" : "");

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (category != null && !category.isEmpty()) {
                ps.setString(1, category);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int total = rs.getInt("Total");
                System.out.println("Total experts: " + total);
                return total;
            }
        } catch (SQLException e) {
            System.err.println("SQL Error in countFilteredExperts: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Tìm kiếm Experts theo tên có phân trang
    public List<ExpertNew> searchExpertsByName(String keyword, int offset, int limit) {
        List<ExpertNew> experts = new ArrayList<>();
        String sql = "SELECT u.UserID, u.UserName, u.FullName, u.Email, u.Avartar, c.Name AS CourseName, cat.CategoryName, "
                + "f.Rating "
                + "FROM Users u "
                + "LEFT JOIN Courses c ON u.UserID = c.UserID "
                + "LEFT JOIN Category cat ON c.CategoryID = cat.CategoryID "
                + "LEFT JOIN Feedbacks f ON c.CourseID = f.CourseID "
                + "WHERE u.RoleID = 2 AND (u.FullName LIKE ? OR u.UserName LIKE ?) "
                + "ORDER BY u.UserID";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            // Map để lưu trữ expert, danh sách khóa học và danh sách rating
            Map<Integer, ExpertNew> expertMap = new LinkedHashMap<>();
            Map<Integer, List<Double>> ratingsMap = new HashMap<>();

            while (rs.next()) {
                int userID = rs.getInt("userID");
                ExpertNew expert = expertMap.get(userID);

                if (expert == null) {
                    expert = new ExpertNew();
                    expert.setUserID(userID);
                    expert.setUserName(rs.getString("userName"));
                    expert.setFullName(rs.getString("fullName"));
                    expert.setEmail(rs.getString("email"));
                    expert.setAvartar(rs.getString("avartar"));
                    expert.setCategoryName(rs.getString("categoryName"));
                    expertMap.put(userID, expert);
                    ratingsMap.put(userID, new ArrayList<>());
                }

                // Thêm khóa học
                String courseName = rs.getString("courseName");
                if (courseName != null && !courseName.equals("No Course")) {
                    expert.getCourseNames().add(courseName);
                }

                // Thu thập rating
                double rating = rs.getDouble("Rating");
                if (rs.wasNull()) {
                    rating = 0;
                }
                ratingsMap.get(userID).add(rating);
            }

            // Tính trung bình rating cho mỗi expert
            for (Map.Entry<Integer, ExpertNew> entry : expertMap.entrySet()) {
                int userID = entry.getKey();
                ExpertNew expert = entry.getValue();
                List<Double> ratings = ratingsMap.get(userID);

                double avgRating = 0;
                if (!ratings.isEmpty()) {
                    double sum = 0;
                    int count = 0;
                    for (Double rating : ratings) {
                        if (rating > 0) {
                            sum += rating;
                            count++;
                        }
                    }
                    avgRating = (count > 0) ? sum / count : 0;
                }
                expert.setAvgRating(avgRating);
            }

            // Chuyển map thành list
            experts = new ArrayList<>(expertMap.values());

            // Áp dụng phân trang
            int start = Math.min(offset, experts.size());
            int end = Math.min(start + limit, experts.size());
            experts = experts.subList(start, end);

            System.out.println("Search experts size in DAO: " + experts.size());
        } catch (SQLException e) {
            System.err.println("SQL Error in searchExpertsByName: " + e.getMessage());
            e.printStackTrace();
        }
        return experts;
    }

    // Đếm số Experts theo từ khóa tìm kiếm
    public int countSearchExperts(String keyword) {
        String sql = "SELECT COUNT(DISTINCT u.UserID) AS Total FROM Users u "
                + "WHERE u.RoleID = 2 AND (u.FullName LIKE ? OR u.UserName LIKE ?);";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("Total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
