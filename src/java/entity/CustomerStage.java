/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author Nguyễn Tùng
 */
public class CustomerStage {
    private int stageId;
    private String stageName;
    private int stageOrder;

    public CustomerStage() {
    }

    public CustomerStage(int stageId, String stageName, int stageOrder) {
        this.stageId = stageId;
        this.stageName = stageName;
        this.stageOrder = stageOrder;
    }

    public int getStageId() {
        return stageId;
    }

    public void setStageId(int stageId) {
        this.stageId = stageId;
    }

    public String getStageName() {
        return stageName;
    }

    public void setStageName(String stageName) {
        this.stageName = stageName;
    }

    public int getStageOrder() {
        return stageOrder;
    }

    public void setStageOrder(int stageOrder) {
        this.stageOrder = stageOrder;
    }
    
}
