/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package dal;

import Model.MoneyHistoryByAdmin;
import Model.RequestPrint;
import java.util.Date;
import java.util.List;
import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.After;
import org.junit.BeforeClass;
import org.junit.AfterClass;
import org.junit.Test;
import static org.mockito.Mockito.*;
import java.sql.*;
import org.junit.runner.RunWith;
import org.mockito.*;
import org.mockito.junit.MockitoJUnitRunner;

/**
 *
 * @author DELL
 */
@RunWith(MockitoJUnitRunner.class)
public class AdminDaoTest {

    @Mock
    private Connection mockConnection;

    @Mock
    private PreparedStatement mockPreparedStatement;

    @Mock
    private ResultSet mockResultSet;

    private AdminDao admindao;

    public AdminDaoTest() {
    }

    @BeforeClass
    public static void setUpClass() {
    }

    @AfterClass
    public static void tearDownClass() {
    }

    @Before
    public void setUp() {
        MockitoAnnotations.openMocks(this);  // Khởi tạo mock
        admindao = new AdminDao();
        admindao.connection = mockConnection; // giả lập connection cho user dao
    }

    @After
    public void tearDown() {
    }

    @Test
    public void testGetAllHistory() throws SQLException {
        System.out.println("getAllHistory");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);

        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("PayID")).thenReturn(1);
        when(mockResultSet.getInt("Status")).thenReturn(1);
        when(mockResultSet.getDate("CreatedAt")).thenReturn(new java.sql.Date(System.currentTimeMillis()));
        when(mockResultSet.getInt("CourseID")).thenReturn(101);
        when(mockResultSet.getString("CourseName")).thenReturn("Java Programming");
        when(mockResultSet.getString("PaymentMethod")).thenReturn("Credit Card");
        when(mockResultSet.getDate("PaymentDate")).thenReturn(new java.sql.Date(System.currentTimeMillis()));
        when(mockResultSet.getFloat("Price")).thenReturn(100.0f);

        List<MoneyHistoryByAdmin> history = admindao.getAllHistory();
        assertNotNull(history);
        assertEquals(1, history.size());
        assertEquals("Java Programming", history.get(0).getCourseName());
    }

    @Test
    public void testGet5History() throws SQLException {
        System.out.println("get5History");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("PayID")).thenReturn(1);

        List<MoneyHistoryByAdmin> history = admindao.get5History(1);
        assertNotNull(history);
        assertEquals(1, history.size());
    }

    @Test
    public void testGetAllRequest() throws SQLException {
        System.out.println("getAllRequest");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true, false);

        List<RequestPrint> requests = admindao.getAllRequest();
        assertNotNull(requests);
        assertEquals(1, requests.size());
    }

    @Test
    public void testGet5Request() throws SQLException {
        System.out.println("get5Request");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true, false);

        List<RequestPrint> requests = admindao.get5Request(1);
        assertNotNull(requests);
        assertEquals(1, requests.size());
    }

    @Test
    public void testDeleteRequest() throws SQLException {
        System.out.println("deleteRequest");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        admindao.deleteRequest("1");
        verify(mockPreparedStatement, times(1)).executeUpdate();
    }

    @Test
    public void testUpdateRoleForUser() throws SQLException {
        System.out.println("UpdateRoleForUser");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);

        admindao.UpdateRoleForUser("1", "2");
        verify(mockPreparedStatement, times(1)).executeUpdate();
    }

    @Test
    public void testUpdateUserForAdmin() throws SQLException {
        System.out.println("UpdateUserForAdmin");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        admindao.UpdateUserForAdmin("1", "Test Name", "test@example.com", "2", "Active");
        verify(mockPreparedStatement, times(1)).executeUpdate();
    }

}
