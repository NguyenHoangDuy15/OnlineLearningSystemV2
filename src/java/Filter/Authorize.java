/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package Filter;

import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
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

/**
 *
 * @author Administrator
 */
@WebFilter(filterName = "Authorize", urlPatterns = {"/*"})
public class Authorize implements Filter {

    private static final List<String> ADMIN_ALLOW = Arrays.asList(
            "/jsp/", "/ChangeUserForAdmin.jsp", "/ListofBlogByAdmin.jsp", "/ListofBlogByAdmin.jsp",
            "/ListOfCourseRequestByAdmin.jsp", "/ListOfCourseByAdmin.jsp", "/ListOfExpert.jsp", "/ListOfFeedbackByAdmin.jsp",
            "/ListOfMoneyHistoryByAdmin.jsp", "/ListOfRequestByAdmin.jsp", "/ListOfSeller.jsp", "/ListOfUserByAdmin.jsp",
            "/dashboard.jsp", "/navbar-header.jsp", "/sidebarManager.jsp", "/addNewUser.jsp", "/changePassword.jsp", "/DeleteFeedbackByAdminServlet",
            "/AddNewUserServlet", "/ChangeUserForAdminServlet", "/DeleteBlogByAdminServlet", "/DeleteRequestServlet", "/DeleteUserByAdminServlet", "/DenyCourse",
            "/ListBlogByAdminServlet", "/ListOfCourseByAdminServlet", "/ListOfCourseRequestByAdminServlet", "/ListOfSellerServlet", "/ListOfFeedbackByAdminServlet",
            "/ListOfRequestByAdminServlet", "/ListOfExpertServlet", "/ListOfTopCourseByAdminServlet", "/ListOfUserByAdminServlet",
            "/ListTranscriptByAdminServlet", "/SearchExpertByAdminServlet", "/SearchSellerByAdminServlet", "/SearchUserByAdminServlet", "ShowAdminDasboardServlet",
            "/ShowCourseDetailByAdmin", "/UpdateRoleCourse", "/UpdateRoleUserServlet", "/showDetailTestByAdmin", "/ChangePasswordServlet"
    );

    private static final List<String> EXPERT_ALLOW = Arrays.asList(
            "/jsp/", "/Certificate.jsp", "/Dotest.jsp", "/Error.jsp",
            "/ReviewTest.jsp", "/Role.jsp", "/chatbot-widget.jsp", "/PaymentVN.jsp", "/Request.jsp", "/Result.jsp",
            "/changePassword.jsp", "/Role.jsp", "/enrollment.jsp",
            "/historytransaction.jsp", "/return.jsp", "/lessons.jsp", "/viewprofile.jsp",
            "/error1.jsp", "/courseDetails.jsp", "/editLesson.jsp", "/NoticeJSP.jsp", "/CreateTest.jsp",
            "/expertDashboard.jsp", "/editTest.jsp", "/ViewCourse.jsp", "/viewQuestions.jsp", "/viewTests.jsp", "/CourseServlet",
            "/createCourse.jsp", "/test.jsp", "/DownloadCertificateServlet", "/Certificatecontroller",
            "/ChatbotServlet", "/ChangePasswordServlet", "/Feedbackcontroller", "/Historytransaction",
            "/Lessonservlet", "/Mycourses", "/myenrollment", "/Request", "/enrollment.jsp", "/Role", "/ReviewTest",
            "/TestAnswer", "/VNPAYReturnServlet", "/VNPAYServlet", "/ViewProfile", "/index",
            "/NoticeServlet", "/QuestionController", "/RequestServlet", "/ShowexpertServlet", "/TestServlet",
            "/ViewCourse", "/ViewQuestionsServlet", "/ViewTest", "/createCourse"
    );

    private static final List<String> SALE_ALLOW = Arrays.asList(
            "/jsp/", "/Certificate.jsp", "/Dotest.jsp", "/Error.jsp",
            "/ReviewTest.jsp", "/Role.jsp", "/chatbot-widget.jsp", "/PaymentVN.jsp", "/Request.jsp", "/Result.jsp",
            "/changePassword.jsp", "/Role.jsp", "/detail.jsp", "/enrollment.jsp",
            "/historytransaction.jsp", "/return.jsp", "/lessons.jsp", "/viewprofile.jsp",
            "/createblog.jsp", "/updateblog.jsp", "/viewownerbloglist.jsp",
            "/DownloadCertificateServlet", "/Certificatecontroller",
            "/ChatbotServlet", "/ChangePasswordServlet", "/Feedbackcontroller", "/Historytransaction",
            "/Lessonservlet", "/Mycourses", "/myenrollment", "/Request", "/enrollment.jsp", "/Role", "/ReviewTest",
            "/TestAnswer", "/VNPAYReturnServlet", "/VNPAYServlet", "/ViewProfile", "/index",
            "/CreateBlog", "/DeleteBlog", "/EditBlog", "/viewownerbloglist"
    );

    private static final List<String> CUSTOMER_ALLOW = Arrays.asList(
            "/jsp/", "/Certificate.jsp", "/Dotest.jsp", "/Error.jsp",
            "/ReviewTest.jsp", "/Role.jsp", "/chatbot-widget.jsp", "/PaymentVN.jsp", "/Request.jsp", "/Result.jsp",
            "/changePassword.jsp", "/Role.jsp", "/enrollment.jsp",
            "/historytransaction.jsp", "/return.jsp", "/lessons.jsp", "/viewprofile.jsp", "/DownloadCertificateServlet", "/Certificatecontroller",
            "/ChatbotServlet", "/ChangePasswordServlet", "/Feedbackcontroller", "/Historytransaction",
            "/Lessonservlet", "/Mycourses", "/myenrollment", "/Request", "/enrollment.jsp", "/Role", "/ReviewTest",
            "/TestAnswer", "/VNPAYReturnServlet", "/VNPAYServlet", "/ViewProfile", "/index"
    );

    private static final boolean debug = true;

    // The filter configuration object we are associated with.  If
    // this value is null, this filter instance is not currently
    // configured. 
    private FilterConfig filterConfig = null;

    public Authorize() {
    }

    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("Authorize:DoBeforeProcessing");
        }

        // Write code here to process the request and/or response before
        // the rest of the filter chain is invoked.
        // For example, a logging filter might log items on the request object,
        // such as the parameters.
        /*
	for (Enumeration en = request.getParameterNames(); en.hasMoreElements(); ) {
	    String name = (String)en.nextElement();
	    String values[] = request.getParameterValues(name);
	    int n = values.length;
	    StringBuffer buf = new StringBuffer();
	    buf.append(name);
	    buf.append("=");
	    for(int i=0; i < n; i++) {
	        buf.append(values[i]);
	        if (i < n-1)
	            buf.append(",");
	    }
	    log(buf.toString());
	}
         */
    }

    private void doAfterProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("Authorize:DoAfterProcessing");
        }

        // Write code here to process the request and/or response after
        // the rest of the filter chain is invoked.
        // For example, a logging filter might log the attributes on the
        // request object after the request has been processed. 
        /*
	for (Enumeration en = request.getAttributeNames(); en.hasMoreElements(); ) {
	    String name = (String)en.nextElement();
	    Object value = request.getAttribute(name);
	    log("attribute: " + name + "=" + value.toString());

	}
         */
        // For example, a filter might append something to the response.
        /*
	PrintWriter respOut = new PrintWriter(response.getWriter());
	respOut.println("<P><B>This has been appended by an intrusive filter.</B>");
         */
    }

    /**
     *
     * @param request The servlet request we are processing
     * @param response The servlet response we are creating
     * @param chain The filter chain we are processing
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet error occurs
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String requestURI = req.getRequestURI();
        HttpSession session = req.getSession(false);

        // If session doesn't exist, let Authenticate filter handle it
        if (session == null) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is authenticated with a specific role
        Object admin = session.getAttribute("admin");
        Object expert = session.getAttribute("expert");
        Object sale = session.getAttribute("sale");
        Object customer = session.getAttribute("customer");

        // Check role-specific authorization
        if (admin != null && isURLAllowed(requestURI, ADMIN_ALLOW)) {
            chain.doFilter(request, response);
            return;
        } else if (expert != null && isURLAllowed(requestURI, EXPERT_ALLOW)) {
            chain.doFilter(request, response);
            return;
        } else if (sale != null && isURLAllowed(requestURI, SALE_ALLOW)) {
            chain.doFilter(request, response);
            return;
        } else if (customer != null && isURLAllowed(requestURI, CUSTOMER_ALLOW)) {
            chain.doFilter(request, response);
            return;
        }

        // If we're here, let's see if the user is trying to access a protected area they shouldn't
        if ((admin == null && isURLAllowed(requestURI, ADMIN_ALLOW))
                || (expert == null && isURLAllowed(requestURI, EXPERT_ALLOW))
                || (sale == null && isURLAllowed(requestURI, SALE_ALLOW))
                || (customer == null && isURLAllowed(requestURI, CUSTOMER_ALLOW))) {
            // User is trying to access a protected area without proper role
            req.setAttribute("errorMessage", "Bạn không có quyền truy cập trang này.");
            req.getRequestDispatcher("/Unauthorized.jsp").forward(request, response);
            return;
        }

        // If not matching any specific role-based URL, let request pass through
        chain.doFilter(request, response);
    }

    private boolean isURLAllowed(String requestURI, List<String> allowedURLs) {
        for (String url : allowedURLs) {
            if (requestURI.contains(url)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Return the filter configuration object for this filter.
     */
    public FilterConfig getFilterConfig() {
        return (this.filterConfig);
    }

    /**
     * Set the filter configuration object for this filter.
     *
     * @param filterConfig The filter configuration object
     */
    public void setFilterConfig(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    /**
     * Destroy method for this filter
     */
    public void destroy() {
    }

    /**
     * Init method for this filter
     */
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
        if (filterConfig != null) {
            if (debug) {
                log("Authorize:Initializing filter");
            }
        }
    }

    /**
     * Return a String representation of this object.
     */
    @Override
    public String toString() {
        if (filterConfig == null) {
            return ("Authorize()");
        }
        StringBuffer sb = new StringBuffer("Authorize(");
        sb.append(filterConfig);
        sb.append(")");
        return (sb.toString());
    }

    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);

        if (stackTrace != null && !stackTrace.equals("")) {
            try {
                response.setContentType("text/html");
                PrintStream ps = new PrintStream(response.getOutputStream());
                PrintWriter pw = new PrintWriter(ps);
                pw.print("<html>\n<head>\n<title>Error</title>\n</head>\n<body>\n"); //NOI18N

                // PENDING! Localize this for next official release
                pw.print("<h1>The resource did not process correctly</h1>\n<pre>\n");
                pw.print(stackTrace);
                pw.print("</pre></body>\n</html>"); //NOI18N
                pw.close();
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        } else {
            try {
                PrintStream ps = new PrintStream(response.getOutputStream());
                t.printStackTrace(ps);
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        }
    }

    public static String getStackTrace(Throwable t) {
        String stackTrace = null;
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            pw.close();
            sw.close();
            stackTrace = sw.getBuffer().toString();
        } catch (Exception ex) {
        }
        return stackTrace;
    }

    public void log(String msg) {
        filterConfig.getServletContext().log(msg);
    }

}
