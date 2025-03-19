package util;

/**
 *
 * @author DELL
 */
import Model.Transaction;
import Model.VerifyCode;
import java.util.*;
import java.lang.*;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class SendEmail {

    private static final String fromEmail = "hoangduytech16@gmail.com";
    private static final String password = "evok pazv cgmq crix";

    public String getRandom() {
        Random rnd = new Random();
        int number = rnd.nextInt(999999);
        return String.format("%06d", number);
    }

    public boolean sendEmail(VerifyCode verifycode, String mail) {

        String toEmail = mail;

        try {
            Properties pr = new Properties();
            pr.put("mail.smtp.host", "smtp.gmail.com");
            pr.put("mail.smtp.port", "587");
            pr.put("mail.smtp.auth", "true");
            pr.put("mail.smtp.starttls.enable", "true");
            //pr.put("mail.smtp.socketFactory.port", "587");
            //pr.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

            //get Session
            Session session = Session.getDefaultInstance(pr, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(fromEmail, password);
                }
            });

            Message mess = new MimeMessage(session);

            mess.setFrom(new InternetAddress(fromEmail));
            mess.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));

            mess.setSubject("User Email Verification");
            mess.setText("Registered successfully.Please verify your account using this code: " + verifycode.getCode());

            // Transport
            Transport.send(mess);
            return true;
        } catch (Exception e) {
             e.printStackTrace();
            return false;
        }

    }
}
