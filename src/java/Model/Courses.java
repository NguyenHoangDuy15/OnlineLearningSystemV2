/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.sql.Date;

public class Courses {

    int userid;

    int courseID;
    String name;
    String expertName;
    float price;
    String image;
    double averageRating;
    int totalReviews;
    String category;
    String description;

    public Courses() {
    }

    public Courses(int userid, int courseID, String name, String expertName, String image, String description, float price, double averageRating, int totalReviews) {
        this.userid = userid;
        this.courseID = courseID;
        this.name = name;
        this.expertName = expertName;
        this.image = image;
        this.description = description;
        this.price = price;
        this.averageRating = averageRating;
        this.totalReviews = totalReviews;
    }

    public Courses(int courseID, String name, String description, float price, String image, String category, String expertName, double averageRating) {
        this.courseID = courseID;
        this.name = name;

        this.description = description;
        this.price = price;
        this.image = image;
        this.category = category;
        this.expertName = expertName;
        this.averageRating = averageRating;

    }

    public Courses(int courseID, String name, String expertName, float price, double averageRating, int totalReviews) {
        this.courseID = courseID;
        this.name = name;
        this.expertName = expertName;
        this.price = price;
        this.averageRating = averageRating;
        this.totalReviews = totalReviews;
    }

    public Courses(int courseID, String name, String description, float price) {
        this.courseID = courseID;
        this.name = name;
        this.description = description;
        this.price = price;
    }

    public Courses(int courseID, String name, String image, String description) {
        this.courseID = courseID;
        this.name = name;
        this.image = image;
        this.description = description;
    }

    public Courses(int courseID, String name, float price, String image, String description) {
        this.courseID = courseID;
        this.name = name;
        this.price = price;
        this.image = image;
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getExpertName() {
        return expertName;
    }

    public void setExpertName(String expertName) {
        this.expertName = expertName;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public int getTotalReviews() {
        return totalReviews;
    }

    public void setTotalReviews(int totalReviews) {
        this.totalReviews = totalReviews;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    // Getter và Setter
    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "Courses{" + "courseID=" + courseID + ", name=" + name + ", description=" + description + ", price=" + price + '}';
    }

}
