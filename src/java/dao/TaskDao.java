package dao;

import entity.Task;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException; // <<< ĐÃ THÊM
import java.sql.Types;         // <<< ĐÃ THÊM
import java.util.ArrayList;
import java.util.List;
import utility.DBConnector;

public class TaskDao {

   
    /**
     * Lấy danh sách các Ghi chú cá nhân (To-do) của một user.
     * Lấy TẤT CẢ, sắp xếp theo: chưa hoàn thành lên trước.
     */
    public List<Task> getPersonalTasks(int userId) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM Tasks " +
                     "WHERE user_id = ? AND customer_id IS NULL " +
                     "ORDER BY is_completed ASC, created_at ASC"; // Sắp xếp theo (0)Chưa hoàn thành, (1)Đã hoàn thành

        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tasks.add(mapRowToTask(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tasks;
    }
    
    /**
     * Thêm một task mới vào CSDL.
     */
    public boolean insertTask(Task task) {
        String sql = "INSERT INTO Tasks (user_id, customer_id, title, due_date, is_completed) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, task.getUserId());
            
            if (task.getCustomerId() != null) {
                ps.setInt(2, task.getCustomerId());
            } else {
                // SỬA LỖI Ở ĐÂY: java.sql.Types.INTEGER
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            
            ps.setString(3, task.getTitle());
            
            if (task.getDueDate() != null) {
                // Chuyển đổi java.util.Date sang java.sql.Date
                ps.setDate(4, new java.sql.Date(task.getDueDate().getTime()));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }
            
            ps.setBoolean(5, task.isCompleted());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật trạng thái hoàn thành (checked/unchecked) của một task.
     */
    public boolean updateTaskStatus(int taskId, int userId, boolean isCompleted) {
        String sql = "UPDATE Tasks SET is_completed = ? WHERE task_id = ? AND user_id = ?";
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, isCompleted);
            ps.setInt(2, taskId);
            ps.setInt(3, userId); 
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa một task.
     */
    public boolean deleteTask(int taskId, int userId) {
        String sql = "DELETE FROM Tasks WHERE task_id = ? AND user_id = ?";
        try (Connection conn = DBConnector.makeConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, taskId);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Phương thức trợ giúp để map dữ liệu từ ResultSet sang đối tượng Task
    private Task mapRowToTask(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setTaskId(rs.getInt("task_id"));
        task.setUserId(rs.getInt("user_id"));
        task.setCustomerId(rs.getObject("customer_id", Integer.class)); 
        task.setTitle(rs.getString("title"));
        task.setDueDate(rs.getDate("due_date"));
        task.setCompleted(rs.getBoolean("is_completed"));
        task.setCreatedAt(rs.getTimestamp("created_at"));
        return task;
    }
}