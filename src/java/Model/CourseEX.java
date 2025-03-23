/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */


package Model;
/**
 *
 * @author CONG NINH
 */
import java.util.*;
 import java.lang.*;
 import java.io.*;
public class CourseEX {
 int userid;
    int courseID;
    String name;
    String description;
    float price;
        int status;
    String image;
    int category;
  


    public CourseEX(int userid, int courseID, String name, float price, String image, int category, String description, int status) {
        this.userid = userid;
        this.courseID = courseID;
        this.name = name;
        this.price = price;
        this.image = image;
        this.category = category;
        this.description = description;
        this.status = status;
    }
 public CourseEX(int courseID, String name, String description, float price) {
        this.courseID = courseID;
        this.name = name;
        this.description = description;
        this.price = price;
        
    }

    public CourseEX(int courseID, String name, String description , String image) {
        this.courseID = courseID;
        this.name = name;
        this.image = image;
        this.description = description;
    }
    public CourseEX(int courseID, String name,float price, String description , String image) {
        this.courseID = courseID;
        this.name = name;
        this.price=price;
        this.description = description;
        this.image = image;
      
        
    }

    public CourseEX( String name, float price, String image, int userid, String description) {
        this.userid = userid;
        this.name = name;
        this.price = price;
        this.image = image;
        this.category = category;
        this.description = description;
    }
    public CourseEX(int courseID, String name, String description,float price, int status) {
        this.courseID = courseID;
        this.name = name;       
        this.description = description;
        this.price=price;
        this.status = status;
      
        
    }
    
    public CourseEX() {
    }

    public CourseEX(String name, String description, float price, String image, Integer userID, int category) {
        this.name=name;
        this.description=description;
        this.price=price;
        this.image=image;
        this.userid=userID;
        this.category=category;
    }
     public CourseEX(String name, String description, float price, String image, int userID, int category) {
        this.name=name;
        this.description=description;
        this.price=price;
        this.image=image;
        this.userid=userID;
        this.category=category;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

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

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getCategory() {
        return category;
    }

    public void setCategory(int category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "CourseEX{" + "userid=" + userid + ", courseID=" + courseID + ", name=" + name + ", price=" + price + ", image=" + image + ", category=" + category + ", description=" + description + ", status=" + status + '}';
    }

   
    
}
