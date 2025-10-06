SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE audit_logs;
TRUNCATE TABLE reports;
TRUNCATE TABLE report_types;
TRUNCATE TABLE commissions;
TRUNCATE TABLE commission_policies;
TRUNCATE TABLE contracts;
TRUNCATE TABLE contract_status;
TRUNCATE TABLE customers;
TRUNCATE TABLE products;
TRUNCATE TABLE product_categories;
TRUNCATE TABLE manager_agent;
TRUNCATE TABLE users;
TRUNCATE TABLE user_status;
TRUNCATE TABLE role_permission;
TRUNCATE TABLE permissions;
TRUNCATE TABLE roles;

SET FOREIGN_KEY_CHECKS = 1;

SET FOREIGN_KEY_CHECKS = 0;

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

SET FOREIGN_KEY_CHECKS = 1;

create TABLE Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name ENUM('Admin', 'Manager', 'Agent') NOT NULL UNIQUE,
    description VARCHAR(255)
);
CREATE TABLE Permissions (
    permission_id INT AUTO_INCREMENT PRIMARY KEY,
    permission_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);
CREATE TABLE Role_Permissions (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY(role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id),
    FOREIGN KEY (permission_id) REFERENCES Permissions(permission_id)
);
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    role_id INT NOT NULL,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    phone_number VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255),
    created_by INT,
    -- Agent tạo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(user_id)
);
CREATE TABLE Product_Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    base_price DECIMAL(12, 2) NOT NULL,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Product_Categories(category_id)
);
CREATE TABLE Contracts (
    contract_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    agent_id INT NOT NULL,
    product_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status ENUM('Pending', 'Active', 'Expired', 'Cancelled') DEFAULT 'Pending',
    premium_amount DECIMAL(12, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE TABLE Commission_Policies (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_name VARCHAR(100) NOT NULL,
    description TEXT,
    rate DECIMAL(5, 2) NOT NULL,
    -- % hoa hồng
    effective_from DATE NOT NULL,
    effective_to DATE
);
CREATE TABLE Commissions (
    commission_id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT NOT NULL,
    agent_id INT NOT NULL,
    policy_id INT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contract_id) REFERENCES Contracts(contract_id),
    FOREIGN KEY (agent_id) REFERENCES Users(user_id),
    FOREIGN KEY (policy_id) REFERENCES Commission_Policies(policy_id)
);
CREATE TABLE Reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    manager_id INT NOT NULL,
    report_type ENUM('Revenue', 'Performance') NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_summary JSON,
    FOREIGN KEY (manager_id) REFERENCES Users(user_id)
);
-- =========================
-- Roles
-- =========================
INSERT INTO Roles (role_name, description) VALUES
('Admin', 'System administrator with full permissions'),
('Manager', 'Manager overseeing agents'),
('Agent', 'Agent selling products');

-- =========================
-- Permissions
-- =========================
INSERT INTO Permissions (permission_name, description) VALUES
('VIEW_CONTRACT', 'View contract details'),
('CREATE_CONTRACT', 'Create new contracts'),
('APPROVE_CONTRACT', 'Approve pending contracts'),
('VIEW_REPORT', 'View business reports'),
('MANAGE_USERS', 'Manage users and roles');

-- =========================
-- Role_Permissions
-- =========================
INSERT INTO Role_Permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id
FROM Roles r, Permissions p
WHERE 
    (r.role_name = 'Admin') 
    OR (r.role_name = 'Manager' AND p.permission_name IN ('VIEW_CONTRACT','APPROVE_CONTRACT','VIEW_REPORT'))
    OR (r.role_name = 'Agent' AND p.permission_name IN ('VIEW_CONTRACT','CREATE_CONTRACT'));

-- =========================
-- Users
-- =========================
INSERT INTO Users (user_id, username, password_hash, full_name, email, phone_number, role_id, status)
VALUES
(2, 'manager1', '123456', 'Manager One', 'thanh200417@gmail.com', '0901111222', 2, 'Active'),
(3, 'agent1', '654321', 'Agent One', 'thanh2004175@gmail.com', '0912333444', 1, 'Active');


-- =========================
-- Product_Categories
-- =========================
INSERT INTO Product_Categories (category_name, description)
VALUES
('Life Insurance', 'Bảo hiểm nhân thọ'),
('Health Insurance', 'Bảo hiểm sức khỏe'),
('Car Insurance', 'Bảo hiểm ô tô');

-- =========================
-- Products
-- =========================
INSERT INTO Products (product_name, description, base_price, category_id)
VALUES
('Life Protect 2025', 'Gói bảo hiểm nhân thọ cơ bản cho cá nhân', 10000000, 1),
('Health Care Plus', 'Bảo hiểm sức khỏe mở rộng', 5000000, 2),
('Car Safe', 'Bảo hiểm xe ô tô toàn diện', 7000000, 3);

-- =========================
-- Customers (do Agent tạo)
-- =========================
INSERT INTO Customers (full_name, date_of_birth, phone_number, email, address, created_by)
VALUES
('Pham Van Khach', '1990-05-20', '0909123456', 'khach1@example.com', '123 Nguyễn Trãi, Hà Nội', 3),
('Tran Thi Khach', '1985-03-15', '0911222333', 'khach2@example.com', '456 Lê Lợi, TP.HCM', 3);

-- =========================
-- Contracts
-- =========================
INSERT INTO Contracts (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount)
VALUES
(1, 3, 1, '2025-01-01', '2030-01-01', 'Active', 10000000),
(2, 3, 2, '2025-02-01', '2026-02-01', 'Pending', 5000000);

-- =========================
-- Commission_Policies
-- =========================
INSERT INTO Commission_Policies (policy_name, description, rate, effective_from, effective_to)
VALUES
('Standard 10%', 'Hoa hồng cơ bản 10%', 10.00, '2025-01-01', '2030-12-31'),
('Bonus 15%', 'Hoa hồng thưởng 15%', 15.00, '2025-01-01', '2030-12-31');

-- =========================
-- Commissions
-- =========================
INSERT INTO Commissions (contract_id, agent_id, policy_id, amount)
VALUES
(1, 3, 1, 1000000),  -- 10% của 10,000,000
(2, 3, 2, 750000);   -- 15% của 5,000,000

-- =========================
-- Reports
-- =========================
INSERT INTO Reports (manager_id, report_type, period_start, period_end, data_summary)
VALUES
(2, 'Revenue', '2025-09-01', '2025-09-30', JSON_OBJECT('total_contracts', 2, 'total_revenue', 15000000)),
(2, 'Performance', '2025-01-01', '2025-12-31', JSON_OBJECT('active_agents', 1, 'commissions_paid', 1750000));
