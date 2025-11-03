/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author Nguyễn Tùng
 */
public class InteractionType {
    private int typeId;
    private String typeName;
    private String iconClass;

    // Constructors
    public InteractionType() {
    }

    public InteractionType(int typeId, String typeName, String iconClass) {
        this.typeId = typeId;
        this.typeName = typeName;
        this.iconClass = iconClass;
    }

    // Getters and Setters
    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getIconClass() {
        return iconClass;
    }

    public void setIconClass(String iconClass) {
        this.iconClass = iconClass;
    }
}