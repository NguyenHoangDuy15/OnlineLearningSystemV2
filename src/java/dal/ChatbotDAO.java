/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Model.Chatbot;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class ChatbotDAO extends DBContext {

    public boolean saveMessage(Chatbot message) throws SQLException {
        String sql = "INSERT INTO ChatHistory (UserID, MessageContent, ChatType) VALUES (?, ?, 'User-AI')";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, message.getUserID());
            stmt.setString(2, message.getMessageContent());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public List<Chatbot> getChatHistory(int userID) throws SQLException {
        List<Chatbot> messages = new ArrayList<>();
        String sql = "SELECT ChatID, MessageContent FROM ChatHistory WHERE UserID = ? AND ChatType = 'User-AI' ORDER BY Timestamp ASC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    int chatID = rs.getInt("ChatID");
                    String messageContent = rs.getString("MessageContent");
                    Chatbot message = new Chatbot(userID, messageContent);
                    message.setChatID(chatID); // Giả sử Chatbot có setter cho chatID
                    messages.add(message);
                }
            }
        }
        return messages;
    }
}
