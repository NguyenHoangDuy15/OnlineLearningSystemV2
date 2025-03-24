/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;
import java.util.*;
import java.lang.*; // day la 2 thu vien rat hay dung trong khoa hoc nay


/**
 *
 * @author THU UYEN
 */
public class ExpertNew {
     int userId;
    String username;
    String fullname;
    String email;
    String avatar;
    String courseName;

    public ExpertNew() {
    }

    public ExpertNew(int userId, String username, String fullname, String email, String avatar, String courseName) {
        this.userId = userId;
        this.username = username;
        this.fullname = fullname;
        this.email = email;
        this.avatar = avatar;
        this.courseName = courseName;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    @Override
    public String toString() {
        return "ExpertNew{" + "userId=" + userId + ", username=" + username + ", fullname=" + fullname + ", email=" + email + ", avatar=" + avatar + ", courseName=" + courseName + '}';
    }
    
}
