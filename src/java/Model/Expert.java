/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Administrator
 */
public class Expert {

    int userId;
    String username;
    String name;
    String email;
    String avatar;
    String courseName;
    double rating;

    public Expert(int userId, String username, String email, String avatar, String courseName) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.avatar = avatar;
        this.courseName = courseName;
    }

    public Expert(int userId, String username, String avatar, double rating) {
        this.userId = userId;
        this.username = username;
      
        this.avatar = avatar;
        this.rating = rating;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public Expert(String username, String courseName, String avatar) {
        this.username = username;
        this.courseName = courseName;
        this.avatar = avatar;
    }

    public Expert(String username, String name) {
        this.username = username;
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    @Override
    public String toString() {
        return "Expert{" + "username=" + username + ", courseName=" + courseName + ", avatar=" + avatar + '}';
    }

 

}
