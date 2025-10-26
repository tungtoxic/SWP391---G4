/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.sql.Timestamp;

public class ContractHistory {
    private int historyId;
    private int contractId;
    private String changeType;
    private String oldValue;
    private String newValue;
    private Timestamp changeDate;
    private String note;

    public ContractHistory() {}

    public ContractHistory(int historyId, int contractId, String changeType, String oldValue, String newValue, Timestamp changeDate, String note) {
        this.historyId = historyId;
        this.contractId = contractId;
        this.changeType = changeType;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.changeDate = changeDate;
        this.note = note;
    }

    // Getters & Setters
    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public String getChangeType() {
        return changeType;
    }

    public void setChangeType(String changeType) {
        this.changeType = changeType;
    }

    public String getOldValue() {
        return oldValue;
    }

    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }

    public String getNewValue() {
        return newValue;
    }

    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }

    public Timestamp getChangeDate() {
        return changeDate;
    }

    public void setChangeDate(Timestamp changeDate) {
        this.changeDate = changeDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    @Override
    public String toString() {
        return "ContractHistory{" +
                "historyId=" + historyId +
                ", contractId=" + contractId +
                ", changeType='" + changeType + '\'' +
                ", oldValue='" + oldValue + '\'' +
                ", newValue='" + newValue + '\'' +
                ", changeDate=" + changeDate +
                ", note='" + note + '\'' +
                '}';
    }
}

