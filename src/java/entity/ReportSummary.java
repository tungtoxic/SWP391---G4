package entity;

public class ReportSummary {
    private int totalContracts, activeContracts, pendingContracts, expiredContracts;
    private int totalCustomers;
    private double totalRevenue, paidCommission, pendingCommission;

    public int getTotalContracts() {
        return totalContracts;
    }

    public void setTotalContracts(int totalContracts) {
        this.totalContracts = totalContracts;
    }

    public int getActiveContracts() {
        return activeContracts;
    }

    public void setActiveContracts(int activeContracts) {
        this.activeContracts = activeContracts;
    }

    public int getPendingContracts() {
        return pendingContracts;
    }

    public void setPendingContracts(int pendingContracts) {
        this.pendingContracts = pendingContracts;
    }

    public int getExpiredContracts() {
        return expiredContracts;
    }

    public void setExpiredContracts(int expiredContracts) {
        this.expiredContracts = expiredContracts;
    }

    public int getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public double getPaidCommission() {
        return paidCommission;
    }

    public void setPaidCommission(double paidCommission) {
        this.paidCommission = paidCommission;
    }

    public double getPendingCommission() {
        return pendingCommission;
    }

    public void setPendingCommission(double pendingCommission) {
        this.pendingCommission = pendingCommission;
    }

    
}
