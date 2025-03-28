package Model;

public class History {

    int historyID;
    int userID;
    int courseID;
    int testID;
    int correctAnswers;
    int totalQuestions;
    int teststatus;
    int coursestatus;
    String creatat;
    int score;

    public History(int historyID, int userID, int testID) {
        this.historyID = historyID;
        this.userID = userID;
        this.testID = testID;
    }

    public History() {
    }

    public History(int historyID, String creatat, int teststatus, int correctAnswers, int totalQuestions) {
        this.historyID = historyID;
        this.creatat = creatat;
        this.teststatus = teststatus;
        this.correctAnswers = correctAnswers;

        this.totalQuestions = totalQuestions;

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

    public int getCorrectAnswers() {
        return correctAnswers;
    }

    public void setCorrectAnswers(int correctAnswers) {
        this.correctAnswers = correctAnswers;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
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
