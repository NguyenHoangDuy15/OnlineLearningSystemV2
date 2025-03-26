package local.UserController;

import Model.GoogleAccount;
import Model.User;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;
import org.apache.http.client.HttpResponseException;
import java.nio.charset.StandardCharsets;

import java.util.List;
import util.Constant;

/**
 *
 * @author DELL
 */
@WebServlet(name = "LoginGoogle", urlPatterns = {"/LoginGoogle"})
public class LoginGoogle extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginGoogle</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginGoogle at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    User getuserByEmail(List<User> list, String email) {
        
        for (User p : list) {
            if (p.getEmail().equals(email)) {
                return p;
            }
        }
        return null;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession sec = request.getSession();
        
        String code = request.getParameter("code");

        // Kiểm tra nếu không có code
        if (code == null || code.isEmpty()) {
            request.setAttribute("err", "Google không trả về mã xác thực. Vui lòng thử lại!");
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Lấy access token từ Google
            String accessToken = getToken(code);

            // Lấy thông tin người dùng từ Google
            GoogleAccount user = getUserInfo(accessToken);

            // Tạo đối tượng Customer và lưu thông tin
            User customer = new User();
            customer.setUserName(user.getName());
            customer.setEmail(user.getEmail());
            customer.setStatus(1);

            // Kiểm tra nếu tài khoản đã tồn tại trong CSDL
            UserDAO d = new UserDAO();
            List<User> list = d.getAll();
            User account = getuserByEmail(list, user.getEmail());
            
            if (account == null) {
                d.add(customer.getUserName(), null, customer.getUserName(), customer.getEmail());
                list = d.getAll();
                account = getuserByEmail(list, customer.getEmail()); // Cập nhật lại account
            }

            // Kiểm tra trạng thái tài khoản
            if (account != null && account.getStatus() == 0) {
                request.setAttribute("err", "Account banned!");
                request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
                return;
            }

            // Đặt tài khoản vào session
            
            sec.setAttribute("sessionID", sec.getId());
            sec.setAttribute("rollID", account.getRoleID()); // Thêm rollID vào session
            request.setAttribute("rollID", account.getRoleID());
            sec.setAttribute("username", account.getUserName());
          
            sec.setAttribute("account", account);
            sec.setAttribute("isLoggedIn", true);
            sec.setAttribute("Fullname", account.getFullName());
            sec.setAttribute("userid", account.getUserID());
            if (account.getRoleID() == 1) {
                sec.setAttribute("admin", account.getRoleID());
                response.sendRedirect("ShowAdminDasboardServlet");
            } else if (account.getRoleID() == 2) {
                sec.setAttribute("expert", account.getRoleID());
                response.sendRedirect("ShowexpertServlet");
            } else if (account.getRoleID() == 3) {
                sec.setAttribute("sale", account.getRoleID());
                response.sendRedirect("viewownerbloglist");
                sec.setAttribute("isSale", true);
            } else {
                User u = new User();
                sec.setAttribute("customer", account.getRoleID());
                response.sendRedirect("index");
            }
            
        } catch (IOException e) {
            request.setAttribute("err", "Connect Google Fail!");
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        }
    }

    // Lấy mã access token từ Google
    public static String getToken(String code) throws ClientProtocolException, IOException {
        String response;
        try {
            // Gửi request đến Google để lấy access token
            response = Request.Post(Constant.GOOGLE_LINK_GET_TOKEN)
                    .bodyForm(
                            Form.form()
                                    .add("client_id", Constant.GOOGLE_CLIENT_ID)
                                    .add("client_secret", Constant.GOOGLE_CLIENT_SECRET)
                                    .add("redirect_uri", Constant.GOOGLE_REDIRECT_URI)
                                    .add("code", code)
                                    .add("grant_type", Constant.GOOGLE_GRANT_TYPE)
                                    .build()
                    )
                    .execute().returnContent().asString(StandardCharsets.UTF_8);
            
            JsonObject jobj = new Gson().fromJson(response, JsonObject.class);

            // Kiểm tra nếu có lỗi từ Google
            if (jobj.has("error")) {
                throw new IOException("Lỗi từ Google: " + jobj.get("error").getAsString());
            }
            
            return jobj.get("access_token").getAsString();
            
        } catch (HttpResponseException e) {
            System.err.println("Lỗi khi gọi API lấy token từ Google: " + e.getMessage());
            throw new IOException("Không thể lấy token từ Google. Vui lòng kiểm tra lại client_id và client_secret.");
        }
    }

    // Lấy thông tin người dùng từ Google API
    public static GoogleAccount getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
        String link = Constant.GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link)
                .execute()
                .returnContent()
                .asString(StandardCharsets.UTF_8); // Đảm bảo mã hóa UTF-8

        System.out.println("Response from Google: " + response);
        return new Gson().fromJson(response, GoogleAccount.class);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
