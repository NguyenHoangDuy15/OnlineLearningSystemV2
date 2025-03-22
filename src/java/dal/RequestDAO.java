package dal;

import Model.Feedback;
import Model.RequestPrint;
import Model.Requests;
import java.util.*;
import java.lang.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RequestDAO extends DBContext {

    public List<Requests> getAllRequests() {
        List<Requests> list = new ArrayList<>();
        String sql = "SELECT [RequestID]\n"
                + "      ,[RequestedRole]\n"
                + "      ,[UserID]\n"
                + "  FROM [dbo].[Requests]";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Requests r = new Requests(rs.getInt("RequestID"), rs.getInt("RequestedRole"), rs.getInt("UserID"));
                list.add(r);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

  public boolean insertRequest(int userId, int requestedRole) throws SQLException {
        String sql = "INSERT INTO Requests (UserID, RequestedRole) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, requestedRole);
            return ps.executeUpdate() > 0;
        }
    }

    // Lấy trạng thái của yêu cầu gần nhất
    public Integer getLatestRequestStatus(int userId, int requestedRole) throws SQLException {
        String query = "SELECT TOP 1 Status FROM Requests WHERE UserID = ? AND RequestedRole = ? ORDER BY RequestID DESC";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setInt(2, requestedRole);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Nếu Status là NULL, trả về null
                    if (rs.getObject("Status") == null) {
                        return null;
                    }
                    // Trả về giá trị Status (0 hoặc 1)
                    return rs.getInt("Status");
                }
            }
        }
        // Nếu không có yêu cầu trước đó, trả về -1
        return -1;
    }

    public List<RequestPrint> getRoleRequestsByUserID(int userID) {
        List<RequestPrint> requests = new ArrayList<>();
        String sql = "SELECT r.RequestID, r.UserID, ro.RoleName AS RequestedRole, "
                + "CASE "
                + "WHEN r.Status IS null THEN N'Pending' "
                + "WHEN r.Status = 0 THEN N'Rejected' "
                + "WHEN r.Status = 1 THEN N'Approved' "
                + "ELSE N'Unknown' "
                + "END AS StatusText "
                + "FROM Requests r "
                + "LEFT JOIN Roles ro ON r.RequestedRole = ro.RoleID "
                + "WHERE r.UserID = ?;";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RequestPrint request = new RequestPrint(
                        rs.getInt("RequestID"),
                        rs.getInt("UserID"),
                        rs.getString("RequestedRole"), // ✅ Correctly retrieve RoleName as a string
                        rs.getString("StatusText") // ✅ Correctly retrieve StatusText as a string
                );
                requests.add(request);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return requests;
    }

    public static void main(String[] args) {

        RequestDAO dao = new RequestDAO();

        int testUserID = 6; // Change this to an actual userID in your database

        List<RequestPrint> requests = dao.getRoleRequestsByUserID(testUserID);

        System.out.println("=== Role Requests for UserID: " + testUserID + " ===");
        for (RequestPrint request : requests) {
            System.out.println("Request ID: " + request.getRequestID());
            System.out.println("User ID: " + request.getUserID());
            System.out.println("Requested Role: " + request.getRequestedRole());
            System.out.println("Status: " + request.getStatustext());
            System.out.println("-----------------------------------");
        }
    }
}
