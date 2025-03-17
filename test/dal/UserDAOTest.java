/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit4TestClass.java to edit this template
 */
package dal;

import Model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.runner.RunWith;
import static org.mockito.ArgumentMatchers.anyString;
import org.mockito.Mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.MockitoJUnitRunner;

/**
 *
 * @author DELL
 */
@RunWith(MockitoJUnitRunner.class)
public class UserDAOTest {

    @Mock
    private Connection mockConnection;

    @Mock
    private PreparedStatement mockPreparedStatement;

    @Mock
    private ResultSet mockResultSet;

    private UserDAO userDAO;

    public UserDAOTest() {
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
        userDAO = new UserDAO();
        userDAO.connection = mockConnection; // giả lập connection cho user dao
    }

    @After
    public void tearDown() {
    }

    @Test
    public void testAdd() throws SQLException {
        System.out.println("add");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);

        userDAO.addUser("testUser", "testPass", "Test Name", "test@example.com", 2);
        verify(mockPreparedStatement, times(1)).executeUpdate();
    }

    @Test
    public void testAddUser() throws SQLException {
        System.out.println("addUser");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("UserID")).thenReturn(1);

        List<User> users = userDAO.getAll();
        assertNotNull(users);
        assertEquals(1, users.size());
    }


    @Test
    public void testGetAllExpert() throws SQLException {
        System.out.println("getAllExpert");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("UserID")).thenReturn(1);
        
        List<User> experts = userDAO.getAllExpert();
        assertNotNull(experts);
        assertEquals(1, experts.size());
    }

    @Test
    public void testCheck() throws SQLException {
        System.out.println("check");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getString("UserName")).thenReturn("testUser");
        
        User user = userDAO.check("testUser", "testPass");
        assertNotNull(user);
        assertEquals("testUser", user.getUserName());
    }

    @Test
    public void testChangePass() throws SQLException {
        System.out.println("changePass");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        

        userDAO.changePass("newPass", 1);
        verify(mockPreparedStatement, times(1)).executeUpdate();
    }


    @Test
    public void testDelete() throws SQLException {
        System.out.println("delete");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);

        userDAO.delete("1");
        verify(mockPreparedStatement, times(1)).executeUpdate();
    }

    @Test
    public void testGetUserByUserId() throws SQLException {
        System.out.println("getUserByUserId");
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt("UserID")).thenReturn(1);
        when(mockResultSet.getString("UserName")).thenReturn("testUser");
        
        User user = userDAO.getUserByUserId("1");
        assertNotNull(user);
        assertEquals("testUser", user.getUserName());
    }

}
