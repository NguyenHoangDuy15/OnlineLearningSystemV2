package dal;

import Model.TestEX;
import Model.QuestionEX;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/TestServlet")
public class TestServlet extends HttpServlet {
    private TestEXDAO testDAO;
    private QuestionEXDAO questionDAO;

    @Override
    public void init() throws ServletException {
        testDAO = new TestEXDAO();
        questionDAO = new QuestionEXDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String testIdStr = request.getParameter("testId");
        int testId;
        try {
            testId = Integer.parseInt(testIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid test ID");
            request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            return;
        }

        // Lấy thông tin bài kiểm tra
        TestEX test = testDAO.getTestById(testId);
        if (test == null) {
            request.setAttribute("error", "Test not found");
            request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            return;
        }

        // Lấy danh sách câu hỏi
        List<QuestionEX> questions = questionDAO.getQuestionsByTestId(testId);
        if (questions == null) {
            System.out.println("No questions found for testId: " + testId);
            questions = new ArrayList<>(); // Đảm bảo danh sách không null
        } else {
            System.out.println("Found " + questions.size() + " questions for testId: " + testId);
            for (QuestionEX q : questions) {
                System.out.println("Question ID: " + q.getQuestionID() + ", Content: " + q.getQuestionContent());
            }
        }

        // Truyền dữ liệu vào JSP
        request.setAttribute("test", test);
        request.setAttribute("questions", questions);
        request.getRequestDispatcher("jsp/editTest.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("updateTest".equals(action)) {
            try {
                System.out.println("Starting updateTest action");
                int testId = Integer.parseInt(request.getParameter("testId"));
                String testName = request.getParameter("testName");
                System.out.println("testId: " + testId + ", testName: " + testName);

                // Cập nhật thông tin bài kiểm tra
                TestEX test = testDAO.getTestById(testId);
                if (test == null) {
                    throw new Exception("Test not found");
                }
                test.setName(testName);
                System.out.println("Calling testDAO.updateTest");
                testDAO.updateTest(test);

                // Xử lý câu hỏi từ form
                String[] questionIds = request.getParameterValues("questionId[]");
                String[] questionContents = request.getParameterValues("question[]");
                String[] correctAnswers = request.getParameterValues("correctAnswer[]");
                String[] optionAs = request.getParameterValues("optionA[]");
                String[] optionBs = request.getParameterValues("optionB[]");
                String[] optionCs = request.getParameterValues("optionC[]");
                String[] optionDs = request.getParameterValues("optionD[]");

                List<Integer> submittedQuestionIds = new ArrayList<>();
                int newQuestionsAdded = 0;

                // Xử lý các câu hỏi được gửi lên (nếu có)
                if (questionContents != null && questionContents.length > 0) {
                    int length = questionContents.length;

                    // Kiểm tra độ dài của các mảng
                    StringBuilder errorDetails = new StringBuilder();
                    if (questionIds == null || questionIds.length != length) {
                        errorDetails.append("questionId[] length: ").append(questionIds == null ? "null" : questionIds.length).append("; ");
                    }
                    if (correctAnswers == null || correctAnswers.length != length) {
                        errorDetails.append("correctAnswer[] length: ").append(correctAnswers == null ? "null" : correctAnswers.length).append("; ");
                    }
                    if (optionAs == null || optionAs.length != length) {
                        errorDetails.append("optionA[] length: ").append(optionAs == null ? "null" : optionAs.length).append("; ");
                    }
                    if (optionBs == null || optionBs.length != length) {
                        errorDetails.append("optionB[] length: ").append(optionBs == null ? "null" : optionBs.length).append("; ");
                    }
                    if (optionCs == null || optionCs.length != length) {
                        errorDetails.append("optionC[] length: ").append(optionCs == null ? "null" : optionCs.length).append("; ");
                    }
                    if (optionDs == null || optionDs.length != length) {
                        errorDetails.append("optionD[] length: ").append(optionDs == null ? "null" : optionDs.length).append("; ");
                    }

                    if (errorDetails.length() > 0) {
                        System.out.println("Mismatch in form data: " + errorDetails.toString());
                        length = Math.min(length, 
                            Math.min(correctAnswers != null ? correctAnswers.length : 0,
                            Math.min(optionAs != null ? optionAs.length : 0,
                            Math.min(optionBs != null ? optionBs.length : 0,
                            Math.min(optionCs != null ? optionCs.length : 0,
                            optionDs != null ? optionDs.length : 0)))));
                    }

                    System.out.println("Number of questions submitted: " + length);
                    for (int i = 0; i < length; i++) {
                        // Kiểm tra dữ liệu hợp lệ
                        if (questionContents[i] == null || questionContents[i].trim().isEmpty() ||
                            optionAs[i] == null || optionAs[i].trim().isEmpty() ||
                            optionBs[i] == null || optionBs[i].trim().isEmpty() ||
                            optionCs[i] == null || optionCs[i].trim().isEmpty() ||
                            optionDs[i] == null || optionDs[i].trim().isEmpty() ||
                            correctAnswers[i] == null || correctAnswers[i].trim().isEmpty()) {
                            System.out.println("Skipping invalid question " + (i + 1) + ": some fields are empty");
                            throw new Exception("Invalid data for question " + (i + 1) + ": some fields are empty");
                        }

                        // Kiểm tra giá trị của correctAnswer
                        if (!correctAnswers[i].matches("^[A-D]$")) {
                            System.out.println("Skipping invalid question " + (i + 1) + ": correct answer must be A, B, C, or D");
                            throw new Exception("Invalid correct answer for question " + (i + 1) + ": must be A, B, C, or D");
                        }

                        String questionIdStr = questionIds[i];
                        if (questionIdStr != null && !questionIdStr.isEmpty()) {
                            // Câu hỏi hiện có: Cập nhật
                            int questionId = Integer.parseInt(questionIdStr);
                            submittedQuestionIds.add(questionId);
                            System.out.println("Updating existing question " + questionId + ": " + questionContents[i]);
                            questionDAO.updateQuestion(
                                questionId,
                                questionContents[i],
                                optionAs[i],
                                optionBs[i],
                                optionCs[i],
                                optionDs[i]
                            );
                            // Cập nhật đáp án đúng
                            System.out.println("Updating correct answer for question " + questionId + ": " + correctAnswers[i]);
                            questionDAO.updateCorrectAnswer(questionId, correctAnswers[i]);
                        } else {
                            // Câu hỏi mới: Thêm
                            System.out.println("Adding new question: " + questionContents[i]);
                            int newQuestionId = questionDAO.addQuestion(
                                questionContents[i],
                                optionAs[i],
                                optionBs[i],
                                optionCs[i],
                                optionDs[i],
                                testId
                            );
                            if (newQuestionId == -1) {
                                System.out.println("Failed to add new question " + (i + 1));
                                throw new Exception("Failed to add new question " + (i + 1));
                            }
                            submittedQuestionIds.add(newQuestionId);
                            newQuestionsAdded++;
                            System.out.println("Adding correct answer for new questionId: " + newQuestionId + ", answer: " + correctAnswers[i]);
                            questionDAO.addCorrectAnswer(newQuestionId, correctAnswers[i]);
                        }
                    }
                } else {
                    System.out.println("No questions submitted in the form.");
                }

                // Chuyển hướng về chính TestServlet với thông báo
                String message = "Test updated successfully.";
                if (newQuestionsAdded > 0) {
                    message += " Added " + newQuestionsAdded + " new question(s).";
                }
                System.out.println("Redirecting to TestServlet with testId: " + testId);
                response.sendRedirect("TestServlet?testId=" + testId + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"));
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "An error occurred while saving changes: " + e.getMessage());
                request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            }
        } else if ("deactivateQuestion".equals(action)) {
            try {
                int questionId = Integer.parseInt(request.getParameter("questionId"));
                System.out.println("Deactivating question with questionId: " + questionId);
                questionDAO.deactivateQuestion(questionId);
                int testId = Integer.parseInt(request.getParameter("testId"));
                response.sendRedirect("TestServlet?testId=" + testId + "&message=" + java.net.URLEncoder.encode("Question deactivated successfully.", "UTF-8"));
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "An error occurred while deactivating the question: " + e.getMessage());
                request.getRequestDispatcher("jsp/error1.jsp").forward(request, response);
            }
        }
    }
}