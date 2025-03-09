/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Administrator
 */
public class CustomerCourse {

    int courseId;
    String courseName;
    String description;
    float price;
    String instructor;

    public CustomerCourse(int courseId, String courseName, String description, float price, String instructor) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.description = description;
        this.price = price;
        this.instructor = instructor;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public void setInstructor(String instructor) {
        this.instructor = instructor;
    }

    public int getCourseId() {
        return courseId;
    }

    public String getCourseName() {
        return courseName;
    }

    public String getDescription() {
        return description;
    }

    public float getPrice() {
        return price;
    }

    public String getInstructor() {
        return instructor;
    }

    @Override
    public String toString() {
        return "CustomerCourse{" + "courseId=" + courseId + ", name=" + courseName + ", description=" + description + ", price=" + price + ", instructor=" + instructor + '}';
    }

}
