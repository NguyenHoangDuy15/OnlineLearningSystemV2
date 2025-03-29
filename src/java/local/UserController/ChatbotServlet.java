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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import org.json.JSONObject;

@WebServlet(name = "ChatbotServlet", urlPatterns = {"/ChatbotServlet"})
public class ChatbotServlet extends HttpServlet {

    private String API_KEY;
    private String API_URL;
    private String WEATHER_API_KEY;
    private String WEATHER_API_URL;
    private DBContext dbContext;
    private Map<String, String> cityMapping;

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
            WEATHER_API_KEY = props.getProperty("weather.api.key");
            WEATHER_API_URL = props.getProperty("weather.api.url");
            if (API_KEY == null || API_URL == null || WEATHER_API_KEY == null || WEATHER_API_URL == null) {
                throw new ServletException("Thiếu api.key, api.url, weather.api.key hoặc weather.api.url trong config.properties");
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

        initializeCityMapping();
    }

    private void initializeCityMapping() {
        cityMapping = new HashMap<>();
        cityMapping.put("hà nội", "Hanoi");
        cityMapping.put("thành phố hồ chí minh", "Ho Chi Minh City");
        cityMapping.put("tp.hcm", "Ho Chi Minh City");
        cityMapping.put("hải phòng", "Hai Phong");
        cityMapping.put("đà nẵng", "Da Nang");
        cityMapping.put("cần thơ", "Can Tho");
        cityMapping.put("thủ đức", "Thu Duc");
        cityMapping.put("bắc giang", "Bac Giang");
        cityMapping.put("bắc ninh", "Bac Ninh");
        cityMapping.put("chí linh", "Chi Linh");
        cityMapping.put("đông triều", "Dong Trieu");
        cityMapping.put("hà nam", "Phu Ly");
        cityMapping.put("hạ long", "Ha Long");
        cityMapping.put("hải dương", "Hai Duong");
        cityMapping.put("hưng yên", "Hung Yen");
        cityMapping.put("lào cai", "Lao Cai");
        cityMapping.put("móng cái", "Mong Cai");
        cityMapping.put("nam định", "Nam Dinh");
        cityMapping.put("ninh bình", "Ninh Binh");
        cityMapping.put("phổ yên", "Pho Yen");
        cityMapping.put("phú thọ", "Viet Tri");
        cityMapping.put("sông công", "Song Cong");
        cityMapping.put("tam điệp", "Tam Diep");
        cityMapping.put("thái nguyên", "Thai Nguyen");
        cityMapping.put("uông bí", "Uong Bi");
        cityMapping.put("vĩnh phúc", "Vinh Yen");
        cityMapping.put("từ sơn", "Tu Son");
        cityMapping.put("bảo lộc", "Bao Loc");
        cityMapping.put("buôn ma thuột", "Buon Ma Thuot");
        cityMapping.put("cam ranh", "Cam Ranh");
        cityMapping.put("đà lạt", "Da Lat");
        cityMapping.put("đông hà", "Dong Ha");
        cityMapping.put("hội an", "Hoi An");
        cityMapping.put("huế", "Hue");
        cityMapping.put("kon tum", "Kon Tum");
        cityMapping.put("nha trang", "Nha Trang");
        cityMapping.put("pleiku", "Pleiku");
        cityMapping.put("quảng ngãi", "Quang Ngai");
        cityMapping.put("quy nhơn", "Quy Nhon");
        cityMapping.put("sầm sơn", "Sam Son");
        cityMapping.put("tam kỳ", "Tam Ky");
        cityMapping.put("thanh hóa", "Thanh Hoa");
        cityMapping.put("vinh", "Vinh");
        cityMapping.put("an giang", "Long Xuyen");
        cityMapping.put("bà rịa", "Ba Ria");
        cityMapping.put("bạc liêu", "Bac Lieu");
        cityMapping.put("bến cát", "Ben Cat");
        cityMapping.put("bến tre", "Ben Tre");
        cityMapping.put("biên hòa", "Bien Hoa");
        cityMapping.put("cà mau", "Ca Mau");
        cityMapping.put("cao lãnh", "Cao Lanh");
        cityMapping.put("châu đốc", "Chau Doc");
        cityMapping.put("dĩ an", "Di An");
        cityMapping.put("đồng hới", "Dong Hoi");
        cityMapping.put("gò công", "Go Cong");
        cityMapping.put("hà tiên", "Ha Tien");
        cityMapping.put("hồng ngự", "Hong Ngu");
        cityMapping.put("long khánh", "Long Khanh");
        cityMapping.put("mỹ tho", "My Tho");
        cityMapping.put("ngã bảy", "Nga Bay");
        cityMapping.put("phú quốc", "Phu Quoc");
        cityMapping.put("phú mỹ", "Phu My");
        cityMapping.put("rạch giá", "Rach Gia");
        cityMapping.put("sa đéc", "Sa Dec");
        cityMapping.put("sóc trăng", "Soc Trang");
        cityMapping.put("tân an", "Tan An");
        cityMapping.put("tân uyên", "Tan Uyen");
        cityMapping.put("thuận an", "Thuan An");
        cityMapping.put("thủ dầu một", "Thu Dau Mot");
        cityMapping.put("trà vinh", "Tra Vinh");
        cityMapping.put("vị thanh", "Vi Thanh");
        cityMapping.put("vĩnh long", "Vinh Long");
        cityMapping.put("vũng tàu", "Vung Tau");
        cityMapping.put("bắc kạn", "Bac Kan");
        cityMapping.put("cẩm phả", "Cam Pha");
        cityMapping.put("điện biên phủ", "Dien Bien Phu");
        cityMapping.put("hà tĩnh", "Ha Tinh");
        cityMapping.put("hòa bình", "Hoa Binh");
        cityMapping.put("lai châu", "Lai Chau");
        cityMapping.put("lạng sơn", "Lang Son");
        cityMapping.put("phúc yên", "Phuc Yen");
        cityMapping.put("sơn la", "Son La");
        cityMapping.put("tuyên quang", "Tuyen Quang");
        cityMapping.put("yên bái", "Yen Bai");
        cityMapping.put("đồng xoài", "Dong Xoai");
        cityMapping.put("tây ninh", "Tay Ninh");
        cityMapping.put("thái bình", "Thai Binh");
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
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                jsonResponse.put("userMessage", "");
                jsonResponse.put("botResponse", "Please enter a message! / Vui lòng nhập tin nhắn!");
            } else {
                userMessage = userMessage.trim().replaceAll("<", "<").replaceAll(">", ">");
                String botResponse = processMessage(userMessage);
                jsonResponse.put("userMessage", userMessage);
                jsonResponse.put("botResponse", botResponse);
            }
        } catch (Exception e) {
            log("Lỗi trong doPost: " + e.getMessage(), e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.put("userMessage", userMessage != null ? userMessage : "");
            jsonResponse.put("botResponse", "An error occurred. Please try again later. / Đã xảy ra lỗi. Vui lòng thử lại sau.");
        }

        response.getWriter().write(jsonResponse.toString());
    }

    private String processMessage(String message) {
        String lowercaseMessage = message.toLowerCase();
        String contextData = "";
        boolean isPriceQuery = lowercaseMessage.contains("giá") || lowercaseMessage.contains("price") || lowercaseMessage.contains("bao nhiêu") || lowercaseMessage.contains("how much");
        boolean isWeatherQuery = lowercaseMessage.contains("thời tiết") || lowercaseMessage.contains("weather");
        String searchTerm = null;
        boolean isVietnamese = containsVietnamese(message);

        // Trích xuất searchTerm từ tin nhắn
        if (lowercaseMessage.contains("khóa học") || lowercaseMessage.contains("course")) {
            String[] words = lowercaseMessage.split(lowercaseMessage.contains("khóa học") ? "khóa học" : "course");
            if (words.length > 1) {
                searchTerm = words[1].trim().replace("giá", "").replace("price", "").replace("là", "").replace("bao nhiêu", "").replace("how much", "").trim();
            }
        } else if (lowercaseMessage.contains("danh mục") || lowercaseMessage.contains("category")) {
            String[] words = lowercaseMessage.split(lowercaseMessage.contains("danh mục") ? "danh mục" : "category");
            if (words.length > 1) {
                searchTerm = words[1].trim();
            }
        } else if (lowercaseMessage.contains("bài kiểm tra") || lowercaseMessage.contains("test")) {
            String[] words = lowercaseMessage.split(lowercaseMessage.contains("bài kiểm tra") ? "bài kiểm tra" : "test");
            if (words.length > 1) {
                searchTerm = words[1].trim();
            }
        } else if (lowercaseMessage.contains("blog")) {
            String[] words = lowercaseMessage.split("blog");
            if (words.length > 1) {
                searchTerm = words[1].trim();
            }
        }

        // Xử lý truy vấn thời tiết
        List<String> cityNames = new ArrayList<>();
        if (isWeatherQuery) {
            String[] words;
            String cityPart = null;
            if (lowercaseMessage.contains("thời tiết")) {
                words = lowercaseMessage.split("thời tiết");
                if (words.length > 1) {
                    cityPart = words[1].trim();
                }
            } else if (lowercaseMessage.contains("weather")) {
                words = lowercaseMessage.split("weather");
                if (words.length > 1) {
                    cityPart = words[1].trim();
                }
                if (cityPart == null || cityPart.isEmpty()) {
                    String[] beforeWeather = words[0].trim().split("\\s+");
                    if (beforeWeather.length > 0) {
                        if (beforeWeather[beforeWeather.length - 1].equalsIgnoreCase("city") && beforeWeather.length > 1) {
                            cityPart = beforeWeather[beforeWeather.length - 2];
                        } else {
                            cityPart = beforeWeather[beforeWeather.length - 1];
                        }
                    }
                }
            }

            if (cityPart == null || cityPart.isEmpty()) {
                return isVietnamese
                        ? "Vui lòng cung cấp tên thành phố (ví dụ: 'Thời tiết Hà Nội')."
                        : "Please provide a city name (e.g., 'Hanoi weather').";
            }

            String[] cityArray = cityPart.split(",| và | and ");
            for (String city : cityArray) {
                city = city.replace("thành phố", "").trim();
                if (!city.isEmpty()) {
                    String standardizedCityName = city.toLowerCase();
                    String mappedCityName = cityMapping.get(standardizedCityName);
                    cityNames.add(mappedCityName != null ? mappedCityName : city);
                }
            }

            if (cityNames.isEmpty()) {
                return isVietnamese
                        ? "Vui lòng cung cấp ít nhất một tên thành phố."
                        : "Please provide at least one city name.";
            }
        }

        // Truy xuất dữ liệu từ cơ sở dữ liệu
        if (dbContext != null && !isWeatherQuery) {
            try {
                if (lowercaseMessage.contains("khóa học phổ biến") || lowercaseMessage.contains("popular courses")) {
                    contextData = fetchPopularCourses(isVietnamese);
                } else if (lowercaseMessage.contains("khóa học") || lowercaseMessage.contains("courses")) {
                    contextData = fetchCourses(searchTerm, isVietnamese);
                } else if (lowercaseMessage.contains("category") || lowercaseMessage.contains("danh mục")) {
                    contextData = fetchCategories(searchTerm, isVietnamese);
                } else if (lowercaseMessage.contains("tổng số người tham gia") || lowercaseMessage.contains("số người tham gia") || lowercaseMessage.contains("participants")) {
                    contextData = fetchTotalParticipants(searchTerm, isVietnamese);
                } else if (lowercaseMessage.contains("bài kiểm tra") || lowercaseMessage.contains("test")) {
                    contextData = fetchTests(searchTerm, isVietnamese);
                } else if (lowercaseMessage.contains("blog")) {
                    contextData = fetchBlogs(searchTerm, isVietnamese);
                }
            } catch (SQLException e) {
                log("Lỗi khi truy xuất dữ liệu từ cơ sở dữ liệu: " + e.getMessage(), e);
                contextData = isVietnamese
                        ? "Không thể truy cập cơ sở dữ liệu. Tôi sẽ trả lời dựa trên kiến thức chung."
                        : "Unable to access the database. I will respond based on general knowledge.";
            }
        } else if (!isWeatherQuery) {
            contextData = isVietnamese
                    ? "Không thể truy cập cơ sở dữ liệu. Tôi sẽ trả lời dựa trên kiến thức chung."
                    : "Unable to access the database. I will respond based on general knowledge.";
        }

        // Xử lý truy vấn thời tiết
        if (isWeatherQuery) {
            StringBuilder weatherData = new StringBuilder();
            for (String city : cityNames) {
                String result = fetchWeather(city, isVietnamese);
                weatherData.append(result).append("\n");
            }
            return weatherData.toString().trim();
        }

        // Tạo prompt gửi đến API chatbot
        String fullPrompt;
        if (contextData.isEmpty() || contextData.contains("Không thể truy cập cơ sở dữ liệu") || contextData.contains("Unable to access the database")) {
            fullPrompt = isVietnamese
                    ? "Bạn là một trợ lý thông minh cho một nền tảng học lập trình trực tuyến. Hãy trả lời câu hỏi sau một cách tự nhiên, chính xác và phù hợp với người học lập trình:\n" + message
                    : "You are an intelligent assistant for an online programming learning platform. Answer the following question naturally, accurately, and appropriately for programming learners:\n" + message;
        } else {
            if (isPriceQuery) {
                fullPrompt = isVietnamese
                        ? "Bạn là một trợ lý thông minh cho một nền tảng học lập trình trực tuyến. Dưới đây là thông tin từ cơ sở dữ liệu:\n" + contextData + "\nDựa trên thông tin này, hãy trả lời câu hỏi sau một cách tự nhiên, chính xác và phù hợp với người học lập trình, tập trung vào thông tin về giá cả:\n" + message + "\nNếu cần, hãy trả lời dựa trên kiến thức chung."
                        : "You are an intelligent assistant for an online programming learning platform. Below is information from the database:\n" + contextData + "\nBased on this information, answer the following question naturally, accurately, and appropriately for programming learners, focusing on price information:\n" + message + "\nIf necessary, respond based on general knowledge.";
            } else {
                fullPrompt = isVietnamese
                        ? "Bạn là một trợ lý thông minh cho một nền tảng học lập trình trực tuyến. Dưới đây là thông tin từ cơ sở dữ liệu:\n" + contextData + "\nDựa trên thông tin này, hãy trả lời câu hỏi sau một cách tự nhiên, chính xác và phù hợp với người học lập trình:\n" + message + "\nNếu cần, hãy trả lời dựa trên kiến thức chung."
                        : "You are an intelligent assistant for an online programming learning platform. Below is information from the database:\n" + contextData + "\nBased on this information, answer the following question naturally, accurately, and appropriately for programming learners:\n" + message + "\nIf necessary, respond based on general knowledge.";
            }
        }

        String botResponse = callChatbotAPI(fullPrompt);

        // Đảm bảo trả về thông tin giá nếu là truy vấn giá
        if (isPriceQuery && !botResponse.toLowerCase().contains("giá") && !botResponse.toLowerCase().contains("price") && !botResponse.toLowerCase().contains("miễn phí") && !botResponse.toLowerCase().contains("free")) {
            if (contextData.contains("Khóa học") || contextData.contains("Course")) {
                String[] lines = contextData.split("\n");
                for (String line : lines) {
                    if (searchTerm != null && line.toLowerCase().contains(searchTerm.toLowerCase())) {
                        String[] parts = line.split(", ");
                        for (String part : parts) {
                            if (part.startsWith("Giá: ") || part.startsWith("Price: ")) {
                                botResponse = isVietnamese
                                        ? "Giá của khóa học " + searchTerm + " là " + part.substring(5) + "."
                                        : "The price of the course " + searchTerm + " is " + part.substring(7) + ".";
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

    private boolean containsVietnamese(String text) {
        return text.matches(".*[àáâãèéêìíòóôõùúýăđĩũơưạảấầẩẫậắằẳẵặẹẻẽếềểễệỉịọỏốồổỗộớờởỡợụủứừửữựỳỵỷỹ].*");
    }

    private String fetchCourses(String searchTerm, boolean isVietnamese) throws SQLException {
        StringBuilder result = new StringBuilder(isVietnamese ? "Danh sách khóa học:\n" : "List of courses:\n");
        String query = "SELECT c.CourseID, c.Name AS CourseName, c.Price, cat.CategoryName, c.Description "
                + "FROM Courses c "
                + "JOIN Category cat ON c.CategoryID = cat.CategoryID ";
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            query += "WHERE c.Name LIKE ? ";
        }

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                stmt.setString(1, "%" + searchTerm.trim() + "%");
            }
            try (ResultSet rs = stmt.executeQuery()) {
                boolean hasResults = false;
                while (rs.next()) {
                    hasResults = true;
                    double price = rs.getDouble("Price");
                    boolean isPriceNull = rs.wasNull();
                    String priceStr = isPriceNull ? (isVietnamese ? "Miễn phí" : "Free") : String.format("%.2f", price);
                    result.append(String.format(isVietnamese
                            ? "Khóa học: %s (ID: %d), Giá: %s, Danh mục: %s, Mô tả: %s\n"
                            : "Course: %s (ID: %d), Price: %s, Category: %s, Description: %s\n",
                            rs.getString("CourseName"), rs.getInt("CourseID"),
                            priceStr, rs.getString("CategoryName"), rs.getString("Description")));
                }
                if (!hasResults) {
                    result.append(searchTerm == null || searchTerm.trim().isEmpty()
                            ? (isVietnamese ? "Không có khóa học nào trong hệ thống.\n" : "No courses in the system.\n")
                            : (isVietnamese ? "Không tìm thấy khóa học nào phù hợp với '" + searchTerm + "'.\n" : "No courses found matching '" + searchTerm + "'.\n"));
                }
            }
        }
        return result.toString();
    }

    private String fetchCategories(String searchTerm, boolean isVietnamese) throws SQLException {
        StringBuilder result = new StringBuilder(isVietnamese ? "Danh sách danh mục:\n" : "List of categories:\n");
        String query = "SELECT cat.CategoryName, COUNT(c.CourseID) AS TotalCourses "
                + "FROM Category cat "
                + "LEFT JOIN Courses c ON cat.CategoryID = c.CategoryID ";
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            query += "WHERE cat.CategoryName LIKE ? ";
        }
        query += "GROUP BY cat.CategoryName";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                stmt.setString(1, "%" + searchTerm.trim() + "%");
            }
            try (ResultSet rs = stmt.executeQuery()) {
                boolean hasResults = false;
                while (rs.next()) {
                    hasResults = true;
                    result.append(String.format(isVietnamese
                            ? "Danh mục: %s, Tổng số khóa học: %d\n"
                            : "Category: %s, Total courses: %d\n",
                            rs.getString("CategoryName"), rs.getInt("TotalCourses")));
                }
                if (!hasResults) {
                    result.append(searchTerm == null || searchTerm.trim().isEmpty()
                            ? (isVietnamese ? "Không có danh mục nào trong hệ thống.\n" : "No categories in the system.\n")
                            : (isVietnamese ? "Không tìm thấy danh mục nào phù hợp với '" + searchTerm + "'.\n" : "No categories found matching '" + searchTerm + "'.\n"));
                }
            }
        }
        return result.toString();
    }

    private String fetchTotalParticipants(String searchTerm, boolean isVietnamese) throws SQLException {
        StringBuilder result = new StringBuilder(isVietnamese ? "Thông tin về số người tham gia:\n" : "Information about participants:\n");
        String query = "SELECT c.Name, COUNT(e.EnrollmentID) AS TotalEnrolledStudents "
                + "FROM Courses c "
                + "LEFT JOIN Enrollments e ON c.CourseID = e.CourseID AND e.Status = 1 ";
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            query += "WHERE c.Name LIKE ? ";
        }
        query += "GROUP BY c.CourseID, c.Name";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                stmt.setString(1, "%" + searchTerm.trim() + "%");
            }
            try (ResultSet rs = stmt.executeQuery()) {
                boolean hasResults = false;
                while (rs.next()) {
                    hasResults = true;
                    result.append(String.format(isVietnamese
                            ? "- Khóa học: %s, Số người tham gia: %d\n"
                            : "- Course: %s, Number of participants: %d\n",
                            rs.getString("Name"), rs.getInt("TotalEnrolledStudents")));
                }
                if (!hasResults) {
                    result.append(searchTerm == null || searchTerm.trim().isEmpty()
                            ? (isVietnamese ? "Chưa có người tham gia khóa học nào.\n" : "No participants in any course yet.\n")
                            : (isVietnamese ? "Không tìm thấy khóa học nào phù hợp với '" + searchTerm + "'.\n" : "No courses found matching '" + searchTerm + "'.\n"));
                }
            }
        }
        return result.toString();
    }

    private String fetchTests(String searchTerm, boolean isVietnamese) throws SQLException {
        StringBuilder result = new StringBuilder(isVietnamese ? "Danh sách bài kiểm tra:\n" : "List of tests:\n");
        String query = "SELECT t.TestID, t.Name AS TestName, COUNT(q.QuestionID) AS TotalQuestions, c.Name AS CourseName "
                + "FROM Test t "
                + "LEFT JOIN Question q ON t.TestID = q.TestID "
                + "JOIN Courses c ON t.CourseID = c.CourseID "
                + "WHERE t.Status = 1 ";
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            query += "AND (t.Name LIKE ? OR c.Name LIKE ?) ";
        }
        query += "GROUP BY t.TestID, t.Name, c.Name";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                stmt.setString(1, "%" + searchTerm.trim() + "%");
                stmt.setString(2, "%" + searchTerm.trim() + "%");
            }
            try (ResultSet rs = stmt.executeQuery()) {
                boolean hasResults = false;
                while (rs.next()) {
                    hasResults = true;
                    result.append(String.format(isVietnamese
                            ? "Bài kiểm tra: %s (ID: %d), Tổng số câu hỏi: %d, Khóa học: %s\n"
                            : "Test: %s (ID: %d), Total questions: %d, Course: %s\n",
                            rs.getString("TestName"), rs.getInt("TestID"),
                            rs.getInt("TotalQuestions"), rs.getString("CourseName")));
                }
                if (!hasResults) {
                    result.append(searchTerm == null || searchTerm.trim().isEmpty()
                            ? (isVietnamese ? "Không có bài kiểm tra nào trong hệ thống.\n" : "No tests in the system.\n")
                            : (isVietnamese ? "Không tìm thấy bài kiểm tra nào phù hợp với '" + searchTerm + "'.\n" : "No tests found matching '" + searchTerm + "'.\n"));
                }
            }
        }
        return result.toString();
    }

    private String fetchBlogs(String searchTerm, boolean isVietnamese) throws SQLException {
        StringBuilder result = new StringBuilder(isVietnamese ? "Danh sách bài blog:\n" : "List of blogs:\n");
        String query = "SELECT b.BlogID, b.BlogTitle, b.BlogDate, u.UserName "
                + "FROM Blogs b "
                + "JOIN Users u ON b.UserID = u.UserID ";
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            query += "WHERE b.BlogTitle LIKE ? ";
        }
        query += "ORDER BY b.BlogDate DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                stmt.setString(1, "%" + searchTerm.trim() + "%");
            }
            try (ResultSet rs = stmt.executeQuery()) {
                boolean hasResults = false;
                while (rs.next()) {
                    hasResults = true;
                    result.append(String.format(isVietnamese
                            ? "Blog: %s (ID: %d), Tác giả: %s, Ngày đăng: %s\n"
                            : "Blog: %s (ID: %d), Author: %s, Posted on: %s\n",
                            rs.getString("BlogTitle"), rs.getInt("BlogID"),
                            rs.getString("UserName"), rs.getDate("BlogDate").toString()));
                }
                if (!hasResults) {
                    result.append(searchTerm == null || searchTerm.trim().isEmpty()
                            ? (isVietnamese ? "Không có bài blog nào trong hệ thống.\n" : "No blogs in the system.\n")
                            : (isVietnamese ? "Không tìm thấy bài blog nào phù hợp với '" + searchTerm + "'.\n" : "No blogs found matching '" + searchTerm + "'.\n"));
                }
            }
        }
        return result.toString();
    }

    private String fetchPopularCourses(boolean isVietnamese) throws SQLException {
        StringBuilder result = new StringBuilder(isVietnamese ? "Danh sách các khóa học phổ biến:\n" : "List of popular courses:\n");
        String query = "SELECT TOP 5 c.Name, COUNT(e.EnrollmentID) AS TotalEnrolledStudents "
                + "FROM Courses c "
                + "LEFT JOIN Enrollments e ON c.CourseID = e.CourseID AND e.Status = 1 "
                + "GROUP BY c.CourseID, c.Name "
                + "ORDER BY TotalEnrolledStudents DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            boolean hasResults = false;
            while (rs.next()) {
                hasResults = true;
                result.append(String.format(isVietnamese
                        ? "- Khóa học: %s, Số người tham gia: %d\n"
                        : "- Course: %s, Number of participants: %d\n",
                        rs.getString("Name"), rs.getInt("TotalEnrolledStudents")));
            }
            if (!hasResults) {
                result.append(isVietnamese
                        ? "Chưa có khóa học nào được tham gia.\n"
                        : "No courses have been enrolled in yet.\n");
            }
        }
        return result.toString();
    }

    private String fetchWeather(String cityName, boolean isVietnamese) {
        HttpURLConnection conn = null;
        try {
            String urlString = WEATHER_API_URL + "?q=" + URLEncoder.encode(cityName, "UTF-8") + "&appid=" + WEATHER_API_KEY + "&units=metric&lang=" + (isVietnamese ? "vi" : "en");
            URL url = new URL(urlString);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            int statusCode = conn.getResponseCode();
            if (statusCode >= 200 && statusCode < 300) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }

                    JSONObject jsonResponse = new JSONObject(response.toString());
                    String weatherDescription = jsonResponse.getJSONArray("weather").getJSONObject(0).getString("description");
                    double temp = jsonResponse.getJSONObject("main").getDouble("temp");
                    int humidity = jsonResponse.getJSONObject("main").getInt("humidity");
                    double windSpeed = jsonResponse.getJSONObject("wind").getDouble("speed");

                    return String.format(isVietnamese
                            ? "Thời tiết tại %s: %s, nhiệt độ %.1f°C, độ ẩm %d%%, tốc độ gió %.1f m/s."
                            : "Weather in %s: %s, temperature %.1f°C, humidity %d%%, wind speed %.1f m/s.",
                            cityName, weatherDescription, temp, humidity, windSpeed);
                }
            } else {
                return isVietnamese
                        ? "Không thể lấy thông tin thời tiết cho " + cityName + "."
                        : "Unable to fetch weather information for " + cityName + ".";
            }
        } catch (Exception e) {
            log("Lỗi khi gọi API thời tiết: " + e.getMessage(), e);
            return isVietnamese
                    ? "Không thể lấy thông tin thời tiết cho " + cityName + "."
                    : "Unable to fetch weather information for " + cityName + ".";
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
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
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }

                    JSONObject jsonResponse = new JSONObject(response.toString());
                    if (!jsonResponse.has("candidates") || jsonResponse.getJSONArray("candidates").isEmpty()) {
                        return "Không nhận được phản hồi hợp lệ từ API. / No valid response received from the API.";
                    }
                    JSONObject candidate = jsonResponse.getJSONArray("candidates").getJSONObject(0);
                    if (!candidate.has("content") || !candidate.getJSONObject("content").has("parts")) {
                        return "Phản hồi từ API không đúng định dạng. / Response from API is not in the correct format.";
                    }
                    return candidate.getJSONObject("content").getJSONArray("parts").getJSONObject(0).getString("text");
                }
            } else {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                    StringBuilder errorResponse = new StringBuilder();
                    String errorLine;
                    while ((errorLine = br.readLine()) != null) {
                        errorResponse.append(errorLine.trim());
                    }
                    return "Lỗi từ API: Mã trạng thái " + statusCode + ", Thông tin lỗi: " + errorResponse.toString()
                            + " / API error: Status code " + statusCode + ", Error details: " + errorResponse.toString();
                }
            }
        } catch (Exception e) {
            log("Lỗi khi gọi API: " + e.getMessage(), e);
            return "Xin lỗi, đã xảy ra lỗi khi xử lý yêu cầu. Vui lòng thử lại sau. / Sorry, an error occurred while processing your request. Please try again later.";
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    @Override
    public void destroy() {
        if (dbContext != null) {
            dbContext.closeConnection();
        }
    }
}
