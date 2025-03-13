package dal;

import Model.Courses;
import org.junit.*;
import org.mockito.*;
import java.sql.*;
import java.util.*;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class CourseDaoTest {
    
    private CourseDao courseDao;
    @Mock private Connection mockConnection;
    @Mock private PreparedStatement mockStatement;
    @Mock private ResultSet mockResultSet;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.initMocks(this);
        courseDao = new CourseDao();
        courseDao.connection = mockConnection;
    }

    @Test
    public void testSearchCoursesByName() throws Exception {
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockStatement);
        when(mockStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("CourseID")).thenReturn(1);
        when(mockResultSet.getString("Name")).thenReturn("Java Basics");
        when(mockResultSet.getString("Description")).thenReturn("Learn Java");
        when(mockResultSet.getFloat("Price")).thenReturn(100.0f);
        
        List<Courses> courses = courseDao.searchCoursesByName("Java");
        assertEquals(1, courses.size());
        assertEquals("Java Basics", courses.get(0).getName());
    }

    @Test
    public void testGetAllCourses() throws Exception {
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockStatement);
        when(mockStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("CourseID")).thenReturn(1);
        when(mockResultSet.getString("Name")).thenReturn("Java Basics");
        when(mockResultSet.getString("Description")).thenReturn("Learn Java");
        when(mockResultSet.getString("imageCources")).thenReturn("java.jpg");

        List<Courses> courses = courseDao.getAllCourses();
        assertEquals(1, courses.size());
    }

    @Test
    public void testGetCourseById() throws Exception {
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockStatement);
        when(mockStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt("CourseID")).thenReturn(1);
        when(mockResultSet.getString("Name")).thenReturn("Java Basics");
        when(mockResultSet.getString("imageCources")).thenReturn("java.jpg");
        when(mockResultSet.getString("Description")).thenReturn("Learn Java");
        
        Courses course = courseDao.getCourseById(1);
        assertNotNull(course);
        assertEquals("Java Basics", course.getName());
    }

    @Test
    public void testDeleteCourse() throws Exception {
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockStatement);
        when(mockStatement.executeUpdate()).thenReturn(1);
        
        courseDao.deleteCourse("1");
        verify(mockStatement, times(1)).executeUpdate();
    }
}
