package entity;

public class AgentPerformanceDTO {

    private int agentId;
    private String agentName;
    private double totalPremium;
    private int contractsCount;
    private double targetAmount; // Target "Hiện tại" (Current) (cho Progress Bar)
    private double overAchievementRate; // % Vượt

    // === BƯỚC 2: BỔ SUNG "TRÍ NHỚ" (BASELINE) ===
    private double baselineTarget; // Target "Gốc" (Original) (cho Huy hiệu)
    // =========================================

    // (Các trường "di sản" (legacy) (không dùng))
    private double conversionRate; 
    private double targetProgress;
    private double revenuePercentage;

    public AgentPerformanceDTO() {
    }
    
    // Constructor (Giữ nguyên)
    public AgentPerformanceDTO(int agentId, String agentName, double totalPremium, int contractsCount) {
        this.agentId = agentId;
        this.agentName = agentName;
        this.totalPremium = totalPremium;
        this.contractsCount = contractsCount;
        // (Các trường "di sản" (legacy) giữ nguyên)
        this.conversionRate = 0.0; 
        this.targetProgress = 0.0; 
        this.revenuePercentage = 0.0;
        // (Các trường "mới" (new) (sẽ được "set" (đặt) từ DAO))
        this.targetAmount = 0.0;
        this.overAchievementRate = 0.0;
        this.baselineTarget = 0.0;
    }

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

    public double getTargetAmount() {
        return targetAmount;
    }

    public void setTargetAmount(double targetAmount) {
        this.targetAmount = targetAmount;
    }

    public double getOverAchievementRate() {
        return overAchievementRate;
    }

    public void setOverAchievementRate(double overAchievementRate) {
        this.overAchievementRate = overAchievementRate;
    }

    public double getBaselineTarget() {
        return baselineTarget;
    }

    public void setBaselineTarget(double baselineTarget) {
        this.baselineTarget = baselineTarget;
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