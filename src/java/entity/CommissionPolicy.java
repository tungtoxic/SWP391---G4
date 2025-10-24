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
    private BigDecimal rate; // Sử dụng BigDecimal cho độ chính xác cao
    private Date effectiveFrom;

    public CommissionPolicy() {
    }

    public CommissionPolicy(int policyId, String policyName, BigDecimal rate, Date effectiveFrom) {
        this.policyId = policyId;
        this.policyName = policyName;
        this.rate = rate;
        this.effectiveFrom = effectiveFrom;
    }

    // Getters and Setters
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

    public Date getEffectiveFrom() {
        return effectiveFrom;
    }

    public void setEffectiveFrom(Date effectiveFrom) {
        this.effectiveFrom = effectiveFrom;
    }
}