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

-- 1. Roles
create TABLE Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name ENUM('Admin', 'Manager', 'Agent') NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- 2. Permissionsrole_permissionsrole_permissions
CREATE TABLE Permissions (
    permission_id INT AUTO_INCREMENT PRIMARY KEY,
    permission_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

-- 3. Role_Permissions
CREATE TABLE Role_Permissions (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY(role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id),
    FOREIGN KEY (permission_id) REFERENCES Permissions(permission_id)
);

-- 4. Users
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    role_id INT NOT NULL,
    status ENUM('Active','Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

-- 5. Customers (khách hàng không có login)
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    phone_number VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255),
    created_by INT,  -- Agent tạo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(user_id)
);

-- 6. Product Categories
CREATE TABLE Product_Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- 7. Products
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    base_price DECIMAL(12,2) NOT NULL,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Product_Categories(category_id)
);

-- 8. Contracts
CREATE TABLE Contracts (
    contract_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    agent_id INT NOT NULL,
    product_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status ENUM('Pending','Active','Expired','Cancelled') DEFAULT 'Pending',
    premium_amount DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 9. Commission Policies
CREATE TABLE Commission_Policies (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_name VARCHAR(100) NOT NULL,
    description TEXT,
    rate DECIMAL(5,2) NOT NULL, -- % hoa hồng
    effective_from DATE NOT NULL,
    effective_to DATE
);

-- 10. Commissions
CREATE TABLE Commissions (
    commission_id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT NOT NULL,
    agent_id INT NOT NULL,
    policy_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contract_id) REFERENCES Contracts(contract_id),
    FOREIGN KEY (agent_id) REFERENCES Users(user_id),
    FOREIGN KEY (policy_id) REFERENCES Commission_Policies(policy_id)
);

-- 11. Reports
CREATE TABLE Reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    manager_id INT NOT NULL,
    report_type ENUM('Revenue','Performance') NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_summary JSON,
    FOREIGN KEY (manager_id) REFERENCES Users(user_id)
);

SET FOREIGN_KEY_CHECKS=1;
-- =========================
-- Roles
-- =========================
INSERT INTO Roles (name) VALUES 
('Admin'),
('Manager'),
('Agent');

-- =========================
-- Permissions (ví dụ)
-- =========================
INSERT INTO Permissions (name) VALUES
('VIEW_CONTRACT'),
('CREATE_CONTRACT'),
('APPROVE_CONTRACT'),
('VIEW_REPORT'),
('MANAGE_USERS');

-- =========================
-- User_Status
-- =========================
INSERT INTO User_Status (code, description) VALUES
('ACTIVE', 'Active user'),
('INACTIVE', 'Inactive user');

-- =========================
-- Users
-- =========================
INSERT INTO Users (username, password_hash, full_name, email, phone_number, role_id, status)
VALUES
('admin1', '123456', 'Admin One', 'admin1@example.com', '0901234567', 1, 'Active'),
('agent1', '654321', 'Agent One', 'agent1@example.com', '0912345678', 3, 'Active');



-- =========================
-- Manager_Agent (manager quản lý agent)
-- =========================
INSERT INTO Manager_Agent (manager_id, agent_id) VALUES 
(2, 3);

-- =========================
-- Customers
-- =========================
INSERT INTO Customers (name, phone, email, address, created_by)
VALUES 
('Pham Van Khach', '0909123456', 'khach1@example.com', '123 Nguyễn Trãi, Hà Nội', 3),
('Tran Thi Khach', '0911222333', 'khach2@example.com', '456 Lê Lợi, HCM', 3);

-- =========================
-- Product_Categories
-- =========================
INSERT INTO Product_Categories (name) VALUES
('Life Insurance'),
('Health Insurance'),
('Car Insurance');

-- =========================
-- Products
-- =========================
INSERT INTO Products (name, description, category_id, price)
VALUES
('Life Protect 2025', 'Gói bảo hiểm nhân thọ cơ bản', 1, 10000000),
('Health Care Plus', 'Bảo hiểm sức khỏe mở rộng', 2, 5000000),
('Car Safe', 'Bảo hiểm xe ô tô toàn diện', 3, 7000000);

-- =========================
-- Contract_Status
-- =========================
INSERT INTO Contract_Status (code, description) VALUES
('PENDING', 'Waiting for approval'),
('ACTIVE', 'Contract is active'),
('EXPIRED', 'Contract has expired');

-- =========================
-- Contracts
-- =========================
INSERT INTO Contracts (customer_id, product_id, agent_id, start_date, end_date, status_code, total_value)
VALUES
(1, 1, 3, '2025-01-01', '2030-01-01', 'ACTIVE', 10000000),
(2, 2, 3, '2025-02-01', '2026-02-01', 'PENDING', 5000000);

-- =========================
-- Commission_Policies
-- =========================
INSERT INTO Commission_Policies (name, description, rate)
VALUES
('Standard 10%', 'Hoa hồng cơ bản 10%', 10.00),
('Bonus 15%', 'Hoa hồng thưởng 15%', 15.00);

-- =========================
-- Commissions
-- =========================
INSERT INTO Commissions (contract_id, agent_id, policy_id, amount)
VALUES
(1, 3, 1, 1000000), -- 10% của 10,000,000
(2, 3, 2, 750000);  -- 15% của 5,000,000

-- =========================
-- Report_Types
-- =========================
INSERT INTO Report_Types (code, description)
VALUES
('MONTHLY', 'Báo cáo tháng'),
('YEARLY', 'Báo cáo năm');

-- =========================
-- Reports
-- =========================
INSERT INTO Reports (manager_id, report_type_code, period_start, period_end)
VALUES
(2, 'MONTHLY', '2025-09-01', '2025-09-30'),
(2, 'YEARLY', '2025-01-01', '2025-12-31');

-- =========================
-- Audit_Logs
-- =========================
INSERT INTO Audit_Logs (user_id, action, table_name, record_id, old_value, new_value)
VALUES
(1, 'INSERT', 'Customers', 1, NULL, 'New customer created'),
(3, 'INSERT', 'Contracts', 1, NULL, 'New contract created');

select * from users
SELECT username, email, password_hash FROM Users;
SET FOREIGN_KEY_CHECKS = 0;

-- Xoá toàn bộ dữ liệu user
TRUNCATE TABLE Users;

-- Bật lại kiểm tra khoá ngoại
SET FOREIGN_KEY_CHECKS = 1;