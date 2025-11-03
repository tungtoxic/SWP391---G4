package entity;

// DTO này kế thừa từ Contract và thêm các trường tên đã được JOIN
public class ContractDTO extends Contract {
    private String customerName;
    private String agentName;
    private String productName;

    // Getters and Setters cho 3 trường mới
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getAgentName() { return agentName; }
    public void setAgentName(String agentName) { this.agentName = agentName; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
}