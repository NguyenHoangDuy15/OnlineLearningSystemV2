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
    private Map<String, String> cityMapping; // Map để lưu ánh xạ tên thành phố tiếng Việt sang tiếng Anh

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

        // Khởi tạo ánh xạ tên thành phố
        initializeCityMapping();
    }

    // Khởi tạo ánh xạ tên thành phố tiếng Việt sang tiếng Anh
    private void initializeCityMapping() {
        cityMapping = new HashMap<>();
        // Thành phố trực thuộc trung ương
        cityMapping.put("hà nội", "Hanoi");
        cityMapping.put("thành phố hồ chí minh", "Ho Chi Minh City");
        cityMapping.put("tp.hcm", "Ho Chi Minh City");
        cityMapping.put("hải phòng", "Hai Phong");
        cityMapping.put("đà nẵng", "Da Nang");
        cityMapping.put("cần thơ", "Can Tho");

        // Thành phố thuộc thành phố trực thuộc trung ương
        cityMapping.put("thủ đức", "Thu Duc");

        // Thành phố trực thuộc tỉnh
        // Miền Bắc
        cityMapping.put("bắc giang", "Bac Giang");
        cityMapping.put("bắc ninh", "Bac Ninh");
        cityMapping.put("chí linh", "Chi Linh");
        cityMapping.put("đông triều", "Dong Trieu");
        cityMapping.put("hà nam", "Phu Ly"); // Hà Nam thường gọi là Phủ Lý
        cityMapping.put("hạ long", "Ha Long");
        cityMapping.put("hải dương", "Hai Duong");
        cityMapping.put("hưng yên", "Hung Yen");
        cityMapping.put("lào cai", "Lao Cai");
        cityMapping.put("móng cái", "Mong Cai");
        cityMapping.put("nam định", "Nam Dinh");
        cityMapping.put("ninh bình", "Ninh Binh");
        cityMapping.put("phổ yên", "Pho Yen");
        cityMapping.put("phú thọ", "Viet Tri"); // Phú Thọ thường gọi là Việt Trì
        cityMapping.put("sông công", "Song Cong");
        cityMapping.put("tam điệp", "Tam Diep");
        cityMapping.put("thái nguyên", "Thai Nguyen");
        cityMapping.put("uông bí", "Uong Bi");
        cityMapping.put("vĩnh phúc", "Vinh Yen"); // Vĩnh Phúc thường gọi là Vĩnh Yên
        cityMapping.put("từ sơn", "Tu Son");

        // Miền Trung
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

        // Miền Nam
        cityMapping.put("an giang", "Long Xuyen"); // An Giang thường gọi là Long Xuyên
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

        // Các thành phố khác
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

    // Xử lý tin nhắn của người dùng
    private String processMessage(String message) {
        String lowercaseMessage = message.toLowerCase();
        String contextData = "";
        boolean isPriceQuery = lowercaseMessage.contains("giá") || lowercaseMessage.contains("price") || lowercaseMessage.contains("bao nhiêu");
        boolean isWeatherQuery = lowercaseMessage.contains("thời tiết") || lowercaseMessage.contains("weather");
        String courseName = null;

        // Trích xuất tên khóa học nếu người dùng hỏi cụ thể (ví dụ: "khóa học Java")
        if (lowercaseMessage.contains("khóa học")) {
            String[] words = lowercaseMessage.split("khóa học");
            if (words.length > 1) {
                courseName = words[1].trim();
                courseName = courseName.replace("giá", "").replace("là", "").replace("bao nhiêu", "").trim();
            }
        }

        // Trích xuất danh sách các thành phố nếu người dùng hỏi về thời tiết (ví dụ: "thời tiết Hà Nội, Đà Nẵng và TP.HCM")
        String cityName = null;
        List<String> cityNames = new ArrayList<>(); // Danh sách các thành phố
        if (isWeatherQuery) {
            // Tách chuỗi dựa trên từ "thời tiết" hoặc "weather"
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
                    // Thử lấy trước từ "weather" (ví dụ: "London weather" hoặc "city London weather")
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

            // Tách danh sách các thành phố (dựa trên dấu phẩy hoặc từ "và")
            String[] cityArray = cityPart.split(",| và ");
            for (String city : cityArray) {
                city = city.replace("thành phố", "").trim();
                if (!city.isEmpty()) {
                    // Chuyển đổi tên thành phố từ tiếng Việt sang tiếng Anh (nếu là thành phố Việt Nam)
                    String standardizedCityName = city.toLowerCase();
                    String mappedCityName = cityMapping.get(standardizedCityName);
                    if (mappedCityName != null) {
                        cityNames.add(mappedCityName);
                    } else {
                        // Nếu không tìm thấy trong cityMapping, sử dụng tên gốc (có thể là thành phố quốc tế)
                        cityNames.add(city);
                    }
                }
            }

            if (cityNames.isEmpty()) {
                return "Vui lòng cung cấp ít nhất một tên thành phố (ví dụ: 'Thời tiết Hà Nội' hoặc 'London weather').";
            }
        }

        // Truy vấn cơ sở dữ liệu nếu không phải yêu cầu thời tiết
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

        // Xử lý yêu cầu thời tiết cho nhiều thành phố
        if (isWeatherQuery) {
            StringBuilder weatherData = new StringBuilder();
            for (String city : cityNames) {
                String result = fetchWeather(city);
                weatherData.append(result).append("\n");
            }
            return weatherData.toString().trim();
        }

        // Tạo prompt để gửi đến API chatbot nếu không phải yêu cầu thời tiết
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

        // Nếu người dùng hỏi về giá nhưng câu trả lời không chứa thông tin giá
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

    // Lấy thông tin thời tiết từ OpenWeatherMap
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