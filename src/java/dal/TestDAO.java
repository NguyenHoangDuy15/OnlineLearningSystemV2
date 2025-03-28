package dal;

import Model.History;

import Model.Question;
import Model.Test;
import Model.User;
import Model.UserAnswer;
import java.util.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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

    public List<Question> getQuestionsByTestId(int testId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE TestID = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Question question = new Question(
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

    public int insertHistory(int userId, int testId, int courseId) {
        String sql = "INSERT INTO History (UserID, TestID, CourseID, CreatedAt) VALUES (?, ?, ?, GETDATE())";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, userId);
            stmt.setInt(2, testId);
            stmt.setInt(3, courseId);

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void insertUserAnswer(int userId, int testId, int questionId, String answerOption, int answerId, int historyId) {
        String sql = "INSERT INTO UserAnswers (UserID, TestID, QuestionID, AnswerOption, AnswerID, IsCorrectAnswer, HistoryID) VALUES (?, ?, ?, ?, ?, null, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, testId);
            ps.setInt(3, questionId);
            ps.setString(4, answerOption);
            ps.setInt(5, answerId);
            ps.setInt(6, historyId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateCorrectAnswers(int userId, int testId, int historyId) {
        String sql = "UPDATE UA "
                + "SET IsCorrectAnswer = CASE "
                + "    WHEN UA.AnswerOption = A.AnswerContent THEN 1 "
                + "    ELSE 0 "
                + "END "
                + "FROM UserAnswers UA "
                + "JOIN Answer A ON UA.QuestionID = A.QuestionID "
                + "WHERE UA.UserID = ? AND UA.TestID = ? AND UA.HistoryID = ?";  // Lọc theo HistoryID để cập nhật kết quả cho lần làm bài hiện tại

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, testId);
            ps.setInt(3, historyId);  // Cập nhật trạng thái đúng/sai chỉ cho bản ghi thuộc lần làm bài cụ thể
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String getTestResult(int userId, int testId, int historyId) {
        String countCorrectSql = "SELECT COUNT(*) FROM UserAnswers WHERE UserID = ? AND TestID = ? AND HistoryID = ? AND IsCorrectAnswer = 1";
        String countTotalSql = "SELECT COUNT(*) FROM Question WHERE TestID = ?";
        String updateTestStatusSql = "UPDATE History SET TestStatus = ? WHERE UserID = ? AND TestID = ? AND HistoryID = ?";
        String getCourseIdSql = "SELECT CourseID, COALESCE(CourseStatus, -1) FROM History WHERE TestID = ? AND UserID = ? AND HistoryID = ?";
        // Sửa truy vấn để kiểm tra trạng thái mới nhất của tất cả bài test
        String checkTestsSql = "SELECT (CASE WHEN NOT EXISTS ("
                + "    SELECT 1 FROM Test t "
                + "    WHERE t.CourseID = ? AND t.Status = 1 "
                + "    AND NOT EXISTS ("
                + "        SELECT 1 FROM History h "
                + "        WHERE h.TestID = t.TestID AND h.UserID = ? AND h.TestStatus = 1 "
                + "        AND h.HistoryID = ("
                + "            SELECT MAX(h2.HistoryID) "
                + "            FROM History h2 "
                + "            WHERE h2.TestID = t.TestID AND h2.UserID = ?"
                + "        )"
                + "    )"
                + ") THEN 1 ELSE 0 END) AS ShouldUpdateCourse";
        String updateCourseStatusSql = "UPDATE History SET CourseStatus = ? WHERE CourseID = ? AND UserID = ? AND HistoryID = ?";

        try {
            // 1️⃣ Lấy số câu trả lời đúng
            PreparedStatement psCorrect = connection.prepareStatement(countCorrectSql);
            psCorrect.setInt(1, userId);
            psCorrect.setInt(2, testId);
            psCorrect.setInt(3, historyId);
            ResultSet rsCorrect = psCorrect.executeQuery();
            int correctCount = (rsCorrect.next()) ? rsCorrect.getInt(1) : 0;

            // 2️⃣ Lấy tổng số câu hỏi
            PreparedStatement psTotal = connection.prepareStatement(countTotalSql);
            psTotal.setInt(1, testId);
            ResultSet rsTotal = psTotal.executeQuery();
            int totalCount = (rsTotal.next()) ? rsTotal.getInt(1) : 1;

            // 3️⃣ Tính phần trăm đúng và xác định trạng thái bài test
            double percentage = (correctCount * 100.0) / totalCount;
            int testStatus = (percentage >= 80) ? 1 : 0;
            String status = (percentage >= 80) ? "Finished courses" : "You must have the results over 80%";

            // 4️⃣ Cập nhật TestStatus trong bảng History
            PreparedStatement psUpdateTest = connection.prepareStatement(updateTestStatusSql);
            psUpdateTest.setInt(1, testStatus);
            psUpdateTest.setInt(2, userId);
            psUpdateTest.setInt(3, testId);
            psUpdateTest.setInt(4, historyId);
            psUpdateTest.executeUpdate();

            // 5️⃣ Lấy CourseID và CourseStatus hiện tại
            PreparedStatement psGetCourse = connection.prepareStatement(getCourseIdSql);
            psGetCourse.setInt(1, testId);
            psGetCourse.setInt(2, userId);
            psGetCourse.setInt(3, historyId);
            ResultSet rsCourse = psGetCourse.executeQuery();

            if (rsCourse.next()) {
                int courseId = rsCourse.getInt(1);
                int courseStatus = rsCourse.getInt(2); // Nếu NULL, mặc định trả về -1

                // 6️⃣ Nếu CourseStatus đang NULL (-1), cập nhật thành 0
                if (courseStatus == -1) {
                    PreparedStatement psInitCourse = connection.prepareStatement(updateCourseStatusSql);
                    psInitCourse.setInt(1, 0);
                    psInitCourse.setInt(2, courseId);
                    psInitCourse.setInt(3, userId);
                    psInitCourse.setInt(4, historyId);
                    psInitCourse.executeUpdate();
                }

                // 7️⃣ Kiểm tra nếu trạng thái mới nhất của tất cả bài test là pass (CourseStatus => 1)
                PreparedStatement psCheck = connection.prepareStatement(checkTestsSql);
                psCheck.setInt(1, courseId);
                psCheck.setInt(2, userId);
                psCheck.setInt(3, userId); // Tham số thứ 3 cho subquery MAX(HistoryID)
                ResultSet rsCheck = psCheck.executeQuery();

                if (rsCheck.next() && rsCheck.getInt(1) == 1) {
                    // ✅ Nếu trạng thái mới nhất của tất cả bài test là pass, cập nhật CourseStatus = 1
                    PreparedStatement psUpdateCourse = connection.prepareStatement(updateCourseStatusSql);
                    psUpdateCourse.setInt(1, 1);
                    psUpdateCourse.setInt(2, courseId);
                    psUpdateCourse.setInt(3, userId);
                    psUpdateCourse.setInt(4, historyId);
                    psUpdateCourse.executeUpdate();
                }
            }

            return String.format("%.1f%% - %s", percentage, status);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "0.0% - Fail";
    }

    public List<UserAnswer> getUserAnswers(int userId, int testId, int historyId) throws SQLException {
        List<UserAnswer> answers = new ArrayList<>();
        String sql = "SELECT Q.QuestionID, Q.QuestionContent, Q.OptionA, Q.OptionB, "
                + "Q.OptionC, Q.OptionD, UA.AnswerOption, UA.IsCorrectAnswer "
                + "FROM UserAnswers UA "
                + "JOIN Question Q ON UA.QuestionID = Q.QuestionID "
                + "WHERE UA.UserID = ? AND UA.TestID = ? AND UA.HistoryID = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, testId);
            stmt.setInt(3, historyId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    UserAnswer answer = new UserAnswer();
                    answer.setQuestionID(rs.getInt("QuestionID"));
                    answer.setQuestionContent(rs.getString("QuestionContent"));
                    answer.setOptionA(rs.getString("OptionA"));
                    answer.setOptionB(rs.getString("OptionB"));
                    answer.setOptionC(rs.getString("OptionC"));
                    answer.setOptionD(rs.getString("OptionD"));
                    answer.setAnswerOption(rs.getString("AnswerOption"));
                    answer.setIsCorrectAnswer(rs.getBoolean("IsCorrectAnswer"));
                    answers.add(answer);
                }
            }
        }
        return answers;
    }

    public Integer getCourseStatus(int userId, int courseId) {
        String sql = "SELECT TOP 1 CourseStatus "
                + "FROM History "
                + "WHERE UserID = ? AND CourseID = ? AND CourseStatus = 1 "
                + "ORDER BY HistoryID DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("CourseStatus"); // Trả về 1 nếu đã từng hoàn thành
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Trả về null nếu chưa từng hoàn thành
    }

    public Integer getHistoryId(int userId, int testId, int courseId) {
        Integer historyId = null;
        String sql = "SELECT TOP 1 HistoryID \n"
                + "FROM History \n"
                + "WHERE UserID = ? AND TestID = ? AND CourseID = ? \n"
                + "ORDER BY HistoryID DESC;";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);

            stmt.setInt(1, userId);
            stmt.setInt(2, testId);
            stmt.setInt(3, courseId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    historyId = rs.getInt("HistoryID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return historyId;
    }

    public Integer getLastTestId(int userId, int courseId) {
        String sql = "SELECT Top 1 TestID FROM History WHERE UserID = ? AND CourseID = ? ORDER BY HistoryID DESC ";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, courseId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("TestID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Map<Integer, Integer> getAllTestStatuses(int userId, int courseId) {
        Map<Integer, Integer> testStatuses = new HashMap<>();
        String sql = "SELECT t.TestID, h.TestStatus "
                + "FROM Test t "
                + "LEFT JOIN History h ON t.TestID = h.TestID AND h.UserID = ? AND h.CourseID = ? "
                + "WHERE t.CourseID = ? AND t.Status = 1";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, courseId);
            stmt.setInt(3, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int testId = rs.getInt("TestID");
                    Integer status = rs.getObject("TestStatus") != null ? rs.getInt("TestStatus") : null;
                    testStatuses.put(testId, status); // null nếu chưa làm, hoặc giá trị TestStatus nếu đã làm
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return testStatuses;
    }

}
