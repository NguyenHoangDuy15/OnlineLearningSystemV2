package Model;

public class Requests {
    /*
    RequestID INT PRIMARY KEY IDENTITY(1,1),
    RequestedRole INT FOREIGN KEY REFERENCES Roles(RoleID),
    UserID INT FOREIGN KEY REFERENCES Users(UserID)*/
    private int RequestID;
    private int RequestedRole;
    private int UserID;

    public Requests() {
    }

    public Requests(int RequestID, int RequestedRole, int UserID) {
        this.RequestID = RequestID;
        this.RequestedRole = RequestedRole;
        this.UserID = UserID;
    }

    public int getRequestID() {
        return RequestID;
    }

    public void setRequestID(int RequestID) {
        this.RequestID = RequestID;
    }

    public int getRequestedRole() {
        return RequestedRole;
    }

    public void setRequestedRole(int RequestedRole) {
        this.RequestedRole = RequestedRole;
    }

    public int getUserID() {
        return UserID;
    }

    public void setUserID(int UserID) {
        this.UserID = UserID;
    }

    @Override
    public String toString() {
        return "Requests{" + "RequestID=" + RequestID + ", RequestedRole=" + RequestedRole + ", UserID=" + UserID + '}';
    }
    
    
}
