package Model;

import java.sql.Date;

public class Feedback {

    int userId;
    int courseId;
    int rating;
    String comment;
    Date createdAt;
    String customername;
    String course;

    public Feedback(int userId, int courseId, int rating, String comment, Date createdAt) {
        this.userId = userId;
        this.courseId = courseId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    // Constructor mặc định
    public Feedback() {
    }

    public Feedback(String comment, String customername, String course) {
        this.comment = comment;
        this.customername = customername;
        this.course = course;
    }


    // Constructor KHÔNG có createdAt (Dùng khi SQL tự lấy ngày)
    public Feedback(int userId, int courseId, int rating, String comment) {
        this.userId = userId;
        this.courseId = courseId;
        this.rating = rating;
        this.comment = comment;

    }

    // Getter & Setter
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getCustomername() {
        return customername;
    }

    public void setCustomername(String customername) {
        this.customername = customername;
    }

    public String getCourse() {
        return course;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    @Override
    public String toString() {
        return "Feedback{userId=" + userId + ", courseId=" + courseId
                + ", rating=" + rating + ", comment=" + comment + ", createdAt=" + createdAt + '}';
    }
}
