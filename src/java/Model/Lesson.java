package Model;
public class Lesson {

    private String type;
    private int id;
    private String name;
   
    private String content; // Để null cho Test
    private String status;

    public Lesson(String type, int id, String name, String content) {
        this.type = type;
        this.id = id;
        this.name = name;
        this.content = content;
    }

    public Lesson(String type, int id, String name, String content, String status) {
        this.type = type;
        this.id = id;
        this.name = name;
        
        this.content = content;
        this.status = status;
    }

    // Getters & Setters
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

   

   

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Lesson{" + "type=" + type + ", id=" + id + ", name=" + name + ", content=" + content + ", status=" + status + '}';
    }
    
}
