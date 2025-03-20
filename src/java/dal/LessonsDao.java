/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Model.Lesson;

import dal.DBContext;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import java.util.Scanner;

/**
 *
 * @author Administrator
 */
public class LessonsDao extends DBContext {

    public List<Lesson> getLessonsAndTests(int courseId) {
        List<Lesson> list = new ArrayList<>();
        String sql = "SELECT \n"
                + "    'Lesson' AS Type, \n"
                + "    l.LessonID AS ID, \n"
                + "    l.Title AS Name, \n"
                + "    l.Content\n"
                + "FROM Lessons l \n"
                + "WHERE l.CourseID = ? and l.Status = 1\n"
                + "\n"
                + "UNION ALL\n"
                + "\n"
                + "SELECT \n"
                + "    'Test' AS Type, \n"
                + "    t.TestID AS ID, \n"
                + "    t.Name AS Name, \n"
                + "    NULL AS Content\n"
                + "FROM Test t \n"
                + "WHERE t.CourseID = ? and t.Status = 1";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, courseId);
            ps.setInt(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Lesson(
                            rs.getString("Type"),
                            rs.getInt("ID"),
                            rs.getString("Name"),
                            rs.getString("Content")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
