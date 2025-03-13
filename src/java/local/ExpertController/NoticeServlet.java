/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package local.ExpertController;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;



/**
 *
 * @author CONG NINH
 */
@WebServlet(name = "NoticeServlet", urlPatterns = {"/NoticeServlet"})
public class NoticeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tham số success và error từ URL
        String success = request.getParameter("success");
        String error = request.getParameter("error");

        // Đặt các tham số này vào request attribute để JSP sử dụng
        if (success != null) {
            request.setAttribute("success", success);
        }
        if (error != null) {
            request.setAttribute("error", error);
        }

        // Forward tới NoticeJSP
        request.getRequestDispatcher("jsp/NoticeJSP.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); 
    }
}