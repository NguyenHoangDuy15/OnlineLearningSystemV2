package Model;

import java.util.*;
import java.lang.*;

public class User {
    private int UserID;
    private String FullName;
    private String UserName;
    private String Email;
    private String Password;
    private int Status;
    private int RoleID;

    public User() {
    }

    public User(int UserID, String FullName, String UserName, String Email, String Password, int Status, int RoleID) {
        this.UserID = UserID;
        this.FullName = FullName;
        this.UserName = UserName;
        this.Email = Email;
        this.Password = Password;
        this.Status = Status;
        this.RoleID = RoleID;
    }

    public int getUserID() {
        return UserID;
    }

    public void setUserID(int UserID) {
        this.UserID = UserID;
    }

    public String getFullName() {
        return FullName;
    }

    public void setFullName(String FullName) {
        this.FullName = FullName;
    }

    public String getUserName() {
        return UserName;
    }

    public void setUserName(String UserName) {
        this.UserName = UserName;
    }

    public String getEmail() {
        return Email;
    }

    public void setEmail(String Email) {
        this.Email = Email;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String Password) {
        this.Password = Password;
    }

    public int getStatus() {
        return Status;
    }

    public void setStatus(int Status) {
        this.Status = Status;
    }

    public int getRoleID() {
        return RoleID;
    }

    public void setRoleID(int RoleID) {
        this.RoleID = RoleID;
    }

    @Override
    public String toString() {
        return "User{" + "UserID=" + UserID + ", FullName=" + FullName + ", UserName=" + UserName + ", Email=" + Email + ", Password=" + Password + ", Status=" + Status + ", RoleID=" + RoleID + '}';
    }
    
}
