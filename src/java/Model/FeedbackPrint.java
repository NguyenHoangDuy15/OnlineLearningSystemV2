package Model;

import java.util.*;
import java.lang.*;

public class FeedbackPrint {
    private int FbID;
    private String Username;
    private String CourseName;
    private int Rating;
    private String Comment;
    private Date CreateAt;

    public FeedbackPrint() {
    }

    public FeedbackPrint(int FbID, String Username, String CourseName, int Rating, String Comment, Date CreateAt) {
        this.FbID = FbID;
        this.Username = Username;
        this.CourseName = CourseName;
        this.Rating = Rating;
        this.Comment = Comment;
        this.CreateAt = CreateAt;
    }

    public int getFbID() {
        return FbID;
    }

    public void setFbID(int FbID) {
        this.FbID = FbID;
    }

    public String getUsername() {
        return Username;
    }

    public void setUsername(String Username) {
        this.Username = Username;
    }

    public String getCourseName() {
        return CourseName;
    }

    public void setCourseName(String CourseName) {
        this.CourseName = CourseName;
    }

    public int getRating() {
        return Rating;
    }

    public void setRating(int Rating) {
        this.Rating = Rating;
    }

    public String getComment() {
        return Comment;
    }

    public void setComment(String Comment) {
        this.Comment = Comment;
    }

    public Date getCreateAt() {
        return CreateAt;
    }

    public void setCreateAt(Date CreateAt) {
        this.CreateAt = CreateAt;
    }

    @Override
    public String toString() {
        return "FeedbackPrint{" + "FbID=" + FbID + ", Username=" + Username + ", CourseName=" + CourseName + ", Rating=" + Rating + ", Comment=" + Comment + ", CreateAt=" + CreateAt + '}';
    }
    
}
