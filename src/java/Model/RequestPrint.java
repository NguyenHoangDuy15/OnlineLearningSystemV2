package Model;

import java.util.*;
import java.lang.*;

public class RequestPrint {
    private int RequestID;
    private int UserID;
    private String UserName;
    private int RequestedRole;

    public RequestPrint() {
    }

    public RequestPrint(int RequestID, int UserID, String UserName, int RequestedRole) {
        this.RequestID = RequestID;
        this.UserID = UserID;
        this.UserName = UserName;
        this.RequestedRole = RequestedRole;
    }

    public int getRequestID() {
        return RequestID;
    }

    public void setRequestID(int RequestID) {
        this.RequestID = RequestID;
    }

    public int getUserID() {
        return UserID;
    }

    public void setUserID(int UserID) {
        this.UserID = UserID;
    }

    public String getUserName() {
        return UserName;
    }

    public void setUserName(String UserName) {
        this.UserName = UserName;
    }

    public int getRequestedRole() {
        return RequestedRole;
    }

    public void setRequestedRole(int RequestedRole) {
        this.RequestedRole = RequestedRole;
    }

    @Override
    public String toString() {
        return "RequestPrint{" + "RequestID=" + RequestID + ", UserID=" + UserID + ", UserName=" + UserName + ", RequestedRole=" + RequestedRole + '}';
    }

}
