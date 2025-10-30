/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.math.BigDecimal;
import java.util.Date;

/**
 *
 * @author Nguyễn Tùng
 */

public class CommissionPolicy {
    private int policyId;
    private String policyName;
    private BigDecimal rate;
    private String rateType;         // "Fixed" hoặc "Tiered"
    private Date effectiveFrom;
    private Date effectiveTo;
    private String status;           // "Active", "Expired", "Draft"

    // Constructors
    public CommissionPolicy() {
    }

    public CommissionPolicy(int policyId, String policyName, BigDecimal rate, String rateType,
                            Date effectiveFrom, Date effectiveTo, String status) {
        this.policyId = policyId;
        this.policyName = policyName;
        this.rate = rate;
        this.rateType = rateType;
        this.effectiveFrom = effectiveFrom;
        this.effectiveTo = effectiveTo;
        this.status = status;
    }

    // Getters & Setters
    public int getPolicyId() {
        return policyId;
    }

    public void setPolicyId(int policyId) {
        this.policyId = policyId;
    }

    public String getPolicyName() {
        return policyName;
    }

    public void setPolicyName(String policyName) {
        this.policyName = policyName;
    }

    public BigDecimal getRate() {
        return rate;
    }

    public void setRate(BigDecimal rate) {
        this.rate = rate;
    }

    public String getRateType() {
        return rateType;
    }

    public void setRateType(String rateType) {
        this.rateType = rateType;
    }

    public Date getEffectiveFrom() {
        return effectiveFrom;
    }

    public void setEffectiveFrom(Date effectiveFrom) {
        this.effectiveFrom = effectiveFrom;
    }

    public Date getEffectiveTo() {
        return effectiveTo;
    }

    public void setEffectiveTo(Date effectiveTo) {
        this.effectiveTo = effectiveTo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Optional: toString() để dễ debug/log
    @Override
    public String toString() {
        return "CommissionPolicy{" +
                "policyId=" + policyId +
                ", policyName='" + policyName + '\'' +
                ", rate=" + rate +
                ", rateType='" + rateType + '\'' +
                ", effectiveFrom=" + effectiveFrom +
                ", effectiveTo=" + effectiveTo +
                ", status='" + status + '\'' +
                '}';
    }
}