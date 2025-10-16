SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS 
    insurance_product_details,
    reports,
    commissions,
    commission_policies,
    contracts,
    customers,
    products,
    product_categories,
    users,
    Role_Permissions,
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
    username VARCHAR(50) UNIQUE,
    password_hash VARCHAR(255),
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    role_id INT,
    status ENUM('Active', 'Inactive','Pending') DEFAULT 'Active',
    is_first_login BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
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
 
CREATE TABLE Insurance_Product_Details (
    product_id INT PRIMARY KEY, -- 🔑 Khóa chính trùng với sản phẩm
    category_id INT NOT NULL,
    product_type ENUM('life', 'health', 'car') NOT NULL,
    
    -- Dùng chung
    coverage_amount DECIMAL(12,2),
    duration_years INT,
    
    -- Bảo hiểm nhân thọ
    beneficiaries TEXT,
    maturity_benefit TEXT,
    maturity_amount DECIMAL(15,2),
    
    -- Bảo hiểm sức khỏe
    hospitalization_limit DECIMAL(12,2),
    surgery_limit DECIMAL(12,2),
    maternity_limit DECIMAL(12,2), -- 🍼 Giới hạn sinh đẻ
    min_age INT DEFAULT 0,         -- 🔹 Tuổi tối thiểu được bảo hiểm
    max_age INT DEFAULT 100,
    waiting_period INT,
    
    -- Bảo hiểm ô tô
    vehicle_type VARCHAR(100),
    vehicle_value DECIMAL(12,2),
    coverage_type VARCHAR(255),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Product_Categories(category_id)
);


INSERT INTO Roles (role_name, description) VALUES
('Agent', 'Nhân viên tư vấn / đại lý bán hàng'),
('Manager', 'Quản lý giám sát đại lý'),
('Admin', 'Quản trị hệ thống');
SELECT user_id, username, password_hash FROM Users;
-- ===============================
INSERT INTO Product_Categories (category_name, description)
VALUES
('Bảo hiểm nhân thọ', 'Bảo hiểm chi trả quyền lợi khi người được bảo hiểm tử vong hoặc đáo hạn'),
('Bảo hiểm sức khỏe', 'Bảo hiểm chi trả chi phí y tế, nằm viện, phẫu thuật, sinh đẻ'),
('Bảo hiểm ô tô', 'Bảo hiểm cho thiệt hại, mất mát hoặc trách nhiệm dân sự của xe ô tô');

INSERT INTO Products (product_name, base_price, category_id)
VALUES
('Gói nhân thọ cơ bản', 5000000, 1),
('Bảo hiểm sức khỏe toàn diện', 2000000, 2),
('Bảo hiểm ô tô thân vỏ', 10000000, 3);
INSERT INTO Insurance_Product_Details (
    product_id, category_id, product_type,
    coverage_amount, duration_years,
    beneficiaries, maturity_benefit, maturity_amount
) VALUES (
    1, 1, 'life',
    100000000, 20,
    'Gia đình, người thân',
    'Nhận toàn bộ giá trị hợp đồng khi đáo hạn',
    150000000
);
INSERT INTO Insurance_Product_Details (
    product_id, category_id, product_type,
    coverage_amount,
    hospitalization_limit, surgery_limit, maternity_limit,
    min_age, max_age, waiting_period
) VALUES (
    2, 2, 'health',
    500000000,
    200000000, 100000000, 50000000,
    18, 65, 30
);
INSERT INTO Insurance_Product_Details (
    product_id, category_id, product_type,
    vehicle_type, vehicle_value, coverage_type, coverage_amount
) VALUES (
    3, 3, 'car',
    'Sedan', 800000000, 'Bảo hiểm vật chất, cháy nổ, mất cắp', 700000000
);


INSERT INTO Users (username, password_hash, full_name, email, phone_number, role_id, status)
VALUES (
    'agent1',
    123,  
    'Nguyễn Văn Quản Lý',
    'agent1@example.com',
    '0909123456',
    1,                    -- role_id của Agent
    'Active'
);
INSERT INTO Users (username, password_hash, full_name, email, phone_number, role_id, status)
VALUES (
    'manager2',
    123,  
    'Nguyễn Văn',
    'agent@example.com',
    '0909123456',
    2,                    -- role_id của Manager
    'Active'
);



