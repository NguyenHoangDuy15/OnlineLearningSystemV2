package Model;

import dal.UserDAO;
import java.util.*;
import java.lang.*;

public class Usernew extends User {

    private String avatar;

    public Usernew(int id, String fullName, String userName, String email, String password, String avatar, int roleID, int status) {
        super(id, fullName, userName, email, password, roleID, status);
        this.avatar = avatar;
    }

    // Constructor chuyển đổi từ User -> Usernew
    public Usernew(User user) {
        super(user.getUserID(), user.getFullName(), user.getUserName(), user.getEmail(), user.getPassword(), user.getRoleID(), user.getStatus());
        UserDAO userDAO = new UserDAO();
        Usernew userNew = userDAO.getUserNewByUserId(user.getUserID());
        this.avatar = userNew.avatar; // Hoặc lấy từ DB nếu cần
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
}
//public class Usernew {
//
//    private int UserID;
//    private String FullName;
//    private String UserName;
//    private String Email;
//    private String Password;
//    private String Avartar;
//    private int RoleID;
//    private int Status;
//
//    public Usernew() {
//    }
//
//    public Usernew(int UserID, String FullName, String UserName, String Email, String Password, String Avartar, int RoleID, int Status) {
//        this.UserID = UserID;
//        this.FullName = FullName;
//        this.UserName = UserName;
//        this.Email = Email;
//        this.Password = Password;
//        this.Avartar = Avartar;
//        this.RoleID = RoleID;
//        this.Status = Status;
//    }
//
//    public int getUserID() {
//        return UserID;
//    }
//
//    public void setUserID(int UserID) {
//        this.UserID = UserID;
//    }
//
//    public String getFullName() {
//        return FullName;
//    }
//
//    public void setFullName(String FullName) {
//        this.FullName = FullName;
//    }
//
//    public String getUserName() {
//        return UserName;
//    }
//
//    public void setUserName(String UserName) {
//        this.UserName = UserName;
//    }
//
//    public String getEmail() {
//        return Email;
//    }
//
//    public void setEmail(String Email) {
//        this.Email = Email;
//    }
//
//    public String getPassword() {
//        return Password;
//    }
//
//    public void setPassword(String Password) {
//        this.Password = Password;
//    }
//
//    public String getAvartar() {
//        return Avartar;
//    }
//
//    public void setAvartar(String Avartar) {
//        this.Avartar = Avartar;
//    }
//
//    public int getRoleID() {
//        return RoleID;
//    }
//
//    public void setRoleID(int RoleID) {
//        this.RoleID = RoleID;
//    }
//
//    public int getStatus() {
//        return Status;
//    }
//
//    public void setStatus(int Status) {
//        this.Status = Status;
//    }
//
//    @Override
//    public String toString() {
//        return "Usernew{" + "UserID=" + UserID + ", FullName=" + FullName + ", UserName=" + UserName + ", Email=" + Email + ", Password=" + Password + ", Avartar=" + Avartar + ", RoleID=" + RoleID + ", Status=" + Status + '}';
//    }
//    
//    
//}
