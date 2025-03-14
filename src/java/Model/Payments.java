/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Administrator
 */
public class Payments {
    int payid;
    int userid;
    int courseid;
    double amount;

    public Payments() {
    }
    

    public Payments(int userid, int courseid, double amount) {
        this.userid = userid;
        this.courseid = courseid;
        this.amount = amount;
    }


    public int getPayid() {
        return payid;
    }

    public void setPayid(int payid) {
        this.payid = payid;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public int getCourseid() {
        return courseid;
    }

    public void setCourseid(int courseid) {
        this.courseid = courseid;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    @Override
    public String toString() {
        return "Payment{" + "payid=" + payid + ", userid=" + userid + ", courseid=" + courseid + ", amount=" + amount + '}';
    }
    
    
}
