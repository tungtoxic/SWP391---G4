package dao;

import entity.Contract;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utility.DBConnector;

public class ContractDao {
    public List<Contract> getAllContracts() {
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
        """;

        try (Connection con = DBConnector.makeConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
}
