package Model;

/**
 *
 * @author DELL
 */
import java.util.*;
import java.lang.*;

public class CatergoryPrint {
    private int CatID;
    private String CatName;

    public CatergoryPrint() {
    }

    public CatergoryPrint(int CatID, String CatName) {
        this.CatID = CatID;
        this.CatName = CatName;
    }

    public int getCatID() {
        return CatID;
    }

    public void setCatID(int CatID) {
        this.CatID = CatID;
    }

    public String getCatName() {
        return CatName;
    }

    public void setCatName(String CatName) {
        this.CatName = CatName;
    }

    @Override
    public String toString() {
        return "CatergoryPrint{" + "CatID=" + CatID + ", CatName=" + CatName + '}';
    }
    
}
