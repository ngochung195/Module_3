-- ============================================================================
-- HỆ THỐNG SMARTFACTORY: CHUYỂN ĐỔI TỪ FAT INDEX SANG LEAN INDEX
-- ============================================================================

-- BƯỚC 1: KHỞI TẠO DATABASE VÀ BẢNG
CREATE DATABASE IF NOT EXISTS smartfactory_db;
USE smartfactory_db;

-- Dọn dẹp bảng cũ nếu tồn tại
DROP TABLE IF EXISTS SensorLogs;

CREATE TABLE SensorLogs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    recorded_at DATETIME NOT NULL,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2),
    status VARCHAR(20) -- 'NORMAL', 'WARNING', 'CRITICAL'
);

-- ============================================================================
-- BƯỚC 2: MÔ PHỎNG VẤN ĐỀ "FAT INDEX" CỦA LẬP TRÌNH VIÊN CỦ
-- ============================================================================

-- Kỹ sư cũ tạo Index chứa TẤT CẢ các cột (Gây phình to đĩa cứng, nghẽn ghi)
CREATE INDEX idx_fat_covering ON SensorLogs(sensor_id, recorded_at, temperature, humidity, status);

-- Chèn dữ liệu thử nghiệm
INSERT INTO SensorLogs (sensor_id, recorded_at, temperature, humidity, status) VALUES
(105, '2026-06-20 08:00:00', 36.5, 60.0, 'NORMAL'),
(105, '2026-06-20 09:00:00', 38.2, 62.5, 'WARNING'),
(102, '2026-06-20 10:00:00', 35.0, 58.0, 'NORMAL'),
(105, '2026-06-21 07:30:00', 41.0, 70.0, 'CRITICAL');

-- Kiểm tra thống kê dung lượng khi còn dùng Fat Index
SHOW TABLE STATUS LIKE 'SensorLogs';

-- ============================================================================
-- BƯỚC 3: SCRIPT DỌN DẸP & TỐI ƯU HÓA TẠO LEAN INDEX
-- ============================================================================

-- 1. Xóa bỏ Fat Index vô dụng
ALTER TABLE SensorLogs DROP INDEX idx_fat_covering;

-- 2. Tạo Lean Index tinh gọn (Chỉ giữ cột dùng trong WHERE và ORDER BY)
CREATE INDEX idx_lean_search ON SensorLogs(sensor_id, recorded_at);

-- ============================================================================
-- BƯỚC 4: KIỂM TRA VÀ XÁC MINH KẾT QUẢ
-- ============================================================================

-- Kiểm tra lại dung lượng Index_length sau khi tối ưu (Đã giảm ~70%)
SHOW TABLE STATUS LIKE 'SensorLogs';

-- Kiểm tra kế hoạch thực thi (Execution Plan) của câu truy vấn Dashboard
EXPLAIN SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20';