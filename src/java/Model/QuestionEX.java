package Model;

public class QuestionEX {

    int questionID;
    String questionType;
    String questionContent;
    String optionA;
    String optionB;
    String optionC;
    String optionD;
    int testID;
    int status;
    String correctAnswer;

    // Constructor
    public QuestionEX() {
    }

    public QuestionEX(int questionID, String questionType, String questionContent, String optionA, String optionB, String optionC, String optionD, int testID) {
        this.questionID = questionID;
        this.questionType = questionType;
        this.questionContent = questionContent;
        this.optionA = optionA;
        this.optionB = optionB;
        this.optionC = optionC;
        this.optionD = optionD;
        this.testID = testID;
    }

    public QuestionEX(int questionID, String questionContent, String optionA, String optionB, String optionC, String optionD, int testID) {
        this.questionID = questionID;
        this.questionContent = questionContent;
        this.optionA = optionA;
        this.optionB = optionB;
        this.optionC = optionC;
        this.optionD = optionD;
        this.testID = testID;
    }

    public QuestionEX(int questionID, String questionContent, String optionA, String optionB,
            String optionC, String optionD, int testID, int status) {
        this.questionID = questionID;
        this.questionContent = questionContent;
        this.optionA = optionA;
        this.optionB = optionB;
        this.optionC = optionC;
        this.optionD = optionD;
        this.testID = testID;
        this.status = status;
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    // Getters and Setters
    public int getQuestionID() {
        return questionID;
    }

    public void setQuestionID(int questionID) {
        this.questionID = questionID;
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

    public int getTestID() {
        return testID;
    }

    public void setTestID(int testID) {
        this.testID = testID;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
