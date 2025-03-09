package Model;

import java.util.*;
import java.lang.*;

public class MoneyHistoryByAdmin {
    private int PayID;
    private int Status;
    private Date CreateAt;
    private int CourseID;
    private String CourseName;
    private String PaymentMethod;
    private Date PaymentDate;
    private float Price;

    public MoneyHistoryByAdmin() {
    }

    public MoneyHistoryByAdmin(int PayID, int Status, Date CreateAt, int CourseID, String CourseName, String PaymentMethod, Date PaymentDate, float Price) {
        this.PayID = PayID;
        this.Status = Status;
        this.CreateAt = CreateAt;
        this.CourseID = CourseID;
        this.CourseName = CourseName;
        this.PaymentMethod = PaymentMethod;
        this.PaymentDate = PaymentDate;
        this.Price = Price;
    }

    public int getPayID() {
        return PayID;
    }

    public void setPayID(int PayID) {
        this.PayID = PayID;
    }

    public int getStatus() {
        return Status;
    }

    public void setStatus(int Status) {
        this.Status = Status;
    }

    public Date getCreateAt() {
        return CreateAt;
    }

    public void setCreateAt(Date CreateAt) {
        this.CreateAt = CreateAt;
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

    public String getPaymentMethod() {
        return PaymentMethod;
    }

    public void setPaymentMethod(String PaymentMethod) {
        this.PaymentMethod = PaymentMethod;
    }

    public Date getPaymentDate() {
        return PaymentDate;
    }

    public void setPaymentDate(Date PaymentDate) {
        this.PaymentDate = PaymentDate;
    }

    public float getPrice() {
        return Price;
    }

    public void setPrice(float Price) {
        this.Price = Price;
    }

    @Override
    public String toString() {
        return "MoneyHistoryByAdmin{" + "PayID=" + PayID + ", Status=" + Status + ", CreateAt=" + CreateAt + ", CourseID=" + CourseID + ", CourseName=" + CourseName + ", PaymentMethod=" + PaymentMethod + ", PaymentDate=" + PaymentDate + ", Price=" + Price + '}';
    }
}
