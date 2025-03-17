package dal;

import Model.User;
import Model.Usernew;
import java.util.*;
import java.lang.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.MaHoa;

public class UserDAO extends DBContext {

    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        MaHoa m = new MaHoa();
        System.out.println(dao.get5ExpertBySearch(1, "Hoang"));
        System.out.println(m.toSHA1("theanh"));
        System.out.println(dao.check("theanh", m.toSHA1("theanh")));
        //dao.add("123", "123", "123", "123");
    }

    public void add(String user, String pass, String name, String email) {
        String sql = "INSERT INTO [dbo].[Users]\n"
                + "           ([FullName]\n"
                + "           ,[UserName]\n"
                + "           ,[Email]\n"
                + "           ,[Password]\n"
                + "           ,[Status]\n"
                + "           ,[RoleID])\n"
                + "     VALUES\n"
                + "           (?\n"
                + "           ,?\n"
                + "           ,?\n"
                + "           ,?\n"
                + "           ,1\n"
                + "           ,4)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, name);
            st.setString(2, user);
            st.setString(3, email);
            st.setString(4, pass);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void addUser(String user, String pass, String name, String email, int role) {
        String sql = "INSERT INTO [dbo].[Users]\n"
                + "           ([FullName]\n"
                + "           ,[UserName]\n"
                + "           ,[Email]\n"
                + "           ,[Password]\n"
                + "           ,[Status]\n"
                + "           ,[RoleID])\n"
                + "     VALUES\n"
                + "           (?\n"
                + "           ,?\n"
                + "           ,?\n"
                + "           ,?\n"
                + "           ,1\n"
                + "           ,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, name);
            st.setString(2, user);
            st.setString(3, email);
            st.setString(4, pass);
            st.setInt(5, role);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Status]\n"
                + "      ,[RoleID]\n"
                + "  FROM [dbo].[Users]";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<User> getAllExpert() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  Where [RoleID] = 2";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<User> get5Expert(int index) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE [RoleID] = 2\n"
                + "  ORDER BY [UserID] OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<User> get5ExpertBySearch(int index, String name) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE [RoleID] = 2 AND [FullName] like ?\n"
                + "  ORDER BY [UserID] OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + name + "%");
            st.setInt(2, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
    
    public List<User> findExpertBySearch(String name) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE [RoleID] = 2 AND [FullName] like ?\n";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + name + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
    
    public List<User> get5User(int index) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE [RoleID] = 2 OR [RoleID] = 3 OR [RoleID] = 4\n"
                + "  ORDER BY [UserID] OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
    
    public List<User> get5UserBySearch(int index, String name) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE ([RoleID] = 2 OR [RoleID] = 3 OR [RoleID] = 4) AND [FullName] like ?\n"
                + "  ORDER BY [UserID] OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + name + "%");
            st.setInt(2, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
    
    public List<User> findUserBySearch(String name) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE ([RoleID] = 2 OR [RoleID] = 3 OR [RoleID] = 4) AND [FullName] like ?\n";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + name + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
    
    public List<User> get5SellerBySearch(int index, String name) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE [RoleID] = 3 AND [FullName] like ?\n"
                + "  ORDER BY [UserID] OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + name + "%");
            st.setInt(2, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
    public List<User> findSellerBySearch(String name) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE [RoleID] = 3 AND [FullName] like ?\n";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + name + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<User> get5Seller(int index) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE [RoleID] = 3\n"
                + "  ORDER BY [UserID] OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<User> getAllSale() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  Where [RoleID] = 3";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                User u = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public User check(String username, String password) {
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Status]\n"
                + "      ,[RoleID]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE [UserName]= ? and [Password] = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User a = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                return a;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public void changePass(String pass, int id) {
        String sql = "UPDATE [dbo].[Users]\n"
                + "   SET [Password] = ?\n"
                + " WHERE [UserID] = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, pass);
            st.setInt(2, id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public User checkWithGmail(String username, String mail) {
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Status]\n"
                + "      ,[RoleID]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE [UserName]= ? and [Email] = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, mail);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User a = new User(rs.getInt("UserID"), rs.getString("FullName"),
                        rs.getString("UserName"), rs.getString("Email"),
                        rs.getString("Password"), rs.getInt("Status"), rs.getInt("RoleID"));
                return a;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    // Delete
    public void delete(String id) {
        String sql = "UPDATE [dbo].[Users]\n"
                + "   SET [Status] = 0\n"
                + " WHERE [UserID] = ?";
        try {
            PreparedStatement rs = connection.prepareStatement(sql);
            rs.setString(1, id);
            rs.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public Usernew getUserByUserId(String userid) {
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE [UserID] = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, userid);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Usernew user = new Usernew(rs.getInt("UserID"), rs.getString("FullName"), rs.getString("UserName"), rs.getString("Email"), rs.getString("Password"), rs.getString("Avartar"), rs.getInt("RoleID"), rs.getInt("Status"));
                return user;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public boolean updateProfile(Usernew user) {
        String sql = "UPDATE Users SET FullName = ?, Email = ?, Avartar = ?, Status = ? WHERE UserID = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, user.getFullName());
            stm.setString(2, user.getEmail());
            stm.setString(3, user.getAvatar()); // Ảnh đại diện (có thể null nếu không đổi)
            stm.setInt(4, user.getStatus()); // Trạng thái user (nếu có)
            stm.setInt(5, user.getUserID()); // Xác định user cần cập nhật

            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public Usernew getUserNewByUserId(int userid) {
        String sql = "SELECT [UserID]\n"
                + "      ,[FullName]\n"
                + "      ,[UserName]\n"
                + "      ,[Email]\n"
                + "      ,[Password]\n"
                + "      ,[Avartar]\n"
                + "      ,[RoleID]\n"
                + "      ,[Status]\n"
                + "  FROM [dbo].[Users]\n"
                + "  WHERE [UserID] = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, "" + userid);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Usernew user = new Usernew(rs.getInt("UserID"), rs.getString("FullName"), rs.getString("UserName"), rs.getString("Email"), rs.getString("Password"), rs.getString("Avartar"), rs.getInt("RoleID"), rs.getInt("Status"));
                return user;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }
}
