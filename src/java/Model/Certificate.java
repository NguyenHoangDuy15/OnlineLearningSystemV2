/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Administrator
 */
public class Certificate {

    int userid;
    String fullname;
    int courseId;
    String name;
    String imageCourses;
    String description;
    String courseStatus;
    String completionTime;

    public Certificate() {
    }

    public Certificate(String fullname, int coutseId, String name, String imageCourses, String description, String completionTime) {
        this.fullname = fullname;
        this.courseId = coutseId;
        this.name = name;
        this.imageCourses = imageCourses;
        this.description = description;
        this.completionTime = completionTime;
    }

    public Certificate(int courseId, String name, String imageCourses, String description,
            String courseStatus) {
        this.courseId = courseId;
        this.name = name;
        this.imageCourses = imageCourses;
        this.description = description;
        this.courseStatus = courseStatus;

    }

    public String getCompletionTime() {
        return completionTime;
    }

    public void setCompletionTime(String completionTime) {
        this.completionTime = completionTime;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    // Getters & Setters
    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImageCourses() {
        return imageCourses;
    }

    public void setImageCourses(String imageCourses) {
        this.imageCourses = imageCourses;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCourseStatus() {
        return courseStatus;
    }

    public void setCourseStatus(String courseStatus) {
        this.courseStatus = courseStatus;
    }

}
