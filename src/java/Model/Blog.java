package Model;

import java.util.*;
import java.lang.*;

public class Blog {

    private int BlogID;
    private String BlogTitle;
    private String BlogDetail;
    private String BlogImage;
    private Date BlogDate;
    private int UserID;

    public Blog() {
    }

    public Blog(int BlogID, String BlogTitle, String BlogDetail, String BlogImage, Date BlogDate, int UserID) {
        this.BlogID = BlogID;
        this.BlogTitle = BlogTitle;
        this.BlogDetail = BlogDetail;
        this.BlogImage = BlogImage;
        this.BlogDate = BlogDate;
        this.UserID = UserID;
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

    public String getBlogDetail() {
        return BlogDetail;
    }

    public void setBlogDetail(String BlogDetail) {
        this.BlogDetail = BlogDetail;
    }

    public String getBlogImage() {
        return BlogImage;
    }

    public void setBlogImage(String BlogImage) {
        this.BlogImage = BlogImage;
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

    @Override
    public String toString() {
        return "Blog{" + "BlogID=" + BlogID + ", BlogTitle=" + BlogTitle + ", BlogDetail=" + BlogDetail + ", BlogImage=" + BlogImage + ", BlogDate=" + BlogDate + ", UserID=" + UserID + '}';
    }
}
