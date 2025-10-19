/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utility;

/**
 *
 * @author Helios 16
 */
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import org.json.JSONObject;

public class VerifyRecaptcha {

    // 🔑 Secret key từ Google reCAPTCHA
    private static final String SECRET_KEY = "6Lf4T90rAAAAALNCgGs2CI6T2IxBEuKHxESyCPtH";
    private static final String SITE_VERIFY_URL = "https://www.google.com/recaptcha/api/siteverify";

    public static boolean verify(String gRecaptchaResponse) {
        if (gRecaptchaResponse == null || gRecaptchaResponse.length() == 0) {
            return false;
        }

        try {
            URL obj = new URL(SITE_VERIFY_URL);
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();

            // POST request
            con.setRequestMethod("POST");
            con.setDoOutput(true);

            String postParams = "secret=" + SECRET_KEY + "&response=" + gRecaptchaResponse;

            try (OutputStream out = con.getOutputStream()) {
                out.write(postParams.getBytes(StandardCharsets.UTF_8));
            }

            // Đọc response
            StringBuilder response = new StringBuilder();
            try (InputStream in = con.getInputStream()) {
                byte[] buffer = new byte[1024];
                int len;
                while ((len = in.read(buffer)) != -1) {
                    response.append(new String(buffer, 0, len, StandardCharsets.UTF_8));
                }
            }

            // Parse JSON
            JSONObject json = new JSONObject(response.toString());
            return json.getBoolean("success");

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
