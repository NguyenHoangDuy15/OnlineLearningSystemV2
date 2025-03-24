package local.UserController;

import dal.DBContext; // Assuming this is your DBContext class in the DAL package
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

        // Initialize DBContext
        try {
            dbContext = new DBContext();
        } catch (Exception e) {
            // Log the error but allow the servlet to continue without database access
            log("Không thể khởi tạo DBContext: " + e.getMessage(), e);
            dbContext = null; // Set to null to indicate database is unavailable
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String userMessage = request.getParameter("message");
        JSONObject jsonResponse = new JSONObject();

        try {
            if (userMessage == null || userMessage.trim().isEmpty()) {
                jsonResponse.put("userMessage", "");
                jsonResponse.put("botResponse", "Vui lòng nhập tin nhắn!");
            } else {
                String botResponse = processMessage(userMessage);
                jsonResponse.put("userMessage", userMessage);
                jsonResponse.put("botResponse", botResponse);
            }
        } catch (Exception e) {
            log("Lỗi trong doPost: " + e.getMessage(), e);
            jsonResponse.put("userMessage", userMessage != null ? userMessage : "");
            jsonResponse.put("botResponse", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
        }

        response.getWriter().write(jsonResponse.toString());
    }

    private String processMessage(String message) {
        // Analyze the user's message to determine the intent
        String lowercaseMessage = message.toLowerCase();
        String contextData = "";

        // Only attempt to fetch data if DBContext is available
        if (dbContext != null) {
            try {
                if (lowercaseMessage.contains("lesson") || lowercaseMessage.contains("course") || lowercaseMessage.contains("khóa học")) {
                    contextData = fetchCourses();
                } else if (lowercaseMessage.contains("category") || lowercaseMessage.contains("danh mục")) {
                    contextData = fetchCategories();
                } else if (lowercaseMessage.contains("blog") || lowercaseMessage.contains("bài viết")) {
                    contextData = fetchBlogs();
                } else if (lowercaseMessage.contains("tổng số người tham gia") || lowercaseMessage.contains("số người tham gia") || lowercaseMessage.contains("participants")) {
                    contextData = fetchTotalParticipants();
                } else if (lowercaseMessage.contains("đánh giá") || lowercaseMessage.contains("rating") || lowercaseMessage.contains("điểm đánh giá")) {
                    contextData = fetchCourseRatings();
                }
            } catch (SQLException e) {
                // If database access fails, log the error and proceed without database data
                log("Lỗi khi truy xuất dữ liệu từ cơ sở dữ liệu: " + e.getMessage(), e);
                contextData = "Không thể truy cập cơ sở dữ liệu. Tôi sẽ trả lời dựa trên kiến thức chung.";
            }
        } else {
            contextData = "Không thể truy cập cơ sở dữ liệu. Tôi sẽ trả lời dựa trên kiến thức chung.";
        }

        // Construct the prompt based on whether database data is available
        String fullPrompt;
        if (contextData.isEmpty() || contextData.contains("Không thể truy cập cơ sở dữ liệu")) {
            // Fallback prompt without database data, tailored for a programming learning website
            fullPrompt = "Bạn là một trợ lý thông minh cho một nền tảng học lập trình trực tuyến. "
                    + "Hãy trả lời câu hỏi sau một cách tự nhiên, chính xác và phù hợp với người học lập trình:\n"
                    + message;
        } else {
            // Prompt with database data, tailored for a programming learning website
            fullPrompt = "Bạn là một trợ lý thông minh cho một nền tảng học lập trình trực tuyến. "
                    + "Dưới đây là thông tin từ cơ sở dữ liệu:\n"
                    + contextData + "\nDựa trên thông tin này, hãy trả lời câu hỏi sau một cách tự nhiên, chính xác và phù hợp với người học lập trình:\n"
                    + message + "\nNếu cần, hãy trả lời dựa trên kiến thức chung.";
        }

        return callChatbotAPI(fullPrompt);
    }

    // Fetch courses from the database
    private String fetchCourses() throws SQLException {
        StringBuilder result = new StringBuilder("Danh sách khóa học:\n");
        String query = "SELECT c.CourseID, c.Name, c.Price, cat.CategoryName AS CategoryName\n"
                + "                      FROM Courses c \n"
                + "                      JOIN Category cat ON c.CategoryID = cat.CategoryID";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                result.append(String.format("Khóa học: %s (ID: %d), Giá: %d, Danh mục: %s\n",
                        rs.getString("Name"), rs.getInt("CourseID"),
                        rs.getInt("Price"), rs.getString("CategoryName")));
            }
        }
        return result.toString();
    }

    // Fetch categories from the database
    private String fetchCategories() throws SQLException {
        StringBuilder result = new StringBuilder("Danh sách danh mục:\n");
        String query = "SELECT CategoryID, CategoryName, Description FROM Category";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                result.append(String.format("Danh mục: %s (ID: %d), Mô tả: %s\n",
                        rs.getString("CategoryName"), rs.getInt("CategoryID"),
                        rs.getString("Description")));
            }
        }
        return result.toString();
    }

    // Fetch blogs from the database
    private String fetchBlogs() throws SQLException {
        StringBuilder result = new StringBuilder("Danh sách bài viết blog:\n");
        String query = "SELECT BlogID, BlogTitle, BlogDetail FROM Blogs";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                result.append(String.format("Bài viết: %s (ID: %d), Chi tiết: %s\n",
                        rs.getString("BlogTitle"), rs.getInt("BlogID"),
                        rs.getString("BlogDetail")));
            }
        }
        return result.toString();
    }

    // Fetch total participants (enrollments) from the database
    private String fetchTotalParticipants() throws SQLException {
        StringBuilder result = new StringBuilder("Thông tin về số người tham gia:\n");
        // First, get the total number of enrollments
        String totalQuery = "SELECT COUNT(*) AS TotalParticipants FROM Enrollments";
        int totalParticipants = 0;
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(totalQuery); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                totalParticipants = rs.getInt("TotalParticipants");
                result.append(String.format("Tổng số người tham gia các khóa học: %d\n", totalParticipants));
            }
        }

        // Then, get the number of participants per course
        String perCourseQuery = "SELECT c.Name, COUNT(e.UserID) AS ParticipantCount \n"
                + "                               FROM Enrollments e \n"
                + "                               JOIN Courses c ON e.CourseID = c.CourseID \n"
                + "                               GROUP BY c.CourseID, c.Name";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(perCourseQuery); ResultSet rs = stmt.executeQuery()) {
            result.append("Số người tham gia theo từng khóa học:\n");
            while (rs.next()) {
                result.append(String.format("- Khóa học: %s, Số người tham gia: %d\n",
                        rs.getString("Name"), rs.getInt("ParticipantCount")));
            }
        }
        return result.toString();
    }

    // Fetch course ratings from the database
    private String fetchCourseRatings() throws SQLException {
        StringBuilder result = new StringBuilder("Thông tin về đánh giá khóa học:\n");
        // First, get the overall average rating
        String overallQuery = "SELECT AVG(Rating) AS OverallAverage FROM Feedbacks";
        double overallAverage = 0.0;
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(overallQuery); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                overallAverage = rs.getDouble("OverallAverage");
                result.append(String.format("Điểm đánh giá trung bình của tất cả khóa học: %.2f/5\n", overallAverage));
            }
        }

        // Then, get the average rating per course
        String perCourseQuery = "SELECT c.Name, AVG(f.Rating) AS AverageRating, COUNT(f.Rating) AS RatingCount \n"
                + "                               FROM Feedbacks f \n"
                + "                               JOIN Courses c ON f.CourseID = c.CourseID \n"
                + "                              GROUP BY c.CourseID, c.Name";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(perCourseQuery); ResultSet rs = stmt.executeQuery()) {
            result.append("Điểm đánh giá trung bình theo từng khóa học:\n");
            while (rs.next()) {
                result.append(String.format("- Khóa học: %s, Điểm trung bình: %.2f/5 (Số lượt đánh giá: %d)\n",
                        rs.getString("Name"), rs.getDouble("AverageRating"), rs.getInt("RatingCount")));
            }
        }
        return result.toString();
    }

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

    @Override
    public void destroy() {
        // Close DBContext connection if needed
        if (dbContext != null) {
            dbContext.closeConnection();
        }
    }
}
