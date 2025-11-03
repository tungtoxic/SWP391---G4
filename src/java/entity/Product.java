/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 *
 * @author Nguyễn Tùng
 */
public class Product {
    
    private int productId;
    private String productName;
    private String description; // Cột này có trong CSDL của bạn
    private int categoryId;     // Giữ lại vì nó có trong CSDL
    private BigDecimal basePrice; // Dùng BigDecimal cho kiểu DECIMAL
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public Product() {
    }

    // Getters and Setters
    // (Bạn tự generate getters/setters cho tất cả các trường nhé)
    // ...
    
    // Ví dụ:
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public BigDecimal getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(BigDecimal basePrice) {
        this.basePrice = basePrice;
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
}