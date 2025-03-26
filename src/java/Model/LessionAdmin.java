package Model;

/**
 *
 * @author DELL
 */
import java.util.*;
import java.lang.*;

public class LessionAdmin {

    private int LessionID;
    private String Content;
    private int CourseID;
    private String Title;
    private int Status;

    public LessionAdmin() {
    }

    public LessionAdmin(int LessionID, String Content, int CourseID, String Title, int Status) {
        this.LessionID = LessionID;
        this.Content = Content;
        this.CourseID = CourseID;
        this.Title = Title;
        this.Status = Status;
    }

    public int getLessionID() {
        return LessionID;
    }

    public void setLessionID(int LessionID) {
        this.LessionID = LessionID;
    }

    public String getContent() {
        return Content;
    }

    public void setContent(String Content) {
        this.Content = Content;
    }

    public int getCourseID() {
        return CourseID;
    }

    public void setCourseID(int CourseID) {
        this.CourseID = CourseID;
    }

    public String getTitle() {
        return Title;
    }

    public void setTitle(String Title) {
        this.Title = Title;
    }

    public int getStatus() {
        return Status;
    }

    public void setStatus(int Status) {
        this.Status = Status;
    }

    @Override
    public String toString() {
        return "LessionAdmin{" + "LessionID=" + LessionID + ", Content=" + Content + ", CourseID=" + CourseID + ", Title=" + Title + ", Status=" + Status + '}';
    }
    
    

}
