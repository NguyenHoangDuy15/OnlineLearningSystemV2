package dal;

import Model.Feedback;
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
}
