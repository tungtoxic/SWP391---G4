package dao;

import entity.Contract;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utility.DBConnector;

public class ContractDao {

    private Connection conn;

    public ContractDao() {
        this.conn = DBConnector.makeConnection();
    }

    // 🟢 Lấy toàn bộ hợp đồng (JOIN để hiển thị đầy đủ)
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

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Contract c = new Contract();
                c.setContractId(rs.getInt("contract_id"));
                c.setCustomerId(rs.getInt("customer_id"));
                c.setAgentId(rs.getInt("agent_id"));
                c.setProductId(rs.getInt("product_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setBeneficiaries(rs.getString("beneficiaries"));
                c.setStatus(rs.getString("status"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setPremiumAmount(rs.getBigDecimal("premium_amount"));
                c.setAgentName(rs.getString("agent_name"));     // 👈 thêm dòng này
                c.setCustomerName(rs.getString("customer_name"));// 👈 thêm dòng này
                c.setProductName(rs.getString("product_name"));  // 👈 thêm dòng này

                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void renewContract(int contractId, int renewYears) throws SQLException {
        String sql = "UPDATE contracts SET end_date = DATE_ADD(end_date, INTERVAL ? YEAR) WHERE contract_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, renewYears);
            ps.setInt(2, contractId);
            ps.executeUpdate();
        }
    }

    public void updateStatus(int contractId, String newStatus) throws SQLException {
        String sql = "UPDATE Contracts SET status = ? WHERE contract_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, contractId);
            ps.executeUpdate();
        }
    }

    // 🟢 Thêm hợp đồng mới
    public boolean insertContract(Contract c) {
        String sql = """
            INSERT INTO Contracts (customer_id, agent_id, product_id, start_date, end_date, beneficiaries, status, premium_amount)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, c.getCustomerId());
            ps.setInt(2, c.getAgentId());
            ps.setInt(3, c.getProductId());
            ps.setDate(4, c.getStartDate());
            ps.setDate(5, c.getEndDate());
            ps.setString(6, c.getBeneficiaries());
            ps.setString(7, c.getStatus());
            ps.setBigDecimal(8, c.getPremiumAmount());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🟢 Xóa hợp đồng
    public boolean deleteContract(int id) {
        String sql = "DELETE FROM Contracts WHERE contract_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
