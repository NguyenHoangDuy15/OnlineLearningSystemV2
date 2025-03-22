import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.*;
import java.net.*;
import java.util.Properties;
import org.json.JSONObject; // Thư viện để phân tích JSON

@WebServlet(name = "ChatbotServlet", urlPatterns = {"/ChatbotServlet"})
public class ChatbotServlet extends HttpServlet {
    private String API_KEY; // Khóa API của Gemini
    private String API_URL; // Địa chỉ API của Gemini

    // Hàm khởi tạo Servlet, đọc API key và URL từ tệp cấu hình
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
            // Thêm API Key vào URL
            API_URL = API_URL + "?key=" + API_KEY;
        } catch (IOException e) {
            throw new ServletException("Không thể tải tệp config.properties", e);
        }
    }

    // Xử lý yêu cầu GET (chuyển hướng về trang hiện tại)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("jsp/index.jsp");
        }
    }

    // Xử lý yêu cầu POST từ form trong chatbot
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String userMessage = request.getParameter("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            userMessage = "Xin chào!";
        }

        // Gọi API của Gemini để lấy phản hồi
        String botResponse = callChatbotAPI(userMessage);

        // Lưu tin nhắn và phản hồi vào session để hiển thị trên JSP
        HttpSession session = request.getSession();
        session.setAttribute("userMessage", userMessage);
        session.setAttribute("botResponse", botResponse);

        // Chuyển hướng về trang hiện tại
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("jsp/index.jsp");
        }
    }

    // Hàm gọi API của Gemini
    private String callChatbotAPI(String message) {
        HttpURLConnection conn = null;
        try {
            // Tạo kết nối đến API
            URL url = new URL(API_URL);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            // Tạo payload JSON theo định dạng của Gemini API
            String jsonInputString = String.format(
                "{\"contents\": [{\"parts\": [{\"text\": \"%s\"}]}]}",
                message.replace("\"", "\\\"") // Thoát ký tự " trong tin nhắn
            );
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonInputString.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            // Kiểm tra mã trạng thái HTTP
            int statusCode = conn.getResponseCode();
            if (statusCode >= 200 && statusCode < 300) {
                // Đọc phản hồi thành công
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                    StringBuilder response = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        response.append(responseLine.trim());
                    }

                    // Phân tích JSON để lấy nội dung phản hồi của Gemini
                    JSONObject jsonResponse = new JSONObject(response.toString());
                    return jsonResponse.getJSONArray("candidates")
                        .getJSONObject(0)
                        .getJSONObject("content")
                        .getJSONArray("parts")
                        .getJSONObject(0)
                        .getString("text");
                }
            } else {
                // Đọc phản hồi lỗi
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
            e.printStackTrace();
            return "Xin lỗi, tôi không thể xử lý yêu cầu của bạn. Lỗi: " + e.getMessage();
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }
}