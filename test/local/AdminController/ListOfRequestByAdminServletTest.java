package local.AdminController;

import Model.RequestPrint;
import dal.AdminDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.MockitoJUnitRunner;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class ListOfRequestByAdminServletTest {

    @InjectMocks
    private ListOfRequestByAdminServlet servlet;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private AdminDao adminDao;

    @Mock
    private RequestDispatcher requestDispatcher;

    @Before
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        when(request.getSession()).thenReturn(session);
        when(request.getRequestDispatcher("jsp/ListOfRequestByAdmin.jsp")).thenReturn(requestDispatcher);
    }

    @Test
    public void testProcessRequest_NoIndex() throws Exception {
        when(request.getParameter("index")).thenReturn(null);
        List<RequestPrint> allRequests = new ArrayList<>();
        for (int i = 0; i < 6; i++) allRequests.add(new RequestPrint());
        List<RequestPrint> fiveRequests = allRequests.subList(0, 5);

        when(adminDao.getAllRequest()).thenReturn(allRequests);
        when(adminDao.get5Request(1)).thenReturn(fiveRequests);

        servlet.processRequest(request, response);

        verify(session).setAttribute("Nopage", 2);
        verify(session).setAttribute("currentindex", 1);
        verify(session).setAttribute("listRequest", fiveRequests);
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testProcessRequest_WithIndex() throws Exception {
        when(request.getParameter("index")).thenReturn("2");
        List<RequestPrint> allRequests = new ArrayList<>();
        for (int i = 0; i < 6; i++) allRequests.add(new RequestPrint());
        List<RequestPrint> oneRequest = allRequests.subList(5, 6);

        when(adminDao.getAllRequest()).thenReturn(allRequests);
        when(adminDao.get5Request(2)).thenReturn(oneRequest);

        servlet.processRequest(request, response);

        verify(session).setAttribute("Nopage", 2);
        verify(session).setAttribute("currentindex", 2);
        verify(session).setAttribute("listRequest", oneRequest);
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testProcessRequest_NoRequests() throws Exception {
        when(adminDao.getAllRequest()).thenReturn(new ArrayList<>());

        servlet.processRequest(request, response);

        verify(request).setAttribute("noti", "No Request found");
        verify(session).setAttribute("Nopage", 0);
        verify(session).setAttribute("currentindex", 1);
        verify(session).setAttribute("listRequest", new ArrayList<>());
        verify(requestDispatcher).forward(request, response);
    }

    @Test
    public void testProcessRequest_Exception() throws Exception {
        when(request.getParameter("index")).thenThrow(new NumberFormatException("Invalid index"));

        servlet.processRequest(request, response);

        verify(response).sendRedirect("exceptionErrorPage.jsp");
    }

    @Test
    public void testGetNoPage_EmptyList() {
        assertEquals(0, servlet.getNoPage(new ArrayList<>()));
    }

    @Test
    public void testGetNoPage_FiveItems() {
        List<RequestPrint> list = new ArrayList<>();
        for (int i = 0; i < 5; i++) list.add(new RequestPrint());
        assertEquals(1, servlet.getNoPage(list));
    }

    @Test
    public void testGetNoPage_SixItems() {
        List<RequestPrint> list = new ArrayList<>();
        for (int i = 0; i < 6; i++) list.add(new RequestPrint());
        assertEquals(2, servlet.getNoPage(list));
    }
}
