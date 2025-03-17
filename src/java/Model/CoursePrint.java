package Model;

/**
 *
 * @author DELL
 */
import java.util.*;
import java.lang.*;

public class CoursePrint {
    private int CourseID;
    private String CourseName;
    private String Description;
    private String CreatedBy;
    private double price;

    public CoursePrint() {
    }

    public CoursePrint(int CourseID, String CourseName, String Description, String CreatedBy, double price) {
        this.CourseID = CourseID;
        this.CourseName = CourseName;
        this.Description = Description;
        this.CreatedBy = CreatedBy;
        this.price = price;
    }

    public int getCourseID() {
        return CourseID;
    }

    public void setCourseID(int CourseID) {
        this.CourseID = CourseID;
    }

    public String getCourseName() {
        return CourseName;
    }

    public void setCourseName(String CourseName) {
        this.CourseName = CourseName;
    }

    public String getDescription() {
        return Description;
    }

    public void setDescription(String Description) {
        this.Description = Description;
    }

    public String getCreatedBy() {
        return CreatedBy;
    }

    public void setCreatedBy(String CreatedBy) {
        this.CreatedBy = CreatedBy;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "CoursePrint{" + "CourseID=" + CourseID + ", CourseName=" + CourseName + ", Description=" + Description + ", CreatedBy=" + CreatedBy + ", price=" + price + '}';
    }
    
}
