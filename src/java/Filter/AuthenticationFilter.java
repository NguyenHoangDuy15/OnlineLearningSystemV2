package Filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.List;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/*"})
public class AuthenticationFilter implements Filter {

    // Danh sách các URL công khai (không cần đăng nhập)
    private static final List<String> ALLOWED_URLS = Arrays.asList(
            "/LoginServlet", "/jsp/login.jsp", "/jsp/course.jsp", "/jsp/detail.jsp", "/detail",
            "/jsp/Landingpage.jsp", "/jsp/Instructor.jsp", "/jsp/register.jsp",
            "/jsp/viewblog.jsp", "/ViewBlog", "/RegisterServlet", "/VerifyServlet",
            "/jsp/verify.jsp", "/jsp/changePassword.jsp", "/jsp/forgetPassword.jsp", "/jsp/header",
            "/assets/", "/jsp/footer.jsp", "/css", "/img", "/js", "/Landingpage", "/course",
             "/ForgotPassword", "/LogoutServlet", "/Instructor", "/SearchBlog","/Expert",
            // Thêm các URL liên quan đến đăng nhập Google
            "/LoginGoogle", // Servlet xử lý đăng nhập Google
            "/oauth2callback", // URL callback của Google (nếu có)
            "/auth/google/callback" // Một dạng URL callback khác (nếu có)
    );

    private static final boolean debug = true;
    private FilterConfig filterConfig = null;

    public AuthenticationFilter() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String requestURI = req.getRequestURI();
        HttpSession session = req.getSession(false);

        // Log để debug
        if (debug) {
            log("Request URI: " + requestURI);
        }

        // Nếu URL thuộc danh sách được phép -> cho phép truy cập
        if (isAllowed(requestURI)) {
            chain.doFilter(request, response);
            return;
        }

        // Kiểm tra xem người dùng đã đăng nhập chưa
        if (session != null && session.getAttribute("account") != null) {
            // Nếu đã đăng nhập, cho phép truy cập
            chain.doFilter(request, response);
            return;
        }

        // Nếu chưa đăng nhập và không phải trang login -> chuyển hướng về trang đăng nhập
        if (!requestURI.endsWith("/LoginServlet") && !requestURI.endsWith("/jsp/login.jsp") && !requestURI.endsWith("/LoginGoogle")) {
            res.sendRedirect(req.getContextPath() + "/LoginServlet");
        } else {
            chain.doFilter(request, response);
        }
    }

    private boolean isAllowed(String requestURI) {
        for (String url : ALLOWED_URLS) {
            if (requestURI.contains(url)) {
                return true;
            }
        }
        // Kiểm tra các tài nguyên tĩnh
        return requestURI.startsWith("/assets/")
                || requestURI.startsWith("/js/")
                || requestURI.startsWith("/img/")
                || requestURI.startsWith("/css/");
    }

    @Override
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
        if (filterConfig != null && debug) {
            log("AuthenticationFilter:Initializing filter");
        }
    }

    @Override
    public void destroy() {
    }

    public void log(String msg) {
        filterConfig.getServletContext().log(msg);
    }
}
