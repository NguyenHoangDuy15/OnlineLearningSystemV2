/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;

/**
 *
 * @author Administrator
 */
public class Transaction {

    int transactionID;
    int payid;
    int status;
    Date createdAt;
    int courseID;
    String paymentMethod;
    String courseName;
    double paidAmount;

    int userID;

    public Transaction() {
    }

    public Transaction(int transactionID, int userID, int courseID, String courseName, double paidAmount, String paymentMethod, int status, Date createdAt) {
        this.transactionID = transactionID;
        this.userID = userID;
        this.courseID = courseID;
        this.courseName = courseName;
        this.paidAmount = paidAmount;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.createdAt = createdAt;
    }

    public Transaction(int payid, int courseID, String paymentMethod) {
        this.transactionID = transactionID;
        this.payid = payid;

        this.courseID = courseID;
        this.paymentMethod = paymentMethod;
    }

    public int getTransactionID() {
        return transactionID;
    }

    public void setTransactionID(int transactionID) {
        this.transactionID = transactionID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public double getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(double paidAmount) {
        this.paidAmount = paidAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getPayid() {
        return payid;
    }

    public void setPayid(int payid) {
        this.payid = payid;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Transaction{" + "transactionID=" + transactionID + ", userID=" + userID + ", courseID=" + courseID + ", courseName=" + courseName + ", paidAmount=" + paidAmount + ", paymentMethod=" + paymentMethod + ", status=" + status + ", createdAt=" + createdAt + '}';
    }

}
