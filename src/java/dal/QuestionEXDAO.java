package dal;

import Model.QuestionEX;
import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuestionEXDAO extends DBContext {
    public List<QuestionEX> getQuestionsByTestId(int testId) {
        List<QuestionEX> list = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE TestID = ? AND Status = 1";

        try {
            if (connection == null) {
                throw new SQLException("Database connection is null");
            }

            System.out.println("Querying questions for testId: " + testId);
            try (PreparedStatement st = connection.prepareStatement(sql)) {
                st.setInt(1, testId);
                try (ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        QuestionEX question = new QuestionEX();
                        question.setQuestionID(rs.getInt("QuestionID"));
                        question.setQuestionContent(rs.getString("QuestionContent"));
                        question.setOptionA(rs.getString("OptionA"));
                        question.setOptionB(rs.getString("OptionB"));
                        question.setOptionC(rs.getString("OptionC"));
                        question.setOptionD(rs.getString("OptionD"));
                        question.setTestID(rs.getInt("TestID"));
                        question.setStatus(rs.getInt("Status"));
                        list.add(question);
                        System.out.println("Found question: " + question.getQuestionID() + ", content: " + question.getQuestionContent());
                    }
                    System.out.println("Total questions found: " + list.size());
                }
            }
        } catch (SQLException e) {
            System.err.println("Error querying questions for testId: " + testId + ": " + e.getMessage());
            e.printStackTrace(); 
        }

        return list;
    }

   public boolean deactivateQuestion(int questionId) {
    String sql = "UPDATE Question SET Status = 0 WHERE QuestionID = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setInt(1, questionId);
        int rowsAffected = st.executeUpdate();
        if (rowsAffected > 0) {
            deleteCorrectAnswerByQuestionId(questionId);
            System.out.println("Deactivated question " + questionId + ": " + rowsAffected + " rows affected");
            return true;
        }
        return false;
    } catch (SQLException e) {
        System.err.println("Error deactivating question " + questionId + ": " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

    public int addQuestion(String questionContent, String optionA, String optionB, String optionC, String optionD, int testId) {
        String sql = "INSERT INTO Question(QuestionType, QuestionContent, OptionA, OptionB, OptionC, OptionD, TestID, Status) VALUES('multiple choice', ?, ?, ?, ?, ?, ?, 1)";
        try {
            PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setString(1, questionContent);
            st.setString(2, optionA);
            st.setString(3, optionB);
            st.setString(4, optionC);
            st.setString(5, optionD);
            st.setInt(6, testId);
            int rowsAffected = st.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = st.getGeneratedKeys();
                if (rs.next()) {
                    System.out.println("Added new question with ID: " + rs.getInt(1));
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding question: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public void updateQuestion(int questionId, String questionContent, String optionA, String optionB, String optionC, String optionD) {
        String sql = "UPDATE Question SET QuestionContent = ?, OptionA = ?, OptionB = ?, OptionC = ?, OptionD = ? WHERE QuestionID = ? AND Status = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, questionContent);
            st.setString(2, optionA);
            st.setString(3, optionB);
            st.setString(4, optionC);
            st.setString(5, optionD);
            st.setInt(6, questionId);
            int rowsAffected = st.executeUpdate();
            System.out.println("Updated question " + questionId + ": " + rowsAffected + " rows affected");
        } catch (SQLException e) {
            System.err.println("Error updating question " + questionId + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    public String getCorrectAnswerByQuestionId(int questionId) {
        String sql = "SELECT AnswerContent FROM Answer WHERE QuestionID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, questionId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getString("AnswerContent");
            }
        } catch (SQLException e) {
            System.err.println("Error getting correct answer for question " + questionId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public void addCorrectAnswer(int questionId, String correctAnswer) {
        String sql = "INSERT INTO Answer (AnswerContent, QuestionID) VALUES (?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, correctAnswer);
            st.setInt(2, questionId);
            int rowsAffected = st.executeUpdate();
            System.out.println("Added correct answer for question " + questionId + ": " + rowsAffected + " rows affected");
        } catch (SQLException e) {
            System.err.println("Error adding correct answer for question " + questionId + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateCorrectAnswer(int questionId, String correctAnswer) {
        String sql = "UPDATE Answer SET AnswerContent = ? WHERE QuestionID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, correctAnswer);
            st.setInt(2, questionId);
            int rowsAffected = st.executeUpdate();
            if (rowsAffected == 0) {
                addCorrectAnswer(questionId, correctAnswer);
            } else {
                System.out.println("Updated correct answer for question " + questionId + ": " + rowsAffected + " rows affected");
            }
        } catch (SQLException e) {
            System.err.println("Error updating correct answer for question " + questionId + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void deleteCorrectAnswerByQuestionId(int questionId) {
        String sql = "DELETE FROM Answer WHERE QuestionID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, questionId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
