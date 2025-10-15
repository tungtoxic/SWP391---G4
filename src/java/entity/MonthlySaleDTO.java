/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author Nguyễn Tùng
 */
public class MonthlySaleDTO {
    private String monthYear;
    private double totalPremium;

    // Constructor
    public MonthlySaleDTO(String monthYear, double totalPremium) {
        this.monthYear = monthYear;
        this.totalPremium = totalPremium;
    }
    
    // Getters
    public String getMonthYear() { return monthYear; }
    public double getTotalPremium() { return totalPremium; }
    
    // Setters
    public void setMonthYear(String monthYear) { this.monthYear = monthYear; }
    public void setTotalPremium(double totalPremium) { this.totalPremium = totalPremium; }
}
