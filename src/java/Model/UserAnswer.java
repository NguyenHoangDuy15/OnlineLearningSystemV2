package Model;

public class UserAnswer {

  

    int userID;
    int testID;
    int questionID;
    String questionContent;
    String optionA;
    String optionB;
    String optionC;
    String optionD;
    String answerOption;
    boolean isCorrectAnswer;
    int answerID;
    
    int historyid;

    public UserAnswer(int userID, int testID, int questionID, String answerOption, int answerID, boolean isCorrectAnswer, int historyid) {
        this.userID = userID;
        this.testID = testID;
        this.questionID = questionID;
        this.answerOption = answerOption;
        this.answerID = answerID;
        this.isCorrectAnswer = isCorrectAnswer;
        this.historyid = historyid;
    }

    public UserAnswer(int questionID, String questionContent, String optionA, String optionB, String optionC, String optionD, String answerOption, boolean isCorrectAnswer) {
        this.questionID = questionID;
        this.questionContent = questionContent;
        this.optionA = optionA;
        this.optionB = optionB;
        this.optionC = optionC;
        this.optionD = optionD;
        this.answerOption = answerOption;
        this.isCorrectAnswer = isCorrectAnswer;
    }

  
    public UserAnswer() {
    }

    public String getQuestionContent() {
        return questionContent;
    }

    public void setQuestionContent(String questionContent) {
        this.questionContent = questionContent;
    }

    public String getOptionA() {
        return optionA;
    }

    public void setOptionA(String optionA) {
        this.optionA = optionA;
    }

    public String getOptionB() {
        return optionB;
    }

    public void setOptionB(String optionB) {
        this.optionB = optionB;
    }

    public String getOptionC() {
        return optionC;
    }

    public void setOptionC(String optionC) {
        this.optionC = optionC;
    }

    public String getOptionD() {
        return optionD;
    }

    public void setOptionD(String optionD) {
        this.optionD = optionD;
    }

    public int getHistoryid() {
        return historyid;
    }

    public void setHistoryid(int historyid) {
        this.historyid = historyid;
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

    public int getQuestionID() {
        return questionID;
    }

    public void setQuestionID(int questionID) {
        this.questionID = questionID;
    }

    public String getAnswerOption() {
        return answerOption;
    }

    public void setAnswerOption(String answerOption) {
        this.answerOption = answerOption;
    }

    public int getAnswerID() {
        return answerID;
    }

    public void setAnswerID(int answerID) {
        this.answerID = answerID;
    }

    public boolean isIsCorrectAnswer() {
        return isCorrectAnswer;
    }

    public void setIsCorrectAnswer(boolean isCorrectAnswer) {
        this.isCorrectAnswer = isCorrectAnswer;
    }

    @Override
    public String toString() {
        return "UserAnswer{" + "userID=" + userID + ", testID=" + testID + ", questionID=" + questionID + ", answerOption=" + answerOption + ", answerID=" + answerID + ", isCorrectAnswer=" + isCorrectAnswer + '}';
    }

}
