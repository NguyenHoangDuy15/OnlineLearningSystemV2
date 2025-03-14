
package Model;
public class History {
     int historyID;
     int userID;
     int testID;

    public History(int historyID, int userID, int testID) {
        this.historyID = historyID;
        this.userID = userID;
        this.testID = testID;
    }

    public History() {
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
