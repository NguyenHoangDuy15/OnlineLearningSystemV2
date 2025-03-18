package Model;

/**
 *
 * @author DELL
 */
import java.util.*;
import java.lang.*;

public class VerifyCode {
    private String code;

    public VerifyCode() {
    }

    public VerifyCode(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Override
    public String toString() {
        return "VerifyCode{" + "code=" + code + '}';
    }
    
}
