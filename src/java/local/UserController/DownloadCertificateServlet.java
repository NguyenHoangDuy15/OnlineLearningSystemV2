package local.UserController;

import Model.Certificate;
import dal.CertificateDAO;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URL;
import java.io.InputStream;
import java.net.URLEncoder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.itextpdf.io.image.ImageDataFactory;
import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Image;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;

@WebServlet(name = "DownloadCertificateServlet", urlPatterns = {"/DownloadCertificateServlet"})
public class DownloadCertificateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Log the start of the request
        System.out.println("Received request for DownloadCertificateServlet with courseId: " + request.getParameter("courseId"));

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userid");
        System.out.println("UserID from session: " + userId);

        if (userId == null) {
            System.out.println("User not logged in, redirecting to LoginServlet");
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String courseIdParam = request.getParameter("courseId");
        if (courseIdParam == null || courseIdParam.isEmpty()) {
            System.out.println("Course ID is missing");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Course ID is required");
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdParam);
        } catch (NumberFormatException e) {
            System.out.println("Invalid Course ID: " + courseIdParam);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Course ID");
            return;
        }

        CertificateDAO certificateDAO = new CertificateDAO();
        Certificate history = certificateDAO.getEarliestCompletion(userId, courseId);
        System.out.println("Certificate: " + history);

        if (history == null) {
            System.out.println("Certificate not found for userId: " + userId + ", courseId: " + courseId);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Certificate not found");
            return;
        }

        // Thiết lập response để xuất PDF
        String fileName = "certificate_" + history.getFullname().replaceAll("[^a-zA-Z0-9_-]", "_") + ".pdf";
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        // Sử dụng ByteArrayOutputStream để tạo PDF trước
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter writer = null;
        PdfDocument pdf = null;
        Document document = null;

        try {
            // Tạo PDF bằng iText 7
            writer = new PdfWriter(baos);
            pdf = new PdfDocument(writer);
            document = new Document(pdf);

            // Thêm logo (nếu có)
            if (history.getImageCourses() != null && !history.getImageCourses().isEmpty()) {
                System.out.println("ImageCourses URL/Path: " + history.getImageCourses());
                try {
                    if (history.getImageCourses().startsWith("http")) {
                        URL imageUrl = new URL(history.getImageCourses());
                        try (InputStream inputStream = imageUrl.openStream()) {
                            byte[] imageBytes = inputStream.readAllBytes();
                            Image logo = new Image(ImageDataFactory.create(imageBytes));
                            logo.scaleToFit(250, 250);
                            logo.setHorizontalAlignment(com.itextpdf.layout.properties.HorizontalAlignment.CENTER);
                            document.add(logo);
                        }
                    } else {
                        java.io.File imageFile = new java.io.File(history.getImageCourses());
                        if (imageFile.exists() && imageFile.canRead()) {
                            Image logo = new Image(ImageDataFactory.create(history.getImageCourses()));
                            logo.scaleToFit(250, 250);
                            logo.setHorizontalAlignment(com.itextpdf.layout.properties.HorizontalAlignment.CENTER);
                            document.add(logo);
                        } else {
                            System.out.println("Image file does not exist or is not readable: " + history.getImageCourses());
                        }
                    }
                } catch (Exception e) {
                    System.out.println("Error loading logo in PDF: " + e.getMessage());
                }
            }

            // Tiêu đề
            document.add(new Paragraph("Certificate of Specialization Completion")
                    .setFontSize(24)
                    .setFontColor(ColorConstants.BLUE)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginBottom(20));

            // Nội dung
            document.add(new Paragraph("This is to certify that")
                    .setFontSize(12)
                    .setTextAlignment(TextAlignment.CENTER));

            String fullNameStr = history.getFullname() != null ? history.getFullname() : "Unknown";
            document.add(new Paragraph(fullNameStr)
                    .setFontSize(18)
                    .setFontColor(ColorConstants.BLUE)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginBottom(10));

            document.add(new Paragraph("has successfully completed the specialization")
                    .setFontSize(12)
                    .setTextAlignment(TextAlignment.CENTER));

            String specializationStr = history.getName() != null ? history.getName() : "Unknown";
            document.add(new Paragraph(specializationStr)
                    .setFontSize(18)
                    .setFontColor(ColorConstants.BLUE)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginBottom(10));

            String completionTimeStr = history.getCompletionTime() != null ? history.getCompletionTime() : "Unknown";
            document.add(new Paragraph("Completed on: " + completionTimeStr)
                    .setFontSize(12)
                    .setTextAlignment(TextAlignment.CENTER));

            // Chữ ký
            Table signatureTable = new Table(UnitValue.createPercentArray(2)).useAllAvailableWidth();
            signatureTable.setWidth(UnitValue.createPercentValue(80));
            signatureTable.setMarginTop(40);

            Cell cell1 = new Cell().add(new Paragraph("____________________\nPraveen Mittal\nAdjunct Professor")
                    .setFontSize(12)
                    .setTextAlignment(TextAlignment.CENTER));
            cell1.setBorder(com.itextpdf.layout.borders.Border.NO_BORDER);

            Cell cell2 = new Cell().add(new Paragraph("____________________\nKevin Wendt\nAcademic Director")
                    .setFontSize(12)
                    .setTextAlignment(TextAlignment.CENTER));
            cell2.setBorder(com.itextpdf.layout.borders.Border.NO_BORDER);

            signatureTable.addCell(cell1);
            signatureTable.addCell(cell2);
            document.add(signatureTable);

            // Footer
            document.add(new Paragraph(
                    "The specialization named in this certificate may draw on material from courses taught on-campus, "
                    + "but the included courses are not equivalent to on-campus courses. Participation in this online "
                    + "specialization does not constitute enrollment at the university. This certificate does not confer "
                    + "a University grade, course credit or degree, and it does not verify the identity of the learner.\n"
                    + "Verify this certificate at: https://platform.com/verify/9C1SRH67X8VA")
                    .setFontSize(10)
                    .setFontColor(ColorConstants.GRAY)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setMarginTop(30));

            // Đóng document
            document.close();

            // Ghi dữ liệu PDF vào response
            response.getOutputStream().write(baos.toByteArray());
            response.getOutputStream().flush();
        } catch (Exception e) {
            System.out.println("Error generating PDF: " + e.getMessage());
            e.printStackTrace();
            response.reset();
            response.sendRedirect(request.getContextPath() + "jsp/Error.jsp?message=" + URLEncoder.encode("Error generating PDF: " + e.getMessage(), "UTF-8"));
        } finally {
            if (document != null) {
                try {
                    document.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            if (pdf != null) {
                try {
                    pdf.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            if (writer != null) {
                try {
                    writer.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for downloading certificate as PDF";
    }
}