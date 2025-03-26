package Model;

/**
 *
 * @author DELL
 */
import java.util.*;
import java.lang.*;

public class TestAdmin {
    private int TestID;
    private String Name;
    private int Status;
    private String CreatedBy;
    private int CourseID;

    public TestAdmin() {
    }

    public TestAdmin(int TestID, String Name, int Status, String CreatedBy, int CourseID) {
        this.TestID = TestID;
        this.Name = Name;
        this.Status = Status;
        this.CreatedBy = CreatedBy;
        this.CourseID = CourseID;
    }

    public int getTestID() {
        return TestID;
    }

    public void setTestID(int TestID) {
        this.TestID = TestID;
    }

    public String getName() {
        return Name;
    }

    public void setName(String Name) {
        this.Name = Name;
    }

    public int getStatus() {
        return Status;
    }

    public void setStatus(int Status) {
        this.Status = Status;
    }

    public String getCreatedBy() {
        return CreatedBy;
    }

    public void setCreatedBy(String CreatedBy) {
        this.CreatedBy = CreatedBy;
    }

    public int getCourseID() {
        return CourseID;
    }

    public void setCourseID(int CourseID) {
        this.CourseID = CourseID;
    }

    @Override
    public String toString() {
        return "TestAdmin{" + "TestID=" + TestID + ", Name=" + Name + ", Status=" + Status + ", CreatedBy=" + CreatedBy + ", CourseID=" + CourseID + '}';
    }
    
    
}
