package utility;

import java.security.MessageDigest;

public class PasswordUtils {

    public static String hashPassword(String password) {
    try {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] digest = md.digest(password.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : digest) {
            sb.append(String.format("%02x", b & 0xff)); // chuẩn MySQL
        }
        return sb.toString().toLowerCase();
    } catch (Exception e) {
        throw new RuntimeException(e);
    }
}

    // So sánh mật khẩu người dùng nhập với hash trong DB
    public static boolean verifyPassword(String plainPassword, String storedHash) {
        String hashedInput = hashPassword(plainPassword);
        return hashedInput.equals(storedHash);
    }
}
