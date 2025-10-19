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

public class CommissionReportDTO {
    private int contractId;
    private String customerName;
    private String policyName;
    private double premiumAmount;
    private double commissionAmount;
    private String status; // Thêm cột status
    private Timestamp commissionDate;

    // Constructor đã cập nhật
    public CommissionReportDTO(int contractId, String customerName, String policyName, double premiumAmount, double commissionAmount, String status, Timestamp commissionDate) {
        this.contractId = contractId;
        this.customerName = customerName;
        this.policyName = policyName;
        this.premiumAmount = premiumAmount;
        this.commissionAmount = commissionAmount;
        this.status = status;
        this.commissionDate = commissionDate;
    }

    // Getters and Setters
    public int getContractId() { return contractId; }
    public void setContractId(int agentId) { this.contractId = agentId; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getPolicyName() { return policyName; }
    public void setPolicyName(String policyName) { this.policyName = policyName; }
    public double getPremiumAmount() { return premiumAmount; }
    public void setPremiumAmount(double premiumAmount) { this.premiumAmount = premiumAmount; }
    public double getCommissionAmount() { return commissionAmount; }
    public void setCommissionAmount(double commissionAmount) { this.commissionAmount = commissionAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getCommissionDate() { return commissionDate; }
    public void setCommissionDate(Timestamp commissionDate) { this.commissionDate = commissionDate; }
}