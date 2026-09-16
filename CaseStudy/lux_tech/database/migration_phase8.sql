-- ============================================================
-- MIGRATION PHASE 8: CUSTOMER ONLINE SHOP FOUNDATION
-- ============================================================
-- Chạy script này trên database hiện tại (electronic_store)
-- KHÔNG chạy lại schema.sql (sẽ xóa toàn bộ dữ liệu)
-- ============================================================

USE electronic_store;

-- ============================================================
-- Bước 1: Sửa CHECK constraint role → thêm 'CUSTOMER'
-- ============================================================
-- Với MySQL 8.0+, cần xóa constraint cũ và tạo lại
-- Nếu dùng MySQL 5.7 (không enforce CHECK), bỏ qua bước này

-- Tên constraint tự động là 'users_chk_1' trên MySQL 8.0
-- Kiểm tra tên constraint: SHOW CREATE TABLE users;
-- Nếu constraint có tên khác, sửa lại dòng ALTER TABLE bên dưới

ALTER TABLE users DROP CHECK users_chk_1;
ALTER TABLE users MODIFY COLUMN role VARCHAR(20) NOT NULL;
ALTER TABLE users ADD CONSTRAINT chk_users_role
    CHECK (role IN ('ADMIN', 'STAFF', 'CUSTOMER'));

-- ============================================================
-- Bước 2: Thêm cột customer_id vào bảng users
-- ============================================================
ALTER TABLE users
    ADD COLUMN customer_id INT NULL DEFAULT NULL AFTER role;

ALTER TABLE users
    ADD CONSTRAINT fk_users_customers
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL;

-- ============================================================
-- Bước 3: Tạo Customer mẫu + User CUSTOMER tương ứng
-- Password: '123456' (BCrypt hash)
-- ============================================================
INSERT INTO customers (name, phone, email, address) VALUES
('Nguyễn Demo Customer', '0900000001', 'customer@demo.com', '123 Đường Demo, Quận 1, TP.HCM');

-- Lấy id vừa insert của customer trên
SET @customer_id = LAST_INSERT_ID();

INSERT INTO users (username, password, role, customer_id) VALUES
('customer', '$2a$10$vF/LyauKodYSHjUsOfnTfuHABiHZG6P54QnTgVy64MrYTkkXOhhuq', 'CUSTOMER', @customer_id);

-- ============================================================
-- Kiểm tra kết quả
-- ============================================================
SELECT 'users table:' AS info;
SELECT id, username, role, customer_id FROM users;

SELECT 'customers table (last):' AS info;
SELECT id, name, phone, email FROM customers WHERE id = @customer_id;
