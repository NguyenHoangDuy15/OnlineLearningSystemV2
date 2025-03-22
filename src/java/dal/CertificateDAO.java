/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Model.Certificate;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

/**
 *
 * @author Administrator
 */
public class CertificateDAO extends DBContext {

    public List<Certificate> getCompletedCoursesByUser(int userId) {
        List<Certificate> courses = new ArrayList<>();
        String sql = "SELECT \n"
                + "    c.CourseID, \n"
                + "    c.Name, \n"
                + "    c.imageCources, \n"
                + "    c.Description, \n"
                + "    N'Hoàn thành' AS CourseStatus\n"
                + "\n"
                + "FROM Courses c \n"
                + "\n"
                + "WHERE c.CourseID IN (\n"
                + "    SELECT DISTINCT h.CourseID \n"
                + "    FROM History h \n"
                + "    WHERE h.UserID = ? AND h.CourseStatus = 1\n"
                + ");";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Certificate c = new Certificate(
                            rs.getInt("CourseID"),
                            rs.getString("Name"),
                            rs.getString("imageCources"),
                            rs.getString("Description"),
                            rs.getString("CourseStatus")
                    );
                    courses.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public Certificate getEarliestCompletion(int userId, int courseId) {
        String sql = "SELECT TOP 1  \n"
                + "    u.FullName,  \n"
                + "	c.CourseID,\n"
                + "    c.Name AS Course_Name,  \n"
                + "    c.imageCources,  \n"
                + "    c.DESCRIPTION AS Course_Description,  \n"
                + "    h.CreatedAt AS Completion_Time  \n"
                + "FROM Users u  \n"
                + "JOIN History h ON u.USERID = h.USERID  \n"
                + "JOIN Courses c ON h.COURSEID = c.COURSEID  \n"
                + "WHERE u.USERID = ? \n"
                + "AND h.CourseStatus = 1  \n"
                + "AND h.COURSEID = ?\n"
                + "ORDER BY h.CreatedAt ASC;";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Certificate(
                        rs.getString("FullName"),
                        rs.getInt("CourseID"),
                        rs.getString("Course_Name"),
                        rs.getString("imageCources"),
                        rs.getString("Course_Description"),
                        rs.getString("Completion_Time")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) {
        // Khởi tạo đối tượng CertificateDAO
        CertificateDAO certificateDAO = new CertificateDAO();

        // Thay đổi userId và courseId theo dữ liệu thực tế trong cơ sở dữ liệu của bạn
        int userId = 7; // Ví dụ: userId = 1
        int courseId = 1; // Ví dụ: courseId = 1

        // Gọi phương thức getEarliestCompletion
        Certificate certificate = certificateDAO.getEarliestCompletion(userId, courseId);

        // Kiểm tra kết quả
        if (certificate != null) {
            System.out.println("Thông tin chứng chỉ:");
            System.out.println("Full Name: " + certificate.getFullname());
            System.out.println("Course Name: " + certificate.getName());
            System.out.println("Image Courses: " + certificate.getImageCourses());
            System.out.println("Description: " + certificate.getDescription());
            System.out.println("Completion Time: " + certificate.getCompletionTime());
        } else {
            System.out.println("Không tìm thấy chứng chỉ cho userId = " + userId + " và courseId = " + courseId);
        }

        // Đóng kết nối (nếu cần)
    }
}
