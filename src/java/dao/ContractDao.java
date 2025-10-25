package dao;

import entity.Contract;
import entity.ContractDTO;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utility.DBConnector;
import entity.ContractDTO; // Đảm bảo đã import
import java.util.Map; // Đảm bảo đã import
import java.util.LinkedHashMap; // Đảm bảo đã import


public class ContractDao {

    /**
     * Lấy danh sách hợp đồng chi tiết (đã JOIN) của một Agent cụ thể.
     * @param agentId ID của Agent cần lấy hợp đồng.
     * @return Danh sách các đối tượng ContractDTO.
     */
    public List<ContractDTO> getContractsByAgentId(int agentId) {
        List<ContractDTO> list = new ArrayList<>();
        String sql = "SELECT c.*, cust.full_name as customer_name, u.full_name as agent_name, p.product_name " +
                     "FROM Contracts c " +
                     "JOIN Customers cust ON c.customer_id = cust.customer_id " +
                     "JOIN Users u ON c.agent_id = u.user_id " +
                     "JOIN Products p ON c.product_id = p.product_id " +
                     "WHERE c.agent_id = ? ORDER BY c.start_date DESC";

        try (Connection con = DBConnector.makeConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, agentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ContractDTO dto = new ContractDTO();
                    dto.setContractId(rs.getInt("contract_id"));
                    dto.setCustomerId(rs.getInt("customer_id"));
                    dto.setAgentId(rs.getInt("agent_id"));
                    dto.setProductId(rs.getInt("product_id"));
                    dto.setStartDate(rs.getDate("start_date"));
                    dto.setEndDate(rs.getDate("end_date"));
                    dto.setStatus(rs.getString("status"));
                    dto.setPremiumAmount(rs.getBigDecimal("premium_amount"));
                    dto.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    // Lấy các tên đã JOIN
                    dto.setCustomerName(rs.getString("customer_name"));
                    dto.setAgentName(rs.getString("agent_name"));
                    dto.setProductName(rs.getString("product_name"));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Thêm một hợp đồng mới vào cơ sở dữ liệu.
     * @param contract Đối tượng Contract chứa thông tin cần thêm.
     * @return true nếu thêm thành công, false nếu thất bại.
     */
    public boolean insertContract(Contract contract) {
        String sql = "INSERT INTO Contracts (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnector.makeConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, contract.getCustomerId());
            ps.setInt(2, contract.getAgentId());
            ps.setInt(3, contract.getProductId());
            ps.setDate(4, contract.getStartDate());
            
            // Xử lý end_date có thể null
            if (contract.getEndDate() != null) {
                ps.setDate(5, contract.getEndDate());
            } else {
                ps.setNull(5, Types.DATE);
            }
            
            ps.setString(6, contract.getStatus());
            ps.setBigDecimal(7, contract.getPremiumAmount());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
  /**
 * Lấy tất cả hợp đồng có trạng thái "Pending" của các agent
 * do một manager cụ thể quản lý.
 * @param managerId ID của Manager.
 * @return Danh sách các hợp đồng đang chờ duyệt.
 */
public List<ContractDTO> getPendingContractsByManagerId(int managerId) {
    List<ContractDTO> list = new ArrayList<>();
    String sql = "SELECT c.*, cust.full_name as customer_name, u.full_name as agent_name, p.product_name " +
                 "FROM Contracts c " +
                 "JOIN Users u ON c.agent_id = u.user_id " +
                 "JOIN Manager_Agent ma ON u.user_id = ma.agent_id " +
                 "JOIN Customers cust ON c.customer_id = cust.customer_id " +
                 "JOIN Products p ON c.product_id = p.product_id " +
                 "WHERE ma.manager_id = ? AND c.status = 'Pending' " +
                 "ORDER BY c.created_at ASC";

    try (Connection con = DBConnector.makeConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, managerId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ContractDTO dto = new ContractDTO();
                dto.setContractId(rs.getInt("contract_id"));
                dto.setCustomerId(rs.getInt("customer_id"));
                dto.setAgentId(rs.getInt("agent_id"));
                dto.setProductId(rs.getInt("product_id"));
                dto.setStartDate(rs.getDate("start_date"));
                dto.setEndDate(rs.getDate("end_date"));
                dto.setStatus(rs.getString("status"));
                dto.setPremiumAmount(rs.getBigDecimal("premium_amount"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                
                // Lấy các tên đã JOIN
                dto.setCustomerName(rs.getString("customer_name"));
                dto.setAgentName(rs.getString("agent_name"));
                dto.setProductName(rs.getString("product_name"));
                
                list.add(dto);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

    /**
     * Cập nhật trạng thái của một hợp đồng.
     */
    public boolean updateContractStatus(int contractId, String newStatus) {
        String sql = "UPDATE Contracts SET status = ? WHERE contract_id = ?";
        try (Connection con = DBConnector.makeConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, contractId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    // CÁC PHƯƠNG THỨC KHÁC ĐỂ HOÀN THIỆN CRUD (SẼ DÙNG SAU)
/**
     * LẤY MỘT HỢP ĐỒNG CHI TIẾT THEO ID
     * @param contractId ID của hợp đồng cần tìm.
     * @return một đối tượng ContractDTO nếu tìm thấy, null nếu không.
     */
    public ContractDTO getContractById(int contractId) {
        String sql = "SELECT c.*, cust.full_name as customer_name, u.full_name as agent_name, p.product_name " +
                     "FROM Contracts c " +
                     "JOIN Customers cust ON c.customer_id = cust.customer_id " +
                     "JOIN Users u ON c.agent_id = u.user_id " +
                     "JOIN Products p ON c.product_id = p.product_id " +
                     "WHERE c.contract_id = ?";
        
        try (Connection con = DBConnector.makeConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, contractId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ContractDTO dto = new ContractDTO();
                    dto.setContractId(rs.getInt("contract_id"));
                    dto.setCustomerId(rs.getInt("customer_id"));
                    dto.setAgentId(rs.getInt("agent_id"));
                    dto.setProductId(rs.getInt("product_id"));
                    dto.setStartDate(rs.getDate("start_date"));
                    dto.setEndDate(rs.getDate("end_date"));
                    dto.setStatus(rs.getString("status"));
                    dto.setPremiumAmount(rs.getBigDecimal("premium_amount"));
                    dto.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    dto.setCustomerName(rs.getString("customer_name"));
                    dto.setAgentName(rs.getString("agent_name"));
                    dto.setProductName(rs.getString("product_name"));
                    return dto;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
 /**
     * Cập nhật thông tin một hợp đồng.
     * @param contract Đối tượng Contract chứa thông tin mới.
     * @return true nếu cập nhật thành công, false nếu thất bại.
     */
    public boolean updateContract(Contract contract) {
        String sql = "UPDATE Contracts SET customer_id = ?, agent_id = ?, product_id = ?, " +
                     "start_date = ?, end_date = ?, status = ?, premium_amount = ? " +
                     "WHERE contract_id = ?";
        try (Connection con = DBConnector.makeConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, contract.getCustomerId());
            ps.setInt(2, contract.getAgentId());
            ps.setInt(3, contract.getProductId());
            ps.setDate(4, contract.getStartDate());

            if (contract.getEndDate() != null) {
                ps.setDate(5, contract.getEndDate());
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, contract.getStatus());
            ps.setBigDecimal(7, contract.getPremiumAmount());
            ps.setInt(8, contract.getContractId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa một hợp đồng theo ID.
     * @param contractId ID của hợp đồng cần xóa.
     * @return true nếu xóa thành công, false nếu thất bại.
     */
    public boolean deleteContract(int contractId) {
        String sql = "DELETE FROM Contracts WHERE contract_id = ?";
        try (Connection con = DBConnector.makeConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, contractId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            // Lỗi có thể xảy ra nếu hợp đồng này đang được tham chiếu bởi bảng Commissions
            // (Lỗi ràng buộc khóa ngoại - Foreign Key Constraint)
            e.printStackTrace();
        }
        return false;
    }
    // Thêm 2 phương thức này vào file dao/ContractDao.java


/**
 * Lấy các hợp đồng Active sắp hết hạn trong vòng 90 ngày tới.
 */
public List<ContractDTO> getExpiringContracts(int agentId) {
    List<ContractDTO> list = new ArrayList<>();
    // Lấy các hợp đồng hết hạn trong 90 ngày tới VÀ vẫn đang Active
    String sql = "SELECT c.*, cust.full_name as customer_name, p.product_name " +
                 "FROM Contracts c " +
                 "JOIN Customers cust ON c.customer_id = cust.customer_id " +
                 "JOIN Products p ON c.product_id = p.product_id " +
                 "WHERE c.agent_id = ? AND c.status = 'Active' " +
                 "AND c.end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 90 DAY) " +
                 "ORDER BY c.end_date ASC"; // Ưu tiên cái hết hạn sớm nhất

    try (Connection conn = DBConnector.makeConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, agentId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ContractDTO dto = new ContractDTO();
                dto.setContractId(rs.getInt("contract_id"));
                dto.setCustomerName(rs.getString("customer_name"));
                dto.setProductName(rs.getString("product_name"));
                dto.setEndDate(rs.getDate("end_date"));
                list.add(dto);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

/**
 * Lấy dữ liệu doanh thu 6 tháng gần nhất cho biểu đồ.
 * Trả về một Map<String, Double> với Key là "YYYY-MM" (ví dụ: "2025-10")
 * và Value là tổng doanh thu của tháng đó.
 */
public Map<String, Double> getMonthlySalesData(int agentId) {
    // Dùng LinkedHashMap để giữ đúng thứ tự các tháng
    Map<String, Double> salesData = new LinkedHashMap<>();
    String sql = "SELECT DATE_FORMAT(start_date, '%Y-%m') as month, SUM(premium_amount) as monthly_total " +
                 "FROM Contracts " +
                 "WHERE agent_id = ? AND status = 'Active' " +
                 "AND start_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
                 "GROUP BY month " +
                 "ORDER BY month ASC";

    try (Connection conn = DBConnector.makeConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, agentId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                salesData.put(rs.getString("month"), rs.getDouble("monthly_total"));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return salesData;
}
}