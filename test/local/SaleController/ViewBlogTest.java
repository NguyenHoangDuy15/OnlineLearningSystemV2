/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package local.SaleController;

import Model.Blog;
import dal.BlogDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import static org.mockito.Mockito.*;
import org.mockito.junit.MockitoJUnitRunner;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author CONG NINH
 */
@RunWith(MockitoJUnitRunner.class)
public class ViewBlogTest {

    @Mock
    private HttpServletRequest mockRequest;

    @Mock
    private HttpServletResponse mockResponse;

    @Mock
    private BlogDAO mockBlogDAO;

    @Mock
    private RequestDispatcher mockRequestDispatcher;

    @InjectMocks
    private ViewBlog viewBlog;

    @Before
    public void setUp() {
        // Khởi tạo BlogDAO mock trong ViewBlog
        viewBlog.init(); // Gọi init để set blogDAO
        try {
            java.lang.reflect.Field blogDAOField = ViewBlog.class.getDeclaredField("blogDAO");
            blogDAOField.setAccessible(true);
            blogDAOField.set(viewBlog, mockBlogDAO);
        } catch (NoSuchFieldException | IllegalAccessException e) {
            // Nếu không set được, init() đã làm việc này
        }
    }

    @After
    public void tearDown() {
    }

    /**
     * Test of doGet method, of class ViewBlog.
     */
    @Test
    public void testDoGet() throws Exception {
        System.out.println("doGet");

        // Mock request parameter
        when(mockRequest.getParameter("page")).thenReturn("1");
        when(mockRequest.getRequestDispatcher("jsp/viewblog.jsp")).thenReturn(mockRequestDispatcher);

        // Mock BlogDAO behavior
        List<Blog> mockBlogList = new ArrayList<>();
        mockBlogList.add(new Blog()); // Giả lập một blog
        when(mockBlogDAO.getTotalBlogs()).thenReturn(10); // Tổng 10 blog
        when(mockBlogDAO.getBlogsByPage(1, 6)).thenReturn(mockBlogList);

        // Gọi doGet
        viewBlog.doGet(mockRequest, mockResponse);

        // Verify interactions
        verify(mockBlogDAO, times(1)).getTotalBlogs();
        verify(mockBlogDAO, times(1)).getBlogsByPage(1, 6);
        verify(mockRequest, times(1)).setAttribute("blogList", mockBlogList);
        verify(mockRequest, times(1)).setAttribute(eq("currentPage"), eq(1));
        verify(mockRequest, times(1)).setAttribute(eq("totalPages"), eq(2)); // 10 blogs / 6 per page = 2 pages
        verify(mockRequestDispatcher, times(1)).forward(mockRequest, mockResponse);
    }

    /**
     * Test of doPost method, of class ViewBlog.
     */
    @Test
    public void testDoPost() throws Exception {
        System.out.println("doPost");

        // Gọi doPost (hiện tại không làm gì)
        viewBlog.doPost(mockRequest, mockResponse);

        // Vì doPost trống, không cần verify gì cả
        // Test pass nếu không có ngoại lệ
        assertTrue("doPost should complete without throwing an exception", true);
    }

    /**
     * Test of getServletInfo method, of class ViewBlog.
     */
    @Test
    public void testGetServletInfo() {
        System.out.println("getServletInfo");
        String result = viewBlog.getServletInfo();
        assertEquals("Short description", result);
    }
}