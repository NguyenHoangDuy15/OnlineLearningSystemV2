/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

public class Enrollment {

    private int enrollmentId;
    private int userId;
    private String fullName;
    private int courseId;
    private String courseName;
    private String imageCourses;
    private String description;
    private int paymentStatus;

    public Enrollment() {
    }

    // Constructor
    public Enrollment(int enrollmentId, int userId, String fullName, int courseId, String courseName,
            String imageCourses, String description, int paymentStatus) {
        this.enrollmentId = enrollmentId;
        this.userId = userId;
        this.fullName = fullName;
        this.courseId = courseId;
        this.courseName = courseName;
        this.imageCourses = imageCourses;
        this.description = description;
        this.paymentStatus = paymentStatus;
    }

    // Getters and Setters
    public int getEnrollmentId() {
        return enrollmentId;
    }

    public void setEnrollmentId(int enrollmentId) {
        this.enrollmentId = enrollmentId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
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

    public int getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(int paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    @Override
    public String toString() {
        return "Enrollment{" + "enrollmentId=" + enrollmentId + ", userId=" + userId + ", fullName=" + fullName + ", courseId=" + courseId + ", courseName=" + courseName + ", imageCourses=" + imageCourses + ", description=" + description + ", paymentStatus=" + paymentStatus + '}';
    }


}
