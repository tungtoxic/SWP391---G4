/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 *
 * @author Nguyễn Tùng
 */

public class CommissionReportDTO {
private int contractId;
    private String customerName;
    private String policyName; // SỬA: Dùng "product_name" thay vì "policyName" cho logic
    private BigDecimal premiumAmount; // <-- SỬA
    private BigDecimal commissionAmount; // <-- SỬA
    private String status;
    private Timestamp commissionDate;

    public CommissionReportDTO() {
    }

    public CommissionReportDTO(int contractId, String customerName, String policyName, BigDecimal premiumAmount, BigDecimal commissionAmount, String status, Timestamp commissionDate) {
        this.contractId = contractId;
        this.customerName = customerName;
        this.policyName = policyName;
        this.premiumAmount = premiumAmount;
        this.commissionAmount = commissionAmount;
        this.status = status;
        this.commissionDate = commissionDate;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPolicyName() {
        return policyName;
    }

    public void setPolicyName(String policyName) {
        this.policyName = policyName;
    }

    public BigDecimal getPremiumAmount() {
        return premiumAmount;
    }

    public void setPremiumAmount(BigDecimal premiumAmount) {
        this.premiumAmount = premiumAmount;
    }

    public BigDecimal getCommissionAmount() {
        return commissionAmount;
    }

    public void setCommissionAmount(BigDecimal commissionAmount) {
        this.commissionAmount = commissionAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCommissionDate() {
        return commissionDate;
    }

    public void setCommissionDate(Timestamp commissionDate) {
        this.commissionDate = commissionDate;
    }
    
}
   