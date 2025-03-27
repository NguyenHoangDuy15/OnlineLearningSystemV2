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
                jsonResponse.put("botResponse", "Vui lòng nhập tin nhắn!");
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
            jsonResponse.put("botResponse", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
        }

        response.getWriter().write(jsonResponse.toString());
    }

    private String processMessage(String message) {
        String lowercaseMessage = message.toLowerCase();
        String contextData = "";
        boolean isPriceQuery = lowercaseMessage.contains("giá") || lowercaseMessage.contains("price") || lowercaseMessage.contains("bao nhiêu");
        boolean isWeatherQuery = lowercaseMessage.contains("thời tiết") || lowercaseMessage.contains("weather");
        String courseName = null;

        if (lowercaseMessage.contains("khóa học")) {
            String[] words = lowercaseMessage.split("khóa học");
            if (words.length > 1) {
                courseName = words[1].trim();
                courseName = courseName.replace("giá", "").replace("là", "").replace("bao nhiêu", "").trim();
            }
        }

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
                return "Vui lòng cung cấp tên thành phố (ví dụ: 'Thời tiết Hà Nội' hoặc 'London weather').";
            }

            String[] cityArray = cityPart.split(",| và ");
            for (String city : cityArray) {
                city = city.replace("thành phố", "").trim();
                if (!city.isEmpty()) {
                    String standardizedCityName = city.toLowerCase();
                    String mappedCityName = cityMapping.get(standardizedCityName);
                    if (mappedCityName != null) {
                        cityNames.add(mappedCityName);
                    } else {
                        cityNames.add(city);
                    }
                }
            }

            if (cityNames.isEmpty()) {
                return "Vui lòng cung cấp ít nhất một tên thành phố (ví dụ: 'Thời tiết Hà Nội' hoặc 'London weather').";
            }
        }

        if (dbContext != null && !isWeatherQuery) {
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
        } else if (!isWeatherQuery) {
            contextData = "Không thể truy cập cơ sở dữ liệu. Tôi sẽ trả lời dựa trên kiến thức chung.";
        }

        if (isWeatherQuery) {
            StringBuilder weatherData = new StringBuilder();
            for (String city : cityNames) {
                String result = fetchWeather(city);
                weatherData.append(result).append("\n");
            }
            return weatherData.toString().trim();
        }

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

    private String fetchCourses(String courseName) throws SQLException {
        StringBuilder result = new StringBuilder("Danh sách khóa học:\n");
        String query = "SELECT c.CourseID, c.Name AS CourseName, c.Price, cat.CategoryName, c.Description "
                + "FROM Courses c "
                + "JOIN Category cat ON c.CategoryID = cat.CategoryID"
                + (courseName != null && !courseName.isEmpty() ? " WHERE c.Name LIKE ?" : "");
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            if (courseName != null && !courseName.isEmpty()) {
                stmt.setString(1, "%" + courseName + "%");
            }
            try (ResultSet rs = stmt.executeQuery()) {
                boolean hasResults = false;
                while (rs.next()) {
                    hasResults = true;
                    double price = rs.getDouble("Price");
                    boolean isPriceNull = rs.wasNull();
                    String priceStr = isPriceNull ? "Miễn phí" : String.format("%.2f", price);
                    result.append(String.format("Khóa học: %s (ID: %d), Giá: %s, Danh mục: %s, Mô tả: %s\n",
                            rs.getString("CourseName"), rs.getInt("CourseID"),
                            priceStr, rs.getString("CategoryName"), rs.getString("Description")));
                }
                if (!hasResults) {
                    result.append("Không tìm thấy khóa học nào"
                            + (courseName != null && !courseName.isEmpty() ? " với tên '" + courseName + "'" : "") + ".\n");
                }
            }
        }
        return result.toString();
    }

    private String fetchCategories() throws SQLException {
        StringBuilder result = new StringBuilder("Danh sách danh mục:\n");
        String query = "SELECT cat.CategoryName, COUNT(c.CourseID) AS TotalCourses "
                + "FROM Category cat "
                + "LEFT JOIN Courses c ON cat.CategoryID = c.CategoryID "
                + "GROUP BY cat.CategoryName";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            boolean hasResults = false;
            while (rs.next()) {
                hasResults = true;
                result.append(String.format("Danh mục: %s, Tổng số khóa học: %d\n",
                        rs.getString("CategoryName"), rs.getInt("TotalCourses")));
            }
            if (!hasResults) {
                result.append("Không có danh mục nào trong hệ thống.\n");
            }
        }
        return result.toString();
    }

    private String fetchTotalParticipants() throws SQLException {
        StringBuilder result = new StringBuilder("Thông tin về số người tham gia:\n");
        String query = "SELECT c.Name, COUNT(e.EnrollmentID) AS TotalEnrolledStudents "
                + "FROM Courses c "
                + "LEFT JOIN Enrollments e ON c.CourseID = e.CourseID AND e.Status = 1 "
                + "GROUP BY c.CourseID, c.Name";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            boolean hasResults = false;
            while (rs.next()) {
                hasResults = true;
                result.append(String.format("- Khóa học: %s, Số người tham gia: %d\n",
                        rs.getString("Name"), rs.getInt("TotalEnrolledStudents")));
            }
            if (!hasResults) {
                result.append("Chưa có người tham gia khóa học nào.\n");
            }
        }
        return result.toString();
    }

    private String fetchTests() throws SQLException {
        StringBuilder result = new StringBuilder("Danh sách bài kiểm tra:\n");
        String query = "SELECT t.TestID, t.Name AS TestName, COUNT(q.QuestionID) AS TotalQuestions, c.Name AS CourseName "
                + "FROM Test t "
                + "LEFT JOIN Question q ON t.TestID = q.TestID "
                + "JOIN Courses c ON t.CourseID = c.CourseID "
                + "WHERE t.Status = 1 "
                + "GROUP BY t.TestID, t.Name, c.Name";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            boolean hasResults = false;
            while (rs.next()) {
                hasResults = true;
                result.append(String.format("Bài kiểm tra: %s (ID: %d), Tổng số câu hỏi: %d, Khóa học: %s\n",
                        rs.getString("TestName"), rs.getInt("TestID"),
                        rs.getInt("TotalQuestions"), rs.getString("CourseName")));
            }
            if (!hasResults) {
                result.append("Không có bài kiểm tra nào trong hệ thống.\n");
            }
        }
        return result.toString();
    }

    private String fetchWeather(String cityName) {
        HttpURLConnection conn = null;
        try {
            String urlString = WEATHER_API_URL + "?q=" + URLEncoder.encode(cityName, "UTF-8") + "&appid=" + WEATHER_API_KEY + "&units=metric&lang=vi";
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
                    String weatherDescription = jsonResponse.getJSONArray("weather")
                            .getJSONObject(0)
                            .getString("description");
                    double temp = jsonResponse.getJSONObject("main").getDouble("temp");
                    int humidity = jsonResponse.getJSONObject("main").getInt("humidity");
                    double windSpeed = jsonResponse.getJSONObject("wind").getDouble("speed");

                    return String.format("Thời tiết tại %s: %s, nhiệt độ %.1f°C, độ ẩm %d%%, tốc độ gió %.1f m/s.",
                            cityName, weatherDescription, temp, humidity, windSpeed);
                }
            } else {
                return "Không thể lấy thông tin thời tiết cho " + cityName + ".";
            }
        } catch (Exception e) {
            log("Lỗi khi gọi API thời tiết: " + e.getMessage(), e);
            return "Không thể lấy thông tin thời tiết cho " + cityName + ".";
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
        if (dbContext != null) {
            dbContext.closeConnection();
        }
    }
}
