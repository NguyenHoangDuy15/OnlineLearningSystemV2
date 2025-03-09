package Model;

import java.util.*;
import java.lang.*;

public class BlogPrint {

    private int BlogID;
    private String BlogTitle;
    private Date BlogDate;
    private int UserID;
    private String UserName;

    public BlogPrint() {
    }

    public BlogPrint(int BlogID, String BlogTitle, Date BlogDate, int UserID, String UserName) {
        this.BlogID = BlogID;
        this.BlogTitle = BlogTitle;
        this.BlogDate = BlogDate;
        this.UserID = UserID;
        this.UserName = UserName;
    }

    public int getBlogID() {
        return BlogID;
    }

    public void setBlogID(int BlogID) {
        this.BlogID = BlogID;
    }

    public String getBlogTitle() {
        return BlogTitle;
    }

    public void setBlogTitle(String BlogTitle) {
        this.BlogTitle = BlogTitle;
    }

    public Date getBlogDate() {
        return BlogDate;
    }

    public void setBlogDate(Date BlogDate) {
        this.BlogDate = BlogDate;
    }

    public int getUserID() {
        return UserID;
    }

    public void setUserID(int UserID) {
        this.UserID = UserID;
    }

    public String getUserName() {
        return UserName;
    }

    public void setUserName(String UserName) {
        this.UserName = UserName;
    }

    @Override
    public String toString() {
        return "BlogPrint{" + "BlogID=" + BlogID + ", BlogTitle=" + BlogTitle + ", BlogDate=" + BlogDate + ", UserID=" + UserID + ", UserName=" + UserName + '}';
    }
    

}
