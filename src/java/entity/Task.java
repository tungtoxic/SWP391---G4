/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.util.Date;
import java.sql.Timestamp;

/**
 *
 * @author Nguyễn Tùng
 */
public class Task {

    private int taskId;
    private int userId;
    private Integer customerId; // Dùng Integer để có thể nhận giá trị NULL
    private String title;
    private Date dueDate;
    private boolean isCompleted;
    private Timestamp createdAt;

    // Thêm các trường JOIN (nếu cần, ví dụ: tên khách hàng)
    private String customerName;

    public Task() {
    }

    public Task(int taskId, int userId, Integer customerId, String title, Date dueDate, boolean isCompleted, Timestamp createdAt, String customerName) {
        this.taskId = taskId;
        this.userId = userId;
        this.customerId = customerId;
        this.title = title;
        this.dueDate = dueDate;
        this.isCompleted = isCompleted;
        this.createdAt = createdAt;
        this.customerName = customerName;
    }

    // Getters and Setters
    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public boolean isCompleted() {
        return isCompleted;
    }

    public void setCompleted(boolean isCompleted) {
        this.isCompleted = isCompleted;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
}
