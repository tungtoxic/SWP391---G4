/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author Helios 16
 */
import java.util.Date;

public class User {

    private int userId;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phoneNumber;
    private int roleId;
    private String status;
    private Date createdAt;
    private Date updatedAt;
<<<<<<< HEAD
       private String roleName;
=======
    private String roleName;
    private boolean isFirstLogin = true;
>>>>>>> thanhhe180566

    public User() {
    }

    public User(int userId, String username, String password, String fullName, String email,
            String phoneNumber, int roleId, String status, Date createdAt, Date updatedAt, String roleName) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.roleId = roleId;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.roleName = roleName;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPasswordHash(String password) {
        this.password = password;
<<<<<<< HEAD
=======
    }

    public String getPassword() {
        return password;
>>>>>>> thanhhe180566
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getUserId() {
        return userId;
    }

    public String getUsername() {
        return username;
    }

    public String getPasswordHash() {
        return password;
    }

    public String getFullName() {
        return fullName;
    }

    public String getEmail() {
        return email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public int getRoleId() {
        return roleId;
    }

    public String getStatus() {
        return status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public boolean getIsFirstLogin() {
        return isFirstLogin;
    }

    public void setIsFirstLogin(boolean isFirstLogin) {
        this.isFirstLogin = isFirstLogin;
    }

    // getters + setters...
    @Override
    public String toString() {
        return "User{id=" + userId + ", username='" + username + "', fullName='" + fullName + "'}";
    }
}
