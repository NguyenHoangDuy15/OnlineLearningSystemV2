/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

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
        String sql = "SELECT \n"
                + "    c.CourseID, \n"
                + "    c.Name AS CourseName, \n"
                + "    c.Description, \n"
                + "    c.Price, \n"
                + "    u.FullName AS Instructor\n"
                + "FROM Courses c\n"
                + "INNER JOIN Users u ON c.UserID = u.UserID\n"
                + "INNER JOIN Roles r ON u.RoleID = r.RoleID\n"
                + "WHERE r.RoleName = N'Expert'";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                courses.add(new CustomerCourse(
                        rs.getInt("CourseID"),
                        rs.getString("CourseName"),
                        rs.getString("Description"),
                        rs.getFloat("Price"),
                        rs.getString("Instructor")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public static void main(String[] args) {
        CustomerDao customerDao = new CustomerDao();
        List<CustomerCourse> courses = customerDao.getAllCourses();

        System.out.println("Danh sách khóa học của Expert:");
        for (CustomerCourse course : courses) {
            System.out.println("ID: " + course.getCourseId()
                    + ", Tên: " + course.getCourseName()
                    + ", Mô tả: " + course.getDescription()
                    + ", Giá: " + course.getPrice()
                    + ", Hướng dẫn: " + course.getInstructor());
        }
    }
}
