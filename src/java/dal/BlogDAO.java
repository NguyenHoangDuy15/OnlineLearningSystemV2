package dal;

/**
 *
 * @author DELL
 */
import Model.Blog;
import Model.BlogPrint;
import Model.User;
import java.util.*;
import java.lang.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class BlogDAO extends DBContext {

    // 1.Create Blog
    public void createBlog(String title, String detail, String image, int userID, int roleID) {
        if (roleID != 3) {
            System.out.println("Bạn không có quyền tạo blog.");
            return;
        }

        String sql = "INSERT INTO Blogs (BlogTitle, BlogDetail, BlogImage, BlogDate, UserID) VALUES (?, ?, ?, GETDATE(), ?)";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, title);
            st.setString(2, detail);
            st.setString(3, image);
            st.setInt(4, userID);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    // 2.Delete Blog

    public void deleteBlog(int blogID, int roleID) {
        if (roleID != 1 && roleID != 3) {
            System.out.println("Bạn không có quyền xóa blog.");
            return;
        }
        String sql = "DELETE FROM Blogs WHERE BlogID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, blogID);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 3.Edit Blog
    public void editBlog(int blogID, String title, String detail, String image, int userID) {
        String sql = "UPDATE [dbo].[Blogs]\n"
                + "   SET [BlogTitle] = ?\n"
                + "      ,[BlogDetail] = ?\n"
                + "      ,[BlogImage] = ?\n"
                + "      ,[BlogDate] = GETDATE()\n"
                + " WHERE BlogID = ? AND UserID = ? ";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, title);
            st.setString(2, detail);
            st.setString(3, image);
            st.setInt(4, blogID);
            st.setInt(5, userID);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //4. Get All Blog
    public List<Blog> getAllBlogs() {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT [BlogID]\n"
                + "      ,[BlogTitle]\n"
                + "      ,[BlogDetail]\n"
                + "      ,[BlogImage]\n"
                + "      ,[BlogDate]\n"
                + "      ,[UserID]\n"
                + "  FROM [dbo].[Blogs]"
                + "  ORDER BY BlogDate DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Blog b = new Blog(rs.getInt("BlogID"),
                        rs.getString("BlogTitle"),
                        rs.getString("BlogDetail"),
                        rs.getString("BlogImage"),
                        rs.getDate("BlogDate"),
                        rs.getInt("UserID"));
                list.add(b);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    //5.Get Blog by BlogID
    public Blog getBlogByID(int blogID) {
        String sql = "SELECT [BlogID]\n"
                + "      ,[BlogTitle]\n"
                + "      ,[BlogDetail]\n"
                + "      ,[BlogImage]\n"
                + "      ,[BlogDate]\n"
                + "      ,[UserID]\n"
                + "  FROM [dbo].[Blogs]"
                + "  WHERE BlogID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, blogID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Blog(
                        rs.getInt("BlogID"),
                        rs.getString("BlogTitle"),
                        rs.getString("BlogDetail"),
                        rs.getString("BlogImage"),
                        rs.getDate("BlogDate"),
                        rs.getInt("UserID")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //6. Get Blog by Title 
    public List<Blog> searchBlogs(String keyword) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT * FROM Blogs WHERE BlogTitle COLLATE Vietnamese_CI_AI LIKE ? OR BlogDetail COLLATE Vietnamese_CI_AI LIKE ? ORDER BY BlogDate DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + keyword + "%");
            st.setString(2, "%" + keyword + "%");
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Blog b = new Blog(
                        rs.getInt("BlogID"),
                        rs.getString("BlogTitle"),
                        rs.getString("BlogDetail"),
                        rs.getString("BlogImage"),
                        rs.getDate("BlogDate"),
                        rs.getInt("UserID")
                );
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 7. View Blog By UserID (Only Sale)
    public List<Blog> getBlogsByUserID(int userID, int roleID) {
        List<Blog> list = new ArrayList<>();
        if (roleID != 3) {
            System.out.println("Bạn không có quyền xem blog này.");
            return list;
        }
        String sql = "SELECT BlogID, BlogTitle, BlogDetail, BlogImage, BlogDate, UserID "
                + "FROM Blogs WHERE UserID = ? ORDER BY BlogDate DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Blog b = new Blog(
                        rs.getInt("BlogID"),
                        rs.getString("BlogTitle"),
                        rs.getString("BlogDetail"),
                        rs.getString("BlogImage"),
                        rs.getDate("BlogDate"),
                        rs.getInt("UserID")
                );
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
        }
        return list;
    }

    public List<BlogPrint> get5Blogs(int index) {
        List<BlogPrint> list = new ArrayList<>();
        String sql = "SELECT \n"
                + "    b.BlogID, \n"
                + "    b.BlogTitle, \n"
                + "    b.BlogDate, \n"
                + "    u.UserID, \n"
                + "    u.UserName\n"
                + "FROM Blogs b\n"
                + "JOIN Users u ON b.UserID = u.UserID\n"
                + "ORDER BY [UserID] OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, 5 * (index - 1));
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                BlogPrint b = new BlogPrint(rs.getInt("BlogID"),
                        rs.getString("BlogTitle"),
                        rs.getDate("BlogDate"),
                        rs.getInt("UserID"),
                        rs.getString("UserName"));
                list.add(b);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    //9. Search BlogbySale
    public List<Blog> searchBlogsByUserID(int userID, String keyword) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT * FROM Blogs WHERE UserID = ? AND (BlogTitle COLLATE Vietnamese_CI_AI LIKE ? OR BlogDetail COLLATE Vietnamese_CI_AI LIKE ?) ORDER BY BlogDate DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userID);
            st.setString(2, "%" + keyword + "%");
            st.setString(3, "%" + keyword + "%");
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Blog b = new Blog(
                        rs.getInt("BlogID"),
                        rs.getString("BlogTitle"),
                        rs.getString("BlogDetail"),
                        rs.getString("BlogImage"),
                        rs.getDate("BlogDate"),
                        rs.getInt("UserID")
                );
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void main(String[] args) {
        BlogDAO dao = new BlogDAO();
        System.out.println(dao.searchBlogs("tri tue nhan tao"));
//        System.out.println(dao.deleteBlog(6, 3);
    }

}
