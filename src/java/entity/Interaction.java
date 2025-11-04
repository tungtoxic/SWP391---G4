/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.sql.Timestamp;

/**
 *
 * @author Nguyễn Tùng
 */
public class Interaction {

    private int interactionId;
    private int customerId;
    private int agentId;
    private int interactionTypeId; // <-- ĐÃ SỬA: Lưu ID của loại
    private String notes;
    private Timestamp interactionDate;
    private Timestamp createdAt;

    // --- CÁC TRƯỜNG TRANSIENT (KHÔNG CÓ TRONG CSDL) ---
    // Chúng ta sẽ dùng các trường này để lưu kết quả JOIN cho tiện
    private String interactionTypeName;
    private String interactionTypeIcon;
    private String customerName;

    // Constructors
    public Interaction() {
    }

    public Interaction(int interactionId, int customerId, int agentId, int interactionTypeId, String notes, Timestamp interactionDate, Timestamp createdAt, String interactionTypeName, String interactionTypeIcon, String customerName) {
        this.interactionId = interactionId;
        this.customerId = customerId;
        this.agentId = agentId;
        this.interactionTypeId = interactionTypeId;
        this.notes = notes;
        this.interactionDate = interactionDate;
        this.createdAt = createdAt;
        this.interactionTypeName = interactionTypeName;
        this.interactionTypeIcon = interactionTypeIcon;
        this.customerName = customerName;
    }

    // Getters and Setters
    // (Generate tất cả getters/setters cho các trường ở trên)
    public int getInteractionId() {
        return interactionId;
    }

    public void setInteractionId(int interactionId) {
        this.interactionId = interactionId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getAgentId() {
        return agentId;
    }

    public void setAgentId(int agentId) {
        this.agentId = agentId;
    }

    public int getInteractionTypeId() {
        return interactionTypeId;
    }

    public void setInteractionTypeId(int interactionTypeId) {
        this.interactionTypeId = interactionTypeId;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getInteractionDate() {
        return interactionDate;
    }

    public void setInteractionDate(Timestamp interactionDate) {
        this.interactionDate = interactionDate;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Getters/Setters cho các trường TRANSIENT
    public String getInteractionTypeName() {
        return interactionTypeName;
    }

    public void setInteractionTypeName(String interactionTypeName) {
        this.interactionTypeName = interactionTypeName;
    }

    public String getInteractionTypeIcon() {
        return interactionTypeIcon;
    }

    public void setInteractionTypeIcon(String interactionTypeIcon) {
        this.interactionTypeIcon = interactionTypeIcon;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

}
