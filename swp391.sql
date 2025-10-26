-- =====================================================================
-- SCRIPT MASTER CHO CSDL SWP391 - PHIÊN BẢN ĐÃ TÁI CẤU TRÚC
-- =====================================================================

-- ---------------------------------------------------------------------
-- PHẦN 1: DỌN DẸP VÀ TẠO CSDL
-- ---------------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
DROP DATABASE IF EXISTS `swp391`;
CREATE DATABASE `swp391`;
USE `swp391`;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------
-- PHẦN 2: TẠO CẤU TRÚC BẢNG (SCHEMA)
-- ---------------------------------------------------------------------

-- Bảng `Roles`
CREATE TABLE `Roles` (
    `role_id` INT AUTO_INCREMENT PRIMARY KEY,
    `role_name` ENUM('Admin', 'Manager', 'Agent') NOT NULL UNIQUE,
    `description` VARCHAR(255)
);

-- Bảng `Users`
CREATE TABLE `Users` (
    `user_id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) UNIQUE,
    `password_hash` VARCHAR(255),
    `full_name` VARCHAR(100),
    `email` VARCHAR(100) UNIQUE,
    `phone_number` VARCHAR(20),
    `role_id` INT,
    `status` ENUM('Active', 'Inactive','Pending') DEFAULT 'Active',
    `is_first_login` BOOLEAN DEFAULT TRUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`role_id`) REFERENCES `Roles`(`role_id`)
);

-- Bảng `Manager_Agent` để quản lý quan hệ
CREATE TABLE `Manager_Agent` (
    `manager_id` INT NOT NULL,
    `agent_id` INT NOT NULL,
    PRIMARY KEY(`manager_id`, `agent_id`),
    FOREIGN KEY (`manager_id`) REFERENCES `Users`(`user_id`),
    FOREIGN KEY (`agent_id`) REFERENCES `Users`(`user_id`)
);


-- Bảng `Customers`
CREATE TABLE `Customers` (
    `customer_id` INT AUTO_INCREMENT PRIMARY KEY,
    `full_name` VARCHAR(100),
    `date_of_birth` DATE,
    `phone_number` VARCHAR(20),
    `email` VARCHAR(100),
    `address` VARCHAR(255),
    `created_by` INT, -- Agent đã tạo customer này
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`created_by`) REFERENCES `Users`(`user_id`)
);

-- Bảng `Product_Categories` và `Products`
CREATE TABLE `Product_Categories` (
    `category_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_name` VARCHAR(100) NOT NULL,
    `description` TEXT
);

CREATE TABLE `Products` (
    `product_id` INT AUTO_INCREMENT PRIMARY KEY,
    `product_name` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `category_id` INT,
    FOREIGN KEY (`category_id`) REFERENCES `Product_Categories`(`category_id`)
);

-- Bảng `Contracts`
CREATE TABLE `Contracts` (
    `contract_id` INT AUTO_INCREMENT PRIMARY KEY,
    `customer_id` INT NOT NULL,
    `agent_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE,
    `status` ENUM('Pending', 'Active', 'Expired', 'Cancelled') DEFAULT 'Pending',
    `premium_amount` DECIMAL(12, 2) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`customer_id`) REFERENCES `Customers`(`customer_id`),
    FOREIGN KEY (`agent_id`) REFERENCES `Users`(`user_id`),
    FOREIGN KEY (`product_id`) REFERENCES `Products`(`product_id`)
);

-- Bảng `Commission_Policies` và `Commissions`
CREATE TABLE `Commission_Policies` (
    `policy_id` INT AUTO_INCREMENT PRIMARY KEY,
    `policy_name` VARCHAR(100) NOT NULL,
    `rate` DECIMAL(5, 2) NOT NULL, -- Tỷ lệ hoa hồng (ví dụ: 5.00 cho 5%)
    `effective_from` DATE NOT NULL
);

CREATE TABLE `Commissions` (
    `commission_id` INT AUTO_INCREMENT PRIMARY KEY,
    `contract_id` INT NOT NULL,
    `agent_id` INT NOT NULL,
    `policy_id` INT NOT NULL,
    `amount` DECIMAL(12, 2) NOT NULL,
    `status` ENUM('Pending', 'Paid', 'Cancelled') NOT NULL DEFAULT 'Pending',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`contract_id`) REFERENCES `Contracts`(`contract_id`),
    FOREIGN KEY (`agent_id`) REFERENCES `Users`(`user_id`),
    FOREIGN KEY (`policy_id`) REFERENCES `Commission_Policies`(`policy_id`)
);


-- ---------------------------------------------------------------------
-- PHẦN 3: CHÈN DỮ LIỆU MẪU CƠ BẢN (SEED DATA)
-- ---------------------------------------------------------------------

-- Chèn `Roles`
INSERT INTO `Roles` (`role_id`, `role_name`, `description`) VALUES
(1, 'Agent', 'Nhân viên tư vấn / đại lý bán hàng'),
(2, 'Manager', 'Quản lý giám sát đại lý'),
(3, 'Admin', 'Quản trị hệ thống');

-- Chèn `Users` (Admin, Manager, 2 Agents)
INSERT INTO `Users` (`user_id`, `username`, `password_hash`, `full_name`, `email`, `phone_number`, `role_id`, `status`) VALUES
(1, 'agent1', '123', 'Agent One (Tùng)', 'agent1@example.com', '0901111111', 1, 'Active'),
(2, 'manager1', '123', 'Manager One', 'manager1@example.com', '0902222222', 2, 'Active'),
(3, 'admin1', '123', 'Admin One', 'admin1@example.com', '0903333333', 3, 'Active'),
(4, 'agent2', '123', 'Agent Two', 'agent2@example.com', '0904444444', 1, 'Active');

-- Chèn quan hệ `Manager_Agent`
INSERT INTO `Manager_Agent` (`manager_id`, `agent_id`) VALUES
(2, 1), -- Manager 1 quản lý Agent 1
(2, 4); -- Manager 1 quản lý Agent 2

-- Chèn `Product_Categories` và `Products`
INSERT INTO `Product_Categories` (`category_name`) VALUES ('Bảo hiểm nhân thọ'), ('Bảo hiểm sức khỏe');
INSERT INTO `Products` (`product_name`, `category_id`) VALUES ('Gói nhân thọ An Tâm', 1), ('Sức khỏe Vàng', 2);

-- Chèn `Commission_Policies`
INSERT INTO `Commission_Policies` (`policy_name`, `rate`, `effective_from`) VALUES ('Hoa hồng chuẩn 2025', 5.00, '2025-01-01');

-- Chèn dữ liệu test cho Agent 1 để kiểm tra chức năng
INSERT INTO `Customers` (`full_name`, `created_by`) VALUES ('Khách hàng Test A', 1);
INSERT INTO `Contracts` (`customer_id`, `agent_id`, `product_id`, `start_date`, `status`, `premium_amount`) 
VALUES (LAST_INSERT_ID(), 1, 1, '2025-10-01', 'Active', 10000000);
INSERT INTO `Commissions` (`contract_id`, `agent_id`, `policy_id`, `amount`, `status`) 
VALUES (LAST_INSERT_ID(), 1, 1, 500000, 'Pending'); -- 5% của 10,000,000



-- =====================================================================
-- SCRIPT CHÈN DỮ LIỆU MẪU QUY MÔ LỚN
-- =====================================================================
USE `swp391`;

-- ---------------------------------------------------------------------
-- PHẦN 1: TẠO THÊM NGƯỜI DÙNG (USERS)
-- ---------------------------------------------------------------------
-- (Giữ lại user_id 1-4 đã có, bắt đầu từ 5)

INSERT INTO `Users` (`user_id`, `username`, `password_hash`, `full_name`, `email`, `phone_number`, `role_id`, `status`) VALUES
-- Thêm 1 Admin
(5, 'admin2', '123', 'Admin Two', 'admin2@example.com', '0905555555', 3, 'Active'),

-- Thêm 4 Manager
(6, 'manager2', '123', 'Manager Thị B', 'manager2@example.com', '0906666666', 2, 'Active'),
(7, 'manager3', '123', 'Manager Văn C', 'manager3@example.com', '0907777777', 2, 'Active'),
(8, 'manager4', '123', 'Manager Thị D', 'manager4@example.com', '0908888888', 2, 'Active'),
(9, 'manager5', '123', 'Manager Văn E', 'manager5@example.com', '0909999999', 2, 'Active'),

-- Thêm 8 Agent
(10, 'agent3', '123', 'Agent Thị F', 'agent3@example.com', '0913333333', 1, 'Active'),
(11, 'agent4', '123', 'Agent Văn G', 'agent4@example.com', '0914444444', 1, 'Active'),
(12, 'agent5', '123', 'Agent Thị H', 'agent5@example.com', '0915555555', 1, 'Active'),
(13, 'agent6', '123', 'Agent Văn I', 'agent6@example.com', '0916666666', 1, 'Active'),
(14, 'agent7', '123', 'Agent Thị K', 'agent7@example.com', '0917777777', 1, 'Active'),
(15, 'agent8', '123', 'Agent Văn L', 'agent8@example.com', '0918888888', 1, 'Active'),
(16, 'agent9', '123', 'Agent Thị M', 'agent9@example.com', '0919999999', 1, 'Active'),
(17, 'agent10', '123', 'Agent Văn N', 'agent10@example.com', '0921111111', 1, 'Pending');


-- ---------------------------------------------------------------------
-- PHẦN 2: PHÂN BỔ AGENT CHO MANAGER
-- ---------------------------------------------------------------------
-- (Giữ lại các phân bổ cũ cho manager1 (user_id=2))
INSERT INTO `Manager_Agent` (`manager_id`, `agent_id`) VALUES
(6, 10), (6, 11), -- Manager 2 quản lý 2 agent
(7, 12), (7, 13), -- Manager 3 quản lý 2 agent
(8, 14), (8, 15), (8, 16), -- Manager 4 quản lý 3 agent
(9, 17); -- Manager 5 quản lý 1 agent


-- ---------------------------------------------------------------------
-- PHẦN 3: TẠO KHÁCH HÀNG (CUSTOMERS)
-- ---------------------------------------------------------------------
INSERT INTO `Customers` (`full_name`, `date_of_birth`, `phone_number`, `email`, `address`, `created_by`) VALUES
('Lê Minh Anh', '1988-03-15', '0981112222', 'minhanh@mail.com', '123 Đường A, Q1, TPHCM', 1),
('Trần Ngọc Bích', '1995-07-20', '0982223333', 'ngocbich@mail.com', '456 Đường B, Q3, TPHCM', 4),
('Phạm Văn Cường', '1980-11-01', '0983334444', 'vancuong@mail.com', '789 Đường C, Q5, TPHCM', 10),
('Võ Thị Dung', '1992-01-25', '0984445555', 'thidung@mail.com', '101 Đường D, Q7, TPHCM', 11),
('Hoàng Minh Hải', '1975-09-10', '0985556666', 'minhhai@mail.com', '212 Đường E, Hà Nội', 12),
('Nguyễn Thị Lan', '1998-02-18', '0986667777', 'thilan@mail.com', '313 Đường F, Hà Nội', 13),
('Đặng Văn Kiên', '1983-06-30', '0987778888', 'vankien@mail.com', '414 Đường G, Đà Nẵng', 14),
('Bùi Thu Thảo', '2000-12-05', '0988889999', 'thuthao@mail.com', '515 Đường H, Đà Nẵng', 15),
('Lý Minh Tuấn', '1991-04-12', '0971112233', 'minhtuan@mail.com', '616 Đường I, Cần Thơ', 16),
('Mai Thị Phương', '1989-08-22', '0972223344', 'thiphuong@mail.com', '717 Đường K, Cần Thơ', 1),
('Trịnh Quang Vinh', '1979-10-03', '0973334455', 'quangvinh@mail.com', '818 Đường L, Hải Phòng', 4),
('Đỗ Ngọc Mai', '1996-05-28', '0974445566', 'ngocmai@mail.com', '919 Đường M, Hải Phòng', 10),
('Hồ Văn Nam', '1985-07-14', '0975556677', 'vannam@mail.com', '111 Đường N, Nha Trang', 11),
('Vương Thị Kim', '1993-03-09', '0976667788', 'thikim@mail.com', '222 Đường P, Nha Trang', 12),
('Tô Minh Đức', '1981-01-01', '0977778899', 'minhduc@mail.com', '333 Đường Q, Vũng Tàu', 13),
('Châu Mỹ Lệ', '1999-11-11', '0978889900', 'myle@mail.com', '444 Đường R, Vũng Tàu', 14),
('Dương Hùng Dũng', '1986-09-19', '0961112233', 'hungdung@mail.com', '555 Đường S, Quy Nhơn', 15),
('Phan Thị Tuyết', '1994-06-06', '0962223344', 'thituyet@mail.com', '666 Đường T, Quy Nhơn', 16),
('Ngô Quang Hải', '1997-04-12', '0963334455', 'quanghai@mail.com', '777 Đường U, Huế', 1),
('Lưu Bích Hằng', '1982-08-08', '0964445566', 'bichhang@mail.com', '888 Đường V, Huế', 4);

-- ---------------------------------------------------------------------
-- PHẦN 4: TẠO HỢP ĐỒNG (CONTRACTS) VÀ HOA HỒNG (COMMISSIONS)
-- ---------------------------------------------------------------------

-- Hợp đồng và Hoa hồng cho Agent 4 (user_id = 4)
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, status, premium_amount) VALUES (2, 4, 2, '2025-08-10', 'Active', 15000000);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES (LAST_INSERT_ID(), 4, 1, 750000, 'Paid');
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, status, premium_amount) VALUES (11, 4, 1, '2025-09-05', 'Active', 25000000);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES (LAST_INSERT_ID(), 4, 1, 1250000, 'Pending');

-- Hợp đồng và Hoa hồng cho Agent 10 (user_id = 10)
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, status, premium_amount) VALUES (3, 10, 1, '2025-07-15', 'Active', 30000000);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES (LAST_INSERT_ID(), 10, 1, 1500000, 'Paid');
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, status, premium_amount) VALUES (12, 10, 2, '2025-10-02', 'Pending', 5000000);

-- Hợp đồng và Hoa hồng cho Agent 12 (user_id = 12)
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, status, premium_amount) VALUES (5, 12, 2, '2025-06-20', 'Expired', 12000000);
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, status, premium_amount) VALUES (14, 12, 1, '2025-08-25', 'Active', 18000000);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES (LAST_INSERT_ID(), 12, 1, 900000, 'Pending');

-- Hợp đồng và Hoa hồng cho Agent 14 (user_id = 14)
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, status, premium_amount) VALUES (7, 14, 1, '2025-09-12', 'Active', 22000000);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES (LAST_INSERT_ID(), 14, 1, 1100000, 'Paid');

-- Thêm vài hợp đồng cho Agent 1 (user_id = 1) để test
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, status, premium_amount) VALUES (1, 1, 2, '2025-10-05', 'Active', 7000000);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES (LAST_INSERT_ID(), 1, 1, 350000, 'Pending');
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, status, premium_amount) VALUES (10, 1, 1, '2025-10-10', 'Active', 12000000);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES (LAST_INSERT_ID(), 1, 1, 600000, 'Pending');
