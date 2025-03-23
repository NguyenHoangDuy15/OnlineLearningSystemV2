package Model;

public class LessonEX {
    private int lessonID;
    private int courseID;
    private String title;
    private String content;
    private int status;

    public LessonEX() {
    }

    public LessonEX(int lessonID, int courseID, String title, String content, int status) {
        this.lessonID = lessonID;
        this.courseID = courseID;
        this.title = title;
        this.content = content;
        this.status = status;
    }

    public LessonEX(int courseID, String title, String content) {
        this.courseID = courseID;
        this.title = title;
        this.content = content;
        this.status = 1; 
    }

    public int getLessonID() {
        return lessonID;
    }

    public void setLessonID(int lessonID) {
        this.lessonID = lessonID;
    }

    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "LessonEX{" + "lessonID=" + lessonID + ", courseID=" + courseID + ", title=" + title + ", content=" + content + ", status=" + status + '}';
    }
}