package entity;

import java.sql.Date;
import java.sql.Timestamp;
import java.math.BigDecimal;

public class Contract {
    private int contractId;
    private int customerId;
    private int agentId;
    private int productId;
    private Date startDate;
    private Date endDate;
    private String status;
    private BigDecimal premiumAmount; // Dùng BigDecimal cho tiền tệ là tốt nhất
    private Timestamp createdAt;
    private String productName;

    public Contract() {
    }

    public Contract(int contractId, int customerId, int agentId, int productId, Date startDate, Date endDate, String status, BigDecimal premiumAmount, Timestamp createdAt, String productName) {
        this.contractId = contractId;
        this.customerId = customerId;
        this.agentId = agentId;
        this.productId = productId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.premiumAmount = premiumAmount;
        this.createdAt = createdAt;
        this.productName = productName;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
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

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getPremiumAmount() {
        return premiumAmount;
    }

    public void setPremiumAmount(BigDecimal premiumAmount) {
        this.premiumAmount = premiumAmount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }
   
}