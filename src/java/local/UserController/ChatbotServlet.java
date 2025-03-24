package local.UserController;

import dal.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import org.json.JSONObject;

@WebServlet(name = "ChatbotServlet", urlPatterns = {"/ChatbotServlet"})
public class ChatbotServlet extends HttpServlet {

    private String API_KEY;
    private String API_URL;
    private DBContext dbContext;

    // Khởi tạo servlet, đọc cấu hình API và kết nối cơ sở dữ liệu
    @Override
    public void init() throws ServletException {
        Properties props = new Properties();
        try (InputStream input = getServletContext().getResourceAsStream("/WEB-INF/config.properties")) {
            if (input == null) {
                throw new ServletException("Không tìm thấy tệp config.properties trong WEB-INF");
            }
            props.load(input);
            API_KEY = props.getProperty("api.key");
            API_URL = props.getProperty("api.url");
            if (API_KEY == null || API_URL == null) {
                throw new ServletException("Thiếu api.key hoặc api.url trong config.properties");
            }
            API_URL = API_URL + "?key=" + API_KEY;
        } catch (IOException e) {
            throw new ServletException("Không thể tải tệp config.properties", e);
        }

        try {
            dbContext = new DBContext();
        } catch (Exception e) {
            log("Không thể khởi tạo DBContext: " + e.getMessage(), e);
            dbContext = null;
        }
    }

    // Xử lý yêu cầu POST từ JSP
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String userMessage = request.getParameter("message");
        JSONObject jsonResponse = new JSONObject();

        try {
            if (userMessage == null || userMessage.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.put("userMessage", "");
                jsonResponse.put("botResponse", "Vui lòng nhập tin nhắn!");
            } else {
                // Làm sạch dữ liệu đầu vào để tránh XSS
                userMessage = userMessage.trim().replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                String botResponse = processMessage(userMessage);
                jsonResponse.put("userMessage", userMessage);
                jsonResponse.put("botResponse", botResponse);
            }
        } catch (Exception e) {
            log("Lỗi trong doPost: " + e.getMessage(), e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.put("userMessage", userMessage != null ? userMessage : "");
            jsonResponse.put("botResponse", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
        }

        response.getWriter().write(jsonResponse.toString());
    }

    // Xử lý tin nhắn của người dùng
    private String processMessage(String message) {
        String lowercaseMessage = message.toLowerCase();
        String contextData = "";
        boolean isPriceQuery = lowercaseMessage.contains("giá") || lowercaseMessage.contains("price") || lowercaseMessage.contains("bao nhiêu");
        String courseName = null;

        // Trích xuất tên khóa học nếu người dùng hỏi cụ thể (ví dụ: "khóa học Java")
        if (lowercaseMessage.contains("khóa học")) {
            String[] words = lowercaseMessage.split("khóa học");
            if (words.length > 1) {
                courseName = words[1].trim();
                courseName = courseName.replace("giá", "").replace("là", "").replace("bao nhiêu", "").trim();
            }
        }

        // Truy vấn cơ sở dữ liệu nếu DBContext khả dụng
        if (dbContext != null) {
            try {
                if (lowercaseMessage.contains("lessons") || lowercaseMessage.contains("courses") || lowercaseMessage.contains("khóa học")) {
                    contextData = fetchCourses(courseName);
                } else if (lowercaseMessage.contains("category") || lowercaseMessage.contains("danh mục")) {
                    contextData = fetchCategories();
                } else if (lowercaseMessage.contains("tổng số người tham gia") || lowercaseMessage.contains("số người tham gia") || lowercaseMessage.contains("participants")) {
                    contextData = fetchTotalParticipants();
                } else if (lowercaseMessage.contains("bài kiểm tra") || lowercaseMessage.contains("test")) {
                    contextData = fetchTests();
                }
            } catch (SQLException e) {
                log("Lỗi khi truy xuất dữ liệu từ cơ sở dữ liệu: " + e.getMessage(), e);
                contextData = "Không thể truy cập cơ sở dữ liệu. Tôi sẽ trả lời dựa trên kiến thức chung.";
            }
        } else {
            contextData = "Không thể truy cập cơ sở dữ liệu. Tôi sẽ trả lời dựa trên kiến thức chung.";
        }

        // Tạo prompt để gửi đến API chatbot
        String fullPrompt;
        if (contextData.isEmpty() || contextData.contains("Không thể truy cập cơ sở dữ liệu")) {
            fullPrompt = "Bạn là một trợ lý thông minh cho một nền tảng học lập trình trực tuyến. "
                    + "Hãy trả lời câu hỏi sau một cách tự nhiên, chính xác và phù hợp với người học lập trình:\n"
                    + message;
        } else {
            if (isPriceQuery) {
                fullPrompt = "Bạn là một trợ lý thông minh cho một nền tảng học lập trình trực tuyến. "
                        + "Dưới đây là thông tin từ cơ sở dữ liệu:\n"
                        + contextData + "\nDựa trên thông tin này, hãy trả lời câu hỏi sau một cách tự nhiên, chính xác và phù hợp với người học lập trình, tập trung vào thông tin về giá cả:\n"
                        + message + "\nNếu cần, hãy trả lời dựa trên kiến thức chung.";
            } else {
                fullPrompt = "Bạn là một trợ lý thông minh cho một nền tảng học lập trình trực tuyến. "
                        + "Dưới đây là thông tin từ cơ sở dữ liệu:\n"
                        + contextData + "\nDựa trên thông tin này, hãy trả lời câu hỏi sau một cách tự nhiên, chính xác và phù hợp với người học lập trình:\n"
                        + message + "\nNếu cần, hãy trả lời dựa trên kiến thức chung.";
            }
        }

        String botResponse = callChatbotAPI(fullPrompt);

        // Nếu người dùng hỏi về giá nhưng câu trả lời không chứa thông tin giá, tự động trích xuất từ contextData
        if (isPriceQuery && !botResponse.toLowerCase().contains("giá") && !botResponse.toLowerCase().contains("miễn phí")) {
            if (contextData.contains("Khóa học") && courseName != null) {
                String[] lines = contextData.split("\n");
                for (String line : lines) {
                    if (line.toLowerCase().contains(courseName.toLowerCase())) {
                        String[] parts = line.split(", ");
                        for (String part : parts) {
                            if (part.startsWith("Giá: ")) {
                                botResponse = "Giá của khóa học " + courseName + " là " + part.substring(5) + ".";
                                break;
                            }
                        }
                        break;
                    }
                }
            }
        }

        return botResponse;
    }

    // Lấy danh sách khóa học từ cơ sở dữ liệu
    private String fetchCourses(String courseName) throws SQLException {
        StringBuilder result = new StringBuilder("Danh sách khóa học:\n");
        String query = "SELECT c.CourseID, c.Name, c.Price, cat.CategoryName AS CategoryName\n"
                + "FROM Courses c \n"
                + "JOIN Category cat ON c.CategoryID = cat.CategoryID\n";
        if (courseName != null && !courseName.isEmpty()) {
            query += "WHERE c.Name LIKE ?";
        }
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            if (courseName != null && !courseName.isEmpty()) {
                stmt.setString(1, "%" + courseName + "%");
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    double price = rs.getDouble("Price");
                    boolean isPriceNull = rs.wasNull();
                    String priceStr = isPriceNull ? "Miễn phí" : String.format("%.2f", price);
                    result.append(String.format("Khóa học: %s (ID: %d), Giá: %s, Danh mục: %s\n",
                            rs.getString("Name"), rs.getInt("CourseID"),
                            priceStr, rs.getString("CategoryName")));
                }
            }
        }
        return result.toString();
    }

    // Lấy danh sách danh mục từ cơ sở dữ liệu
    private String fetchCategories() throws SQLException {
        StringBuilder result = new StringBuilder("Danh sách danh mục:\n");
        String query = "SELECT CategoryID, CategoryName, Description FROM Category";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                result.append(String.format("Danh mục: %s (ID: %d), Mô tả: %s\n",
                        rs.getString("CategoryName"), rs.getInt("CategoryID"),
                        rs.getString("Description")));
            }
        }
        return result.toString();
    }

    // Lấy thông tin số người tham gia từ bảng History
    private String fetchTotalParticipants() throws SQLException {
        StringBuilder result = new StringBuilder("Thông tin về số người tham gia:\n");
        String totalQuery = "SELECT COUNT(*) AS TotalParticipants FROM History";
        int totalParticipants = 0;
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(totalQuery);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                totalParticipants = rs.getInt("TotalParticipants");
                result.append(String.format("Tổng số người tham gia các khóa học: %d\n", totalParticipants));
            }
        }

        String perCourseQuery = "SELECT c.Name, COUNT(h.UserID) AS ParticipantCount \n"
                + "FROM History h \n"
                + "JOIN Courses c ON h.CourseID = c.CourseID \n"
                + "GROUP BY c.CourseID, c.Name";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(perCourseQuery);
             ResultSet rs = stmt.executeQuery()) {
            result.append("Số người tham gia theo từng khóa học:\n");
            while (rs.next()) {
                result.append(String.format("- Khóa học: %s, Số người tham gia: %d\n",
                        rs.getString("Name"), rs.getInt("ParticipantCount")));
            }
        }
        return result.toString();
    }

    // Lấy danh sách bài kiểm tra từ cơ sở dữ liệu
    private String fetchTests() throws SQLException {
        StringBuilder result = new StringBuilder("Danh sách bài kiểm tra:\n");
        String query = "SELECT t.TestID, t.Name, t.Status, c.Name AS CourseName \n"
                + "FROM Test t \n"
                + "JOIN Courses c ON t.CourseID = c.CourseID";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                result.append(String.format("Bài kiểm tra: %s (ID: %d), Trạng thái: %s, Khóa học: %s\n",
                        rs.getString("Name"), rs.getInt("TestID"),
                        rs.getString("Status"), rs.getString("CourseName")));
            }
        }
        return result.toString();
    }

    // Gọi API chatbot bên ngoài để tạo câu trả lời
    private String callChatbotAPI(String prompt) {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(API_URL);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String jsonInputString = String.format(
                    "{\"contents\": [{\"parts\": [{\"text\": \"%s\"}]}]}",
                    prompt.replace("\"", "\\\"")
            );
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int statusCode = conn.getResponseCode();
            if (statusCode >= 200 && statusCode < 300) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }

                    JSONObject jsonResponse = new JSONObject(response.toString());
                    if (!jsonResponse.has("candidates") || jsonResponse.getJSONArray("candidates").isEmpty()) {
                        return "Không nhận được phản hồi hợp lệ từ API.";
                    }
                    JSONObject candidate = jsonResponse.getJSONArray("candidates").getJSONObject(0);
                    if (!candidate.has("content") || !candidate.getJSONObject("content").has("parts")) {
                        return "Phản hồi từ API không đúng định dạng.";
                    }
                    return candidate.getJSONObject("content")
                            .getJSONArray("parts")
                            .getJSONObject(0)
                            .getString("text");
                }
            } else {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                    StringBuilder errorResponse = new StringBuilder();
                    String errorLine;
                    while ((errorLine = br.readLine()) != null) {
                        errorResponse.append(errorLine.trim());
                    }
                    return "Lỗi từ API: Mã trạng thái " + statusCode + ", Thông tin lỗi: " + errorResponse.toString();
                }
            }
        } catch (Exception e) {
            log("Lỗi khi gọi API: " + e.getMessage(), e);
            return "Xin lỗi, đã xảy ra lỗi khi xử lý yêu cầu. Vui lòng thử lại sau.";
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    // Đóng kết nối cơ sở dữ liệu khi servlet bị hủy
    @Override
    public void destroy() {
        if (dbContext != null) {
            dbContext.closeConnection();
        }
    }
}