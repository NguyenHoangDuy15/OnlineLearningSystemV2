/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import Model.Feedback;
import Model.FeedbackPrint;
import Model.User;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDao extends DBContext {

    public boolean insertFeedback(Feedback feedback) {
        String sql = "INSERT INTO Feedbacks (UserID, CourseID, Rating, Comment, CreatedAt) VALUES (?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, feedback.getUserId());
            stmt.setInt(2, feedback.getCourseId());
            stmt.setInt(3, feedback.getRating());
            stmt.setString(4, feedback.getComment());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Feedback> getAllFeedback() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT [FeedbackID],[UserID],[CourseID],[Rating],[Comment],[CreatedAt] FROM [dbo].[Feedbacks] Where [Status] = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Feedback f = new Feedback(rs.getInt("FeedbackID"), rs.getInt("UserID"), rs.getInt("Rating"),
                        rs.getString("Comment"), rs.getDate("CreatedAt"));
                list.add(f);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<FeedbackPrint> getAllFeedbackForAdmin(int index) {
        List<FeedbackPrint> list = new ArrayList<>();
        String sql = "SELECT \n"
                + "    f.FeedbackID AS FbID, \n"
                + "    u.UserName AS Username, \n"
                + "    c.Name AS CourseName, \n"
                + "    f.Rating, \n"
                + "    f.Comment, \n"
                + "    f.CreatedAt\n"
                + "FROM Feedbacks f\n"
                + "JOIN Users u ON f.UserID = u.UserID\n"
                + "JOIN Courses c ON f.CourseID = c.CourseID Where f.Status = 1\n"
                + "ORDER BY c.CourseID \n"
                + "OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                FeedbackPrint f = new FeedbackPrint(rs.getInt("FbID"), rs.getString("Username"), rs.getString("CourseName"),
                        rs.getInt("Rating"), rs.getString("Comment"), rs.getDate("CreatedAt"));
                list.add(f);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Feedback> getCustomerFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT u.FullName AS CustomerName, c.Name AS CourseName, f.Comment AS Feedback "
                + "FROM Feedbacks f "
                + "JOIN Users u ON f.UserID = u.UserID "
                + "JOIN Courses c ON f.CourseID = c.CourseID "
                + "WHERE u.RoleID = 4"; // Chỉ lấy phản hồi từ khách hàng

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Feedback(
                        rs.getString("CustomerName"),
                        rs.getString("CourseName"),
                        rs.getString("Feedback")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteFeedback(String id) {
        String sql = "UPDATE [dbo].[Feedbacks]\n"
                + "   SET [Status] = 0\n"
                + " WHERE FeedbackID = ?";
        try {
            PreparedStatement rs = connection.prepareStatement(sql);
            rs.setString(1, id);
            rs.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public static void main(String[] args) {
        // Tạo đối tượng DAL để gọi hàm
        FeedbackDao feedbackDAO = new FeedbackDao();
        System.out.println(feedbackDAO.getAllFeedbackForAdmin(1));
        // Gọi hàm lấy phản hồi của customer
        List<Feedback> feedbacks = feedbackDAO.getCustomerFeedbacks();

        // Kiểm tra dữ liệu
        if (feedbacks.isEmpty()) {
            System.out.println("Không có phản hồi nào từ khách hàng.");
        } else {
            System.out.println("Danh sách phản hồi từ khách hàng:");
            for (Feedback fb : feedbacks) {
                System.out.println("Tên khách hàng: " + fb.getCustomername());
                System.out.println("Tên khóa học: " + fb.getCourse());
                System.out.println("Phản hồi: " + fb.getComment());
                System.out.println("----------------------");
            }
        }
    }
}
