
package Model;
public class History {
     int historyID;
     int userID;
     int courseID;
     int testID;
     
     int teststatus;
     int coursestatus;
     String creatat;
    public History(int historyID, int userID, int testID) {
        this.historyID = historyID;
        this.userID = userID;
        this.testID = testID;
    }

    public History() {
    }

    public History(int historyID, int userID, int courseID, int testID, int teststatus, int coursestatus, String creatat) {
        this.historyID = historyID;
        this.userID = userID;
        this.courseID = courseID;
        this.testID = testID;
        this.teststatus = teststatus;
        this.coursestatus = coursestatus;
        this.creatat = creatat;
    }

 

    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    public int getTeststatus() {
        return teststatus;
    }

    public void setTeststatus(int teststatus) {
        this.teststatus = teststatus;
    }

    public int getCoursestatus() {
        return coursestatus;
    }

    public void setCoursestatus(int coursestatus) {
        this.coursestatus = coursestatus;
    }

    public String getCreatat() {
        return creatat;
    }

    public void setCreatat(String creatat) {
        this.creatat = creatat;
    }

    public int getHistoryID() {
        return historyID;
    }

    public void setHistoryID(int historyID) {
        this.historyID = historyID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getTestID() {
        return testID;
    }

    public void setTestID(int testID) {
        this.testID = testID;
    }

    @Override
    public String toString() {
        return "History{" + "historyID=" + historyID + ", userID=" + userID + ", testID=" + testID + '}';
    }
    
}
