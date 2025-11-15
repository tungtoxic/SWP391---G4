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



ALTER TABLE Products
ADD COLUMN base_price DECIMAL(12, 2) NOT NULL DEFAULT 0;

ALTER TABLE Products
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE Products
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE Customers
ADD COLUMN customer_type ENUM('Lead', 'Client') NOT NULL DEFAULT 'Lead';

CREATE TABLE Tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,          -- ĐÃ SỬA: Ai sở hữu task này
    customer_id INT NULL,          -- Có thể NULL, nếu NULL thì là To-do cá nhân
    title VARCHAR(255) NOT NULL,
    due_date DATE,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
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

USE `swp391`;

-- =====================================================================
-- SCRIPT CHÈN THÊM DỮ LIỆU CHO AGENT 1 VÀ AGENT 4
-- =====================================================================

-- ---------------------------------------------------------------------
-- PHẦN 1: THÊM KHÁCH HÀNG MỚI (Customers)
-- ---------------------------------------------------------------------
-- (Agent 1 có user_id=1, Agent 2 (Two) có user_id=4)

-- Thêm 2 khách hàng mới cho Agent 1
INSERT INTO `Customers` (`full_name`, `date_of_birth`, `phone_number`, `email`, `address`, `created_by`, `customer_type`)
VALUES
('Nguyễn Văn Dũng', '1990-01-01', '0912345678', 'dungnv@mail.com', '12 Nguyễn Trãi, Hà Nội', 1, 'Client'),
('Trần Thị Thảo', '1992-02-02', '0912345679', 'thaott@mail.com', '24 Tôn Đức Thắng, Hà Nội', 1, 'Lead');

-- Thêm 2 khách hàng mới cho Agent 4
INSERT INTO `Customers` (`full_name`, `date_of_birth`, `phone_number`, `email`, `address`, `created_by`, `customer_type`)
VALUES
('Lê Văn Hùng', '1985-03-03', '0987654321', 'hunglv@mail.com', '33 Lê Lợi, Đà Nẵng', 4, 'Client'),
('Phạm Thị Mai', '1995-04-04', '0987654320', 'maipt@mail.com', '45 Hùng Vương, Đà Nẵng', 4, 'Lead');


-- ---------------------------------------------------------------------
-- PHẦN 2: THÊM HỢP ĐỒNG (Contracts) VÀ HOA HỒNG (Commissions / Sales)
-- ---------------------------------------------------------------------

-- Thêm 1 hợp đồng 'Active' cho khách hàng mới của Agent 1
INSERT INTO `Contracts` (`customer_id`, `agent_id`, `product_id`, `start_date`, `end_date`, `status`, `premium_amount`)
VALUES
((SELECT customer_id FROM Customers WHERE email = 'dungnv@mail.com'), 1, 1, '2025-05-15', '2026-05-15', 'Active', 18000000);
-- Thêm hoa hồng cho hợp đồng trên
INSERT INTO `Commissions` (`contract_id`, `agent_id`, `policy_id`, `amount`, `status`)
VALUES
(LAST_INSERT_ID(), 1, 1, (18000000 * 0.05), 'Pending');

-- Thêm 1 hợp đồng 'Pending' cho khách hàng 'Lead' của Agent 1 (chưa có hoa hồng)
INSERT INTO `Contracts` (`customer_id`, `agent_id`, `product_id`, `start_date`, `status`, `premium_amount`)
VALUES
((SELECT customer_id FROM Customers WHERE email = 'thaott@mail.com'), 1, 2, '2025-10-25', 'Pending', 9000000);

-- Thêm 1 hợp đồng 'Active' cho khách hàng mới của Agent 4
INSERT INTO `Contracts` (`customer_id`, `agent_id`, `product_id`, `start_date`, `end_date`, `status`, `premium_amount`)
VALUES
((SELECT customer_id FROM Customers WHERE email = 'hunglv@mail.com'), 4, 2, '2025-06-20', '2026-06-20', 'Active', 22000000);
-- Thêm hoa hồng cho hợp đồng trên
INSERT INTO `Commissions` (`contract_id`, `agent_id`, `policy_id`, `amount`, `status`)
VALUES
(LAST_INSERT_ID(), 4, 1, (22000000 * 0.05), 'Pending');


-- ---------------------------------------------------------------------
-- PHẦN 3: TẠO DỮ LIỆU CHO "RENEWAL ALERTS"
-- ---------------------------------------------------------------------
-- (Tạo các hợp đồng 'Active' sắp hết hạn trong 30 ngày tới)

-- Thêm 1 hợp đồng sắp hết hạn cho Agent 1 (với khách hàng cũ id=2)
INSERT INTO `Contracts` (`customer_id`, `agent_id`, `product_id`, `start_date`, `end_date`, `status`, `premium_amount`)
VALUES
(2, 1, 1, '2024-11-10', DATE_ADD(CURDATE(), INTERVAL 15 DAY), 'Active', 14500000);
INSERT INTO `Commissions` (`contract_id`, `agent_id`, `policy_id`, `amount`, `status`)
VALUES (LAST_INSERT_ID(), 1, 1, (14500000 * 0.05), 'Paid');


-- Thêm 1 hợp đồng sắp hết hạn cho Agent 4 (với khách hàng cũ id=3)
INSERT INTO `Contracts` (`customer_id`, `agent_id`, `product_id`, `start_date`, `end_date`, `status`, `premium_amount`)
VALUES
(3, 4, 2, '2024-11-20', DATE_ADD(CURDATE(), INTERVAL 25 DAY), 'Active', 16000000);
INSERT INTO `Commissions` (`contract_id`, `agent_id`, `policy_id`, `amount`, `status`)
VALUES (LAST_INSERT_ID(), 4, 1, (16000000 * 0.05), 'Paid');


-- ---------------------------------------------------------------------
-- PHẦN 4: TẠO DỮ LIỆU CHO "TODAY'S FOLLOW-UPS"
-- ---------------------------------------------------------------------
-- (Thêm Tasks có due_date = hôm nay và có customer_id)

-- Thêm 1 follow-up cho Agent 1 (với khách hàng cũ id=11)
INSERT INTO `Tasks` (`user_id`, `customer_id`, `title`, `due_date`, `is_completed`)
VALUES
(1, 11, 'Gặp chị Phương (11h) ký HĐ Sức khỏe Vàng', CURDATE(), false);

-- Thêm 2 follow-ups cho Agent 4 (vì Agent 4 chưa có)
INSERT INTO `Tasks` (`user_id`, `customer_id`, `title`, `due_date`, `is_completed`)
VALUES
(4, 12, 'Gọi anh Vinh (14h) tư vấn gói An Tâm', CURDATE(), false),
(4, (SELECT customer_id FROM Customers WHERE email = 'maipt@mail.com'), 'Gửi báo giá cho chị Mai (Lead mới)', CURDATE(), false);


-- ---------------------------------------------------------------------
-- PHẦN 5: TẠO DỮ LIỆU CHO "PERSONAL TO-DO LIST"
-- ---------------------------------------------------------------------
-- (Thêm Tasks có customer_id = NULL)

-- Thêm 1 to-do cá nhân cho Agent 1 (Agent 1 đã có 2 cái)
INSERT INTO `Tasks` (`user_id`, `customer_id`, `title`, `is_completed`)
VALUES
(1, NULL, 'Hoàn thành khóa học sản phẩm mới (E-learning)', false);

-- Thêm 2 to-do cá nhân cho Agent 4 (Agent 4 chưa có)
INSERT INTO `Tasks` (`user_id`, `customer_id`, `title`, `is_completed`)
VALUES
(4, NULL, 'Nộp báo cáo doanh thu T10 cho Manager One', false),
(4, NULL, 'In card visit và name tag', true);

ALTER TABLE Customers
ADD COLUMN status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active' AFTER customer_type;

CREATE TABLE `Agent_Targets` (
  `target_id` INT AUTO_INCREMENT PRIMARY KEY,
  `agent_id` INT NOT NULL,
  `target_amount` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `target_month` INT NOT NULL, -- Sẽ lưu tháng (1-12)
  `target_year` INT NOT NULL, -- Sẽ lưu năm (ví dụ: 2025)
  
  -- Đảm bảo mỗi agent chỉ có 1 target/tháng/năm
  UNIQUE KEY `uk_agent_month_year` (`agent_id`, `target_month`, `target_year`), 
  
  -- Liên kết với bảng Users
  FOREIGN KEY (`agent_id`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE
);

CREATE TABLE `interaction_types` (
  `type_id` INT AUTO_INCREMENT PRIMARY KEY,
  `type_name` VARCHAR(50) NOT NULL UNIQUE,
  `icon_class` VARCHAR(50) DEFAULT 'fa-solid fa-star' -- Thêm icon cho đẹp
);
INSERT INTO `interaction_types` (type_name, icon_class) VALUES
('Call', 'fa-solid fa-phone'),
('Visit', 'fa-solid fa-person-walking-luggage'),
('Email', 'fa-solid fa-envelope'),
('Gift', 'fa-solid fa-gift'),
('Note', 'fa-solid fa-clipboard');

CREATE TABLE `customer_interactions` (
  `interaction_id` INT AUTO_INCREMENT PRIMARY KEY,
  `customer_id` INT NOT NULL,
  `agent_id` INT NOT NULL,
  `interaction_type_id` INT NOT NULL, -- Đã SỬA (thay vì ENUM)
  `notes` TEXT,
  `interaction_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  FOREIGN KEY (`customer_id`) REFERENCES `Customers`(`customer_id`) ON DELETE CASCADE,
  FOREIGN KEY (`agent_id`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE,
  FOREIGN KEY (`interaction_type_id`) REFERENCES `interaction_types`(`type_id`)
);

INSERT INTO `Products` (`product_name`, `description`, `category_id`, `base_price`) VALUES
-- 5 SẢN PHẨM NHÂN THỌ (category_id = 1) --
('An Tâm Hưu Trí', 'Giải pháp tài chính linh hoạt đảm bảo an nhàn khi về hưu.', 1, 15000000.00),
('Vững Bước Tương Lai', 'Quỹ học vấn cho con, đảm bảo tương lai tươi sáng.', 1, 20000000.00),
('Tâm An Bảo Vệ', 'Bảo vệ toàn diện trước rủi ro 100+ bệnh hiểm nghèo.', 1, 12000000.00),
('Gia Đình Là Nhất', 'Bảo vệ trụ cột gia đình, đảm bảo tài chính vững vàng.', 1, 18000000.00),
('Đầu Tư Linh Hoạt 360', 'Kết hợp bảo vệ rủi ro và đầu tư sinh lời hiệu quả.', 1, 25000000.00),

-- 5 SẢN PHẨM SỨC KHỎE (category_id = 2) --
('Sức Khỏe Bạch Kim', 'Quyền lợi nội trú và ngoại trú cao cấp tại các bệnh viện quốc tế.', 2, 8000000.00),
('Bảo Vệ Ung Thư Toàn Diện', 'Chi trả ngay 100% số tiền bảo hiểm khi phát hiện bệnh ung thư.', 2, 5000000.00),
('Chăm Sóc Răng Miệng', 'Gói bảo hiểm nha khoa toàn diện, bao gồm cạo vôi và trám răng.', 2, 3000000.00),
('Tai Nạn 24/7', 'Bảo vệ toàn diện trước mọi rủi ro tai nạn cá nhân.', 2, 2000000.00),
('Sức Khỏe Gia Đình Việt', 'Bảo vệ cho cả gia đình (vợ, chồng, con cái) chỉ trong 1 hợp đồng.', 2, 10000000.00);

CREATE TABLE `Customer_Stages` (
  `stage_id` INT PRIMARY KEY AUTO_INCREMENT,
  `stage_name` VARCHAR(50) NOT NULL,
  `stage_order` INT -- Để sắp xếp (ví dụ: 1-Lead, 2-Potential...)
);

INSERT INTO `Customer_Stages` (stage_name, stage_order) VALUES
('Lead', 1),
('Potential', 2),
('Client', 3),
('Loyal', 4);

ALTER TABLE `Customers` DROP COLUMN `customer_type`; -- Xóa ENUM cũ
ALTER TABLE `Customers` ADD COLUMN `stage_id` INT DEFAULT 1; -- Thêm cột stage_id mới
ALTER TABLE `Customers` ADD CONSTRAINT `fk_customer_stage` FOREIGN KEY (`stage_id`) REFERENCES `Customer_Stages`(`stage_id`);

-- Thêm cột "luật" thời hạn (mặc định 12 tháng)
ALTER TABLE Products
ADD COLUMN duration_months INT NOT NULL DEFAULT 12;

-- Cập nhật "luật" cho 10 sản phẩm mẫu (ví dụ)
-- (Gói Nhân thọ 10 năm, Sức khỏe 1 năm)
UPDATE Products SET duration_months = 120 WHERE category_id = 1;
UPDATE Products SET duration_months = 12 WHERE category_id = 2;

ALTER TABLE customer_interactions
MODIFY COLUMN interaction_date DATETIME NOT NULL;

INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) 
VALUES (4, 11, 3, '2025-05-01', '2035-05-01', 'Active', 12000000.00);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) 
VALUES (LAST_INSERT_ID(), 11, 1, (12000000.00 * 0.05), 'Paid');

-- 2. "Thắp sáng" (Light up) Agent 6 (user_id = 13)
-- (Sử dụng Khách hàng 6 ('Nguyễn Thị Lan') và Sản phẩm 4 ('Gia Đình Là Nhất'))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) 
VALUES (6, 13, 4, '2025-06-01', '2035-06-01', 'Pending', 18000000.00);
-- (Không có Commission vì HĐ này là 'Pending')

-- 3. "Thắp sáng" (Light up) Agent 8 (user_id = 15)
-- (Sử dụng Khách hàng 8 ('Bùi Thu Thảo') và Sản phẩm 6 ('Sức Khỏe Bạch Kim'))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) 
VALUES (8, 15, 6, '2025-07-01', '2026-07-01', 'Active', 8000000.00);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) 
VALUES (LAST_INSERT_ID(), 15, 1, (8000000.00 * 0.05), 'Pending');

-- 4. "Thắp sáng" (Light up) Agent 9 (user_id = 16)
-- (Sử dụng Khách hàng 9 ('Lý Minh Tuấn') và Sản phẩm 7 ('Bảo Vệ Ung Thư Toàn Diện'))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) 
VALUES (9, 16, 7, '2025-08-01', '2026-08-01', 'Active', 5000000.00);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) 
VALUES (LAST_INSERT_ID(), 16, 1, (5000000.00 * 0.05), 'Paid');

-- 5. "Thắp sáng" (Light up) Agent 10 (user_id = 17) (Agent 'Pending')
-- (Tạo 1 HĐ 'Pending' cho Agent 'Pending' (user_id 17), sử dụng Khách hàng 18 ('Phan Thị Tuyết'))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) 
VALUES (18, 17, 8, '2025-09-01', '2026-09-01', 'Pending', 3000000.00);

USE `swp391`;

-- =====================================================================
-- SCRIPT BỔ SUNG 2 (BACKFILL)
-- MỤC TIÊU: "Lấp đầy" (Backfill) quá khứ (Tháng 5, 6, 7, 9) cho 
-- Agent 1 (ID 1) và Agent 2 (ID 4) để "thắp sáng" (light up) Bar Chart.
-- =====================================================================

-- 1. "Vá" (Patch) Quá khứ cho Agent 1 (user_id = 1)
-- (Sử dụng Khách hàng 1 ('Lê Minh Anh') và Sản phẩm 1 ('Gói nhân thọ An Tâm' - 15Tr, 120 tháng))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) 
VALUES (1, 1, 1, '2025-05-10', '2035-05-10', 'Active', 15000000.00);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) 
VALUES (LAST_INSERT_ID(), 1, 1, (15000000.00 * 0.05), 'Paid');

-- (Sử dụng Khách hàng 10 ('Mai Thị Phương') và Sản phẩm 6 ('Sức Khỏe Bạch Kim' - 8Tr, 12 tháng))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) 
VALUES (10, 1, 6, '2025-07-20', '2026-07-20', 'Active', 8000000.00);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) 
VALUES (LAST_INSERT_ID(), 1, 1, (8000000.00 * 0.05), 'Paid');


-- 2. "Vá" (Patch) Quá khứ cho Agent 2 (user_id = 4)
-- (Sử dụng Khách hàng 2 ('Trần Ngọc Bích') và Sản phẩm 7 ('Bảo Vệ Ung Thư' - 5Tr, 12 tháng))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) 
VALUES (2, 4, 7, '2025-06-15', '2026-06-15', 'Active', 5000000.00);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) 
VALUES (LAST_INSERT_ID(), 4, 1, (5000000.00 * 0.05), 'Paid');

-- (Sử dụng Khách hàng 11 ('Trịnh Quang Vinh') và Sản phẩm 5 ('Đầu Tư Linh Hoạt 360' - 25Tr, 120 tháng))
-- (Script Lượt 55 đã chèn HĐ cho CUST 11 vào T9/2025, nhưng chúng ta thêm 1 HĐ nữa cho T9)
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) 
VALUES (11, 4, 5, '2025-09-02', '2035-09-02', 'Active', 25000000.00);
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) 
VALUES (LAST_INSERT_ID(), 4, 1, (25000000.00 * 0.05), 'Paid');


USE `swp391`;

-- =====================================================================
-- SCRIPT BỔ SUNG 3 (SCALE UP)
-- MỤC TIÊU: "Bơm" (Inject) 10 Hợp đồng (Contracts) "sạch" (clean)
-- cho mỗi Agent "câm" (ID 10-17) để "thắp sáng" (light up)
-- Leaderboard và Bar Chart (Doanh số Team).
-- =====================================================================

-- ---------------------------------------------------------------------
-- BƯỚC 1: "VÁ" (PATCH) LỖ HỔNG (THE GAP)
-- Agent 10 (user_id = 17) 100% "câm" (silent) (không có Khách hàng).
-- Chúng ta phải "bơm" (inject) Khách hàng cho nó TRƯỚC (FIRST).
-- ---------------------------------------------------------------------

INSERT INTO `Customers` (full_name, date_of_birth, phone_number, email, address, created_by, stage_id) 
VALUES
('Khách Agent 17 (A)', '1990-01-01', '0917000111', 'khach17a@mail.com', '17A Address, Hanoi', 17, 1),
('Khách Agent 17 (B)', '1991-02-02', '0917000222', 'khach17b@mail.com', '17B Address, Hanoi', 17, 2),
('Khách Agent 17 (C)', '1992-03-03', '0917000333', 'khach17c@mail.com', '17C Address, Hanoi', 17, 3),
('Khách Agent 17 (D)', '1993-04-04', '0917000444', 'khach17d@mail.com', '17D Address, Hanoi', 17, 1);

-- "Chốt" (Lock in) 4 ID Khách hàng (Customer ID) "mới" (new) này
SET @cust17A = (SELECT customer_id FROM Customers WHERE email = 'khach17a@mail.com');
SET @cust17C = (SELECT customer_id FROM Customers WHERE email = 'khach17c@mail.com');

-- ---------------------------------------------------------------------
-- BƯỚC 2: "BƠM" (INJECT) HỢP ĐỒNG (CONTRACTS)
-- (Sử dụng ID Khách hàng (Customer ID) và ID Sản phẩm (Product ID) 
-- đã có 100% (existing) từ "SCRIPT MASTER")
-- ---------------------------------------------------------------------

-- === AGENT 3 (ID 10) ===
-- (Sử dụng Khách 3 & 12 | Sản phẩm 1 (15Tr/120m) & 6 (8Tr/12m))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) VALUES 
(3, 10, 1, '2025-05-05', '2035-05-05', 'Active', 15000000.00),
(12, 10, 6, '2025-05-15', '2026-05-15', 'Active', 8000000.00),
(3, 10, 1, '2025-06-05', '2035-06-05', 'Active', 15000000.00),
(12, 10, 6, '2025-06-15', '2026-06-15', 'Active', 8000000.00),
(3, 10, 1, '2025-07-05', '2035-07-05', 'Expired', 15000000.00),
(12, 10, 6, '2025-08-15', '2026-08-15', 'Active', 8000000.00),
(3, 10, 1, '2025-09-05', '2035-09-05', 'Cancelled', 15000000.00),
(12, 10, 6, '2025-11-01', '2026-11-01', 'Pending', 8000000.00);
-- (Thêm Hoa hồng (Commissions) cho 6 HĐ 'Active'/'Expired'/'Cancelled')
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES 
(LAST_INSERT_ID()-7, 10, 1, (15000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-6, 10, 1, (8000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-5, 10, 1, (15000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-4, 10, 1, (8000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-3, 10, 1, (15000000.00 * 0.05), 'Cancelled'),
(LAST_INSERT_ID()-2, 10, 1, (8000000.00 * 0.05), 'Pending');

-- === AGENT 4 (ID 11) ===
-- (Sử dụng Khách 4 & 13 | Sản phẩm 2 (20Tr/120m) & 7 (5Tr/12m))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) VALUES 
(4, 11, 2, '2025-05-06', '2035-05-06', 'Active', 20000000.00),
(13, 11, 7, '2025-05-16', '2026-05-16', 'Active', 5000000.00),
(4, 11, 2, '2025-06-06', '2035-06-06', 'Active', 20000000.00),
(13, 11, 7, '2025-06-16', '2026-06-16', 'Active', 5000000.00),
(4, 11, 2, '2025-07-06', '2035-07-06', 'Active', 20000000.00),
(13, 11, 7, '2025-08-16', '2026-08-16', 'Active', 5000000.00),
(4, 11, 2, '2025-09-06', '2035-09-06', 'Active', 20000000.00),
(13, 11, 7, '2025-10-16', '2026-10-16', 'Active', 5000000.00),
(4, 11, 2, '2025-11-01', '2035-11-01', 'Pending', 20000000.00);
-- (Thêm Hoa hồng (Commissions) cho 8 HĐ 'Active')
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES 
(LAST_INSERT_ID()-8, 11, 1, (20000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-7, 11, 1, (5000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-6, 11, 1, (20000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-5, 11, 1, (5000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-4, 11, 1, (20000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-3, 11, 1, (5000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-2, 11, 1, (20000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-1, 11, 1, (5000000.00 * 0.05), 'Paid');

-- === AGENT 5 (ID 12) ===
-- (Sử dụng Khách 5 & 14 | Sản phẩm 3 (12Tr/120m) & 8 (3Tr/12m))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) VALUES 
(5, 12, 3, '2025-05-07', '2035-05-07', 'Active', 12000000.00),
(14, 12, 8, '2025-05-17', '2026-05-17', 'Active', 3000000.00),
(5, 12, 3, '2025-06-07', '2035-06-07', 'Active', 12000000.00),
(14, 12, 8, '2025-06-17', '2026-06-17', 'Active', 3000000.00),
(5, 12, 3, '2025-07-07', '2035-07-07', 'Active', 12000000.00),
(14, 12, 8, '2025-08-17', '2026-08-17', 'Active', 3000000.00),
(5, 12, 3, '2025-09-07', '2035-09-07', 'Active', 12000000.00),
(14, 12, 8, '2025-10-17', '2026-10-17', 'Pending', 3000000.00);
-- (Thêm Hoa hồng (Commissions) cho 7 HĐ 'Active')
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES 
(LAST_INSERT_ID()-7, 12, 1, (12000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-6, 12, 1, (3000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-5, 12, 1, (12000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-4, 12, 1, (3000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-3, 12, 1, (12000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-2, 12, 1, (3000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-1, 12, 1, (12000000.00 * 0.05), 'Paid');

-- === AGENT 6 (ID 13) ===
-- (Sử dụng Khách 6 & 15 | Sản phẩm 4 (18Tr/120m) & 9 (2Tr/12m))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) VALUES 
(6, 13, 4, '2025-05-08', '2035-05-08', 'Active', 18000000.00),
(15, 13, 9, '2025-05-18', '2026-05-18', 'Active', 2000000.00),
(6, 13, 4, '2025-06-08', '2035-06-08', 'Active', 18000000.00),
(15, 13, 9, '2025-06-18', '2026-06-18', 'Active', 2000000.00),
(6, 13, 4, '2025-07-08', '2035-07-08', 'Active', 18000000.00),
(15, 13, 9, '2025-08-18', '2026-08-18', 'Active', 2000000.00),
(6, 13, 4, '2025-09-08', '2035-09-08', 'Active', 18000000.00),
(15, 13, 9, '2025-10-18', '2026-10-18', 'Active', 2000000.00),
(6, 13, 4, '2025-11-02', '2035-11-02', 'Pending', 18000000.00);
-- (Thêm Hoa hồng (Commissions) cho 8 HĐ 'Active')
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES 
(LAST_INSERT_ID()-8, 13, 1, (18000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-7, 13, 1, (2000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-6, 13, 1, (18000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-5, 13, 1, (2000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-4, 13, 1, (18000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-3, 13, 1, (2000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-2, 13, 1, (18000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-1, 13, 1, (2000000.00 * 0.05), 'Pending');

-- === AGENT 7 (ID 14) ===
-- (Sử dụng Khách 7 & 16 | Sản phẩm 5 (25Tr/120m) & 10 (10Tr/12m))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) VALUES 
(7, 14, 5, '2025-05-09', '2035-05-09', 'Active', 25000000.00),
(16, 14, 10, '2025-05-19', '2026-05-19', 'Active', 10000000.00),
(7, 14, 5, '2025-06-09', '2035-06-09', 'Active', 25000000.00),
(16, 14, 10, '2025-06-19', '2026-06-19', 'Active', 10000000.00),
(7, 14, 5, '2025-07-09', '2035-07-09', 'Active', 25000000.00),
(16, 14, 10, '2025-08-19', '2026-08-19', 'Active', 10000000.00),
(7, 14, 5, '2025-09-09', '2035-09-09', 'Active', 25000000.00),
(16, 14, 10, '2025-10-19', '2026-10-19', 'Pending', 10000000.00);
-- (Thêm Hoa hồng (Commissions) cho 7 HĐ 'Active')
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES 
(LAST_INSERT_ID()-7, 14, 1, (25000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-6, 14, 1, (10000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-5, 14, 1, (25000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-4, 14, 1, (10000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-3, 14, 1, (25000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-2, 14, 1, (10000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-1, 14, 1, (25000000.00 * 0.05), 'Paid');

-- === AGENT 8 (ID 15) ===
-- (Sử dụng Khách 8 & 17 | Sản phẩm 1 (15Tr/120m) & 6 (8Tr/12m))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) VALUES 
(8, 15, 1, '2025-05-10', '2035-05-10', 'Active', 15000000.00),
(17, 15, 6, '2025-05-20', '2026-05-20', 'Active', 8000000.00),
(8, 15, 1, '2025-06-10', '2035-06-10', 'Active', 15000000.00),
(17, 15, 6, '2025-06-20', '2026-06-20', 'Active', 8000000.00),
(8, 15, 1, '2025-07-10', '2035-07-10', 'Active', 15000000.00),
(17, 15, 6, '2025-08-20', '2026-08-20', 'Active', 8000000.00),
(8, 15, 1, '2025-09-10', '2035-09-10', 'Active', 15000000.00),
(17, 15, 6, '2025-10-20', '2026-10-20', 'Pending', 8000000.00);
-- (Thêm Hoa hồng (Commissions) cho 7 HĐ 'Active')
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES 
(LAST_INSERT_ID()-7, 15, 1, (15000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-6, 15, 1, (8000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-5, 15, 1, (15000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-4, 15, 1, (8000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-3, 15, 1, (15000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-2, 15, 1, (8000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-1, 15, 1, (15000000.00 * 0.05), 'Paid');

-- === AGENT 9 (ID 16) ===
-- (Sử dụng Khách 9 & 18 | Sản phẩm 2 (20Tr/120m) & 7 (5Tr/12m))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) VALUES 
(9, 16, 2, '2025-05-11', '2035-05-11', 'Active', 20000000.00),
(18, 16, 7, '2025-05-21', '2026-05-21', 'Active', 5000000.00),
(9, 16, 2, '2025-06-11', '2035-06-11', 'Active', 20000000.00),
(18, 16, 7, '2025-06-21', '2026-06-21', 'Active', 5000000.00),
(9, 16, 2, '2025-07-11', '2035-07-11', 'Active', 20000000.00),
(18, 16, 7, '2025-08-21', '2026-08-21', 'Active', 5000000.00),
(9, 16, 2, '2025-09-11', '2035-09-11', 'Active', 20000000.00),
(18, 16, 7, '2025-10-21', '2026-10-21', 'Active', 5000000.00),
(9, 16, 2, '2025-11-03', '2035-11-03', 'Pending', 20000000.00);
-- (Thêm Hoa hồng (Commissions) cho 8 HĐ 'Active')
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES 
(LAST_INSERT_ID()-8, 16, 1, (20000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-7, 16, 1, (5000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-6, 16, 1, (20000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-5, 16, 1, (5000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-4, 16, 1, (20000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-3, 16, 1, (5000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-2, 16, 1, (20000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-1, 16, 1, (5000000.00 * 0.05), 'Pending');

-- === AGENT 10 (ID 17) ===
-- (Sử dụng Khách @cust17A & @cust17C | Sản phẩm 3 (12Tr/120m) & 8 (3Tr/12m))
INSERT INTO `Contracts` (customer_id, agent_id, product_id, start_date, end_date, status, premium_amount) VALUES 
(@cust17A, 17, 3, '2025-05-12', '2035-05-12', 'Active', 12000000.00),
(@cust17C, 17, 8, '2025-05-22', '2026-05-22', 'Active', 3000000.00),
(@cust17A, 17, 3, '2025-06-12', '2035-06-12', 'Active', 12000000.00),
(@cust17C, 17, 8, '2025-06-22', '2026-06-22', 'Active', 3000000.00),
(@cust17A, 17, 3, '2025-07-12', '2035-07-12', 'Active', 12000000.00),
(@cust17C, 17, 8, '2025-08-22', '2026-08-22', 'Active', 3000000.00),
(@cust17A, 17, 3, '2025-09-12', '2035-09-12', 'Active', 12000000.00),
(@cust17C, 17, 8, '2025-10-22', '2026-10-22', 'Active', 3000000.00),
(@cust17A, 17, 3, '2025-11-04', '2035-11-04', 'Pending', 12000000.00);
-- (Thêm Hoa hồng (Commissions) cho 8 HĐ 'Active')
INSERT INTO `Commissions` (contract_id, agent_id, policy_id, amount, status) VALUES 
(LAST_INSERT_ID()-8, 17, 1, (12000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-7, 17, 1, (3000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-6, 17, 1, (12000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-5, 17, 1, (3000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-4, 17, 1, (12000000.00 * 0.05), 'Pending'),
(LAST_INSERT_ID()-3, 17, 1, (3000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-2, 17, 1, (12000000.00 * 0.05), 'Paid'),
(LAST_INSERT_ID()-1, 17, 1, (3000000.00 * 0.05), 'Pending');
