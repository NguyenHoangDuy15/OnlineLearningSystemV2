package dal;

import Model.CatergoryPrint;
import Model.MoneyHistoryByAdmin;
import Model.RequestPrint;
import Model.User;
import java.util.*;
import java.lang.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDao extends DBContext {

    public List<CatergoryPrint> getAllCat() {
        List<CatergoryPrint> list = new ArrayList<>();
        String sql = "SELECT [CategoryID]\n"
                + "      ,[CategoryName]\n"
                + "  FROM [dbo].[Category]";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CatergoryPrint m = new CatergoryPrint(rs.getInt("CategoryID"), rs.getString("CategoryName"));
                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<MoneyHistoryByAdmin> getAllHistory() {
        List<MoneyHistoryByAdmin> list = new ArrayList<>();
        String sql = "SELECT \n"
                + "    t.PayID, \n"
                + "    t.Status, \n"
                + "    t.CreatedAt, \n"
                + "    t.CourseID, \n"
                + "    c.Name AS CourseName, \n"
                + "    t.PaymentMethod, \n"
                + "    t.PaymentDate, \n"
                + "    p.Amount AS Price\n"
                + "FROM TransactionHistory t\n"
                + "JOIN Payment p ON t.PayID = p.PayID\n"
                + "JOIN Courses c ON t.CourseID = c.CourseID;";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                MoneyHistoryByAdmin m = new MoneyHistoryByAdmin(rs.getInt("PayID"), rs.getInt("Status"),
                        rs.getDate("CreatedAt"), rs.getInt("CourseID"),
                        rs.getString("CourseName"), rs.getString("PaymentMethod"),
                        rs.getDate("PaymentDate"), rs.getFloat("Price"));
                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<MoneyHistoryByAdmin> get5History(int index) {
        List<MoneyHistoryByAdmin> list = new ArrayList<>();
        String sql = "SELECT \n"
                + "    t.PayID, \n"
                + "    t.Status, \n"
                + "    t.CreatedAt, \n"
                + "    t.CourseID, \n"
                + "    c.Name AS CourseName, \n"
                + "    t.PaymentMethod, \n"
                + "    t.PaymentDate, \n"
                + "    p.Amount AS Price\n"
                + "FROM TransactionHistory t\n"
                + "JOIN Payment p ON t.PayID = p.PayID\n"
                + "JOIN Courses c ON t.CourseID = c.CourseID\n"
                + "ORDER BY PayID OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY;";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                MoneyHistoryByAdmin m = new MoneyHistoryByAdmin(rs.getInt("PayID"), rs.getInt("Status"),
                        rs.getDate("CreatedAt"), rs.getInt("CourseID"),
                        rs.getString("CourseName"), rs.getString("PaymentMethod"),
                        rs.getDate("PaymentDate"), rs.getFloat("Price"));
                list.add(m);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<RequestPrint> getAllRequest() {
        List<RequestPrint> list = new ArrayList<>();
        String sql = "SELECT r.RequestID,\n"
                + "       r.UserID, \n"
                + "       u.UserName,\n"
                + "       r.RequestedRole,\n"
                + "       r.[Status]\n"
                + "       FROM Requests r\n"
                + "JOIN Users u ON r.UserID = u.UserID\n"
                + "where r.[Status] is null;\n";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                RequestPrint r = new RequestPrint(rs.getInt("RequestID"), rs.getInt("UserID"),
                        rs.getString("UserName"), rs.getInt("RequestedRole"), rs.getInt("Status"));
                list.add(r);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<RequestPrint> get5Request(int index) {
        List<RequestPrint> list = new ArrayList<>();
        String sql = "SELECT r.RequestID,\n"
                + "       r.UserID, \n"
                + "       u.UserName,\n"
                + "       r.RequestedRole,\n"
                + "       r.[Status]\n"
                + "       FROM Requests r\n"
                + "JOIN Users u ON r.UserID = u.UserID\n"
                + "where r.[Status] is null\n"
                + "ORDER BY RequestID OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY;";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                RequestPrint r = new RequestPrint(rs.getInt("RequestID"), rs.getInt("UserID"),
                        rs.getString("UserName"), rs.getInt("RequestedRole"), rs.getInt("Status"));
                list.add(r);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public void deleteRequest(String id, String status) {
        String sql = "UPDATE [dbo].[Requests]\n"
                + "   SET [Status] = ?\n"
                + " WHERE RequestID = ?";
        try {
            PreparedStatement rs = connection.prepareStatement(sql);
            rs.setString(1, status);
            rs.setString(2, id);
            rs.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void UpdateRoleForUser(String UserID, String RoleID) {
        String sql = "UPDATE [dbo].[Users]\n"
                + "   SET [RoleID] = ?\n"
                + " WHERE UserID = ?";
        try {
            PreparedStatement rs = connection.prepareStatement(sql);
            rs.setString(1, RoleID);
            rs.setString(2, UserID);
            rs.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void UpdateUserForAdmin(String UserID, String fullname, String email, String role, String status) {
        String sql = "UPDATE [dbo].[Users]\n"
                + "   SET [FullName] = ?\n"
                + "      ,[Email] = ?\n"
                + "      ,[RoleID] = ?\n"
                + "      ,[Status] = ?\n"
                + " WHERE UserID = ?";
        try {
            PreparedStatement rs = connection.prepareStatement(sql);
            rs.setString(1, fullname);
            rs.setString(2, email);
            rs.setString(3, role);
            rs.setString(4, status);
            rs.setString(5, UserID);
            rs.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public static void main(String[] args) {
        AdminDao dao = new AdminDao();
        System.out.println(dao.getAllCat());
    }
}
