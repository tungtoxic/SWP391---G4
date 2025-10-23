package dao;

import java.sql.*;
import java.util.*;
import entity.ReportSummary;
import utility.DBConnector;

public class ReportDao {

    public ReportSummary getOverallPerformance() throws SQLException {
        ReportSummary report = new ReportSummary();
        try (Connection conn = DBConnector.makeConnection()) {

            // 1. Tổng hợp hợp đồng
            String sqlContracts = "SELECT COUNT(*) total_contracts, SUM(premium_amount) total_revenue,"
                                + " SUM(CASE WHEN status='Active' THEN 1 ELSE 0 END) active_contracts,"
                                + " SUM(CASE WHEN status='Pending' THEN 1 ELSE 0 END) pending_contracts,"
                                + " SUM(CASE WHEN status='Expired' THEN 1 ELSE 0 END) expired_contracts"
                                + " FROM Contracts";
            try (PreparedStatement ps = conn.prepareStatement(sqlContracts);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    report.setTotalContracts(rs.getInt("total_contracts"));
                    report.setTotalRevenue(rs.getDouble("total_revenue"));
                    report.setActiveContracts(rs.getInt("active_contracts"));
                    report.setPendingContracts(rs.getInt("pending_contracts"));
                    report.setExpiredContracts(rs.getInt("expired_contracts"));
                }
            }

            // 2. Tổng khách hàng
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total_customers FROM Customers");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) report.setTotalCustomers(rs.getInt("total_customers"));
            }

            // 3. Hoa hồng
            String sqlCommissions = "SELECT "
                    + "SUM(CASE WHEN status='Paid' THEN amount ELSE 0 END) AS paid,"
                    + "SUM(CASE WHEN status='Pending' THEN amount ELSE 0 END) AS pending "
                    + "FROM Commissions";
            try (PreparedStatement ps = conn.prepareStatement(sqlCommissions);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    report.setPaidCommission(rs.getDouble("paid"));
                    report.setPendingCommission(rs.getDouble("pending"));
                }
            }
        }
        return report;
    }
}
