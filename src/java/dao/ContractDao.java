package dao;

import entity.Contract;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContractDao {

    public List<Contract> getAllContracts() {
        List<Contract> list = new ArrayList<>();
        String sql = """
        SELECT c.*, 
               u.full_name AS agent_name, 
               cu.full_name AS customer_name,
               p.product_name
        FROM Contracts c
        JOIN Users u ON c.agent_id = u.user_id
        JOIN Customers cu ON c.customer_id = cu.customer_id
        JOIN Products p ON c.product_id = p.product_id
    """;

        try (Connection conn = DBConnector.makeConnection();PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Contract c = new Contract();
                c.setContractId(rs.getInt("contract_id"));
                c.setCustomerId(rs.getInt("customer_id"));
                c.setAgentId(rs.getInt("agent_id"));
                c.setProductId(rs.getInt("product_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setStatus(rs.getString("status"));
                c.setEffectiveDate(rs.getDate("effective_date"));
                c.setPremiumAmount(rs.getBigDecimal("premium_amount"));
                c.setAgentName(rs.getString("agent_name"));     
                c.setCustomerName(rs.getString("customer_name"));
                c.setProductName(rs.getString("product_name")); 

                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void renewContract(int contractId, int renewYears) throws SQLException {
        String sql = "UPDATE contracts SET end_date = DATE_ADD(end_date, INTERVAL ? YEAR) WHERE contract_id = ?";
        try (Connection conn = DBConnector.makeConnection();PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, renewYears);
            ps.setInt(2, contractId);
            ps.executeUpdate();
        }
    }

    public void updateStatus(int contractId, String newStatus) throws SQLException {
        String sql = "UPDATE Contracts SET status = ? WHERE contract_id = ?";
        try (Connection conn = DBConnector.makeConnection();PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, contractId);
            ps.executeUpdate();
        }
    }

    public boolean insertContract(Contract c) {
        String sql = """
            INSERT INTO Contracts (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (Connection conn = DBConnector.makeConnection();PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, c.getCustomerId());
            ps.setInt(2, c.getAgentId());
            ps.setInt(3, c.getProductId());
            ps.setDate(4, c.getStartDate());
            ps.setDate(5, c.getEndDate());
            ps.setString(6, c.getStatus());
            ps.setBigDecimal(7, c.getPremiumAmount());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteContract(int id) {
        String sql = "DELETE FROM Contracts WHERE contract_id = ?";
        try (Connection conn = DBConnector.makeConnection();PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
