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

public class DBConnector {
    private static final String URL = "jdbc:mysql://localhost:3306/swp391"; 
    private static final String USER = "root";   // thay bằng user MySQL của bạn
    private static final String PASSWORD = "123456";   // thay bằng password MySQL của bạn

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
}
