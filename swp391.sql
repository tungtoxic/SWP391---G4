-- ROLES
CREATE TABLE Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name ENUM('Admin', 'Manager', 'Agent') NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- USERS
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    password_hash VARCHAR(255),
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    role_id INT,
    status ENUM('Active', 'Inactive','Pending'),
    is_first_login BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

-- MANAGER-AGENT
CREATE TABLE Manager_Agent (
    manager_id INT NOT NULL,
    agent_id INT NOT NULL,
    PRIMARY KEY(manager_id, agent_id),
    FOREIGN KEY (manager_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- CUSTOMERS
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    date_of_birth DATE,
    phone_number VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255),
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- PRODUCT_CATEGORIES
CREATE TABLE Product_Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- PRODUCTS
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    base_price DECIMAL(12, 2),
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Product_Categories(category_id)
);

-- CONTRACTS
CREATE TABLE Contracts (
    contract_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    agent_id INT NOT NULL,
    product_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    effective_date DATE,
    status ENUM('Pending', 'Active', 'Expired', 'Cancelled','Suspended') DEFAULT 'Pending',
    premium_amount DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Contract_Detail (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT NOT NULL,

    term_years INT,
    payment_frequency ENUM('Monthly', 'Quarterly', 'Yearly') DEFAULT 'Monthly',
    next_payment_date DATE,
    coverage_amount DECIMAL(15,2),

    insurance_terms TEXT,       -- Điều khoản bảo hiểm
    benefits TEXT,              -- Quyền lợi bảo hiểm 
    beneficiaries TEXT,     
    cancellation_reason VARCHAR(255),

    FOREIGN KEY (contract_id) REFERENCES Contracts(contract_id) ON DELETE CASCADE
);

-- CONTRACT HISTORY
CREATE TABLE Contract_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT NOT NULL,
    change_type ENUM('Created', 'Updated', 'StatusChanged', 'Payment', 'Violation') NOT NULL,
    old_value TEXT,
    new_value TEXT,
    changed_by VARCHAR(100), 
    FOREIGN KEY (contract_id) REFERENCES Contracts(contract_id) ON DELETE CASCADE
);
-- COMMISSION POLICIES
CREATE TABLE Commission_Policies (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_name VARCHAR(100) NOT NULL,
    rate DECIMAL(5, 2) NOT NULL,
    effective_from DATE NOT NULL
);

-- COMMISSIONS
CREATE TABLE Commissions (
    commission_id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT NOT NULL,
    agent_id INT NOT NULL,
    policy_id INT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    status ENUM('Pending', 'Paid', 'Cancelled') NOT NULL DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (contract_id) REFERENCES Contracts(contract_id) ON DELETE CASCADE,
    FOREIGN KEY (agent_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (policy_id) REFERENCES Commission_Policies(policy_id)
);

-- INSURANCE PRODUCT DETAILS
CREATE TABLE Insurance_Product_Details (
    product_id INT PRIMARY KEY,
    category_id INT NOT NULL,
    product_type ENUM('life', 'health', 'car') NOT NULL,
    coverage_amount DECIMAL(12,2),
    duration_years INT,
    beneficiaries TEXT,
    maturity_benefit TEXT,
    maturity_amount DECIMAL(15,2),
    hospitalization_limit DECIMAL(12,2),
    surgery_limit DECIMAL(12,2),
    maternity_limit DECIMAL(12,2),
    min_age INT DEFAULT 0,
    max_age INT DEFAULT 100,
    waiting_period INT,
    vehicle_type VARCHAR(100),
    vehicle_value DECIMAL(12,2),
    coverage_type VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Product_Categories(category_id)
);

-- TASKS
CREATE TABLE Tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    customer_id INT NULL,
    title VARCHAR(255) NOT NULL,
    due_date DATE,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);


-- Chèn Roles
INSERT INTO Roles (role_id, role_name, description) VALUES
(1, 'Agent', 'Nhân viên tư vấn / đại lý bán hàng'),
(2, 'Manager', 'Quản lý giám sát đại lý'),
(3, 'Admin', 'Quản trị hệ thống');

-- Chèn Users (Admin, Manager, 2 Agents)
INSERT INTO Users (user_id, username, password_hash, full_name, email, phone_number, role_id,status) VALUES
(1, 'agent1', '123', 'Agent One (Tùng)', 'agent1@example.com', '0901111111', 1, 'Inactive'),
(2, 'manager1', '123', 'Manager One', 'manager1@example.com', '0902222222', 2, 'Inactive'),
(3, 'admin1', '123', 'Admin One', 'admin1@example.com', '0903333333', 3, 'Inactive'),
(4, 'agent2', '123', 'Agent Two', 'agent2@example.com', '0904444444', 1, 'Inactive');

-- Chèn quan hệ Manager_Agent
INSERT INTO Manager_Agent (manager_id, agent_id) VALUES
(2, 1), -- Manager 1 quản lý Agent 1
(2, 4); -- Manager 1 quản lý Agent 2

-- Chèn Product_Categories
INSERT INTO Product_Categories (category_name) VALUES
('Bảo hiểm nhân thọ'),
('Bảo hiểm sức khỏe'),
('Bảo hiểm xe');
-- Chèn Products
INSERT INTO Products (product_name, category_id) VALUES
('Gói nhân thọ An Tâm', 1),
('Sức khỏe Vàng', 2);

-- Chèn Commission_Policies
INSERT INTO Commission_Policies (policy_name, rate, effective_from) VALUES
('Hoa hồng chuẩn 2025', 5.00, '2025-01-01');

-- Chèn dữ liệu test cho Agent 1
INSERT INTO Customers (full_name, created_by) VALUES
('Khách hàng Test A', 1);

INSERT INTO Contracts (customer_id, agent_id, product_id, start_date, end_date, effective_date,status, premium_amount) VALUES
(1, 1, 1, '2025-10-01', '2035-10-01', '2025-11-01','Active', 10000000);
INSERT INTO Contracts (customer_id, agent_id, product_id, start_date, end_date, effective_date,status, premium_amount) VALUES
(1, 1, 1, '2025-10-01', '2035-10-01', '2025-11-01','Pending', 10000000);
INSERT INTO Contracts (customer_id, agent_id, product_id, start_date, end_date, effective_date,status, premium_amount) VALUES
(1, 1, 1, '2025-10-01', '2035-10-01', '2025-11-01','Expired', 10000000);
INSERT INTO Contracts (customer_id, agent_id, product_id, start_date, end_date, effective_date,status, premium_amount) VALUES
(1, 1, 1, '2025-10-01', '2035-10-01', '2025-11-01','Cancelled', 10000000);
INSERT INTO Commissions (contract_id, agent_id, policy_id, amount, status) VALUES
(LAST_INSERT_ID(), 1, 1, 500000, 'Pending');


INSERT INTO Commissions (contract_id, agent_id, policy_id, amount, status) VALUES (LAST_INSERT_ID(), 1, 1, 600000, 'Pending');
-- 1. TẠO MỘT LỊCH HẸN "FOLLOW-UP" CHO HÔM NAY
-- (Giả sử agent1 (user_id=1) hẹn gặp khách hàng customer_id=1)
INSERT INTO Tasks (user_id, customer_id, title, due_date, is_completed)
VALUES (1, 1, 'Gọi điện xác nhận gói Sức khỏe Vàng', CURDATE(), false);

-- 2. TẠO MỘT GHI CHÚ "TO-DO" CÁ NHÂN
INSERT INTO Tasks (user_id, customer_id, title, is_completed)
VALUES (1, NULL, 'Gửi báo cáo tuần cho manager', false);
INSERT INTO Tasks (user_id, customer_id, title, is_completed)
VALUES (1, NULL, 'Hen voi anh a', false);

-- 3. TẠO MỘT HỢP ĐỒNG SẮP HẾT HẠN (để kiểm tra Renewal Alerts)
-- (Giả sử hợp đồng contract_id=1 sẽ hết hạn sau 30 ngày nữa)
UPDATE Contracts
SET end_date = DATE_ADD(CURDATE(), INTERVAL 30 DAY), status = 'Active'
WHERE contract_id = 1;
UPDATE Contracts
SET end_date = DATE_ADD(CURDATE(), INTERVAL 5 DAY), status = 'Active'
WHERE contract_id = 1;
SELECT c.*, 
               u.full_name AS agent_name, 
               cu.full_name AS customer_name,
               p.product_name
        FROM Contracts c
        JOIN Users u ON c.agent_id = u.user_id
        JOIN Customers cu ON c.customer_id = cu.customer_id
        JOIN Products p ON c.product_id = p.product_id;
INSERT INTO Insurance_Product_Details (
    product_id, category_id, product_type,
    coverage_amount, duration_years,
    beneficiaries, maturity_benefit, maturity_amount,
    hospitalization_limit, surgery_limit, maternity_limit,
    min_age, max_age, waiting_period,
    vehicle_type, vehicle_value, coverage_type
) VALUES (
    1, 1, 'life',
    200000000, 20,
    'Vợ/chồng, con cái',
    'Chi trả toàn bộ khi tử vong hoặc đáo hạn hợp đồng',
    100000000,
    NULL, NULL, NULL,
    18, 65, NULL,
    NULL, NULL, NULL
);
INSERT INTO Insurance_Product_Details (
    product_id, category_id, product_type,
    coverage_amount, duration_years,
    beneficiaries, maturity_benefit, maturity_amount,
    hospitalization_limit, surgery_limit, maternity_limit,
    min_age, max_age, waiting_period,
    vehicle_type, vehicle_value, coverage_type
) VALUES (
    2, 2, 'health',
    50000000, 1,
    NULL, NULL, NULL,
    20000000, 10000000, 5000000,
    0, 70, 30,
    NULL, NULL, NULL
);
