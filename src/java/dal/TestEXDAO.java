/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author CONG NINH
 */
import Model.QuestionEX;
import Model.TestEX;
import dal.DBContext;
import java.util.*;
import java.lang.*;
import java.io.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TestEXDAO extends DBContext {

    public int addAnswer(String correctAnswer, int questionId) {
        if (correctAnswer == null || correctAnswer.trim().isEmpty()) {
            System.out.println("Failed to add answer: correctAnswer is null or empty for questionId: " + questionId);
            return -1;
        }

        if (!("A".equals(correctAnswer) || "B".equals(correctAnswer) || "C".equals(correctAnswer) || "D".equals(correctAnswer))) {
            System.out.println("Failed to add answer: Invalid correctAnswer: " + correctAnswer + " for questionId: " + questionId);
            return -1;
        }

        System.out.println("Adding answer: Received correctAnswer: " + correctAnswer + " for questionId: " + questionId); // Debug

        String sql = "INSERT INTO Answer(AnswerContent, QuestionID) VALUES(?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setString(1, correctAnswer);
            st.setInt(2, questionId);
            int rows = st.executeUpdate();

            if (rows > 0) {
                System.out.println("Successfully added answer: " + correctAnswer + " for questionId: " + questionId + ", rows affected: " + rows);
                ResultSet rs = st.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            } else {
                System.out.println("Failed to add answer: No rows affected for correctAnswer: " + correctAnswer + " and questionId: " + questionId);
            }
        } catch (SQLException e) {
            System.out.println("Failed to add answer: Error - " + e.getMessage());
        }
        return -1;
    }

    public void updateTestStatus(int testId, int status) {
        String sql = "UPDATE Test SET Status = ? WHERE TestID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, testId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int addQuestion(String questioncontent, String OptionA, String OptionB, String OptionC, String OptionD, int testid) {
        String sql = "INSERT INTO Question(QuestionType, QuestionContent, OptionA, OptionB, OptionC, OptionD, TestID) VALUES('multiple choice', ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setString(1, questioncontent);
            st.setString(2, OptionA);
            st.setString(3, OptionB);
            st.setString(4, OptionC);
            st.setString(5, OptionD);
            st.setInt(6, testid);
            st.executeUpdate();

            ResultSet rs = st.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error adding question: " + e.getMessage());
        }
        return -1;
    }

    public List<TestEX> getTestsByCreatorFullName(int userId) {
        List<TestEX> tests = new ArrayList<>();
        String sql = "SELECT t.TestID, t.Name, t.Status, t.CreatedBy, t.CourseID \n"
                + "FROM Test t \n"
                + "JOIN Courses c ON t.CourseID = c.CourseID \n"
                + "JOIN Users u ON c.UserID = u.UserID \n"
                + "WHERE u.UserID = ? AND u.RoleID = 2";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TestEX test = new TestEX(
                        rs.getInt("TestID"),
                        rs.getString("Name"),
                        rs.getInt("Status"),
                        rs.getString("CreatedBy"),
                        rs.getInt("CourseID")
                );
                tests.add(test);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tests;
    }

    public int createTest(String testName, String createdBy, int courseId) {
        String sql = "INSERT INTO Test(Name, Status, CreatedBy, CourseID) VALUES(?, 1, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setString(1, testName);
            st.setString(2, createdBy);
            st.setInt(3, courseId);
            st.executeUpdate();
            ResultSet rs = st.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error creating test: " + e.getMessage());
        }
        return -1;
    }

    public List<TestEX> getTestsByCourseId(int courseId) {
        List<TestEX> tests = new ArrayList<>();
        String sql = "SELECT TestID, Name, Status, CreatedBy, CourseID FROM Test WHERE CourseID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TestEX test = new TestEX(
                        rs.getInt("TestID"),
                        rs.getString("Name"),
                        rs.getInt("Status"),
                        rs.getString("CreatedBy"),
                        rs.getInt("CourseID")
                );
                tests.add(test);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tests;
    }

    public void updateTestName(int testId, String testName) {
        String sql = "UPDATE Test SET Name = ? WHERE TestID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, testName);
            ps.setInt(2, testId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteQuestionsByTestId(int testId) {
        String sql = "DELETE FROM Question WHERE TestID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean isCorrectAnswer(int questionId, String option) {
        String sql = "SELECT AnswerContent FROM Answer WHERE QuestionID = ? AND AnswerContent = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ps.setString(2, option);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public TestEX getTestById(int testId) {
        String sql = "SELECT TestID, Name, Status, CreatedBy, CourseID FROM Test WHERE TestID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new TestEX(
                        rs.getInt("TestID"),
                        rs.getString("Name"),
                        rs.getInt("Status"),
                        rs.getString("CreatedBy"),
                        rs.getInt("CourseID")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<QuestionEX> getQuestionsByTestId(int testId) {
        List<QuestionEX> questions = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE TestID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                QuestionEX question = new QuestionEX(
                        rs.getInt("QuestionID"),
                        rs.getString("QuestionType"),
                        rs.getString("QuestionContent"),
                        rs.getString("OptionA"),
                        rs.getString("OptionB"),
                        rs.getString("OptionC"),
                        rs.getString("OptionD"),
                        rs.getInt("TestID")
                );

                questions.add(question);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return questions;
    }

    public void updateTest(TestEX test) {
        String sql = "UPDATE Test SET Name = ? WHERE TestID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, test.getName());
            st.setInt(2, test.getTestID());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
