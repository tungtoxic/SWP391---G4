package dao;

import java.sql.*;
import java.util.*;
import entity.ReportSummary;
import utility.DBConnector;

public class ReportDao {

    public ReportSummary getOverallPerformance() {
    ReportSummary summary = new ReportSummary();
    try (Connection conn = DBConnector.makeConnection()) {
        if (conn == null) {
            System.out.println("⚠️ Connection is null");
            return summary;
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

        String sqlCustomers = "SELECT COUNT(*) AS totalCustomers FROM Customers";
        PreparedStatement ps2 = conn.prepareStatement(sqlCustomers);
        ResultSet rs2 = ps2.executeQuery();
        if (rs2.next()) {
            summary.setTotalCustomers(rs2.getInt("totalCustomers"));
        }

        return summary; 
    } catch (SQLException e) {
        e.printStackTrace();
        return summary; 
    }
}

}
