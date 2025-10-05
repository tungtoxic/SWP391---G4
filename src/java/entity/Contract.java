package entity;

import java.sql.Date;

public class Contract {
    private final int contractId;
    private final String customerName;
    private final String productName;
    private final Date startDate;
    private final Date endDate;
    private final double value;
    private final String status;
    private final int managerId;
    private String managerName;  // thêm

    public Contract(int contractId, String customerName, String productName,
                    Date startDate, Date endDate, double value, String status, int managerId) {
        this.contractId = contractId;
        this.customerName = customerName;
        this.productName = productName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.value = value;
        this.status = status;
        this.managerId = managerId;
    }

    // getter & setter
    public int getContractId() { return contractId; }
    public String getCustomerName() { return customerName; }
    public String getProductName() { return productName; }
    public Date getStartDate() { return startDate; }
    public Date getEndDate() { return endDate; }
    public double getValue() { return value; }
    public String getStatus() { return status; }
    public int getManagerId() { return managerId; }

    public String getManagerName() { return managerName; }
    public void setManagerName(String managerName) { this.managerName = managerName; }
}
