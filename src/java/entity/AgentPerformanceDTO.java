package entity;

public class AgentPerformanceDTO {
    private int agentId;
    private String agentName;
    private double totalPremium;
    private int contractsCount;
    private double conversionRate; 
    private double targetProgress;
    private double revenuePercentage;
    
    
    // Constructor đơn giản để mapping từ DB
    public AgentPerformanceDTO(int agentId, String agentName, double totalPremium, int contractsCount) {
        this.agentId = agentId;
        this.agentName = agentName;
        this.totalPremium = totalPremium;
        this.contractsCount = contractsCount;
        this.conversionRate = 0.0; // Sẽ tính sau
        this.targetProgress = 0.0; // Sẽ tính sau
        this.revenuePercentage = 0.0;
    }

    // Constructor đầy đủ
    public AgentPerformanceDTO(int agentId, String agentName, double totalPremium, int contractsCount, double conversionRate, double targetProgress) {
        this.agentId = agentId;
        this.agentName = agentName;
        this.totalPremium = totalPremium;
        this.contractsCount = contractsCount;
        this.conversionRate = conversionRate;
        this.targetProgress = targetProgress;
    }

    // ===== Getters và Setters =====
    public int getAgentId() {
        return agentId;
    }

    public void setAgentId(int agentId) {
        this.agentId = agentId;
    }

    public String getAgentName() {
        return agentName;
    }

    public void setAgentName(String agentName) {
        this.agentName = agentName;
    }

    public double getTotalPremium() {
        return totalPremium;
    }

    public void setTotalPremium(double totalPremium) {
        this.totalPremium = totalPremium;
    }

    public int getContractsCount() {
        return contractsCount;
    }

    public void setContractsCount(int contractsCount) {
        this.contractsCount = contractsCount;
    }

    public double getConversionRate() {
        return conversionRate;
    }

    public void setConversionRate(double conversionRate) {
        this.conversionRate = conversionRate;
    }

    public double getTargetProgress() {
        return targetProgress;
    }

    public void setTargetProgress(double targetProgress) {
        this.targetProgress = targetProgress;
    }

    public double getRevenuePercentage() {
        return revenuePercentage;
    }

    public void setRevenuePercentage(double revenuePercentage) {
        this.revenuePercentage = revenuePercentage;
    }
}