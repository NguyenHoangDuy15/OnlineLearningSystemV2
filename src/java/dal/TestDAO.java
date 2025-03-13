package dal;

import Model.Test;
import Model.User;
import java.util.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.MaHoa;

public class TestDAO extends DBContext {

   public int addAnswer(String correctAnswer, int questionId) {
    if (correctAnswer == null) {
        System.out.println("correctAnswer is null for questionId: " + questionId);
        return -1;
    }

    System.out.println("Received correctAnswer: " + correctAnswer); // Debug

    String sql = "INSERT INTO Answer(AnswerContent, QuestionID) VALUES(?, ?)";
    try {
        PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
        
        String answerContent;
        if (correctAnswer.startsWith("optionA")) {
            answerContent = "A";
        } else if (correctAnswer.startsWith("optionB")) {
            answerContent = "B";
        } else if (correctAnswer.startsWith("optionC")) {
            answerContent = "C";
        } else if (correctAnswer.startsWith("optionD")) {
            answerContent = "D";
        } else {
            System.out.println("Invalid correctAnswer: " + correctAnswer + " for questionId: " + questionId);
            return -1;
        }

        st.setString(1, answerContent);
        st.setInt(2, questionId);
        int rows = st.executeUpdate();
        System.out.println("Inserted answer, rows affected: " + rows); // Debug

        ResultSet rs = st.getGeneratedKeys();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        System.out.println("Error adding answer: " + e.getMessage());
    }
    return -1;
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

    public List<Test> getTestsByCreatorFullName(String fullName) {
        List<Test> tests = new ArrayList<>();
        String sql = "SELECT t.TestID, t.Name, t.Status, t.CreatedBy, t.CourseID \n"
                + "FROM Test t \n"
                + "JOIN Users u ON t.CreatedBy = u.FullName\n"
                + "WHERE u.FullName = ? AND u.RoleID = 2";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Test test = new Test(
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

    public List<Test> getAllTests() {
        List<Test> tests = new ArrayList<>();
        String sql = "SELECT TestID, Name, Status, CreatedBy, CourseID FROM Test";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Test test = new Test(
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

    public void deleteQuestion(int questionid) {
        String sql = "DELETE FROM Question WHERE QuestionID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, questionid);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    // Thêm phương thức createTest
    public int createTest(String testName, String createdBy, int courseId) {
    String sql = "INSERT INTO Test(Name, Status, CreatedBy, CourseID) VALUES(?, 0, ?, ?)";
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

    public static void main(String[] args) {
        TestDAO test = new TestDAO();
        System.out.println(test.getTestsByCreatorFullName("Hoang Cong Ninh"));
        
    }
}
