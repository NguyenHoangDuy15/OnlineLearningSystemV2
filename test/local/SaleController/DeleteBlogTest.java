/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package local.SaleController;

import dal.BlogDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import static junit.framework.Assert.assertEquals;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import static org.mockito.Mockito.*;

/**
 *
 * @author CONG NINH
 */
public class DeleteBlogTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private BlogDAO blogDAO;

    @InjectMocks
    private DeleteBlog deleteBlog;

    @Before
    public void setUp() {
        // Khởi tạo các mock trước mỗi test
        MockitoAnnotations.openMocks(this);
    }

    @After
    public void tearDown() {
        // Dọn dẹp sau mỗi test (nếu cần)
    }

    /**
     * Test of doGet method with valid blogID.
     */
    @Test
    public void testDoGetWithValidBlogId() throws Exception {
        // Arrange
        when(request.getParameter("blogID")).thenReturn("1");
        doNothing().when(blogDAO).deleteBlog(1, 3);
        doNothing().when(response).sendRedirect("viewownerbloglist");

        // Act
        deleteBlog.doGet(request, response);

        // Assert
        verify(blogDAO, times(1)).deleteBlog(1, 3);
        verify(response, times(1)).sendRedirect("viewownerbloglist");
    }

    /**
     * Test of doGet method with invalid blogID (null).
     */
    @Test(expected = NumberFormatException.class)
    public void testDoGetWithNullBlogId() throws Exception {
        // Arrange
        when(request.getParameter("blogID")).thenReturn(null);

        // Act
        deleteBlog.doGet(request, response);

        // Assert (sẽ ném NumberFormatException vì parseInt(null))
    }

    /**
     * Test of doGet method with invalid blogID (non-numeric).
     */
    @Test(expected = NumberFormatException.class)
    public void testDoGetWithNonNumericBlogId() throws Exception {
        // Arrange
        when(request.getParameter("blogID")).thenReturn("abc");

        // Act
        deleteBlog.doGet(request, response);

        // Assert (sẽ ném NumberFormatException vì parseInt("abc"))
    }

    /**
     * Test of doPost method (currently empty).
     */
    @Test
    public void testDoPost() throws Exception {
        // Act
        deleteBlog.doPost(request, response);

        // Assert (không có logic trong doPost, chỉ kiểm tra không ném lỗi)
        verifyNoInteractions(request, response);
    }

    /**
     * Test of getServletInfo method.
     */
    @Test
    public void testGetServletInfo() {
        // Act
        String result = deleteBlog.getServletInfo();

        // Assert
        assertEquals("Short description", result);
    }
}