/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.*;
import java.lang.*;
import java.io.*;
import java.sql.*;
import Model.LessonEX;
import dal.DBContext;

public class LessonEXDAO extends DBContext {

    public int addLesson(int courseID, String title, String content) {
        String sql = "INSERT INTO Lessons (CourseID, Title, Content, Status) VALUES (?, ?, ?, 1)";
        try {
            if (connection == null) {
                throw new SQLException("Database connection is null");
            }
            PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setInt(1, courseID);
            ps.setString(2, title);
            ps.setString(3, content);
            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                System.out.println("Failed to insert new lesson: no rows affected");
                return -1;
            }
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int newLessonId = rs.getInt(1);
                System.out.println("Successfully added new lesson with ID: " + newLessonId + ", title: " + title);
                return newLessonId;
            } else {
                System.out.println("Failed to retrieve generated key for new lesson");
                return -1;
            }
        } catch (SQLException e) {
            System.err.println("Error adding new lesson: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }

    public void deleteLesson(int lessonID) {
        String sql = "UPDATE Lessons SET Status = 0 WHERE LessonID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, lessonID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean deactivateLesson(int lessonId) {
        String sql = "UPDATE Lessons SET Status = 0 WHERE LessonID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, lessonId);
            int rowsAffected = ps.executeUpdate();
            System.out.println("[LessonEXDAO] Deactivate lesson with ID=" + lessonId + ", Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

        public List<LessonEX> getLessonsByCourseId(int courseId) {
            List<LessonEX> lessons = new ArrayList<>();
            String sql = "SELECT LessonID, CourseID, Title, Content, Status FROM Lessons WHERE CourseID = ? AND Status = 1 AND LessonID IS NOT NULL AND LessonID > 0";
            try {
                PreparedStatement ps = connection.prepareStatement(sql);
                ps.setInt(1, courseId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    int lessonId = rs.getInt("LessonID");
                    System.out.println("[LessonEXDAO] Fetched lesson: ID=" + lessonId + ", CourseID=" + rs.getInt("CourseID") + ", Status=" + rs.getInt("Status"));
                    lessons.add(new LessonEX(
                            lessonId,
                            rs.getInt("CourseID"),
                            rs.getString("Title"),
                            rs.getString("Content"),
                            rs.getInt("Status")
                    ));
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            System.out.println("[LessonEXDAO] Total lessons fetched: " + lessons.size());
            return lessons;
        }

        public int getLastInsertedLessonId() {
            String sql = "SELECT MAX(LessonID) as lastId FROM Lessons";
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

        public void updateLesson(LessonEX lesson) {
            String sql = "UPDATE Lessons SET Title = ?, Content = ? WHERE LessonID = ?";
            try {
                PreparedStatement st = connection.prepareStatement(sql);
                st.setString(1, lesson.getTitle());
                st.setString(2, lesson.getContent());
                st.setInt(3, lesson.getLessonID());
                st.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        public LessonEX getLessonById(int lessonId) {
            String sql = "SELECT * FROM Lessons WHERE LessonID = ? AND Status != 0";
            try {
                PreparedStatement st = connection.prepareStatement(sql);
                st.setInt(1, lessonId);
                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    LessonEX lesson = new LessonEX();
                    lesson.setLessonID(rs.getInt("LessonID"));
                    lesson.setTitle(rs.getString("Title"));
                    lesson.setContent(rs.getString("Content"));
                    lesson.setCourseID(rs.getInt("CourseID"));
                    lesson.setStatus(rs.getInt("Status"));
                    return lesson;
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return null;
        }
    }
