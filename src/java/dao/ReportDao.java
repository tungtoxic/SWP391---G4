package dao;

import java.sql.*;
import java.util.*;
import entity.ReportSummary;
import utility.DBConnector;

public class ReportDao {

    public ReportSummary getOverallPerformance() {
    ReportSummary summary = new ReportSummary(); // luôn khởi tạo
    try (Connection conn = DBConnector.makeConnection()) {
        if (conn == null) {
            System.out.println("⚠️ Connection is null");
            return summary; // trả về object rỗng, không null
        }

        // ---- Ví dụ query tổng hợp ----
        String sqlContracts = "SELECT COUNT(*) AS totalContracts, " +
                      "SUM(premium_amount) AS totalRevenue, " +
                      "SUM(CASE WHEN status='Active' THEN 1 ELSE 0 END) AS activeContracts " +
                      "FROM Contracts";

        PreparedStatement ps = conn.prepareStatement(sqlContracts);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            summary.setTotalContracts(rs.getInt("totalContracts"));
            summary.setTotalRevenue(rs.getDouble("totalRevenue"));
            summary.setActiveContracts(rs.getInt("activeContracts"));
        }

        // ---- Lấy tổng khách hàng ----
        String sqlCustomers = "SELECT COUNT(*) AS totalCustomers FROM Customers";
        PreparedStatement ps2 = conn.prepareStatement(sqlCustomers);
        ResultSet rs2 = ps2.executeQuery();
        if (rs2.next()) {
            summary.setTotalCustomers(rs2.getInt("totalCustomers"));
        }

        return summary; // trả về dù giá trị 0
    } catch (SQLException e) {
        e.printStackTrace();
        return summary; // KHÔNG return null
    }
}

}
