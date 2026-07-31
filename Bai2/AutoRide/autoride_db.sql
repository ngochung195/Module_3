CREATE DATABASE IF NOT EXISTS autoride_db;
USE autoride_db;

CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME,
    
    -- LỖI 1: Trạng thái thiếu kiểm soát (VARCHAR thay vì ENUM)
    status VARCHAR(50) DEFAULT 'BOOKED', 
        -- LỖI 2: Không hề có các cột lưu Tiền cọc, Phạt trễ, Phạt hư hỏng. 
    -- Kế toán không thể tính được Tiền hoàn lại (Refund).

    FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);

ALTER TABLE Rentals 
    MODIFY COLUMN status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') DEFAULT 'BOOKED',
    ADD COLUMN security_deposit DECIMAL(15, 2) DEFAULT 0.00 AFTER return_date,
    ADD COLUMN late_fee DECIMAL(15, 2) DEFAULT 0.00 AFTER security_deposit,
    ADD COLUMN damage_fee DECIMAL(15, 2) DEFAULT 0.00 AFTER late_fee;

-- LỖI 3: Thiếu bảng Inspections (Kiểm tra xe) để ghi nhận chi tiết xe bị hư hỏng vị trí nào.
CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL,
    damage_description TEXT,
    inspector_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE RESTRICT
);

-- Mô phỏng kịch bản
-- Bước 2.1: Chuẩn bị dữ liệu mẫu cho bảng Cars
INSERT INTO Cars (model_name, license_plate) 
VALUES ('Toyota Camry 2023', '30H-123.45');

-- Bước 2.2: Khách hàng "Nguyen Van A" thuê xe, cọc 10.000.000 VNĐ, trạng thái ACTIVE
INSERT INTO Rentals (car_id, customer_name, rent_date, security_deposit, status) 
VALUES (1, 'Nguyen Van Huy', NOW(), 10000000.00, 'ACTIVE');

-- Bước 2.3: Nhân viên kiểm tra trả xe, phát hiện vỡ đèn pha -> Insert vào Inspections
INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES (1, NOW(), 'Vỡ đèn pha trái', 'Nhan Vien Binh');

-- Bước 2.4: Update Rentals -> Trạng thái COMPLETED, ghi nhận late_fee = 0, damage_fee = 2.000.000 VNĐ
UPDATE Rentals 
SET return_date = NOW(),
    late_fee = 0.00,
    damage_fee = 2000000.00,
    status = 'COMPLETED'
WHERE rental_id = 1;

-- Số tiền thực tế trả khách
SELECT 
    r.rental_id,
    r.customer_name,
    c.model_name,
    r.security_deposit AS tien_coc,
    r.late_fee AS phạt_trễ,
    r.damage_fee AS phạt_hư_hỏng,
    i.damage_description AS chi_tiet_hieu_hong,
    (r.security_deposit - r.late_fee - r.damage_fee) AS tien_hoan_tra_thuc_te,
    r.status AS trang_thai
FROM Rentals r
JOIN Cars c ON r.car_id = c.car_id
LEFT JOIN Inspections i ON r.rental_id = i.rental_id
WHERE r.rental_id = 1;