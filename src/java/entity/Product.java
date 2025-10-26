package entity;

import java.sql.Timestamp;

public class Product {
    private int productId;
    private String productName;
    private double basePrice;
    private int categoryId;
    private Timestamp createdAt;
    private Timestamp updateAt;
    public Product() {}

    public Product(int productId, String productName, double basePrice, int categoryId, Timestamp createdAt, Timestamp updateAt) {
        this.productId = productId;
        this.productName = productName;
        this.basePrice = basePrice;
        this.categoryId = categoryId;
        this.createdAt = createdAt;
        this.updateAt = updateAt;
    }

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

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdateAt() {
        return updateAt;
    }

    public void setUpdateAt(Timestamp updateAt) {
        this.updateAt = updateAt;
    }

}
