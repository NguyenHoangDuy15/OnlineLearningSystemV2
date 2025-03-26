package Model;

import java.util.ArrayList;
import java.util.List;

public class ExpertNew {

    int userID;
    String userName;
    String fullName;
    String email;
    String avartar;
    List<String> courseNames; // Thay courseName thành List<String>
    String categoryName;
    double avgRating;

    public ExpertNew() {
        this.courseNames = new ArrayList<>(); // Khởi tạo danh sách
    }

    public ExpertNew(int userID, String userName, String fullName, String email, String avartar, List<String> courseNames, String categoryName, double avgRating) {
        this.userID = userID;
        this.userName = userName;
        this.fullName = fullName;
        this.email = email;
        this.avartar = avartar;
        this.courseNames = courseNames != null ? courseNames : new ArrayList<>();
        this.categoryName = categoryName;
        this.avgRating = avgRating;
    }

    // Getters và Setters
    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAvartar() {
        return avartar;
    }

    public void setAvartar(String avartar) {
        this.avartar = avartar;
    }

    public List<String> getCourseNames() {
        return courseNames;
    }

    public void setCourseNames(List<String> courseNames) {
        this.courseNames = courseNames != null ? courseNames : new ArrayList<>();
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public double getAvgRating() {
        return avgRating;
    }

    public void setAvgRating(double avgRating) {
        this.avgRating = avgRating;
    }

    @Override
    public String toString() {
        return "ExpertNew{"
                + "userID=" + userID
                + ", userName='" + userName + '\''
                + ", fullName='" + fullName + '\''
                + ", email='" + email + '\''
                + ", avartar='" + avartar + '\''
                + ", courseNames=" + courseNames
                + ", categoryName='" + categoryName + '\''
                + ", avgRating=" + avgRating
                + '}';
    }
}
