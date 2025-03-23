package dal;

import Model.QuestionEX;
import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuestionEXDAO extends DBContext {

    // Lấy danh sách câu hỏi theo testId
    public List<QuestionEX> getQuestionsByTestId(int testId) {
        List<QuestionEX> list = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE TestID = ? AND Status = 1";
        try {
            if (connection == null) {
                throw new SQLException("Database connection is null");
            }
            System.out.println("Querying questions for testId: " + testId);
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, testId);
            ResultSet rs = st.executeQuery();
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
        } catch (SQLException e) {
            System.err.println("Error querying questions for testId: " + testId);
            e.printStackTrace();
        }
        return list;
    }

    public void deactivateQuestion(int questionId) {
        String sql = "UPDATE Question SET Status = 0 WHERE QuestionID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, questionId);
            int rowsAffected = st.executeUpdate();
            System.out.println("Deactivated question " + questionId + ": " + rowsAffected + " rows affected");
        } catch (SQLException e) {
            System.err.println("Error deactivating question " + questionId + ": " + e.getMessage());
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
    public List<QuestionEX> getDeactivatedQuestionsByTestId(int testId) {
    List<QuestionEX> list = new ArrayList<>();
    String sql = "SELECT * FROM Question WHERE TestID = ? AND Status = 0";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setInt(1, testId);
        ResultSet rs = st.executeQuery();
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
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}

    public void updateQuestion(int questionId, String questionContent, String optionA, String optionB, String optionC, String optionD) {
        String sql = "UPDATE Question SET QuestionType = ?, QuestionContent = ?, OptionA = ?, OptionB = ?, OptionC = ?, OptionD = ? WHERE QuestionID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "Multiple Choice"); // Giá trị mặc định cho QuestionType
            st.setString(2, questionContent);
            st.setString(3, optionA);
            st.setString(4, optionB);
            st.setString(5, optionC);
            st.setString(6, optionD);
            st.setInt(7, questionId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteQuestion(int questionId) {
        String sql = "UPDATE Question SET Status = 0 WHERE QuestionID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, questionId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Xóa tất cả câu hỏi của một test (update status về 0)
    public void deleteQuestionsByTestId(int testId) {
        String sql = "UPDATE Question SET Status = 0 WHERE TestID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, testId);
            st.executeUpdate();
        } catch (SQLException e) {
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
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error adding correct answer: " + e.getMessage());
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
                // Nếu không có bản ghi nào được cập nhật, thêm mới
                addCorrectAnswer(questionId, correctAnswer);
            }
        } catch (SQLException e) {
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
