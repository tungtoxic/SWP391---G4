/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.sql.Timestamp;

public class InsuranceProductDetails {

    private int productId;
    private int categoryId;
    private String productType;

    // Chung
    private Double coverageAmount;
    private Integer durationYears;

    // Life
    private String beneficiaries;
    private String maturityBenefit;
    private Double maturityAmount;
       
    // Health
    private Double hospitalizationLimit;
    private Double surgeryLimit;
    private Double maternityLimit;
    private Integer waitingPeriod;
    private Integer minAge;
    private Integer maxAge;

    // Car
    private String vehicleType;
    private Double vehicleValue;
    private String coverageType;

    private Timestamp createdAt;
    private Timestamp updatedAt;

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public Double getCoverageAmount() {
        return coverageAmount;
    }

    public void setCoverageAmount(Double coverageAmount) {
        this.coverageAmount = coverageAmount;
    }

    public Integer getDurationYears() {
        return durationYears;
    }

    public void setDurationYears(Integer durationYears) {
        this.durationYears = durationYears;
    }

    public String getBeneficiaries() {
        return beneficiaries;
    }

    public void setBeneficiaries(String beneficiaries) {
        this.beneficiaries = beneficiaries;
    }

    public String getMaturityBenefit() {
        return maturityBenefit;
    }

    public void setMaturityBenefit(String maturityBenefit) {
        this.maturityBenefit = maturityBenefit;
    }

    public Double getHospitalizationLimit() {
        return hospitalizationLimit;
    }

    public void setHospitalizationLimit(Double hospitalizationLimit) {
        this.hospitalizationLimit = hospitalizationLimit;
    }

    public Double getSurgeryLimit() {
        return surgeryLimit;
    }

    public void setSurgeryLimit(Double surgeryLimit) {
        this.surgeryLimit = surgeryLimit;
    }

    public Integer getWaitingPeriod() {
        return waitingPeriod;
    }

    public void setWaitingPeriod(Integer waitingPeriod) {
        this.waitingPeriod = waitingPeriod;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public Double getVehicleValue() {
        return vehicleValue;
    }

    public void setVehicleValue(Double vehicleValue) {
        this.vehicleValue = vehicleValue;
    }

    public String getCoverageType() {
        return coverageType;
    }

    public void setCoverageType(String coverageType) {
        this.coverageType = coverageType;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public void setMaturityAmount(Double maturityAmount) {
        this.maturityAmount = maturityAmount;
    }

    public Double getMaturityAmount() {
        return maturityAmount;
    }

    public void setMaternityLimit(Double maternityLimit) {
        this.maternityLimit = maternityLimit;
    }

    public Double getMaternityLimit() {
        return maternityLimit;
    }
    
    public Integer getMinAge() {
        return minAge;
    }

    public Integer getMaxAge() {
        return maxAge;
    }

    public void setMinAge(Integer minAge) {
        this.minAge = minAge;
    }

    public void setMaxAge(Integer maxAge) {
        this.maxAge = maxAge;
    }
}
