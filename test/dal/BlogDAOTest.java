/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package dal;

import dal.BlogDAO;
import Model.Blog;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.*;
import org.mockito.junit.MockitoJUnitRunner;

import java.sql.*;
import java.time.LocalDate;
import java.util.*;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class BlogDAOTest {

    @InjectMocks
    private BlogDAO blogDAO;

    @Mock
    private Connection connection;

    @Mock
    private PreparedStatement preparedStatement;

    @Mock
    private ResultSet resultSet;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.initMocks(this);
        when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);
    }

    @Test
    public void createBlog_shouldCreateBlogSuccessfully() throws Exception {
        when(preparedStatement.executeUpdate()).thenReturn(1);

        blogDAO.createBlog("Test Blog", "This is a test", "image.jpg", 1, 3);

        verify(preparedStatement, times(1)).executeUpdate();
    }

    @Test
    public void deleteBlog_shouldDeleteBlogSuccessfully() throws Exception {
        when(preparedStatement.executeUpdate()).thenReturn(1);

        blogDAO.deleteBlog(1, 3);

        verify(preparedStatement, times(1)).executeUpdate();
    }

    @Test
    public void editBlog_shouldEditBlogSuccessfully() throws Exception {
        when(preparedStatement.executeUpdate()).thenReturn(1);

        blogDAO.editBlog(1, "Updated Title", "Updated Detail", "new_image.jpg", 1);

        verify(preparedStatement, times(1)).executeUpdate();
    }

    @Test
    public void getAllBlogs_shouldReturnListOfBlogs() throws Exception {
        when(preparedStatement.executeQuery()).thenReturn(resultSet);
        when(resultSet.next()).thenReturn(true, false);
        when(resultSet.getInt("BlogID")).thenReturn(1);
        when(resultSet.getString("BlogTitle")).thenReturn("Sample Blog");
        when(resultSet.getString("BlogDetail")).thenReturn("Blog Details");
        when(resultSet.getString("BlogImage")).thenReturn("image.jpg");
        when(resultSet.getDate("BlogDate")).thenReturn(java.sql.Date.valueOf(LocalDate.now()));
        when(resultSet.getInt("UserID")).thenReturn(1);

        List<Blog> blogs = blogDAO.getAllBlogs();

        assertEquals(1, blogs.size());
        assertEquals("Sample Blog", blogs.get(0).getBlogTitle());
    }

    @Test
    public void getBlogByID_shouldReturnCorrectBlog() throws Exception {
        when(preparedStatement.executeQuery()).thenReturn(resultSet);
        when(resultSet.next()).thenReturn(true);
        when(resultSet.getInt("BlogID")).thenReturn(1);
        when(resultSet.getString("BlogTitle")).thenReturn("Sample Blog");
        when(resultSet.getString("BlogDetail")).thenReturn("Blog Details");
        when(resultSet.getString("BlogImage")).thenReturn("image.jpg");
        when(resultSet.getDate("BlogDate")).thenReturn(java.sql.Date.valueOf(LocalDate.now()));
        when(resultSet.getInt("UserID")).thenReturn(1);

        Blog blog = blogDAO.getBlogByID(1);

        assertNotNull(blog);
        assertEquals("Sample Blog", blog.getBlogTitle());
    }

    @Test
    public void searchBlogs_shouldReturnMatchingBlogs() throws Exception {
        when(preparedStatement.executeQuery()).thenReturn(resultSet);
        when(resultSet.next()).thenReturn(true, false);
        when(resultSet.getInt("BlogID")).thenReturn(1);
        when(resultSet.getString("BlogTitle")).thenReturn("Test Blog");
        when(resultSet.getString("BlogDetail")).thenReturn("This is a test");
        when(resultSet.getString("BlogImage")).thenReturn("image.jpg");
        when(resultSet.getDate("BlogDate")).thenReturn(java.sql.Date.valueOf(LocalDate.now()));
        when(resultSet.getInt("UserID")).thenReturn(1);

        List<Blog> blogs = blogDAO.searchBlogs("Test");

        assertEquals(1, blogs.size());
        assertEquals("Test Blog", blogs.get(0).getBlogTitle());
    }

    @Test
    public void getBlogsByUserID_shouldReturnUserBlogs() throws Exception {
        when(preparedStatement.executeQuery()).thenReturn(resultSet);
        when(resultSet.next()).thenReturn(true, false);
        when(resultSet.getInt("BlogID")).thenReturn(1);
        when(resultSet.getString("BlogTitle")).thenReturn("User Blog");
        when(resultSet.getString("BlogDetail")).thenReturn("Blog from user");
        when(resultSet.getString("BlogImage")).thenReturn("image.jpg");
        when(resultSet.getDate("BlogDate")).thenReturn(java.sql.Date.valueOf(LocalDate.now()));
        when(resultSet.getInt("UserID")).thenReturn(1);

        List<Blog> blogs = blogDAO.getBlogsByUserID(1, 3);

        assertEquals(1, blogs.size());
        assertEquals("User Blog", blogs.get(0).getBlogTitle());
    }
}