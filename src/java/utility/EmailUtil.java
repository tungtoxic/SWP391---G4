/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utility;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

    private static final String FROM = "thanh200417@gmail.com";
    private static final String PASSWORD = "rsjc suuk gepx hkfo"; // App password của Gmail

    public static void sendEmail(String to, String subject, String content) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM, PASSWORD);
            }
        };

        Session session = Session.getInstance(props, auth);

        try {
            MimeMessage msg = new MimeMessage(session);
            msg.addHeader("Content-type", "text/html; charset=UTF-8");
            msg.setFrom(new InternetAddress(FROM));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject(subject, "UTF-8");

            // Nội dung (có thể HTML hoặc text)
            msg.setContent(content, "text/html; charset=UTF-8");

            Transport.send(msg);
            System.out.println("Send successfully");

        } catch (Exception e) {
            System.out.println("Send error");
            e.printStackTrace();
        }
    }

    public static void sendTempPassword(String toEmail, String username, String tempPassword) {
        String subject = "Your Agent Account Details";
        String content = "<p>Hello " + username + ",</p>"
                + "<p>Your account has been created by Manager.</p>"
                + "<p>Username: " + username + "</p>"
                + "<p>Temporary Password: " + tempPassword + "</p>"
                + "<p>Please login and change your password immediately.</p>"
                + "<p>Regards,<br>Admin Team</p>";

        // Gọi hàm sendEmail có sẵn
        sendEmail(toEmail, subject, content);
    }
}
