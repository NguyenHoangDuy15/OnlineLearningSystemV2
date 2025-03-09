package util;

import java.util.*;
import java.lang.*;
import java.util.regex.Pattern;

/*
Regex Rules:
Username:

Chỉ chứa chữ cái (a-z, A-Z), số (0-9), dấu gạch dưới (_)
Độ dài từ 5 đến 20 ký tự
Không bắt đầu bằng số
📌 Regex: ^(?![0-9])[a-zA-Z0-9_]{5,20}$

Email:

Định dạng chuẩn (name@example.com)
Chỉ chứa chữ cái, số, dấu chấm (.), dấu gạch dưới (_), dấu gạch ngang (-)
Đuôi phải có ít nhất 2 chữ cái (.com, .vn, .org, ...)
📌 Regex: ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$

Password:

Ít nhất 8 ký tự
Có ít nhất 1 chữ cái viết hoa (A-Z)
Có ít nhất 1 chữ thường (a-z)
Có ít nhất 1 số (0-9)
Có ít nhất 1 ký tự đặc biệt (@, #, $, !, %, ^, &, *)
📌 Regex: ^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$!%^&*])[A-Za-z\d@#$!%^&*]{8,}$
*/

public class Validator {
// Username regex
    private static final String USERNAME_REGEX = "^(?![0-9])[a-zA-Z0-9_]{5,20}$";
    
    // Email regex
    private static final String EMAIL_REGEX = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
    
    // Password regex
    private static final String PASSWORD_REGEX = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@#$!%^&*])[A-Za-z\\d@#$!%^&*]{8,}$";

    public static boolean isValidUsername(String username) {
        return Pattern.matches(USERNAME_REGEX, username);
    }

    public static boolean isValidEmail(String email) {
        return Pattern.matches(EMAIL_REGEX, email);
    }

    public static boolean isValidPassword(String password) {
        return Pattern.matches(PASSWORD_REGEX, password);
    }
}
