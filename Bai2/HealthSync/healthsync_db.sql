CREATE DATABASE IF NOT EXISTS healthsync_db;
USE healthsync_db;

CREATE TABLE IF NOT EXISTS Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

CREATE TABLE IF NOT EXISTS Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);

DROP TABLE IF EXISTS Prescriptions;
DROP TABLE IF EXISTS Appointments;

CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    
    -- Thay thế is_active bằng trạng thái đa bước quy trình
    status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    
    -- Quản lý tiền cọc và tiền phạt hủy hẹn
    deposit_amount DECIMAL(12, 2) DEFAULT 0.00,
    penalty_fee DECIMAL(12, 2) DEFAULT 0.00,
    cancel_reason VARCHAR(255) NULL,
    
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE RESTRICT,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE RESTRICT
);

CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT UNIQUE NOT NULL, -- UNIQUE đảm bảo quan hệ 1-1 chuẩn chỉnh
    medication_details TEXT NOT NULL,
    issued_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- Thêm dữ liệu ban đầu cho Bệnh nhân và Bác sĩ
INSERT INTO Patients (full_name, phone) VALUES 
('Nguyễn Văn Hùng', '0901234567'),
('Trần Thị Lan', '0987654321');

INSERT INTO Doctors (full_name, specialty) VALUES 
('BS. Lê Văn Vĩnh', 'Tim mạch'),
('BS. Phạm Thị Duyên', 'Nội khoa');

-- -----------------------------------------------------------------------------
-- KỊCH BẢN 1: Luồng khám thành công
-- Đặt hẹn (PENDING) -> Xạ nhận/Check-in (CHECKED_IN) -> Hoàn tất (COMPLETED) -> Cấp đơn thuốc
-- -----------------------------------------------------------------------------

-- Bước 1.1: Tạo lịch hẹn mới với cọc 500.000đ (Trạng thái PENDING)
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (1, 1, '2026-08-01 09:00:00', 'PENDING', 500000.00);

SET @app_id_1 = LAST_INSERT_ID();

-- Bước 1.2: Khách hàng đến khám, tiến hành Check-in
UPDATE Appointments 
SET status = 'CHECKED_IN' 
WHERE appointment_id = @app_id_1;

-- Bước 1.3: Bác sĩ khám xong, cập nhật trạng thái COMPLETED
UPDATE Appointments 
SET status = 'COMPLETED' 
WHERE appointment_id = @app_id_1;

-- Bước 1.4: Tạo đơn thuốc cho lịch hẹn đã hoàn tất
INSERT INTO Prescriptions (appointment_id, medication_details)
VALUES (@app_id_1, 'Paracetamol 500mg (20 viên, ngày 2 lần), Amoxicillin 500mg (14 viên, ngày 2 lần)');


-- -----------------------------------------------------------------------------
-- KỊCH BẢN 2: Luồng hủy hẹn và xử lý phạt tiền cọc
-- Đặt hẹn (CONFIRMED) -> Hủy hẹn (CANCELLED) + Phạt 150.000đ
-- -----------------------------------------------------------------------------

-- Bước 2.1: Tạo lịch hẹn với cọc 300.000đ (Trạng thái CONFIRMED)
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (2, 2, '2026-08-02 14:00:00', 'CONFIRMED', 300000.00);

SET @app_id_2 = LAST_INSERT_ID();

-- Bước 2.2: Bệnh nhân báo hủy, ghi nhận lý do hủy và áp dụng phí phạt 150.000đ
UPDATE Appointments 
SET status = 'CANCELLED',
    cancel_reason = 'Bận việc đột xuất',
    penalty_fee = 150000.00
WHERE appointment_id = @app_id_2;

-- Truy vấn 1: Chi tiết các Lịch hẹn kèm Thông tin bệnh nhân, Bác sĩ & Đơn thuốc (nếu có)
SELECT 
    a.appointment_id AS 'Mã Lịch Hẹn',
    p.full_name AS 'Bệnh Nhân',
    d.full_name AS 'Bác Sĩ',
    a.appointment_date AS 'Thời Gian',
    a.status AS 'Trạng Thái',
    FORMAT(a.deposit_amount, 0) AS 'Tiền Cọc (VNĐ)',
    FORMAT(a.penalty_fee, 0) AS 'Phí Phạt (VNĐ)',
    COALESCE(a.cancel_reason, 'N/A') AS 'Lý Do Hủy',
    COALESCE(pr.medication_details, 'Chưa có đơn thuốc') AS 'Chi Tiết Đơn Thuốc'
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
LEFT JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id;

-- Truy vấn 2: Thống kê tổng hợp dòng tiền cọc và tiền phạt thu được
SELECT 
    COUNT(appointment_id) AS 'Tổng Lịch Hẹn',
    FORMAT(SUM(deposit_amount), 0) AS 'Tổng Tiền Cọc Đã Thu',
    FORMAT(SUM(penalty_fee), 0) AS 'Tổng Phí Phạt Giữ Lại'
FROM Appointments;