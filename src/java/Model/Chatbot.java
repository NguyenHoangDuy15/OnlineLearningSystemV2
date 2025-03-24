/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.time.LocalDateTime;

/**
 *
 * @author Administrator
 */
public class Chatbot {

    int chatID;
    int userID;
    String messageContent;
    LocalDateTime timestamp;
    String chatType;
    Integer receiverID;

    public Chatbot() {
    }

    public Chatbot(int chatID, int userID, String messageContent, LocalDateTime timestamp, String chatType, Integer receiverID) {
        this.chatID = chatID;
        this.userID = userID;
        this.messageContent = messageContent;
        this.timestamp = timestamp;
        this.chatType = chatType;
        this.receiverID = receiverID;
    }

    public Chatbot(int userID, String messageContent) {
        this.userID = userID;
        this.messageContent = messageContent;
    }

    public Chatbot(int userID, String messageContent, String chatType, Integer receiverID) {
        this.userID = userID;
        this.messageContent = messageContent;
        this.chatType = chatType;
        this.receiverID = receiverID;
    }

    public int getChatID() {
        return chatID;
    }

    public void setChatID(int chatID) {
        this.chatID = chatID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getMessageContent() {
        return messageContent;
    }

    public void setMessageContent(String messageContent) {
        this.messageContent = messageContent;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public String getChatType() {
        return chatType;
    }

    public void setChatType(String chatType) {
        this.chatType = chatType;
    }

    public Integer getReceiverID() {
        return receiverID;
    }

    public void setReceiverID(Integer receiverID) {
        this.receiverID = receiverID;
    }

    @Override
    public String toString() {
        return "Chatbot{" + "chatID=" + chatID + ", userID=" + userID + ", messageContent=" + messageContent + ", timestamp=" + timestamp + ", chatType=" + chatType + ", receiverID=" + receiverID + '}';
    }

}
