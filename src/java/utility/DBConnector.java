/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utility;

/**
 *
 * @author Helios 16
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnector {
    private static final String URL = "jdbc:mysql://localhost:3306/swp391"; 
    private static final String USER = "root";   // thay bằng user MySQL của bạn
    private static final String PASSWORD = "1234";   // thay bằng password MySQL của bạn
    public static Connection makeConnection() {
        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Tạo connection
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public static void main(String[] args) {
        // Cố gắng tạo một kết nối
        Connection conn = makeConnection();

        // Kiểm tra xem kết nối có được thiết lập thành công không
        if (conn != null) {
            System.out.println("Kết nối đến cơ sở dữ liệu thành công!");
            try {
                // Đóng kết nối sau khi kiểm tra xong là một thói quen tốt
                conn.close();
                System.out.println("Đã đóng kết nối.");
            } catch (SQLException e) {
                System.out.println("Lỗi khi đóng kết nối.");
                e.printStackTrace();
            }
        } else {
            System.out.println("Kết nối đến cơ sở dữ liệu thất bại!");
        }
    }
}
