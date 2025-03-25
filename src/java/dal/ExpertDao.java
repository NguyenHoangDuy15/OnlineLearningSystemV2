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
    public List<ExpertNew> getExpertswCourses() {
    List<ExpertNew> experts = new ArrayList<>();
    String sql = "SELECT DISTINCT u.UserID, u.UserName, u.FullName, u.Email, u.Avartar, c.Name "
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
            String fullName = rs.getString("FullName"); // Thêm FullName
            String email = rs.getString("Email");
            String avatar = rs.getString("Avartar");
            String courseName = rs.getString("Name");

            experts.add(new ExpertNew(userID, userName, fullName, email, avatar, courseName));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return experts;
}

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

}
