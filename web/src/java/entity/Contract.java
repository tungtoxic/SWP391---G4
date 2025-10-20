package entity;

import java.sql.Date;

public class Contract {
    private int contractId;
    private String customer;
    private String agent;
    private String product;
    private Date startDate;
    private Date endDate;
    private String status;
    private double premiumAmount;

    public Contract(int contractId, String customer, String agent, String product, Date startDate, Date endDate, String status, double premiumAmount) {
        this.contractId = contractId;
        this.customer = customer;
        this.agent = agent;
        this.product = product;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.premiumAmount = premiumAmount;
    }

    // Getter & Setter
    public int getContractId() { return contractId; }
    public String getCustomer() { return customer; }
    public String getAgent() { return agent; }
    public String getProduct() { return product; }
    public Date getStartDate() { return startDate; }
    public Date getEndDate() { return endDate; }
    public String getStatus() { return status; }
    public double getPremiumAmount() { return premiumAmount; }
}
