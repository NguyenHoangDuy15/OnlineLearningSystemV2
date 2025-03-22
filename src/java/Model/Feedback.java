package Model;

import java.sql.Date;

public class Feedback {

    int feedbackid;
    int userId;
    int courseId;
    int rating;
    String comment;
    Date createdAt;
    String customername;
    String course;
    String avartar;
    String name;

    public Feedback(int userId, int courseId, int rating, String comment, Date createdAt) {
        this.userId = userId;
        this.courseId = courseId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public Feedback(int feedbackid, String name, int userId, int courseId, String avartar, int rating, String comment, Date createdAt) {
        this.feedbackid = feedbackid;
        this.name = name;
        this.userId = userId;
        this.courseId = courseId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
        this.avartar = avartar;

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

    public int getFeedbackid() {
        return feedbackid;
    }

    public void setFeedbackid(int feedbackid) {
        this.feedbackid = feedbackid;
    }

    // Getter & Setter
    public int getUserId() {
        return userId;
    }

    public String getAvartar() {
        return avartar;
    }

    public void setAvartar(String avartar) {
        this.avartar = avartar;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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
