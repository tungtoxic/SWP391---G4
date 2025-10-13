package dao;

import entity.Contract;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utility.DBConnector;

public class ContractDao {

    // Lấy tất cả hợp đồng
    public List<Contract> getAllContracts() {
        List<Contract> list = new ArrayList<>();
        String sql = """
            SELECT c.contract_id,
                   MAX(cu.full_name) AS customer,
                   MAX(u.username) AS agent,
                   MAX(p.product_name) AS product,
                   MAX(c.start_date) AS start_date,
                   MAX(c.end_date) AS end_date,
                   MAX(c.status) AS status,
                   MAX(c.premium_amount) AS premium_amount
            FROM Contracts c
            JOIN Customers cu ON c.customer_id = cu.customer_id
            JOIN Users u ON c.agent_id = u.user_id
            JOIN Products p ON c.product_id = p.product_id
            GROUP BY c.contract_id
        """;

        try (Connection con = DBConnector.makeConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Contract c = new Contract(
                        rs.getInt("contract_id"),
                        rs.getString("customer"),
                        rs.getString("agent"),
                        rs.getString("product"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date"),
                        rs.getString("status"),
                        rs.getDouble("premium_amount")
                );
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy hợp đồng theo filter
    public List<Contract> getContractsFiltered(String agent, String status, String keyword) {
        List<Contract> list = new ArrayList<>();

        String sql = """
            SELECT c.contract_id,
                   cu.full_name AS customer,
                   u.username AS agent,
                   p.product_name AS product,
                   c.start_date,
                   c.end_date,
                   c.status,
                   c.premium_amount
            FROM Contracts c
            JOIN Customers cu ON c.customer_id = cu.customer_id
            JOIN Users u ON c.agent_id = u.user_id
            JOIN Products p ON c.product_id = p.product_id
            WHERE (LOWER(cu.full_name) LIKE ? OR LOWER(u.username) LIKE ? OR LOWER(p.product_name) LIKE ?)
              AND (? = '' OR c.status = ?)
              AND (? = '' OR u.username = ?)
        """;

        try (Connection con = DBConnector.makeConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            String kw = "%" + (keyword == null ? "" : keyword.toLowerCase()) + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setString(4, status == null ? "" : status);
            ps.setString(5, status == null ? "" : status);
            ps.setString(6, agent == null ? "" : agent);
            ps.setString(7, agent == null ? "" : agent);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Contract c = new Contract(
                            rs.getInt("contract_id"),
                            rs.getString("customer"),
                            rs.getString("agent"),
                            rs.getString("product"),
                            rs.getDate("start_date"),
                            rs.getDate("end_date"),
                            rs.getString("status"),
                            rs.getDouble("premium_amount")
                    );
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng hợp đồng
    public int countContracts() {
        String sql = "SELECT COUNT(*) FROM Contracts";
        try (Connection con = DBConnector.makeConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tính tổng premium
    public double sumPremium() {
        String sql = "SELECT SUM(premium_amount) FROM Contracts";
        try (Connection con = DBConnector.makeConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}
