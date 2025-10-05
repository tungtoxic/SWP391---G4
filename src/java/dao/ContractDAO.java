package dao;

import entity.Contract;
import utility.DBConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContractDAO extends DBConnector {
    public List<Contract> getAllContracts() {
    List<Contract> list = new ArrayList<>();
    String sql = "SELECT c.contract_id, c.customer_name, c.product_name, c.start_date, c.end_date, c.value, c.status, u.username AS manager_name " +
                 "FROM Contracts c JOIN Users u ON c.manager_id = u.user_id";
    try (Connection con = makeConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Contract c = new Contract(
                    rs.getInt("contract_id"),
                    rs.getString("customer_name"),
                    rs.getString("product_name"),
                    rs.getDate("start_date"),
                    rs.getDate("end_date"),
                    rs.getDouble("value"),
                    rs.getString("status"),
                    rs.getInt("manager_id")  // giữ manager_id nếu cần
            );
            c.setManagerName(rs.getString("manager_name"));  // setter mới
            list.add(c);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
}
