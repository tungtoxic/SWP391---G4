SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS 
    audit_logs, 
    reports, 
    report_types, 
    commissions, 
    commission_policies,
    contracts, 
    contract_status, 
    customers, 
    products, 
    product_categories,
    manager_agent, 
    users, 
    user_status, 
    role_permission, 
    permissions, 
    roles;

-- Roles
CREATE TABLE Roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Permissions
CREATE TABLE Permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Role_Permission
CREATE TABLE Role_Permission (
    role_id INT,
    permission_id INT,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES Roles(id),
    FOREIGN KEY (permission_id) REFERENCES Permissions(id)
);

-- User_Status
CREATE TABLE User_Status (
    code VARCHAR(20) PRIMARY KEY,
    description VARCHAR(100)
);

-- Users
CREATE TABLE Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    role_id INT,
    status_code VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(id),
    FOREIGN KEY (status_code) REFERENCES User_Status(code)
);

-- Manager_Agent
CREATE TABLE Manager_Agent (
    manager_id INT,
    agent_id INT,
    PRIMARY KEY (manager_id, agent_id),
    FOREIGN KEY (manager_id) REFERENCES Users(id),
    FOREIGN KEY (agent_id) REFERENCES Users(id)
);

-- Customers
CREATE TABLE Customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255),
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(id)
);

-- Product_Categories
CREATE TABLE Product_Categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

-- Products
CREATE TABLE Products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    category_id INT,
    price DECIMAL(12,2),
    FOREIGN KEY (category_id) REFERENCES Product_Categories(id)
);

-- Contract_Status
CREATE TABLE Contract_Status (
    code VARCHAR(20) PRIMARY KEY,
    description VARCHAR(100)
);

-- Contracts
CREATE TABLE Contracts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    agent_id INT,
    start_date DATE,
    end_date DATE,
    status_code VARCHAR(20),
    total_value DECIMAL(12,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(id),
    FOREIGN KEY (product_id) REFERENCES Products(id),
    FOREIGN KEY (agent_id) REFERENCES Users(id),
    FOREIGN KEY (status_code) REFERENCES Contract_Status(code)
);

-- Commission_Policies
CREATE TABLE Commission_Policies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    rate DECIMAL(5,2)
);

-- Commissions
CREATE TABLE Commissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT,
    agent_id INT,
    policy_id INT,
    amount DECIMAL(12,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contract_id) REFERENCES Contracts(id),
    FOREIGN KEY (agent_id) REFERENCES Users(id),
    FOREIGN KEY (policy_id) REFERENCES Commission_Policies(id)
);

-- Report_Types
CREATE TABLE Report_Types (
    code VARCHAR(20) PRIMARY KEY,
    description VARCHAR(100)
);

-- Reports
CREATE TABLE Reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    manager_id INT,
    report_type_code VARCHAR(20),
    period_start DATE,
    period_end DATE,
    generated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (manager_id) REFERENCES Users(id),
    FOREIGN KEY (report_type_code) REFERENCES Report_Types(code)
);

-- Audit_Logs
CREATE TABLE Audit_Logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100),
    table_name VARCHAR(50),
    record_id INT,
    old_value TEXT,
    new_value TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

SET FOREIGN_KEY_CHECKS=1;
