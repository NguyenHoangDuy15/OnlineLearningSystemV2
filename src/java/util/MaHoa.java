package util;

import java.util.*;
import java.lang.*;
import java.security.MessageDigest;

public class MaHoa {
    public static String toSHA1(String str){
        String salt = "fweqfwe;hfiudsfasdfasdfas";
        String result = null;
        str += salt;
        try {
            byte[] dataBytes = str.getBytes("UTF-8");
            MessageDigest md = MessageDigest.getInstance("SHA-1");
            result = Base64.getEncoder().encodeToString(dataBytes);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public static void main(String[] args) {
        MaHoa mh = new MaHoa();
        System.out.println(mh.toSHA1("123"));
    }
}
