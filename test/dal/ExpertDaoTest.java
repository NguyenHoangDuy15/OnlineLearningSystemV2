package dal;

import Model.Expert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class ExpertDaoTest {

    private ExpertDao expertDao;

    @Mock
    private Connection mockConnection;

    @Mock
    private PreparedStatement mockStatement;

    @Mock
    private ResultSet mockResultSet;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        expertDao = new ExpertDao();
        expertDao.connection = mockConnection;

        when(mockConnection.prepareStatement(anyString())).thenReturn(mockStatement);
    }

    @Test
    public void testGetAllInstructorCourses_Success() throws Exception {
        when(mockStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getString("username")).thenReturn("John Doe");
        when(mockResultSet.getString("name")).thenReturn("Java Course");

        List<Expert> result = expertDao.getAllInstructorCourses();

        assertEquals(1, result.size());
        assertEquals("John Doe", result.get(0).getUsername());
        assertEquals("Java Course", result.get(0).getName());
    }

    @Test
    public void testGetAllInstructorCourses_NoResults() throws Exception {
        when(mockStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(false);

        List<Expert> result = expertDao.getAllInstructorCourses();

        assertTrue(result.isEmpty());
    }

    @Test
    public void testGetAllInstructorCourses_ByExpertId_Success() throws Exception {
        when(mockStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getString("username")).thenReturn("John Doe");
        when(mockResultSet.getString("name")).thenReturn("Java Course");

        List<Expert> result = expertDao.getAllInstructorCourses("1");

        assertEquals(1, result.size());
        assertEquals("John Doe", result.get(0).getUsername());
        assertEquals("Java Course", result.get(0).getName());
    }

    @Test
    public void testGetAllInstructorCourses_ByExpertId_NoResults() throws Exception {
        when(mockStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(false);

        List<Expert> result = expertDao.getAllInstructorCourses("1");

        assertTrue(result.isEmpty());
    }

    @Test
    public void testGetUserIdByUsernameAndRole_Success() throws Exception {
        when(mockStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getString("UserID")).thenReturn("1001");

        String userId = expertDao.getUserIdByUsernameAndRole("john_doe");

        assertEquals("1001", userId);
    }

    @Test
    public void testGetUserIdByUsernameAndRole_NotFound() throws Exception {
        when(mockStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(false);

        String userId = expertDao.getUserIdByUsernameAndRole("john_doe");

        assertNull(userId);
    }
}